package shop.order.service;
import shop.order.pojo.OrdersList;
import util.service.IBaseService;

import java.util.List;

/**
 * 订单明细service接口类
 * @author 张攀攀
 *
 */
public interface IOrdersListService  extends IBaseService <OrdersList> {
    /**
     * 根据订单号查询订单详情
     * @param ordersNo
     * @return
     * @throws Exception
     */
    public List<OrdersList> getOrdersListByOrdersNo(String ordersNo);
}
