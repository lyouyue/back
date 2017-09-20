package shop.order.dao.imp;
import shop.order.dao.IOrdersListDao;
import shop.order.pojo.OrdersList;
import util.dao.BaseDao;
/**
 * 订单明细dao层实现类
 * @author 张攀攀
 *
 */
public class OrdersListDao extends BaseDao<OrdersList> implements IOrdersListDao{
    /**
     * 根据订单号查询订单详情
     *
     * @param ordersNo
     * @return
     * @throws Exception
     */
    @Override
    public OrdersList getOrdersListByOrdersNo(String ordersNo) {
        return get(" where o.ordersNo='" + ordersNo + "'");
    }
}
