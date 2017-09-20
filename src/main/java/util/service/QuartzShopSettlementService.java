package util.service;

import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import shop.order.dao.IOrdersDao;
import shop.store.dao.IShopSettlementDetailDao;
import shop.store.pojo.ShopSettlementDetail;
import util.other.ConfigUtils;
import util.other.Utils;

/**
* ################################
 * @作用：定时器
 * @功能：店铺自动申请结算
 * @作者: Mengqirui
 * @日期：2016年1月15日 上午10:20:04
 * @版本：V1.0
 * ################################
 * 定时规则：每个月的15日启动定时器
 * 扫描规则：扫描上个月以及之前的订单
 * 结算条件：
 * 			订单日志操作状态：5或9（已收货或已评价）
 * 			订单付款状态：1（已付款）
 * 			订单商家结算状态：0（未结算）
 * ################################
 */
@SuppressWarnings("rawtypes")
public class QuartzShopSettlementService {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	/**订单service**/
	private static IOrdersDao ordersDao;
	/**订单结算申请service**/
	private IShopSettlementDetailDao shopSettlementDetailDao;
	/**内部类对象**/
	private ShopSettlementBean ssb = new ShopSettlementBean();
	/**
	 * 主方法
	 */
	public void updateShopSettlement(){
		//【1.读取所有商家数据】
		String shopSql = "SELECT a.shopInfoId,a.shopName,a.customerId,a.companyName,a.commission FROM shop_shopinfo a ,basic_customer b where a.customerId = b.customerId and b.type = 2 ";
		List<Map<String, Object>> shopList = ordersDao.findListMapBySql(shopSql);
		if(Utils.collectionIsNotEmpty(shopList)){
			for(Map<String, Object> map:shopList){
				//【2.读取每一个商家的未结算订单】
				String shopInfoId = String.valueOf(map.get("shopInfoId"));
				List<Map> ordersList = findOrdersByShopInfoId(shopInfoId);
				if(Utils.collectionIsNotEmpty(ordersList)){
					//【3.生成结算记录】
					ssb = getOrdersIds(ordersList);
					//如果没有交易金额 那么忽略掉 不进行统计申请
					if(Utils.stringIsNotEmpty(ssb.getOrdersIds())){
						try {
							makeShopSettlementDetail(map, ssb);
						} catch (ParseException e) {
							String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
						}
					}
				}
			}

		}
	}
	/**
	 * 生成结算记录
	 * @param map
	 * 			查询出的店铺对象
	 * @throws ParseException
	 */
	@SuppressWarnings({ "unused" })
	public void makeShopSettlementDetail(Map map,ShopSettlementBean ssb) throws ParseException{
			ShopSettlementDetail shopSettlementDetail = new ShopSettlementDetail();
			shopSettlementDetail.setShopInfoId(Integer.parseInt(String.valueOf(map.get("shopInfoId"))));
			shopSettlementDetail.setShopName(String.valueOf(map.get("shopName")));
			shopSettlementDetail.setCustomerId(Integer.parseInt(String.valueOf(map.get("customerId"))));
			shopSettlementDetail.setCreateDate(new Date());
			String searchTime = getSearchTime();
			SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM");
			shopSettlementDetail.setSettlementDate(fm.format(fm.parse(searchTime)));
			shopSettlementDetail.setCompanyName(String.valueOf(map.get("companyName")));
			shopSettlementDetail.setTotalCost(ssb.getSum());
			shopSettlementDetail.setStatus(1);
			shopSettlementDetail.setOrdersIds(ssb.getOrdersIds());
			shopSettlementDetail.setCommissionProportion(getCommission(String.valueOf(map.get("commission"))));
			ShopSettlementDetail shopSettlementDetailNew = (ShopSettlementDetail) shopSettlementDetailDao.saveOrUpdateObject(shopSettlementDetail);
	}
	/**
	 * 获取佣金比例
	 */
	public BigDecimal getCommission(String commission){
		String commissionProportionSYS = String.valueOf(ConfigUtils. getSystemConfigValue("commissionProportion"));
		BigDecimal commissionProportion = new BigDecimal(commissionProportionSYS);
		if(commission != null){
			commissionProportion = new BigDecimal(commission);
		}
		return commissionProportion;
	}


	/**
	 * 遍历订单获取订单IDS以及结算总金额数据
	 */
	public ShopSettlementBean getOrdersIds(List<Map> ordersList){
		String ids = "";
		BigDecimal sum = new BigDecimal(0);
		for(Map map :ordersList){
			ids += String.valueOf(map.get("ordersId"))+",";
			sum = sum.add(new BigDecimal(String.valueOf(map.get("finalAmount"))));
		}
		if(Utils.stringIsNotEmpty(ids)){
			ids = ids.substring(0, ids.lastIndexOf(","));
		}
		ssb.setOrdersIds(ids);
		ssb.setSum(sum);
		return ssb;
	}


	/**
	 * 查询未结算订单
	 */
	public List<Map> findOrdersByShopInfoId(String shopInfoId){
			String hql="SELECT a.ordersId as ordersId,c.operatorTime as operatorTime ,a.ordersNo as ordersNo,a.createTime as createTime,a.finalAmount as finalAmount,a.ordersState as ordersState FROM "
					+ "Orders a,ShopInfo b ,OrdersOPLog c WHERE b.shopInfoId="+shopInfoId+" and a.settlementStatusForSellers=0 and a.settlementStatus=1 and  a.shopInfoId=b.shopInfoId and c.ordersId=a.ordersId and (c.ordersOperateState=5 or c.ordersOperateState=9) ";
			//获取查询时间
			String searchTime = getSearchTime();
			hql += " and UNIX_TIMESTAMP('"+searchTime+"') >= UNIX_TIMESTAMP(c.operatorTime)";
			List<Map> ordersList = ordersDao.findListMapByHql(hql+" group by a.ordersId");
		return ordersList;
	}

	/**
	 * 获取查询时间
	 */
	public String getSearchTime(){
		SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
		Calendar cal=Calendar.getInstance();//获取当前日期
		cal.add(Calendar.MONTH, 0);
		cal.set(Calendar.DAY_OF_MONTH,1);//设置为1号,当前日期既为本月第一天
		cal.add(Calendar.DATE, -1);//减少一天
		Date d= cal.getTime();
		String time = fm.format(d)+" 23:59:59";
		return time;
	}


	/**
	 * 内部类
	 * 用来保存订单的IDS以及结算总金额
	 */
	public class ShopSettlementBean{
		/**订单IDS**/
		private String ordersIds;
		/**结算总金额**/
		private BigDecimal sum;
		//setter getter
		public String getOrdersIds() {
			return ordersIds;
		}
		public void setOrdersIds(String ordersIds) {
			this.ordersIds = ordersIds;
		}
		public BigDecimal getSum() {
			return sum;
		}
		public void setSum(BigDecimal sum) {
			this.sum = sum;
		}
	}
	//setter getter
	@SuppressWarnings("static-access")
	public void setOrdersDao(IOrdersDao ordersDao) {
		this.ordersDao = ordersDao;
	}
	public void setShopSettlementDetailDao(
			IShopSettlementDetailDao shopSettlementDetailDao) {
		this.shopSettlementDetailDao = shopSettlementDetailDao;
	}

}
