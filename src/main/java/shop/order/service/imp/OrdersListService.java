package shop.order.service.imp;
import shop.order.dao.IOrdersListDao;
import shop.order.pojo.OrdersList;
import shop.order.service.IOrdersListService;
import util.service.BaseService;

import java.util.List;

/**
 * 订单明细service层实现类
 * @author 张攀攀
 *
 */
public class OrdersListService extends BaseService<OrdersList> implements IOrdersListService{
	@SuppressWarnings("unused")
	private IOrdersListDao ordersListDao;
	public void setOrdersListDao(IOrdersListDao ordersListDao) {
		this.baseDao = this.ordersListDao = ordersListDao;
	}


	/**
	 * 根据订单编号获得明细集合
	 *
	 * @param ordersNo
	 * @return
	 */
	@Override
	public List<OrdersList> getOrdersListByOrdersNo(String ordersNo) {
		return ordersListDao.findObjects("where o.ordersNo='" + ordersNo+"'");
	}
}
