package util.service;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import shop.customer.service.IFundDetailService;
import shop.order.service.IOrdersService;
import shop.returnsApply.service.IReturnsApplyService;
import util.other.Utils;

/**
 * 订单返利定时器Service
 * @author Administrator
 *
 */
public class QuartzOrdersRebateService {
	/**
	 * 日志
	 */
	public Logger logger = Logger.getLogger(this.getClass());
	
	/**订单Service**/
	private IOrdersService ordersService;
	/**退货申请单Service**/
	private IReturnsApplyService returnsApplyService;
	/**资金流水明细Service**/
	private IFundDetailService fundDetailService;

	/**
	 * 订单完成7天，自动返利
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void saveRebateOrders() throws Exception{
		logger.info("进入自动返利");
		SimpleDateFormat sdf=new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
		Date d=new Date();//当前时间
		//正式7天
//		String date = sdf.format(new Date(d.getTime() - 7*24*60*60*1000));//24小时*7天
		//测试2分钟
		String date = sdf.format(new Date(d.getTime() - 2*60*1000));//2分钟
		//查询订单（已完成、未返利）
		String hql = "select o.ordersId as ordersId,o.totalOrdersNo as totalOrdersNo,o.ordersNo as ordersNo,o.rebateAmount as rebateAmount,o.secRebateAmount as secRebateAmount,o.thiRebateAmount as thiRebateAmount,"
				+ "o.isReturn as isReturn,o.customerId as customerId from Orders o ,Customer c  where  o.customerId=c.customerId " +
				" and UNIX_TIMESTAMP(o.updateTime)<=UNIX_TIMESTAMP('"+date+"') and o.ordersState in (5,9) and o.isRebate=0";
		List<Map> listMap = ordersService.findListMapByHql(hql);
		logger.info("待返利条数：" + listMap.size());
		if(Utils.collectionIsNotEmpty(listMap)){
			for(Map<String,Object> map:listMap){
				//用户ID
				Integer customerId = Integer.parseInt(String.valueOf(map.get("customerId")));
				//订单ID
				Integer ordersId = Integer.parseInt(String.valueOf(map.get("ordersId")));
				//总订单号
				String totalNo = String.valueOf(map.get("totalOrdersNo"));
				//订单号
				String code = String.valueOf(map.get("ordersNo"));
				//是否有退货
				Integer isReturn = Integer.parseInt(String.valueOf(map.get("isReturn")));
				//最终参与返利金额
				BigDecimal amount = new BigDecimal(0);
				//最终参与返利金额
				BigDecimal secAmount = new BigDecimal(0);
				//最终参与返利金额
				BigDecimal thiAmount = new BigDecimal(0);
				//已完成订单，用户返利有效金额
				String rebateAmount = String.valueOf(map.get("rebateAmount"));//一级返利金额
				logger.info("一级返利金额:" + rebateAmount);
				String secRebateAmount = String.valueOf(map.get("secRebateAmount"));//二级返利金额
				logger.info("二级返利金额:" + secRebateAmount);
				String thiRebateAmount = String.valueOf(map.get("thiRebateAmount"));//三级返利金额
				logger.info("三级返利金额:" + thiRebateAmount);
				amount = new BigDecimal(rebateAmount);
				secAmount = new BigDecimal(secRebateAmount);
				thiAmount = new BigDecimal(thiRebateAmount);
				boolean isReturns=true;
				if(isReturn!=0){//订单有退货
					//查询退货订单数
					Integer sumCount = returnsApplyService.getCount("where o.ordersId="+ordersId);
					//查询完成退货订单数
					Integer returnCount = returnsApplyService.getCount("where o.returnsState=5 and o.ordersId="+ordersId);
					if(sumCount!=returnCount){//存在未完成退货单，不参与返利
						isReturns=false;
						break;
					}
				}
				//操作返利
				if(isReturns){
					String isSuccess = fundDetailService.saveOrderOver(customerId,totalNo,code,amount,secAmount,thiAmount);
					if(isSuccess.equals("success")){
						//修改订单返利状态：已返利
						ordersService.updateBySQL("update shop_orders o set o.isRebate=1 where o.ordersId="+ordersId);
					}
				}
			}
		}
	}


	public void setOrdersService(IOrdersService ordersService) {
		this.ordersService = ordersService;
	}
	public void setReturnsApplyService(IReturnsApplyService returnsApplyService) {
		this.returnsApplyService = returnsApplyService;
	}
	public void setFundDetailService(IFundDetailService fundDetailService) {
		this.fundDetailService = fundDetailService;
	}
}
