package shop.order.dao.imp;
import shop.order.dao.IOrdersDao;
import shop.order.pojo.Orders;
import util.dao.BaseDao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 订单dao层实现类
 * @author 张攀攀
 *
 */
public class OrdersDao extends BaseDao <Orders> implements IOrdersDao {

    /**
     * 根据订单号，查询与“订单号”“总订单号”都匹配的订单集合
     *
     * @param ordersNo
     * @return
     */
    @Override
    public List<Orders> findOrders(String ordersNo) {
//    	if(ordersNo.contains(",")){
//    		String[] odersNos = ordersNo.split(",");
//    		List<Orders> orderslistAll = new ArrayList<>();
//    		for (String oderN : odersNos) {
//    			List<Orders> orderslist = findObjects(" where o.totalOrdersNo='"+oderN+"' or o.ordersNo='"+oderN+"'");
//    			orderslistAll.addAll(orderslist);
//			}
//    		return orderslistAll;
//    		
//    	}else{
    		return findObjects(" where o.totalOrdersNo='"+ordersNo+"' or o.ordersNo='"+ordersNo+"' or o.jgOrdersNo ='"+ordersNo+"'");
//    	}
    }

    /**
     * 根据订单查找付款人
     *
     * @param ordersNo
     * @return
     */
    @Override
    public List<Map> findPayerByOrdersNo(String ordersNo) {
        return findListMapByHql("select b.customerId as customerId , b.customerName as customerName from Orders a ,ShopInfo b where b.shopInfoId=a.shopInfoId and a.ordersNo='" + ordersNo + "'");
    }
}