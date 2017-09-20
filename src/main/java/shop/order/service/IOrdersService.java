package shop.order.service;
import basic.pojo.Users;
import shop.cityCourier.pojo.CityCourier;
import shop.customer.pojo.Customer;
import shop.order.pojo.Orders;
import shop.order.pojo.Shipping;
import util.service.IBaseService;

import java.util.List;

/**
 * 订单service接口类
 * @author 张攀攀
 *
 */
public interface IOrdersService  extends IBaseService <Orders> {
	public Orders saveOrUpdateChanggeOrdersState(String ordersId,Users users);
	public Orders saveOrUpdateChangeShipments(Orders orders ,CityCourier cityCourier,Users users);
	public Orders saveOrUpdateChangeShipments(Orders orders ,Shipping ship,Users users);

	/**
	 * 订单支付回调的统一接口（修改状态和产品的销量,收支明细）
	 * @param ordersNo	订单号 AESUtils加密过后的订单号
	 * @param dealId	第三方支付交易号 AESUtils加密过后的交易号
	 * @param payMode	支付方式
     */
	public List<Orders> savePaySuccess(String ordersNo, String dealId, Orders.PayMode payMode) throws Exception;

	/**
	 * 保存支付成功后回调修改相关数据
	 */
	public void savePaySuccessCallBack(String ordersNo, Orders.PayMode payMode, List<Orders> listOrders);

	/**
	 * 自动取消过期24时以上的订单
	 */
	public void updateAutoCancelOrder();

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
	public void updateOrdersLevelRebate(String ordersNo);
}