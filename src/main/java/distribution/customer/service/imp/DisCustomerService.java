package distribution.customer.service.imp;

import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import shop.customer.pojo.CustomerBankroll;
import util.pojo.PageHelper;
import util.service.BaseService;

import com.sun.org.apache.xml.internal.security.exceptions.Base64DecodingException;
import com.sun.org.apache.xml.internal.security.utils.Base64;

import distribution.configure.pojo.DisConfigure;
import distribution.customer.dao.IDisCustomerDao;
import distribution.customer.pojo.DisCustomer;
import distribution.customer.service.IDisCustomerService;
/**
 * 分销用户关系：前台Action的service实现类
 * @author 
 */

public class DisCustomerService extends BaseService<DisCustomer> implements IDisCustomerService {
	private IDisCustomerDao disCustomerDao;
	
	@Override
	public PageHelper getPageHelper(PageHelper pageHelper,Map<String,Object> map){
		String where =" where 1=1 ";
		if(!"0".equals(map.get("backJMSId"))){
			where+=" and JMSId = "+map.get("backJMSId");
		}
		if(!"-1".equals(map.get("isJMS"))){
			where+=" and isJMS = "+map.get("isJMS");
		}
		if(!"-1".equals(map.get("isCriticalValue"))){
			where+=" and isCriticalValue = "+map.get("isCriticalValue");
		}
		if(map.get("level1Id")!=null&&!"".equals(map.get("level1Id"))){
			where+=" and level1Id="+map.get("level1Id");
		}
		if(map.get("level2Id")!=null&&!"".equals(map.get("level2Id"))){
			where+=" and level2Id="+map.get("level2Id");
		}
		if(map.get("level3Id")!=null&&!"".equals(map.get("level3Id"))){
			where+=" and level3Id="+map.get("level3Id");
		}
		if(map.get("customerName")!=null&&!"".equals(map.get("customerName"))){
			try {
				where+=" and  b.trueName like '%"+ new String(Base64.encode(map.get("customerName").toString().getBytes("utf-8")))+"%' ";
			} catch (UnsupportedEncodingException e) {
				String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			}
		}
		String sqlCont="select COUNT(c.customerId) from x15_customer  c "
				+ "LEFT JOIN x15_customer_bankroll cb on cb.customerId=c.customerId "
				+ "LEFT JOIN basic_customer b on b.customerId=c.customerId ";
		int totalRecordCount =Integer.parseInt(disCustomerDao.getMaxDataSQL(sqlCont+where).toString());
		pageHelper.setPageInfo(pageHelper.getPageSize(), totalRecordCount, pageHelper.getCurrentPage());
		//%H:%i:%s
		String sql="select "
				+ "c.customerId,c.isCriticalValue,date_format(c.createTime,'%Y-%m-%d') as createTime,"
				+ "cb.*,b.trueName as customerName,c.isJMS "
				+ "from x15_customer  c  "
				+ "LEFT JOIN x15_customer_bankroll cb on cb.customerId=c.customerId "
				+ "LEFT JOIN basic_customer b on b.customerId=c.customerId "
				+where
				+ " ORDER BY c.createTime ";
		
		List<Map<String,Object>> drwingList =this.findListMapPageBySql(sql, pageHelper);
		if(drwingList!=null&&drwingList.size()>0){
			for (int i = 0; i < drwingList.size(); i++) {
				if(drwingList.get(i).get("isCriticalValue").toString().equals("1")){
					drwingList.get(i).put("isCriticalValue", "是");
				}else{
					drwingList.get(i).put("isCriticalValue", "否");
				}
				
				if(drwingList.get(i).get("isJMS").toString().equals("1")){
					drwingList.get(i).put("isJMS", "是");
				}else{
					drwingList.get(i).put("isJMS", "否");
				}
				
				
				if(drwingList.get(i).get("customerName")!=null){
					String s=drwingList.get(i).get("customerName").toString();
					if(!s.trim().equals("")){
						try {
							s=new String(Base64.decode(s.getBytes("utf-8")),"utf-8");
						} catch (UnsupportedEncodingException e) {
							String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
						} catch (Base64DecodingException e) {
							String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
						}
						drwingList.get(i).put("customerName",s);
					}
				}
			}
		}
		pageHelper.setObjectList(drwingList);
		return pageHelper;
	}
	
	@Override
	public DisCustomer getDisCustomerByCustomerId(int customerId){
		return (DisCustomer)disCustomerDao.get(" where o.customerId = "+customerId);
	}
	
	/**
	 * 修改用户关系表字段值
	 * @param customerId
	 * @param type
	 * @param value
	 * @return
	 */
	@Override
	public DisCustomer updateDisCustomer(DisCustomer disCustomer,String type,int value){
		if(("isCriticalValue").equals(type)){
			if(value==1){
				disCustomer.setIsCriticalValue(value);
			}
		}
		return (DisCustomer) disCustomerDao.saveOrUpdateObject(disCustomer);
	}
	
	@Override
	public int updateOrCheckIsCriticalValue(DisCustomer customer, CustomerBankroll customerBankroll,DisConfigure disConfigure) {
		if(customer==null){
			return 0;
		}
		if(customer.getIsJMS()==1||customer.getIsCriticalValue()==1){
			//已经具有资格 不再检查是否发送消息
			return 2;
		}else{
			//检查 有效累计消费+账户总额 是否满足消费临界值
			if(customerBankroll.getRebateAmount().compareTo(disConfigure.getRebatePrice())>=0){
				this.updateDisCustomer(customer, "isCriticalValue",1);
				return 1;
			}else{
				return 4;
			}
		}
	}

	public void setDisCustomerDao(IDisCustomerDao disCustomerDao) {
		this.baseDao = this.disCustomerDao = disCustomerDao;
	}
}
