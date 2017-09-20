package shop.order.service.imp;

import basic.pojo.KeyBook;
import basic.pojo.Users;
import basic.service.IKeyBookService;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.commons.collections.iterators.EntrySetMapIterator;
import org.apache.log4j.Logger;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.classic.Session;

import shop.cityCourier.pojo.CityCourier;
import shop.common.pojo.CoinRules;
import shop.customer.pojo.*;
import shop.customer.service.*;
import shop.order.dao.IOrdersDao;
import shop.order.dao.IOrdersOPLogDao;
import shop.order.dao.IShippingDao;
import shop.order.pojo.Orders;
import shop.order.pojo.OrdersList;
import shop.order.pojo.OrdersOPLog;
import shop.order.pojo.Shipping;
import shop.order.service.IOrdersListService;
import shop.order.service.IOrdersService;
import shop.product.pojo.ProductInfo;
import shop.product.service.IProductInfoService;
import util.other.*;
import util.service.BaseService;

import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
/**
 * 订单service层实现类
 * @author 张攀攀
 *
 */
public class OrdersService extends BaseService<Orders> implements IOrdersService{
	private IOrdersDao ordersDao;
	private IOrdersOPLogDao ordersOPLogDao;
	private IShippingDao shippingDao;
	private IMallCoinService mallCoinService;
	private IOrdersListService ordersListService;
	private IProductInfoService productInfoService;
	private IIncomePayDetailService incomePayDetailService;
	private ICustomerBankrollService customerBankrollService;
	private IFundDetailService fundDetailService;
	private ICustomerService customerService;

	/**
	 * 订单支付回调的统一接口（修改状态和产品的销量,收支明细）
	 *
	 * @param ordersNo 订单号 AESUtils加密过后的订单号
	 * @param dealId   第三方支付交易号 AESUtils加密过后的交易号
	 * @param payMode  支付方式
	 */
	@Override
	public List<Orders> savePaySuccess(String ordersNo, String dealId, Orders.PayMode payMode) throws Exception {
		boolean flag = true;
		if (Utils.objectIsEmpty(ordersNo)) return null;

		ordersNo = AESUtils.decrypt(ordersNo);    //解密-订单号

		List<Orders> listOrders = ordersDao.findOrders(ordersNo);
		if (Utils.objectIsEmpty(listOrders) || listOrders.size() < 1) return null;

		dealId = Utils.objectIsNotEmpty(dealId) ? AESUtils.decrypt(dealId) : null;    //解密-交易号
		int countSuccess = 0;
		for (Orders order : listOrders) {
			//订单的更改
			if (order.getOrdersState() == 0 && order.getSettlementStatus() == 0) {
				if (Utils.objectIsNotEmpty(dealId)) order.setDealId(dealId);//支付交易号（支付宝，快钱，微信等）
				
				//查询是否有预约信息,根据结果设置状态
				Integer ordersId = order.getOrdersId();
				List<Map<String, Object>> list = ordersListService.findListMapBySql("SELECT q.id FROM shop_orderslist s,qy_examination q WHERE s.orderDetailId = q.orderDetailId and s.ordersId = "+ordersId);
				if(list != null && list.size()>0){
					order.setOrdersState(3);
				}else{
					order.setOrdersState(11);
				}
				order.setSettlementStatus(1);//付款成功(含义：已经付款);
				order.setPayMode(payMode.getValue());//保存支付方式
				order.setUpdateTime(new Date());

				order = ordersDao.saveOrUpdateObject(order);
				if (Utils.objectIsNotEmpty(order)) {
					countSuccess++;
				}
			}
		}

		//检查修改订单状态成功条数
		if (countSuccess - listOrders.size() != 0) {
			return null;
		}

		return listOrders;
	}

	/**
	 * 保存支付成功后回调修改相关数据
	 */
	@Override
	public void savePaySuccessCallBack(String ordersNo, Orders.PayMode payMode, List<Orders> listOrders) {
//		List<ProductInfo> listProductInfo = new ArrayList<>();
//		HashSet<ProductInfo> hashsetProductInfo = new HashSet<>();
		Map<Integer, ProductInfo> mapProductInfo = new LinkedHashMap<>();
		if (Utils.objectIsEmpty(ordersNo) || Utils.objectIsEmpty(payMode) || Utils.objectIsEmpty(listOrders) || listOrders.size() < 1) return;

		Customer customer = customerService.getObjectByColumnId("customerId", String.valueOf(listOrders.get(0).getCustomerId()));
		if (Utils.objectIsEmpty(customer)) return;

		ordersNo = AESUtils.decrypt(ordersNo);    //解密-订单号

		BigDecimal amount = new BigDecimal(0);
		for (Orders order : listOrders) {
			//订单的更改
			if ((order.getOrdersState() == 11||order.getOrdersState() == 3||order.getOrdersState() == 0) && order.getSettlementStatus() == 1) {

				amount = amount.add(order.getFinalAmount());//支付金额
				amount = amount.setScale(2, BigDecimal.ROUND_HALF_UP);
				//保存订单日志
				OrdersOPLog ordersOPLog = new OrdersOPLog();
				ordersOPLog.setOrdersId(order.getOrdersId());
				ordersOPLog.setOrdersNo(order.getOrdersNo());
				ordersOPLog.setOperatorTime(new Date());
				ordersOPLog.setOrdersOperateState(2);
				ordersOPLog.setOoperatorId(customer.getCustomerId());//操作人id
				ordersOPLog.setOoperatorSource("3");//1、后台用户；2、后台系统；3、前台顾客；
				ordersOPLog.setOperatorName(customer.getLoginName());//操作人name
				ordersOPLogDao.saveOrUpdateObject(ordersOPLog);//保存订单日志
				//套餐的更改
				List<OrdersList> ordersLists = ordersListService.getOrdersListByOrdersNo(order.getOrdersNo());
				if (Utils.objectIsNotEmpty(ordersLists) && ordersLists.size() > 0) {
					for (OrdersList ordersList : ordersLists) {
						ProductInfo productInfo = new ProductInfo();
						productInfo = productInfoService.getProductInfoByProductId(ordersList.getProductId());
						productInfo.setTotalSales(productInfo.getTotalSales() + ordersList.getCount());
						productInfo.setUpdateDate(new Date());
						
						
						if(mapProductInfo.containsKey(productInfo.getProductId())){
							ProductInfo productInfo2 = mapProductInfo.get(productInfo.getProductId());
							Integer totalSales = productInfo2.getTotalSales();
							productInfo.setTotalSales(totalSales+1);
							mapProductInfo.put(productInfo.getProductId(), productInfo);
							
						}else{
							mapProductInfo.put(productInfo.getProductId(), productInfo);
						}
//						productInfoService.saveOrUpdateObject(productInfo);
					}
				}
				//收支明细(收款人一条记录，付款人一条记录)
				//根据订单查找付款人
				List<Map> payer = ordersDao.findPayerByOrdersNo(order.getOrdersNo());
				if (payer != null && payer.size() > 0) {
					Map mapPayer = payer.get(0);
					IncomePayDetail payerDetail = new IncomePayDetail();//付款人明细
					payerDetail.setPayerId(customer.getCustomerId());
					payerDetail.setPayerName(customer.getLoginName());
					payerDetail.setOutlay(order.getFinalAmount());
					payerDetail.setTradeTime(new Date());
					payerDetail.setSerialNumber(SerialNumberUtil.PaymentSnNumber());
					payerDetail.setIncomeExpensesType(2);//2.会员支付
					incomePayDetailService.saveOrUpdateObject(payerDetail);

					IncomePayDetail payeeDetail = new IncomePayDetail();//收款人明细
					payeeDetail.setPayeeId(Integer.parseInt(mapPayer.get("customerId").toString()));
					payeeDetail.setPayeeName(customer.getLoginName());
					payeeDetail.setIncome(order.getFinalAmount());
					payeeDetail.setTradeTime(new Date());
					payeeDetail.setSerialNumber(SerialNumberUtil.PaymentSnNumber());
					payeeDetail.setIncomeExpensesType(2);//2.会员支付
					incomePayDetailService.saveOrUpdateObject(payeeDetail);
				}
			}
		}

		if (payMode.compareTo(Orders.PayMode.ACCOUNTPAY) == 0) {    // 如果是余额支付时
			//增加消费明细
			FundDetail fundDetail = new FundDetail();
			fundDetail.setCustomerId(customer.getCustomerId());
			fundDetail.setOrdersNo(ordersNo);
			fundDetail.setFundDetailsCode(SerialNumberUtil.PaymentSnNumber());
			fundDetail.setAmount(amount);
			fundDetail.setFundDetailsType(2);    //消费类型 1收入 2支出
			fundDetail.setTransactionTime(new Date());
			fundDetail.setSource(3);            //来源 余额消费
			fundDetailService.saveOrUpdateObject(fundDetail);
		}
		
		

		if(mapProductInfo!=null&&mapProductInfo.size()>0){
			Set<Entry<Integer,ProductInfo>> mapList = mapProductInfo.entrySet();
			for (Entry<Integer, ProductInfo> entry : mapList) {
				ProductInfo value = entry.getValue();
				productInfoService.saveOrUpdateObject(value);
			}
		}
	}

	/**
	 * 自动取消过期24时以上的订单
	 */
	@Override
	public void updateAutoCancelOrder() {
		//查询前一天23:59:59之前未付款的订单
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String date = sdf.format(new Date());
		date = DateUtil.getSpecifiedDayAfter(date, -1) + " 23:59:59";
		String whereSql = "where o.ordersState = 0 and o.settlementStatus = 0 and UNIX_TIMESTAMP(o.createTime)<UNIX_TIMESTAMP('"+date+"')";

		String cancelOrdersIds = "";
		List<Orders> orderses = ordersDao.findObjects(whereSql);
		if (Utils.objectIsNotEmpty(orderses) && orderses.size() > 0) {
			for (Orders orders : orderses) {
				cancelOrdersIds += orders.getOrdersId() + ",";
			}
			cancelOrdersIds = cancelOrdersIds.substring(0, cancelOrdersIds.length() - 1);
			// 更改订单为取消状态
			ordersDao.updateBySQL("update shop_orders set ordersState = 6 where ordersId in (" + cancelOrdersIds + ")");
		}
		logger.info("自动取消过期24小时的订单：" + cancelOrdersIds);
	}

	/**
	 * 更改订单正在配送状态
	 * @return
	 */
	public Orders saveOrUpdateChanggeOrdersState(String ordersId,Users users){
		//修改订单
		Orders order = new Orders();
		order = ordersDao.get(" where o.ordersId="+ordersId);
		order.setOrdersState(3);
		order.setUpdateTime(new Date());
		ordersDao.saveOrUpdateObject(order);
		//插入日志
		OrdersOPLog ordersOPLog = new OrdersOPLog();
		ordersOPLog.setOrdersId(order.getOrdersId());
		ordersOPLog.setOrdersNo(order.getOrdersNo());
		ordersOPLog.setOperatorTime(new Date());
		ordersOPLog.setOrdersOperateState(3);
		ordersOPLog.setOoperatorId(users.getUsersId());//操作人id
		ordersOPLog.setOoperatorSource("1");//1、后台用户；2、后台系统；3、前台顾客；
		ordersOPLog.setOperatorName(users.getTrueName());//操作人name
		ordersOPLogDao.saveOrUpdateObject(ordersOPLog);//保存订单日志
		return order;
	}
	/**
	 * 更改订单已发货状态(走物流公司)
	 * @return
	 */
	@SuppressWarnings("static-access")
	public Orders saveOrUpdateChangeShipments(Orders orders ,Shipping ship,Users users){
		//修改订单
		Orders order = new Orders();
		order = ordersDao.get(" where o.ordersId="+orders.getOrdersId());
		order.setSendType(1);
		order.setOrdersState(4);
		order.setUpdateTime(new Date());
		ordersDao.saveOrUpdateObject(order);
		//插入日志
		OrdersOPLog ordersOPLog = new OrdersOPLog();
		ordersOPLog.setOrdersId(order.getOrdersId());
		ordersOPLog.setOrdersNo(order.getOrdersNo());
		ordersOPLog.setOperatorTime(new Date());
		ordersOPLog.setOrdersOperateState(4);
		ordersOPLog.setOoperatorId(users.getUsersId());//操作人id
		ordersOPLog.setOoperatorSource("1");//1、后台用户；2、后台系统；3、前台顾客；
		ordersOPLog.setOperatorName(users.getTrueName());//操作人name
		ordersOPLogDao.saveOrUpdateObject(ordersOPLog);//保存订单日志
		//物流信息
		SerialNumberUtil serialNumberUtil = new SerialNumberUtil();
		Shipping shipping = new Shipping();
		shipping = ship;
		shipping.setShippingSn(serialNumberUtil.ShippingSnNumber());
		shipping.setOrdersId(orders.getOrdersId());
		shipping.setCreateDate(new Date());
		shippingDao.saveOrUpdateObject(shipping);
		return order;
	}
	/**
	 * 更改订单已发货状态(走同城快递)
	 * @return
	 */
	@SuppressWarnings("static-access")
	public Orders saveOrUpdateChangeShipments(Orders orders ,CityCourier cityCourier,Users users){
		//修改订单
		Orders order = new Orders();
		order = ordersDao.get(" where o.ordersId="+orders.getOrdersId());
		order.setSendType(2);
		order.setOrdersState(4);
		order.setUpdateTime(new Date());
		ordersDao.saveOrUpdateObject(order);
		//插入日志
		OrdersOPLog ordersOPLog = new OrdersOPLog();
		ordersOPLog.setOrdersId(order.getOrdersId());
		ordersOPLog.setOrdersNo(order.getOrdersNo());
		ordersOPLog.setOperatorTime(new Date());
		ordersOPLog.setOrdersOperateState(4);
		ordersOPLog.setOoperatorId(users.getUsersId());//操作人id
		ordersOPLog.setOoperatorSource("1");//1、后台用户；2、后台系统；3、前台顾客；
		ordersOPLog.setOperatorName(users.getTrueName());//操作人name
		ordersOPLogDao.saveOrUpdateObject(ordersOPLog);//保存订单日志
		//物流信息
		SerialNumberUtil serialNumberUtil = new SerialNumberUtil();
		Shipping shipping = new Shipping();
		shipping.setShippingSn(serialNumberUtil.ShippingSnNumber());
		shipping.setCode("tongcheng");
		shipping.setDeliverySn(cityCourier.getCityCourierId()+"");
		shipping.setOrdersId(orders.getOrdersId());
		shipping.setCreateDate(new Date());
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("cityCourierId", cityCourier.getCityCourierId());
		jsonMap.put("cityCourierName", cityCourier.getCityCourierName());
		jsonMap.put("responsibleAreas", cityCourier.getResponsibleAreas());
		jsonMap.put("phone", cityCourier.getPhone());
		jsonMap.put("address", cityCourier.getAddress());
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);
		shipping.setExpressInfo(jo.toString());
		shippingDao.saveOrUpdateObject(shipping);
		return order;
	}

	/**
	 * 更改订单中（三）级返利
	 *
	 * 套餐销售折扣总价 = for[销售单价 * 个数 * vip会员折扣 * 平台促销折扣] * 生日月折扣
	 * 套餐返利基数 = 订单明细中（套餐销售折扣总价 - 优惠券抵扣 - 金币抵扣 - 平台促销减少）
	 * 上一级返利 = 订单内所有套餐（套餐返利基数 * 套餐上一级返利比例）
	 * 上二级返利 = 订单内所有套餐（套餐返利基数 * 套餐上二级返利比例）
	 * 上三级返利 = 订单内所有套餐（套餐返利基数 * 套餐上三级返利比例）
	 *
	 * @param ordersNo
	 */
	@Override
	public void updateOrdersLevelRebate(String ordersNo) {
		logger.info("开始更改订单中（三）级返利");
		//检查订单编号是否为空
		if (Utils.objectIsEmpty(ordersNo)) return;

		//查询出待更改返利金额的订单
		List<Orders> listOrders = ordersDao.findOrders(ordersNo);
		if (Utils.objectIsEmpty(listOrders) || listOrders.size() < 1) return;

		//遍历订单列表
		for (Orders orders : listOrders) {

			//检查订单是否已有返利
			if (orders.getIsRebate().compareTo(1) == 0) break;

			List<OrdersList> ordersLists = ordersListService.getOrdersListByOrdersNo(orders.getOrdersNo());
			if (Utils.objectIsEmpty(ordersLists) || ordersLists.size() < 1) break;

			BigDecimal rebateL1 = BigDecimal.ZERO;//上一级获得总返利
			BigDecimal rebateL2 = BigDecimal.ZERO;//上二级获得总返利
			BigDecimal rebateL3 = BigDecimal.ZERO;//上三级获得总返利

			//遍历订单明细列表
			for (OrdersList ordersList : ordersLists) {
				ProductInfo productInfo = productInfoService.getProductInfoByProductId(ordersList.getProductId());
				if (Utils.objectIsEmpty(productInfo)) break;

				BigDecimal ratioL1 = productInfo.getUpRatio();	//上一级返利比例（以百为单位）
				BigDecimal ratioL2 = productInfo.getSecRatio();	//上二级返利比例（以百为单位）
				BigDecimal ratioL3 = productInfo.getThiRatio();	//上三级返利比例（以百为单位）

				BigDecimal discountTotalPrice = ordersList.getDiscountTotalPrice();	//订单套餐折扣后总价（平台促销、生日月折扣、vip会员折扣，*数量后的）
				BigDecimal couponAmount = ordersList.getCouponAmount();				//优惠券抵扣
				BigDecimal coinPrice = ordersList.getChangeAmount();				//金币抵扣
				BigDecimal platPrice = ordersList.getPlatPromotionDiscountPrice();	//平台促销减少

				//订单套餐返利基数
				BigDecimal baseRebate = discountTotalPrice.subtract(couponAmount).subtract(coinPrice).subtract(platPrice);

				//循环叠加 各级获得返利
				rebateL1 = rebateL1.add(baseRebate.multiply(ratioL1.movePointLeft(2)).setScale(2, BigDecimal.ROUND_HALF_UP));
				rebateL2 = rebateL2.add(baseRebate.multiply(ratioL2.movePointLeft(2)).setScale(2, BigDecimal.ROUND_HALF_UP));
				rebateL3 = rebateL3.add(baseRebate.multiply(ratioL3.movePointLeft(2)).setScale(2, BigDecimal.ROUND_HALF_UP));
			}

			if (rebateL1.compareTo(BigDecimal.ZERO) > 0)
				orders.setRebateAmount(rebateL1);

			if (rebateL2.compareTo(BigDecimal.ZERO) > 0)
				orders.setSecRebateAmount(rebateL2);

			if (rebateL3.compareTo(BigDecimal.ZERO) > 0)
				orders.setThiRebateAmount(rebateL3);

			if (rebateL1.compareTo(BigDecimal.ZERO) > 0 || rebateL2.compareTo(BigDecimal.ZERO) > 0 || rebateL3.compareTo(BigDecimal.ZERO) > 0) {
				orders.setIsRebate(1);			//	有返利
				ordersDao.updateObject(orders);
			}
		}
	}

	public void setOrdersDao(IOrdersDao ordersDao) {
		this.baseDao =this.ordersDao= ordersDao;
	}
	public void setOrdersOPLogDao(IOrdersOPLogDao ordersOPLogDao) {
		this.ordersOPLogDao = ordersOPLogDao;
	}
	public void setShippingDao(IShippingDao shippingDao) {
		this.shippingDao = shippingDao;
	}

	public IMallCoinService getMallCoinService() {
		return mallCoinService;
	}

	public void setMallCoinService(IMallCoinService mallCoinService) {
		this.mallCoinService = mallCoinService;
	}

	public IOrdersListService getOrdersListService() {
		return ordersListService;
	}

	public void setOrdersListService(IOrdersListService ordersListService) {
		this.ordersListService = ordersListService;
	}

	public IProductInfoService getProductInfoService() {
		return productInfoService;
	}

	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}

	public IIncomePayDetailService getIncomePayDetailService() {
		return incomePayDetailService;
	}

	public void setIncomePayDetailService(IIncomePayDetailService incomePayDetailService) {
		this.incomePayDetailService = incomePayDetailService;
	}

	public ICustomerBankrollService getCustomerBankrollService() {
		return customerBankrollService;
	}

	public void setCustomerBankrollService(ICustomerBankrollService customerBankrollService) {
		this.customerBankrollService = customerBankrollService;
	}

	public IFundDetailService getFundDetailService() {
		return fundDetailService;
	}

	public void setFundDetailService(IFundDetailService fundDetailService) {
		this.fundDetailService = fundDetailService;
	}

	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
}