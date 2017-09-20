package basic.service.imp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.springframework.web.context.ServletContextAware;

import promotion.dao.IStoreApplyPromotionDao;
import shop.customer.dao.ICustomerDao;
import shop.information.dao.IInformationDao;
import shop.order.dao.IOrdersDao;
import shop.product.dao.IProductInfoDao;
import shop.returnsApply.dao.IReturnsApplyDao;
import shop.store.dao.IShopInfoDao;
import tuan.dao.ITuanProductDao;
import util.common.EnumUtils;
import util.json.FastJsonUtils;
import util.other.Utils;
import util.service.BaseService;
import basic.dao.IStatisticsDao;
import basic.pojo.Statistics;
import basic.service.IStatisticsService;
/**
 * 统计Service接口实现类
 * @author wy
 *
 */
public class StatisticsService extends BaseService <Statistics> implements IStatisticsService,ServletContextAware{
	private IStatisticsDao statisticsDao;//统计Dao
	private ICustomerDao customerDao;//会员Dao
	private IShopInfoDao shopInfoDao;//店铺Dao
	private IProductInfoDao productInfoDao;//套餐Dao
	private IOrdersDao ordersDao;//订单Dao
	private IReturnsApplyDao returnsApplyDao;//退货Dao
	private IInformationDao informationDao;//信息Dao
	private ITuanProductDao tuanProductDao;//团购套餐
	private IStoreApplyPromotionDao storeApplyPromotionDao;//店铺申请促销活动Service
	//servlet 上下文
	private ServletContext servletContext;

	public Map<String,Object> getStatisticsMap(){
		Map<String,Object> statisticsMap = new HashMap<String,Object>();
		//创建Date对象
		Date endDate = new Date();
		//创建基于当前时间的日历对象
		Calendar cl = Calendar.getInstance();
		cl.setTime(endDate);
		//距离今天，一周内的数据
		cl.add(Calendar.DATE, -7);
		Date startDate = cl.getTime();
		SimpleDateFormat dd = new SimpleDateFormat("yyyy-MM-dd");
		//格式化开始日期和结束日期
		String start = dd.format(startDate);
		String end = dd.format(endDate);
		//一周新增会员数
		Integer newCustomersCount = customerDao.getCount(" where o.registerDate between '"+start+"' and '"+end+"'");
		statisticsMap.put("101", newCustomersCount);
		//新增套餐数
		Integer newProductsCount = productInfoDao.getCount(" where o.updateDate between '"+start+"' and '"+end+"'");
		statisticsMap.put("102", newProductsCount);
		//新增店铺数
		Integer newShopsCount = shopInfoDao.getCount(" where o.applyTime between '"+start+"' and '"+end+"'");
		statisticsMap.put("103", newShopsCount);
		//新增订单数
		Integer newOrdersCount = ordersDao.getCount(" where o.createTime between '"+start+"' and '"+end+"'");
		statisticsMap.put("107", newOrdersCount);
		//新增资讯
		Integer newsCount = informationDao.getCount(" where o.createTime between '"+start+"' and '"+end+"'");
		statisticsMap.put("109", newsCount);
		//会员总数
		String customersHql="SELECT count(a.loginName) FROM Customer a,ShopCustomerInfo b where a.customerId=b.customerId";
		Integer allCustomersCount = customerDao.getCountManyTable(customersHql);
		statisticsMap.put("201", allCustomersCount);
		//套餐总数
		Integer allProductsCount = productInfoDao.getCount("");
		statisticsMap.put("210", allProductsCount);
		//店铺总数
		String whereCondition="SELECT count(a.shopInfoId) from ShopInfo a , ShopCategory b,Customer c where a.shopCategoryId=b.shopCategoryId and a.customerId=c.customerId ";
		Integer allShopsCount = shopInfoDao.getCountManyTable(whereCondition);
		statisticsMap.put("203", allShopsCount);
		//店铺待审核总数
		Integer pendingShopsCount = shopInfoDao.getCount(" where o.isPass =1");
		statisticsMap.put("204", pendingShopsCount);
		//未结算账单总数
		Integer notSettledOrdersCount = ordersDao.getCount(" where o.settlementStatus =0");
		statisticsMap.put("205", notSettledOrdersCount);
		//套餐待审核总数
		Integer pendingProductsCount = productInfoDao.getCount(" where o.isPass =3");
		statisticsMap.put("206", pendingProductsCount);
		//套餐退款总数
		List<Map<String,Object>>  list= returnsApplyDao.findListMapBySql("SELECT SUM(r.count*o.salesPrice) AS sum FROM shop_returnsapply r,shop_orderslist o WHERE  r.returnsState=5 AND o.ordersId=r.ordersId");
		if(Utils.collectionIsNotEmpty(list)){
			statisticsMap.put("211",list.get(0).get("sum"));
		}
		//套餐售款总数
		List<Map<String,Object>>  amountlist= ordersDao.findListMapBySql(" SELECT SUM(o.finalAmount) as sum FROM shop_orders o WHERE o.ordersState=5");
		if(Utils.collectionIsNotEmpty(amountlist)){
			statisticsMap.put("212",amountlist.get(0).get("sum"));
		}
		//待发货订单总数
		Integer shippedOrdersCount = ordersDao.getCount(" where o.ordersState =3");
		statisticsMap.put("207", shippedOrdersCount);
		//待付款订单总数
		Integer obligationsOrdersCount = ordersDao.getCount(" where o.settlementStatus =0");
		statisticsMap.put("208", obligationsOrdersCount);
		//待评价订单总数
		Integer evaluatedOrdersCount = ordersDao.getCount(" where o.ordersState =5");
		statisticsMap.put("209", evaluatedOrdersCount);
		//套餐退货总数
		Integer returnProductsCount = returnsApplyDao.getCount(" where o.returnsState =5");
		statisticsMap.put("213", returnProductsCount);
		//促销套餐总数
		Integer promotionProductsCount = storeApplyPromotionDao.getCount(" where o.promotionState =1");
		statisticsMap.put("114", promotionProductsCount);
		//套餐团购总数
		Integer groupBuyingProductsCount = tuanProductDao.getCount(" ");
		statisticsMap.put("115", groupBuyingProductsCount);
		//活跃会员（待定）
		return statisticsMap;
	}
	/**
	 * @功能：定时修改后台首页展示数据，并同时更新application中的值
	 * @作者:
	 * @参数：
	 * @返回值：void
	 * @日期: 2016年2月22日 下午2:32:27
	 */
	public void updateStatistics(){
		//System.out.println("定时修改统计数据--开始");
		//取值
		Map<String,Object> statisticsMap = getStatisticsMap();
		//修改首页计数据
		updateStatisticsInfo(statisticsMap);
		//更新ServletContext值
		updateServletContext();
		//System.out.println("定时修改统计数据--结束");

	}
	/**
	 * @功能：根据map的值修改统计表中的值，key为where条件，value为修改内容
	 * @作者:
	 * @参数： @param statisticsMap
	 * @返回值：void
	 * @日期: 2016年2月22日 下午3:24:21
	 */
	private void updateStatisticsInfo(Map<String,Object> statisticsMap){
		Iterator<String> it=statisticsMap.keySet().iterator();
		String key = "";
		while(it.hasNext()){
			key = it.next();
			SimpleDateFormat fmt = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());//格式大小写有区别
			String updateTime = fmt.format(new Date());
			//修改统计表数据操作
			statisticsDao.updateBySQL("update basic_statistics o set o.updateTime='"+updateTime+"', o.statisticsNum='"+statisticsMap.get(key)+"' where o.statisticsCode="+key);
		}
	}
	/**
	 * @功能：修改ServletContext值
	 * @作者:
	 * @参数：
	 * @返回值：void
	 * @日期: 2016年2月22日 下午3:11:54
	 */
	private void updateServletContext(){
		String sql="SELECT statisticsType,statisticsName,statisticColor,statisticsNum,statisticsUrl FROM `basic_statistics` WHERE isShow=1";
		//查询当前统计的数据
		List<Map<String,Object>> statisticsList =statisticsDao.findListMapBySql(sql);
		//写到servlet上下文中
		String statisticsListJson = FastJsonUtils.toJSONString(statisticsList);
		servletContext.setAttribute("statisticsList", statisticsListJson);
		SimpleDateFormat fmt = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());//格式大小写有区别
		String updateTime = fmt.format(new Date());
		servletContext.setAttribute("time2",updateTime);//当前本次统计时间
		Calendar dar=Calendar.getInstance();
		dar.setTime(new Date());
		dar.add(java.util.Calendar.HOUR_OF_DAY, 2); //延后2小时
		servletContext.setAttribute("time3",fmt.format(dar.getTime()));
	}
	public void setStatisticsDao(IStatisticsDao statisticsDao) {
		this.baseDao = this.statisticsDao = statisticsDao;
	}
	public void setCustomerDao(ICustomerDao customerDao) {
		this.customerDao = customerDao;
	}
	public void setShopInfoDao(IShopInfoDao shopInfoDao) {
		this.shopInfoDao = shopInfoDao;
	}
	public void setProductInfoDao(IProductInfoDao productInfoDao) {
		this.productInfoDao = productInfoDao;
	}
	public void setOrdersDao(IOrdersDao ordersDao) {
		this.ordersDao = ordersDao;
	}
	public void setReturnsApplyDao(IReturnsApplyDao returnsApplyDao) {
		this.returnsApplyDao = returnsApplyDao;
	}
	public void setInformationDao(IInformationDao informationDao) {
		this.informationDao = informationDao;
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
	public void setStoreApplyPromotionDao(
			IStoreApplyPromotionDao storeApplyPromotionDao) {
		this.storeApplyPromotionDao = storeApplyPromotionDao;
	}
	public void setTuanProductDao(ITuanProductDao tuanProductDao) {
		this.tuanProductDao = tuanProductDao;
	}

}
