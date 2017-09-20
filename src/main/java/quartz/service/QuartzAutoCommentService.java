package quartz.service;

import org.apache.struts2.ServletActionContext;
import org.springframework.web.context.ServletContextAware;
import shop.customer.pojo.EvaluateGoods;
import shop.customer.service.IEvaluateGoodsService;
import shop.order.pojo.Orders;
import shop.order.pojo.OrdersList;
import shop.order.pojo.OrdersOPLog;
import shop.order.service.IOrdersListService;
import shop.order.service.IOrdersOPLogService;
import shop.order.service.IOrdersService;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.other.ConfigUtils;
import util.other.DateUtil;
import util.other.Utils;

import javax.servlet.ServletContext;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * Created by Administrator on 2016/8/15 0015上午 9:28.
 */
@SuppressWarnings({"rawtypes","unused"})
public class QuartzAutoCommentService implements ServletContextAware {
    /**订单Service**/
    private IOrdersService ordersService;
    /**店铺Service**/
    private IShopInfoService shopInfoService;
    /**订单日志Service**/
    private IOrdersOPLogService ordersOPLogService;
    /**订单明细Service**/
    private IOrdersListService ordersListService;
    /**订单评价Service**/
    private IEvaluateGoodsService evaluateGoodsService;

    /**
     * 对订单中套餐的自动评价
     */
    public void saveAutoComment(){
        //获取配置文件内设定的扫描时间间隔
        Integer quartz_autoComment = Integer.parseInt(String.valueOf(((Map)servletContext.getAttribute("fileUrlConfig")).get("quartz_autoComment")));
        SimpleDateFormat sdf=new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
		/*
		Date d=new Date();//当前时间
		String date = sdf.format(new Date(d.getTime() - 7 * 24 * 60 * 60 * 1000));//七天前的时间
	 	*/
        //比如现在是2015-12-05 那么往前3天是2015-12-02 但是有需要包含02号的数据 那么此处需要在往后浮动一天  即：
        quartz_autoComment = quartz_autoComment-1;
        //获取计算的日期
        String specifiedDayBeforeOrAfter = DateUtil.getSpecifiedDayBeforeOrAfter(null, "before", quartz_autoComment);
        //查询订单信息
        String hql = "select a.ordersId as ordersId,a.customerId as customerId,a.shopInfoId as shopInfoId ,c.loginName as loginName,a.updateTime as updateTime from Orders a ,Customer c  where  a.customerId=c.customerId " +
                " and  UNIX_TIMESTAMP(a.updateTime)<UNIX_TIMESTAMP('"+specifiedDayBeforeOrAfter+"') and a.ordersState=5";
        //List<OrdersList> orderList = ordersListService.findObjects("where UNIX_TIMESTAMP(o.operatorTime)>=UNIX_TIMESTAMP('"+date+"') and o.ordersState=5");
        List<Map> listMap = ordersService.findListMapByHql(hql);
        if(Utils.collectionIsNotEmpty(listMap)){
            for(Map map:listMap){//o为订单
                Integer ordersId=Integer.parseInt(String.valueOf(map.get("ordersId")));//订单id
                //Integer count = evaluateGoodsService.getCount(" where o.ordersId="+ordersId);//评价
                //用户信息
                //Customer customer = (Customer) customerService.getObjectByParams(" where o.customerId="+o.getCustomerId());
                //店铺信息
                Integer shopInfoId = Integer.parseInt(String.valueOf(map.get("shopInfoId")));
                ShopInfo shopInfo =  (ShopInfo) shopInfoService.getObjectById(shopInfoId + "");
                //总金币数
                //if(count==0){//没有评价
                String updateTime =sdf.format(map.get("updateTime"));//订单修改时间
                //如果订单修改时间   与   七天前的时间相同 则自动评价（好评）
                //if(updateTime.equals(date)){
                //查询订单明细
                List<OrdersList> olList = ordersListService.findObjects(" where o.ordersId="+ordersId);
                Orders orders = (Orders) ordersService.getObjectByParams("where o.ordersId="+ordersId);
                if(olList!=null&&olList.size()>0){
                    for(OrdersList ol:olList){
                        EvaluateGoods e = new EvaluateGoods();
                        e.setOrdersId(ordersId);
                        e.setOrderDetailId(ol.getOrderDetailId());
                        e.setProductId(ol.getProductId());
                        e.setOrdersNo(ol.getOrdersNo());
                        e.setProductFullName(ol.getProductFullName());
                        e.setSalesPrice(ol.getSalesPrice());
                        e.setLevel(1);//好评
                        e.setContent("");
                        e.setIsAnonymous(0);//非匿名评价
                        e.setCreateTime(new Date());
                        e.setShopInfoId(shopInfo.getShopInfoId());
                        e.setShopName(shopInfo.getShopName());
                        e.setAppraiserId(Integer.parseInt(String.valueOf(map.get("customerId"))));
                        e.setAppraiserName(String.valueOf(map.get("loginName")));
                        e.setAcceptAppraiserId(shopInfo.getCustomerId());
                        e.setAcceptAppraiserName(shopInfo.getCustomerName());
                        e.setEvaluateState(0);
                        e.setExplain("");
                        e.setBothState(1);
                        e.setShowTime(new Date());
                        e.setEvaluateUserType(1);
                        evaluateGoodsService.saveOrUpdateObject(e); //添加评价
                        //记录订单日志
                        OrdersOPLog oplog = new OrdersOPLog();
                        oplog.setOrdersId(Integer.parseInt(String.valueOf(map.get("ordersId"))));
                        oplog.setOoperatorId(0);//0代表系统
                        oplog.setOperatorName("系统");
                        oplog.setOperatorTime(new Date());
                        oplog.setOoperatorSource("1");//好评
                        oplog.setOrdersOperateState(9);
                        ordersOPLogService.saveOrUpdateObject(oplog);
                    }
                    orders.setOrdersState(9); //更新订单状态
                    orders.setUpdateTime(new Date());
                    ordersService.saveOrUpdateObject(orders);
                }
            }
        }
    }

    /**
     * 已发货订单 n天自动收货定时器  n在配置文件中：quartz_ takeDelivery
     * @author Mengqirui
     */
    public void saveAutoTakeDelivery(){
        //获取配置文件内设定的扫描时间间隔
        Integer quartz_takeDelivery = Integer.parseInt(String.valueOf(((Map)servletContext.getAttribute("fileUrlConfig")).get("quartz_takeDelivery")));
		/*SimpleDateFormat sdf=new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
		Date d=new Date();//当前时间 2015-09-01 19:21:24
		String date = sdf.format(new Date(d.getTime() - quartz_takeDelivery * 24 * 60 * 60 * 1000));//n天前的时间
		//时间截取+修改
		date = date.substring(0, 10)+" 23:59:59";*/
        //比如现在是2015-12-05 那么往前3天是2015-12-02 但是有需要包含02号的数据 那么此处需要在往后浮动一天  即：
        quartz_takeDelivery = quartz_takeDelivery-1;
        //获取计算的日期
        String specifiedDayBeforeOrAfter = DateUtil.getSpecifiedDayBeforeOrAfter(null, "before", quartz_takeDelivery);
        //System.out.println(date);
        //查询订单信息--已发货状态
        String hql = "select a.ordersId as ordersId,a.customerId as customerId,a.shopInfoId as shopInfoId ,c.loginName as loginName,a.updateTime as updateTime from Orders a ,Customer c  where  a.customerId=c.customerId " +
                " and  UNIX_TIMESTAMP(a.updateTime)<UNIX_TIMESTAMP('"+specifiedDayBeforeOrAfter+"') and a.ordersState=4";
        List<Map> listMap = ordersService.findListMapByHql(hql);
        if(Utils.collectionIsNotEmpty(listMap)){
            for(Map map:listMap){
                String ordersId = String.valueOf(map.get("ordersId"));
                //匹配订单日志
				/*通过订单id找到已签收的物流信息 */
                Integer count = ordersOPLogService.getCount(" where o.ordersId = "+ordersId+" and o.ordersOperateState=4 and UNIX_TIMESTAMP(o.operatorTime)<UNIX_TIMESTAMP('"+specifiedDayBeforeOrAfter+"')");
                if(count>0){//订单已经发货超出平台设置的时间   那么修改订单状态为5 同时生成操作日志
                    Orders orders = (Orders) ordersService.getObjectByParams("where o.ordersId="+ordersId);
                    //记录订单日志
                    OrdersOPLog oplog = new OrdersOPLog();
                    oplog.setOrdersId(Integer.parseInt(String.valueOf(map.get("ordersId"))));
                    oplog.setOoperatorId(0);//0代表系统
                    oplog.setOperatorName("系统");
                    oplog.setOperatorTime(new Date());
                    oplog.setOoperatorSource("2");//后台系统
                    oplog.setOrdersOperateState(5);
                    ordersOPLogService.saveOrUpdateObject(oplog);
                    orders.setOrdersState(5); //更新订单状态
                    orders.setUpdateTime(new Date());
                    ordersService.saveOrUpdateObject(orders);
                }
            }
        }
    }

    public void setOrdersService(IOrdersService ordersService) {
        this.ordersService = ordersService;
    }
    public void setShopInfoService(IShopInfoService shopInfoService) {
        this.shopInfoService = shopInfoService;
    }
    public void setOrdersOPLogService(IOrdersOPLogService ordersOPLogService) {
        this.ordersOPLogService = ordersOPLogService;
    }
    public void setOrdersListService(IOrdersListService ordersListService) {
        this.ordersListService = ordersListService;
    }
    public void setEvaluateGoodsService(IEvaluateGoodsService evaluateGoodsService) {
        this.evaluateGoodsService = evaluateGoodsService;
    }

    private ServletContext servletContext;

    @Override
    public void setServletContext(ServletContext servletContext) {
        this.servletContext = servletContext;
    }
}