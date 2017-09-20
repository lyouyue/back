package shop.order.dao;
import shop.order.pojo.Orders;
import util.dao.IBaseDao;

import java.util.List;
import java.util.Map;

/**
 * 订单dao层接口类
 * @author 张攀攀
 *
 */
public interface IOrdersDao extends IBaseDao <Orders>{

    /**
     * 根据订单号，查询与“订单号”“总订单号”都匹配的订单集合
     * @param ordersNo
     * @return
     */
    public List<Orders> findOrders(String ordersNo);

    /**
     * 根据订单查找付款人
     * @param ordersNo
     * @return
     */
    public List<Map> findPayerByOrdersNo(String ordersNo);
}
