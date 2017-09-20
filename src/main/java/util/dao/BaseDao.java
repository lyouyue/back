package util.dao;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.transform.Transformers;
import org.springframework.orm.hibernate3.HibernateTemplate;
import org.springframework.orm.hibernate3.SessionFactoryUtils;

import util.common.EncapsulationObject;
import util.other.ReflectUtils;
import util.other.Utils;
import util.other.WebUtil;
import util.pojo.BaseEntity;
import util.pojo.ProcedureBean;

/**
 * 核心类-底层数据DAO操作类
 */
 @SuppressWarnings({"unchecked","rawtypes"})
public class BaseDao<T extends BaseEntity> implements IBaseDao<T> {

	/**
	 * 写数据操作
	 */
	private HibernateTemplate hibernateTemplateWrite;

	/**
	 * 读数据操作
	 */
	private HibernateTemplate hibernateTemplateRead;

	/**
	 * 写数据操作工厂SessionFactory
	 */
	private static SessionFactory sfWrite;

	/**
	 * 读数据操作工厂SessionFactory
	 */
	private static SessionFactory sfRead;

	/**
	 * 写线程
	 */
	private static ThreadLocal<Session> threadLocal_write = new ThreadLocal<Session>();

	/**
	 * 读线程
	 *  1、使用写的线程组来获取当前session，要和读的线程组分离开，否则读的线程中session为只读属性直接影响下面写操作的session的写操作功能。
	 */
	private static ThreadLocal<Session> threadLocal_read = new ThreadLocal<Session>();

	/**
	 * 日志
	 */
	private Logger logger = Logger.getLogger(this.getClass());

	/**
	 * 反射对象
	 */
	protected Class<T> entityClass;

	/**
	 * 在构造函数中利用反射机制获得参数T的具体类
	 */
	public BaseDao() {
		entityClass = ReflectUtils.getClassGenricType(getClass());
		logger.info(entityClass.getName());
	}

	/**
	 * 写数据注入
	 */
	public void setHibernateTemplateWrite(HibernateTemplate hibernateTemplateWrite) {
		this.hibernateTemplateWrite = hibernateTemplateWrite;
		//获得写工厂对象
		sfWrite = this.hibernateTemplateWrite.getSessionFactory();
	}

	/**
	 * 写数据注入
	 */
	public void setHibernateTemplateRead(HibernateTemplate hibernateTemplateRead) {
		this.hibernateTemplateRead = hibernateTemplateRead;
		//获得读工厂对象
		sfRead = this.hibernateTemplateRead.getSessionFactory();
	}

	/**
	 * 获得写Session
	 */
	public Session getSessionForWrite() {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=threadLocal_write.get();
			if(session==null||!session.isOpen()){
//				session = sfWrite.getCurrentSession();
				session = sfWrite.openSession();
			}
			threadLocal_write.set(session);
			return session;
		} catch (Exception e) {
			logger.error("获取session_write工厂出现异常:" + e);
			return null;
		}
	}

	/**
	 * 获得读Session
	 */
	public Session getSessionForRead() {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=threadLocal_read.get();
			if(session==null||!session.isOpen()){
//				session = sfRead.getCurrentSession();
				session = sfRead.openSession();
			}
			threadLocal_read.set(session);
			return session;
		} catch (Exception e) {
			logger.error("获取session_read工厂出现异常:" + e);
			return null;
		}
	}

	/**
	 * 关闭读写Session，并且把session重置为null，放入线程中
	 */
	public void closeSessionForWriteRead(Session session,ThreadLocal<Session> threadLocal) {
		try {
			//session不为空或开启状态，进行session彻底关闭
			if(session!=null&&session.isOpen()){
				session.flush();session.close();
				session=null;
				threadLocal.set(session);
			}
		} catch (Exception e) {
			logger.error("关闭读写方法出现异常:" + e);
		} finally {
			session=null;
		}
	}
	
	/**
	 * 关闭读写Connection，CallableStatement，并且重置为null
	 */
	public void closeConnection(CallableStatement cs,Connection conn) {
		try {
			if(cs!=null) cs.close();
			if(conn!=null) conn.close();
		} catch (SQLException e) {
			logger.error("关闭读写Connection，CallableStatement方法出现异常:" + e);
		} finally {
			cs =null;
			conn =null;
		}
	}

	/**
	 * 添加
	 */
	public T saveObject(Object obj) {
		hibernateTemplateWrite.save(obj);
		return (T) obj;
	}

	/**
	 * 保存或修改对象
	 * @param obj
	 * @return
     */
	public T saveOrUpdateObject(Object obj) {
		hibernateTemplateWrite.saveOrUpdate(obj);
		return (T) obj;
	}

	/**
	 * 修改
	 */
	public T updateObject(Object obj) {
		hibernateTemplateWrite.update(obj);
		return (T)obj;
	}

	/**
	 * 通过指定 的Id删除一条记录
	 */
	public boolean deleteObjectById(String id) {
		Object obj = hibernateTemplateWrite.get(entityClass, Integer.parseInt(id));
		if (obj != null) {
			hibernateTemplateWrite.delete(obj);
		}
		return true;
	}

	/**
	 * 通过指定 的pojo删除一条记录
	 */
	public boolean deleteObject(Object obj) {
		hibernateTemplateWrite.delete(obj);
		return true;
	}

	/**
	 * 通过指定 的条件删除记录
	 */
	public boolean deleteByParams(String whereCondition) {
		String hql = "select o from " + entityClass.getSimpleName() + " o ";
		if (whereCondition != null)
			hql += whereCondition;
		List<?> list = hibernateTemplateWrite.find(hql);
		hibernateTemplateWrite.deleteAll(list);
		return true;
	}

	/**
	 * 通过指定 的Id查找一个对象
	 */
	public T getObjectById(String id) {
		try {
			Object obj = null;
			//开启缓存，创建的临时对象
			HibernateTemplate thisHibernateTemplateRead = hibernateTemplateRead;
			if (Utils.objectIsNotEmpty(id) && !"null".equals(id)) {
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					thisHibernateTemplateRead.setCacheQueries(true);// 设置查询缓存
				}
				obj = thisHibernateTemplateRead.get(entityClass.getName(), Integer.parseInt(id));
			}
			return (T)obj;
		} catch (Exception e) {
			logger.error("通过Id查询对象出现异常:" + e);
			return null;
		}
	}

	/**
	 * 通过指定的条件查找
	 */
	public T get(String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select o from " + entityClass.getSimpleName() + " o ";
		if (whereCondition != null)
			hql += whereCondition;
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setMaxResults(1);
			Object obj = query.uniqueResult();
			return (T)obj;
		} catch (Exception e) {
			logger.error("通过条件查询对象出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 根据指定列id（外键）查询对象
	 *
	 * @param column
	 * @param value
	 * @return
	 */
	public T getObjectByColumnId(String column, String value) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select o from " + entityClass.getSimpleName() + " o ";
		if (Utils.objectIsNotEmpty(column) && Utils.objectIsNotEmpty(value))
			hql += "where o." + column + "=" + value;
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setMaxResults(1);
			Object obj = query.uniqueResult();
			return (T) obj;
		} catch (Exception e) {
			logger.error("通过条件查询对象出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取一些数据 firstIndex 开始索引 maxResult 需要获取的最大记录数
	 */
	public T get(int firstIndex, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select o from " + entityClass.getSimpleName() + " o ";
		if (whereCondition != null)
			hql += whereCondition;
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setMaxResults(1);
			query.setFirstResult(firstIndex);
			Object obj = query.uniqueResult();
			return (T)obj;
		} catch (Exception e) {
			logger.error("通过记录开始位置以及条件查询对象出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取随机记录
	 */
	public T getRandom(String whereCondition) {
		int count = this.getCount(whereCondition);
		if (count == 0)
			return null;
		int recordIndex = (int) (Math.random() * count);
		return this.get(recordIndex, whereCondition);
	}

	/**
	 * 查询所有的记录的分页数目
	 */
	public int getCount(String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select count(o) from " + entityClass.getSimpleName() + " o ";
		if (whereCondition != null)
			hql += whereCondition;
		// 得到Hibernate Query对象
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			// 执行查询，并返回结果
			Iterator iterate = query.iterate();
			if (!iterate.hasNext())
				return 0;
			Object object = iterate.next();
			if (object == null)
				return 0;
			if (object instanceof Long) {
				return ((Long) object).intValue();
			} else if (object instanceof Integer) {
				return ((Integer) object).intValue();
			} else {
				logger.error("统计HQL存在错误");
				return 0;
			}
		} catch (Exception e) {
			logger.error("通过条件查询统计数量出现异常:" + e);
			return 0;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 查询所有的记录的分页数目自定义SQL
	 */
	public int getCountByHQL(String hql) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			Iterator<T> it=query.iterate();
			// 执行查询，并返回结果
			if (!it.hasNext())return 0;
			Object object = it.next();
			if (object == null)return 0;
			if (object instanceof Long) {
				int count=((Long) object).intValue();
				return count;
			}else if (object instanceof Integer) {
				return ((Integer) object).intValue();
			}else {
				logger.error("统计HQL存在错误");
				return 0;
			}
		} catch (Exception e) {
			logger.error("通过条件查询统计数量出现异常:" + e);
			return 0;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取一些数据 (多个表)wjy
	 * firstIndex 开始索引
	 * maxResult 需要获取的最大记录数
	 * params where 条件参数
	 */
	public List findSomeManyTable(int firstIndex, int maxResult,String whereCondition){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql=" ";
		if(whereCondition!=null)hql+=whereCondition;
		try {
			session=this.getSessionForRead();
			Query query = (Query) session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setFirstResult(firstIndex).setMaxResults(maxResult);
			List list=query.list();
			return list;
		}catch(Exception e){
			logger.error("分页查询出现异常:"+e);
			return null;
		}finally{
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 查询所有的记录的分页数目(多个表 )wjy
	 */
	public int getCountManyTable(String params){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "";
		if(params!=null)hql+=params;
		// 得到Hibernate Query对象
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			// 执行查询，并返回结果
			if (!query.iterate().hasNext())return 0;
			Object object = query.iterate().next();
			if (object == null) return 0;
			if (object instanceof Long) {
				return ((Long) object).intValue();
			} else if (object instanceof Integer){
				return ((Integer) object).intValue();
			} else {
				logger.error("统计HQL存在错误");
				return 0;
			}
		}catch(Exception e){
			logger.error("通过条件查询统计数量出现异常:"+e);
			return 0;
		}finally{
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取一些数据 column：排重的列 params：where 条件参数
	 */
	public List<T> findUnSame(String column, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select distinct o." + column + " from " + entityClass.getSimpleName() + " as o ";
		if (whereCondition != null) hql += whereCondition;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List<T> list = query.list();
			return list;
		} catch (Exception e) {
			logger.error("通过条件查询不重复的集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取一些数据 firstIndex 开始索引 maxResult 需要获取的最大记录数 params where 条件参数
	 */
	public List<T> findSome(int firstIndex, int maxResult, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		StringBuffer sb = new StringBuffer();
		sb.append("select o from ").append(entityClass.getSimpleName()).append(" o ");
		if (whereCondition != null) sb.append(whereCondition);
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(sb.toString());
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setFirstResult(firstIndex).setMaxResults(maxResult);
			List<T> list = query.list();
			return list;
		} catch (Exception e) {
			logger.error("分页查询出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取一些数据 selectMap:投影的字段map firstIndex 开始索引 maxResult 需要获取的最大记录数 params
	 * where 条件参数
	 */
	public List <T> findSome(String[] selectColumns, int firstIndex, int maxResult, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		StringBuffer sb = new StringBuffer();
		try {
			List list = new ArrayList();
			session = this.getSessionForRead();
			if (selectColumns != null) {
				sb.append("select ");
				for (int i = 0; i < selectColumns.length; i++) {
					if (i == selectColumns.length - 1) {
						sb.append(" o.").append(selectColumns[i]);
					} else {
						sb.append(" o.").append(selectColumns[i]).append(" ,");
					}
				}
				sb.append(" from ").append(entityClass.getSimpleName()).append(" o ");
				if (whereCondition != null) sb.append(whereCondition);
				Query query = session.createQuery(sb.toString());
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				query.setFirstResult(firstIndex).setMaxResults(maxResult);
				List<Object[]> querylist = query.list();
				for (Object[] dataObjs : querylist) {
					Object obj = EncapsulationObject.getObject(selectColumns,entityClass, dataObjs);
					list.add(obj);
				}
			} else {
				sb.append("select o from ").append(entityClass.getSimpleName()).append(" o ");
				if (whereCondition != null) sb.append(whereCondition);
				Query query = session.createQuery(sb.toString());
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				query.setFirstResult(firstIndex).setMaxResults(maxResult);
				list = query.list();
			}
			return list;
		} catch (Exception e) {
			logger.error("分页查询出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 求和 field 开始索引 params where 条件参数
	 */
	public T getSum(String field, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select sum(o." + field + ") from " + entityClass.getSimpleName() + " as o ";
		if (whereCondition != null) hql += whereCondition;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			Object obj = query.list().get(0);
			return (T) obj;
		} catch (Exception e) {
			logger.error("统计求和出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 查询所有的记录
	 */
	public List<T> findObjects(String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = " from " + entityClass.getSimpleName() + "  o ";
		if (whereCondition != null)
			hql += whereCondition;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List <T> list = query.list();
			return list;
		} catch (Exception e) {
			logger.error("通过条件查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 查询所有的记录
	 */
	public List<T> findObjects(String[] selectColumns, String whereCondition) {
		StringBuffer sb = new StringBuffer();
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			List list = new ArrayList();
			session = this.getSessionForRead();
			if (selectColumns != null) {
				sb.append("select ");
				for (int i = 0; i < selectColumns.length; i++) {
					if (i == selectColumns.length - 1) {
						sb.append(" o.").append(selectColumns[i]);
					} else {
						sb.append(" o.").append(selectColumns[i]).append(" ,");
					}
				}
				sb.append(" from ").append(entityClass.getSimpleName()).append(" o ");
				if (whereCondition != null)
					sb.append(whereCondition);
				Query query = session.createQuery(sb.toString());
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				List<Object[]> querylist = query.list();
				for (Object[] dataObjs : querylist) {
					Object obj = EncapsulationObject.getObject(selectColumns,entityClass, dataObjs);
					list.add(obj);
				}
			} else {
				sb.append("select o from ").append(entityClass.getSimpleName()).append(" o ");
				if (whereCondition != null) sb.append(whereCondition);
				Query query = session.createQuery(sb.toString());
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				list = query.list();
			}
			return list;
		} catch (Exception e) {
			logger.error("通过条件查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 创建nativeQuery 查询所有的记录
	 */
	public List <T> findByNative(String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			String hql = "select o from " + entityClass.getSimpleName() + "  o ";
			if (whereCondition != null) hql += whereCondition;
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			return query.list();
		} catch (Exception e) {
			logger.error("通过条件查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 根据一个列的所有数据
	 *
	 * @author
	 */
	public List<T> findUnList(String column, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select o.'" + column + "' from "+ entityClass.getSimpleName() + " as o ";
		if (whereCondition != null) hql += whereCondition;
		session = this.getSessionForRead();
		try {
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List<T> list = query.list();
			return list;
		} catch (Exception e) {
			logger.error("制定列集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 根据一个列的所有数据，去重复
	 *
	 * @author
	 */
	public List<T> findUnDistinctList(String column, String params) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select distinct o." + column + " from " + entityClass.getSimpleName() + " as o ";
		if (params != null) hql += params;
		session = this.getSessionForRead();
		try {
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List<T> list = query.list();
			return list;
		} catch (Exception e) {
			logger.error("去重查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 根据一个列查询最大数据
	 *
	 * @author
	 */
	public T getMaxData(String column, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select max(o." + column + ") from " + entityClass.getSimpleName() + " as o ";
		if (whereCondition != null) hql += whereCondition;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			Object obj = query.list().get(0);
			return (T) obj;
		} catch (Exception e) {
			logger.error("指定列求出最大值出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 根据一个列查询最大数据，执行SQL查询
	 *
	 * @author
	 */
	public Object getMaxDataSQL(String sql) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session = this.getSessionForRead();
			Query query = session.createSQLQuery(sql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			return query.list().get(0);
		} catch (Exception e) {
			logger.error("指定列求出最大值出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取一些数据 column：排重的列 params：where 条件参数
	 */
	public List <T> findProdProgressSame(String column, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		String hql = "select distinct o." + column + " ,o.pattern from " + entityClass.getSimpleName() + " as o ";
		if (whereCondition != null) hql += whereCondition;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List<T> list = query.list();
			return list;
		} catch (Exception e) {
			logger.error("指定列求出最大值出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取list<map>集合
	 * 自定义Hql 语句，返回结果为list<map>
	 * @param hql
	 * @return
	 * @author
	 */
	public List<Map> findListMapByHql(String hql){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		} catch (Exception e) {
			logger.error("获取list<map>集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取list<map>集合
	 * 分页自定义Hql 语句，返回结果为list<map>
	 * @param hql
	 * @param firstIndex
	 * @param maxResult
	 * @return
	 * @author
	 */
	public List<Map> findListMapPage(String hql,int firstIndex, int maxResult) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			return  query.setFirstResult(firstIndex).setMaxResults(maxResult).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		} catch (Exception e) {
			logger.error("获取list<map>集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取list<map>集合
	 * 分页自定义SQL 语句，返回结果为list<map>
	 * @param sql
	 * @return
	 * @author
	 */
	public List<Map<String,Object>> findListMapPageBySql(String sql, int firstIndex, int maxResult) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session = this.getSessionForRead();
			Query query = session.createSQLQuery(sql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List<Map<String, Object>> list = query.setFirstResult(firstIndex).setMaxResults(maxResult)
					.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
			return list;
		} catch (Exception e) {
			logger.error("获取list<map>集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取list<map>集合
	 * 自定义SQL 语句，返回结果为list<map>
	 * @param sql
	 * @return
	 * @author
	 */
	public List<Map<String,Object>> findListMapBySql(String sql) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session = this.getSessionForRead();
			Query query = session.createSQLQuery(sql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List<Map<String, Object>> list = query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
			return list;
		} catch (Exception e) {
			logger.error("获取list<map>集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取多表联合查询的数据总数
	 * 自定义Hql 语句，返回结果为int总数
	 * @param hql
	 * @return
	 * @author
	 */
	public int getMultilistCount(String hql) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			// 执行查询，并返回结果
			if (!query.iterate().hasNext())
				return 0;
			Object object = query.iterate().next();
			if (object == null)
				return 0;
			if (object instanceof Long) {
				return ((Long) object).intValue();
			} else if (object instanceof Integer) {
				return ((Integer) object).intValue();
			} else {
				logger.error("统计HQL存在错误");
				return 0;
			}
		} catch (Exception e) {
			logger.error("通过条件查询统计数量出现异常:" + e);
			return 0;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取查询的数据总数(多表，单表都可以)
	 * 自定义Hql 语句，返回结果为int总数
	 * @param hql
	 * @return
	 * @author
	 */
	public int getMoreTableCount(String hql) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session = this.getSessionForRead();
			Query query = session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			Long a =  (Long) query.uniqueResult();
			return a.intValue();
		} catch (Exception e) {
			logger.error("通过条件查询统计数量出现异常:" + e);
			return 0;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 获取查询的数据总数(多表，单表都可以)
	 * 自定义Hql 语句，返回结果为int总数
	 * @param sqlCount
	 * @return
	 * @author
	 */
	public int getMoreTableCountBySQL(String sqlCount) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			SQLQuery createSQLQuery = session.createSQLQuery(sqlCount);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				createSQLQuery.setCacheable(true);// 设置查询缓存
			}
			return Integer.parseInt(createSQLQuery.uniqueResult().toString());
		} catch (Exception e) {
			logger.error("通过条件查询统计数量出现异常:" + e);
			return 0;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 通过sql语句修改单个对象或者批量对象
	 * 1、使用写的线程组来获取当前session，要和读的线程组分离开，否则读的线程中session为只读属性直接影响下面写操作的session的写操作功能。
	 */
	public boolean updateBySQL(String sql){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try{
			session=this.getSessionForWrite();
			SQLQuery sql_query=session.createSQLQuery(sql);
			int result=sql_query.executeUpdate();
			if(result>=0){
				return true;
			}else{
				return false;
			}
		}catch(Exception e){
			logger.error("通过条件查询对象出现异常:"+e);
			return false;
		}finally{
			closeSessionForWriteRead(session,threadLocal_write);
		}
	}

	/**
	 * 通过占位符的方式进行查询一个分页集合
	 * @param whereHQL 条件语句
	 * @param paramsMap 参数Map
	 * @param sortParam 排序字段
	 * @return List
	 */
	public List <T> findListByParamsMap(String selectColumns[],int firstIndex, int maxResult,String whereHQL,Map<Object, Object> paramsMap, String sortParam) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		Query query = null;
		StringBuffer sb = new StringBuffer();
		try {
			session=this.getSessionForRead();
			List <T> list = new ArrayList<T>();
			if (selectColumns != null) {
				//1、组装select 指定字段语句片段
				sb.append("select ");
				for (int i = 0; i < selectColumns.length; i++) {
					if (i == selectColumns.length - 1) {
						sb.append(" o.").append(selectColumns[i]);
					} else {
						sb.append(" o.").append(selectColumns[i]).append(" ,");
					}
				}
				//2、组装from语句片段
				sb.append(" from ").append(entityClass.getSimpleName()).append(" o ");
				//3、组装where语句片段
				if (whereHQL != null&&paramsMap!=null){
					//4、设置占位符的参数
					Set<Entry<Object, Object>> set = paramsMap.entrySet();
					if (set != null) {
						sb.append(whereHQL);
						if(sortParam!=null)sb.append(sortParam);
						query = session.createQuery(sb.toString());
						Iterator<Entry<Object, Object>> it = set.iterator();
						while (it.hasNext()) {
							Map.Entry mapentry = it.next();
							query.setParameter(mapentry.getKey().toString(), mapentry.getValue().toString());
						}
					}else{
						if(sortParam!=null)sb.append(sortParam);
						query = session.createQuery(sb.toString());
					}
				}else{
					if(sortParam!=null)sb.append(sortParam);
					query = session.createQuery(sb.toString());
				}
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				List <T[]> querylist = query.list();
				for (Object[] dataObjs : querylist) {
					Object query_obj = EncapsulationObject.getObject(selectColumns, entityClass, dataObjs);
					list.add((T)query_obj);
				}
			} else {
				//1、组装select 字段语句和from语句片段
				sb.append("select o from ").append(entityClass.getSimpleName()).append(" o ");
				//2、组装where语句片段
				//3、设置占位符的参数
				if (whereHQL != null&&paramsMap!=null){
					//4、设置占位符的参数
					Set<Entry<Object, Object>> set = paramsMap.entrySet();
					if (set != null) {
						sb.append(whereHQL);
						if(sortParam!=null)sb.append(sortParam);
						query = session.createQuery(sb.toString());
						Iterator<Entry<Object, Object>> it = set.iterator();
						while (it.hasNext()) {
							Map.Entry mapentry = it.next();
							query.setParameter(mapentry.getKey().toString(), mapentry.getValue().toString());
						}
					}else{
						if(sortParam!=null)sb.append(sortParam);
						query = session.createQuery(sb.toString());
					}
				}else{
					if(sortParam!=null)sb.append(sortParam);
					query = session.createQuery(sb.toString());
				}
				query.setFirstResult(firstIndex).setMaxResults(maxResult);
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				list=query.list();
			}
			return list;
		} catch (Exception e) {
			logger.error("通过条件查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 通过占位符的方式进行查询一个对象
	 * @param whereHQL 条件语句
	 * @param paramsMap 参数Map
	 * @param paramsMap 排序字段
	 * @return T
	 */
	public T findObjectByParamsMap(String selectColumns[],String whereHQL,Map<Object, Object> paramsMap) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		Query query = null;
		Object obj = null;
		StringBuffer sb = new StringBuffer();
		try {
			session=this.getSessionForRead();
			List <T> list = new ArrayList<T>();
			if (selectColumns != null) {
				//1、组装select 指定字段语句片段
				sb.append("select ");
				for (int i = 0; i < selectColumns.length; i++) {
					if (i == selectColumns.length - 1) {
						sb.append(" o.").append(selectColumns[i]);
					} else {
						sb.append(" o.").append(selectColumns[i]).append(" ,");
					}
				}
				//2、组装from语句片段
				sb.append(" from ").append(entityClass.getSimpleName()).append(" o ");
				//3、组装where语句片段
				if (whereHQL != null&&paramsMap!=null){
					//4、设置占位符的参数
					Set<Entry<Object, Object>> set = paramsMap.entrySet();
					if (set != null) {
						sb.append(whereHQL);
						query = session.createQuery(sb.toString());
						Iterator<Entry<Object, Object>> it = set.iterator();
						while (it.hasNext()) {
							Map.Entry mapentry = it.next();
							query.setParameter(mapentry.getKey().toString(), mapentry.getValue().toString());
						}
					}else{
						query = session.createQuery(sb.toString());
					}
				}else{
					query = session.createQuery(sb.toString());
				}
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				List <T[]> querylist = query.list();
				for (Object[] dataObjs : querylist) {
					Object query_obj = EncapsulationObject.getObject(selectColumns, entityClass, dataObjs);
					list.add((T)query_obj);
				}
			} else {
				//1、组装select 字段语句和from语句片段
				sb.append("select o from ").append(entityClass.getSimpleName()).append(" o ");
				//2、组装where语句片段
				//3、设置占位符的参数
				if (whereHQL != null&&paramsMap!=null){
					//4、设置占位符的参数
					Set<Entry<Object, Object>> set = paramsMap.entrySet();
					if (set != null) {
						sb.append(whereHQL);
						query = session.createQuery(sb.toString());
						Iterator<Entry<Object, Object>> it = set.iterator();
						while (it.hasNext()) {
							Map.Entry mapentry = it.next();
							query.setParameter(mapentry.getKey().toString(), mapentry.getValue().toString());
						}
					}else{
						query = session.createQuery(sb.toString());
					}
				}else{
					query = session.createQuery(sb.toString());
				}
				query.setMaxResults(1);
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				list=query.list();
				if(list!=null&&list.size()>0){
					obj=list.get(0);
				}
			}
			return (T) obj;
		} catch (Exception e) {
			logger.error("通过条件查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 查询单个对象中某些字段 selectColumns 查询字段 whereCondition where 条件参数
	 */
	public Object getObjectSome(String[] selectColumns, String whereCondition) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		StringBuffer sb = new StringBuffer();
		Object obj = null;
		try {
			session=this.getSessionForRead();
			if (selectColumns != null) {
				sb.append("select ");
				for (int i = 0; i < selectColumns.length; i++) {
					if (i == selectColumns.length - 1) {
						sb.append(" o.").append(selectColumns[i]);
					} else {
						sb.append(" o.").append(selectColumns[i]).append(" ,");
					}
				}
				sb.append(" from ").append(entityClass.getSimpleName()).append(" o ");
				if (whereCondition != null) sb.append(whereCondition);
				Query query = (Query) session.createQuery(sb.toString());
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				Object[] dataObjs = { query.uniqueResult() };
				obj = EncapsulationObject.getObject(selectColumns, entityClass,dataObjs);
			} else {
				sb.append("select o from ").append(entityClass.getSimpleName()).append(" o ");
				if (whereCondition != null) sb.append(whereCondition);
				Query query = (Query) session.createQuery(sb.toString());
				//判断该对象是否开启缓存
				if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
					query.setCacheable(true);// 设置查询缓存
				}
				obj = query.uniqueResult();
			}
			return obj;
		} catch (Exception e) {
			logger.error("通过条件查询集合出现异常:" + e);
			return null;
		} finally {
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 调用函数更新数据（只读）
	 * @param procedureSql
	 * @param procedureBeen 传入参数集合
	 * @return
	 */
	@Override
	public Map<String, Object> getDataByProcedure(String procedureSql, List<ProcedureBean> procedureBeen) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		Map<String, Object> result = new HashMap();
		session = getSessionForRead();
		Transaction transaction = null;
		Connection conn = null;  //获得连接
		CallableStatement cs = null;  //获取存储过程预编译
		try {
			transaction = session.beginTransaction();
			conn = SessionFactoryUtils.getDataSource(session.getSessionFactory()).getConnection(); //获得连接
			cs = conn.prepareCall(procedureSql);
			List<Integer> outIndex = new ArrayList<>();
			//解析过程需要的参数集合
			if (Utils.objectIsNotEmpty(procedureBeen)) {
				for (int i = 0; i < procedureBeen.size(); i++) {
					Integer index = i + 1;	//获得当前循环序列次号，因为CallableStatement设置参数从1开始，所以+1
					ProcedureBean bean = procedureBeen.get(i);
					if (bean.getSchema().equals(ProcedureBean.Schema.IN)){
						//设置传入参数
						cs.setObject(index, procedureBeen.get(i).getInputValue());
					}
					else if (bean.getSchema().equals(ProcedureBean.Schema.OUT)){
						//设置输出参数的类型
						cs.registerOutParameter(index, bean.getOutputType());
						outIndex.add(index);
					}
				}
			}
			cs.execute();
			transaction.commit();
			for (int i = 0; i < outIndex.size(); i++) {
				Integer index = outIndex.get(i);
				result.put(String.valueOf(procedureBeen.get(index - 1).getOutputKey()), cs.getObject(index));
			}
		} catch (SQLException e) {
			logger.error("通过调用函数查询数据出现异常:" + e);
		} finally {
			closeConnection(cs,conn);//关闭预编译，conn连接
			closeSessionForWriteRead(session,threadLocal_read);
		}
		return result;
	}

	/**
	 * 调用函数更新数据（只写）
	 *
	 * @param procedureSql
	 * @param procedureBeen  传入参数集合
	 * @return
	 */
	@Override
	public Map<String, Object> saveOrUpdateByProcedure(String procedureSql, List<ProcedureBean> procedureBeen) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		Map<String, Object> result = new HashMap();
		session = getSessionForWrite();
		Transaction transaction = null;
		Connection conn = null;  //获得连接
		CallableStatement cs = null;  //获取存储过程预编译
		try {
			transaction = session.beginTransaction();
			conn = SessionFactoryUtils.getDataSource(session.getSessionFactory()).getConnection(); //获得连接
			cs = conn.prepareCall(procedureSql);
			List<Integer> outIndex = new ArrayList<>();
			//解析过程需要的参数集合
			if (Utils.objectIsNotEmpty(procedureBeen)) {
				for (int i = 0; i < procedureBeen.size(); i++) {
					Integer index = i + 1;	//获得当前循环序列次号，因为CallableStatement设置参数从1开始，所以+1
					ProcedureBean bean = procedureBeen.get(i);
					if (bean.getSchema().equals(ProcedureBean.Schema.IN)){
						//设置传入参数
						cs.setObject(index, procedureBeen.get(i).getInputValue());
					}
					else if (bean.getSchema().equals(ProcedureBean.Schema.OUT)){
						//设置输出参数的类型
						cs.registerOutParameter(index, bean.getOutputType());
						outIndex.add(index);
					}
				}
			}
			cs.execute();
			transaction.commit();
			for (int i = 0; i < outIndex.size(); i++) {
				Integer integer = outIndex.get(i);
				result.put(String.valueOf(procedureBeen.get(integer - 1).getOutputKey()), cs.getObject(integer));
			}
		} catch (SQLException e) {
			logger.error("通过调用函数查询数据出现异常:" + e);
		} finally {
			closeConnection(cs,conn);//关闭预编译，conn连接
			closeSessionForWriteRead(session,threadLocal_write);
		}
		return result;
	}

	/******************************************************************************************************
	 * 通过HQL
	 * 准备清理下面4个方法
	 * @param hql
	 *******************************************************************************************************/
	@Override
	public List<?> findByHQL(String hql) {
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			Query query = (Query) session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List  <Object[]> querylist=query.list();
			return querylist;
		}catch(Exception e){
			logger.error("通过条件查询集合出现异常:"+e);
			return null;
		}finally{
			closeSessionForWriteRead(session,threadLocal_read);
		}
	}

	/**
	 * 通过HQL语句以及字段投影查询
	 */
	public List<?> findByHQL(String [] selectColumns,int firstIndex, int maxResult,String hql){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			Query query = (Query) session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setFirstResult(firstIndex).setMaxResults(maxResult);
			List  <Object[]> querylist=query.list();
			List list = null;
			if(querylist!=null){
				list = new ArrayList();
				for (Object[] dataObjs : querylist) {
					Object obj = EncapsulationObject.getObject(selectColumns, entityClass, dataObjs);
					list.add(obj);
				}
			}
			return list;
		}catch(Exception e){
			logger.error("通过条件查询集合出现异常:"+e);
			return null;
		}finally{
			closeSessionForWriteRead(session, threadLocal_read);
		}
	}

	/**
	 * 通过HQL语句
	 */
	public List<?> findByHQL(String [] selectColumns,String hql,int limit){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			Query query = (Query) session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			query.setFirstResult(0).setMaxResults(limit);//查询前limit条，否则查询所有
			List  <Object[]> querylist=query.list();
			List list = null;
			if(querylist!=null){
				list = new ArrayList();
				for (Object[] dataObjs : querylist) {
					Object obj = EncapsulationObject.getObject(selectColumns, entityClass, dataObjs);
					list.add(obj);
				}
			}
			return list;
		}catch(Exception e){
			logger.error("通过条件查询集合出现异常:"+e);
			return null;
		}finally{
			closeSessionForWriteRead(session, threadLocal_read);
		}
	}

	/**
	 * 通过HQL语句
	 */
	public List<?> findByHQL(String [] selectColumns,String hql){
		//BaseDao为Spring创建的单例模式，全局session会造成关闭异常
		Session session = null;
		try {
			session=this.getSessionForRead();
			Query query = (Query) session.createQuery(hql);
			//判断该对象是否开启缓存
			if (WebUtil.getOpenQueryCacheClass().contains(entityClass.getSimpleName())){
				query.setCacheable(true);// 设置查询缓存
			}
			List  <Object[]> querylist=query.list();
			List list = null;
			if(querylist!=null){
				list = new ArrayList();
				for (Object[] dataObjs : querylist) {
					Object obj = EncapsulationObject.getObject(selectColumns, entityClass, dataObjs);
					list.add(obj);
				}
			}
			return list;
		}catch(Exception e){
			logger.error("通过条件查询集合出现异常:"+e);
			return null;
		}finally{
			closeSessionForWriteRead(session, threadLocal_read);
		}
	}

}