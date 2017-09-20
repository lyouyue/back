package shop.order.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;

import basic.pojo.BasicArea;
import basic.pojo.Users;
import basic.service.IAreaService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.cityCourier.pojo.CityCourier;
import shop.cityCourier.service.ICityCourierService;
import shop.customer.pojo.Customer;
import shop.customer.pojo.EvaluateGoods;
import shop.customer.service.ICustomerService;
import shop.customer.service.IEvaluateGoodsService;
import shop.logistics.pojo.Logistics;
import shop.logistics.service.ILogisticsService;
import shop.order.pojo.Orders;
import shop.order.pojo.OrdersList;
import shop.order.pojo.OrdersOPLog;
import shop.order.pojo.Shipping;
import shop.order.service.IOrdersListService;
import shop.order.service.IOrdersOPLogService;
import shop.order.service.IOrdersService;
import shop.order.service.IShippingService;
import shop.product.service.IProductInfoService;
import shop.returnsApply.service.IReturnsApplyService;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.express100.Express100Thred;
import util.express100.bean.ResultItem;
import util.express100.bean.TaskRequest;
import util.express100.callback.demo.JacksonHelper;
import util.express100.postOrder.demo.HttpRequest;
import util.other.AESUtils;
import util.other.JSONFormatDate;
import util.other.Utils;

/**
 * 订单的action操作
 *
 * @author 张攀攀、ss
 */
@SuppressWarnings({"serial","unused","rawtypes"})
public class OrdersAction extends BaseAction {
    Logger logger = Logger.getLogger(OrdersAction.class);
    private IOrdersService ordersService;//订单Service
    private IOrdersOPLogService ordersOPLogService;//订单操作日志Service
    private IOrdersListService ordersListService;//订单明细Service
    private ICustomerService customerService;//会员Service
    private IShopInfoService shopInfoService;//店铺Service
    private IShippingService shippingService;//发货详情Service
    private IReturnsApplyService returnsApplyService;//退货退款service
    /**评价Service**/
    private IEvaluateGoodsService evaluateGoodsService;
    private Orders orders = new Orders();
    private List<Map<String, Object>> ordersList = new ArrayList<Map<String,Object>>();
    private String ids;
    private String ordersId;
    private String params;//查询条件
    private String orderState;//订单状态
    private String isLocked;//锁定状态
    private String customerId;
    private String payMode;
    /**
     * 订单号，AESUtils 加过密的
     **/
    private String ordersNo;
    /**
     * 第三方支付交易号，AESUtils 加过密的
     */
    private String dealId;
    /**
     * 订单付款状态
     */
    private String settlementStatus;
    /**
     * 套餐Service
     **/
    private IProductInfoService productInfoService;
    /**
     * 物流公司信息Service
     */
    private ILogisticsService logisticsService;
    /**
     * 物流信息
     **/
    private Shipping shipping;
    /**
     * 物流公司名称
     **/
    private String code;
    /**
     * 物流信息详细集合
     */
    private ArrayList<ResultItem> resultItemList;
    /**
     * 物流公司信息
     */
	private List<Logistics> logisticsList;
    /**
     * 区域service
     **/
    private IAreaService areaService;
    /**
     * 同城快递信息service
     **/
    private ICityCourierService cityCourierService;
    /**
     * 同城快递信息实体
     **/
    private CityCourier cityCourier;
    /**
     * 快递方式
     **/
    private String logisticsType;
    /**
     * 同城快递员信息
     **/
    private Map<String, Object> cityCourierMap;
    private List<BasicArea> provinceList;
    private List<BasicArea> cityList;
    private String areaId;
    private String shopInfoType;
    /*********************end**********************************/
    /**
     * 异步查询订单套餐
     * By 订单号
     **/
    public void findOrdersProduct() {
        try {
            String hql = "select a.productId as productId,a.productFullName as productFullName,a.salesPrice as salesPrice, a.count as count," +
                    "a.freightPrice as freightPrice ,a.logoImage as logoImg,a.virtualCoinNumber as virtualCoinNumber , a.virtualCoin as virtualCoin,a.discount as discount,a.upRatio AS upRatio,a.secRatio AS secRatio,a.thiRatio AS thiRatio,a.upRatioAmount as upRatioAmount,a.secRatioAmount as secRatioAmount,a.thiRatioAmount as thiRatioAmount from OrdersList a where a.ordersNo='" + ordersNo + "'";
            List<Map> productMap = productInfoService.findListMapByHql(hql);
            JsonConfig jsonConfig = new JsonConfig();
			Map mapKey = (Map) fileUrlConfig;
            String uploadFileVisitRoot=String.valueOf(mapKey.get("uploadFileVisitRoot"));
            Map<String, Object> map = new HashMap<String, Object>();
            map.put("ordersNo", ordersNo);
            map.put("productMap", productMap);
            map.put("uploadFileVisitRoot",uploadFileVisitRoot);
            JSONObject jo = JSONObject.fromObject(map);// 格式化result
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out;
            out = response.getWriter();
            out.println(jo.toString());
            out.flush();
            out.close();
        } catch (Exception e) {
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
    }

    //订单列表初始化
    public String gotoOrdersPage() throws Exception {
        logger.info("123");
        return SUCCESS;
    }

    //保存或修改订单,订单号是订单生成时间加上6位随机数
    public void saveOrUpdateOrders() throws Exception {
        if (orders != null) {
            if (orders.getOrdersId() == null || "".equals(orders.getOrdersId())) {
                orders.setOrdersState(1);
                orders.setIsLocked(0);
            }
            Date createTime = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
            String createTimeStr = sdf.format(createTime);
            orders.setCreateTime(createTime);
            if ("".equals(orders.getOrdersId())) {
                orders.setOrdersId(null);
            }
//			if("".equals(orders.getUseRedbag())){
//				orders.setUseRedbag(null);
//			}
            Double random = Math.random();
            String num = random.toString().substring(2, 8);
            String ordersNo = createTimeStr + num;
            orders.setOrdersNo(ordersNo);
            orders = (Orders) ordersService.saveOrUpdateObject(orders);
            //添加操作日志
            Users users = (Users) request.getSession().getAttribute("users");
            OrdersOPLog ordersOPLog = new OrdersOPLog();
            ordersOPLog.setOrdersId(orders.getOrdersId());//订单ID
            ordersOPLog.setOrdersNo(orders.getOrdersNo());//订单号
            ordersOPLog.setOoperatorId(users.getUsersId());//操作人ID
            ordersOPLog.setOperatorName(users.getUserName());//操作人姓名
            ordersOPLog.setOoperatorSource("1");//操作人来源
            SimpleDateFormat sdff = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
            String formatTime = sdff.format(createTime);
            Date date = sdf.parse(formatTime);
            ordersOPLog.setOperatorTime(date);
            ordersOPLog.setOrdersOperateState(10);
            ordersOPLog.setComments(users.getUserName() + "在" + formatTime + "时添加了订单：" + orders.getOrdersNo());
            ordersOPLogService.saveOrUpdateObject(ordersOPLog);
        }
    }

    //得到订单对象
    public void getOrdersObject() throws Exception {
        orders = (Orders) ordersService.getObjectByParams(" where o.ordersId=" + ordersId);
        Customer customer = (Customer) customerService.getObjectByParams(" where o.customerId=" + orders.getCustomerId());
        //店铺信息
        ShopInfo shopInfo = (ShopInfo) shopInfoService.getObjectByParams(" where o.shopInfoId=" + orders.getShopInfoId());
        Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
        jsonMap.put("orders", orders);// total键 存放总记录数，必须的
        jsonMap.put("customer", customer);// rows键 存放每页记录 list
        jsonMap.put("shopInfo", shopInfo);// rows键 存放每页记录 list
        //得到发货详情对象
        Shipping shipping = (Shipping) shippingService.getObjectByParams(" where o.ordersId=" + ordersId);
        //取得发货详情信息
        jsonMap.put("shipping", shipping);
        //物流信息（json格式）
        String content = "";
        if (Utils.objectIsNotEmpty(shipping)) {
            content = shipping.getExpressInfo();
            if (Utils.objectIsNotEmpty(content)) {
                // 将json字符串转换成jsonObject
                JSONObject jsonObject = JSONObject.fromObject(content);
                Iterator<?> it = jsonObject.keys();
                // 遍历jsonObject数据，添加到Map对象
                while (it.hasNext()) {
                    String key = String.valueOf(it.next());
                    Object value = jsonObject.get(key);
                    jsonMap.put(key, value);
                }
            }
        }
        //查询订单明细
        List<OrdersList> ordersList = ordersListService.findObjects(" where o.ordersId = " + orders.getOrdersId());
        if (ordersList != null && ordersList.size() > 0) {
            OrdersList ordersList2 = ordersList.get(0);
            BigDecimal discount = ordersList2.getDiscount();
            jsonMap.put("zk", discount);//明细中的折扣
        }
        //查询评价信息
        List<EvaluateGoods> egList = evaluateGoodsService.findObjects(" where o.ordersId = " + orders.getOrdersId());
        jsonMap.put("egList", egList);// rows键 存放每页记录 list
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
        JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);// 格式化result
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        //System.out.println(jo.toString());
        out.flush();
        out.close();
    }

    //删除订单，同时删除其他有关该订单的记录
    public void deleteOrders() throws Exception {
        ordersService.deleteObjectsByIds("ordersId", ids);
        //删除订单操作日志表
        ordersOPLogService.deleteObjectsByIds("ordersId", ids);
        //删除订单明细表
        ordersListService.deleteObjectsByIds("ordersId", ids);
    }

    //初始化订单列表数据
    public void ordersList() throws Exception {
        String selectFlag = request.getParameter("selectFlag");
        String ordersNo=request.getParameter("ordersNo");
        String orderSource=request.getParameter("orderSource");
        String hqlCount="select count(o.ordersId) from Orders o ,Customer c,ShopInfo s where 1=1 AND o.customerId=c.customerId AND o.shopInfoId=s.shopInfoId";
        String sql="SELECT o.ordersId AS ordersId,o.sendType as sendType, o.ordersNo AS ordersNo, o.createTime AS createTime,o.updateTime as updateTime,c.loginName AS loginName,s.shopName AS shopName,s.shopInfoType as shopInfoType,"+
        		"o.consignee AS consignee,o.finalAmount AS finalAmount, o.settlementStatus AS settlementStatus,o.ordersState AS ordersState,o.orderSource as orderSource "+
        		" FROM shop_orders o, basic_customer c, shop_shopinfo s WHERE 1=1 AND o.customerId=c.customerId AND o.shopInfoId=s.shopInfoId";
        if(Utils.objectIsNotEmpty(settlementStatus)){
            sql+=" and o.settlementStatus="+settlementStatus;
            hqlCount+=" and o.settlementStatus="+settlementStatus;
        }
        if(Utils.objectIsNotEmpty(orderState)){
            sql+=" and o.ordersState in ("+orderState + ")";
            hqlCount+=" and o.ordersState in ("+orderState +")";
        }
        if(Utils.objectIsNotEmpty(selectFlag)){
        	if(Utils.objectIsNotEmpty(ordersNo)){
        		sql+=" and o.ordersNo like '%"+ordersNo.trim()+"%'";
        		hqlCount+=" and o.ordersNo like '%"+ordersNo.trim()+"%'";
        	}
        }
        if(Utils.objectIsNotEmpty(shopInfoType)){
        	sql+=" and s.shopInfoType="+shopInfoType;
        	hqlCount+=" and s.shopInfoType="+shopInfoType;
        }
        if(Utils.objectIsNotEmpty(orderSource)){
        	sql+=" and o.orderSource="+orderSource;
        	hqlCount+=" and o.orderSource="+orderSource;
        }
        sql+=" ORDER BY o.updateTime DESC ";
        int totalRecordCount = ordersService.getCountByHQL(hqlCount);
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        ordersList = ordersService.findListMapPageBySql(sql, pageHelper);
        Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
        jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
        jsonMap.put("rows", ordersList);// rows键 存放每页记录 list
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
        JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);// 格式化result
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
     * 更改订单正在配送状态
     *
     * @return
     * @throws IOException
     */
    public void saveOrUpdateOrdersStuts() throws IOException {
        boolean isSuccess = false;
        Users users = (Users) session.getAttribute("users");
        if (Utils.objectIsNotEmpty(users) && Utils.objectIsNotEmpty(ordersId)) {
            orders = ordersService.saveOrUpdateChanggeOrdersState(ordersId, users);
            if (Utils.objectIsNotEmpty(orders) && orders.getOrdersState() == 3) {
                isSuccess = true;//配货成功
            }
        }
        JSONObject jo = new JSONObject();
        jo.accumulate("isSuccess", isSuccess);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
     * 订单支付回调（修改状态和产品的销量,收支明细）
     *
     * @throws Exception
     */
    public void savePaySuccess() {
        // 调取订单支付回调接口
        boolean isSuccess = false;
        try {
            System.out.println("进入订单回调 payMode:" + payMode);
            Integer pay_mode = Integer.parseInt(AESUtils.decrypt(payMode));
            System.out.println("进入订单回调 pay_mode:" + pay_mode + ", ordersNo=" + ordersNo);
            List<Orders> orderses = ordersService.savePaySuccess(ordersNo, dealId, Orders.getPayMode(pay_mode));
            if (Utils.objectIsNotEmpty(orderses)) {
                isSuccess = true;
                ordersService.savePaySuccessCallBack(ordersNo, Orders.getPayMode(pay_mode), orderses);
                ordersService.updateOrdersLevelRebate(ordersNo);
            }
            //封装返回数据格式为json
            JSONObject jo = new JSONObject();
            jo.accumulate("isSuccess", isSuccess);
            /*jo.accumulate("ordersNo", ordersNo); jo.accumulate("dealId", dealId); jo.accumulate("payMode", payMode);*/
            returnJson(jo.toString(), response);
        } catch (Exception e) {
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
            logger.error("订单支付回调 savePaySuccess 方法执行有异常 = " + e.getStackTrace());
            JSONObject jo = new JSONObject();
            jo.accumulate("isSuccess", isSuccess);
            returnJson(jo.toString(), response);
        }
    }

    /**
     * 封装返回结果并写入流
     * @param result
     * @param response
     */
    private void returnJson(String result, HttpServletResponse response) {
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = null;
        try {
            out = response.getWriter();
        } catch (IOException e) {
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
        out.println(result);
        out.flush();
        out.close();
    }

    //跳转到未处理的订单列表页面
    public String gotoUntreatedOrdersPage() {
        return SUCCESS;
    }

    //跳转到等待付款的订单列表页面
    public String gotoUnpaidOrdersPage() {
        return SUCCESS;
    }

    //跳转到等待发货的订单列表页面
    public String gotoWaitShipmentsOrdersPage() {
        //获取省
        provinceList = areaService.findObjects(" where o.parentId=0");
        return SUCCESS;
    }

    //跳转到已发货的订单列表页面
    public String gotoAlreadyShipmentsOrdersPage() {
        return SUCCESS;
    }

    //跳转到确认收获的订单列表页面
    public String gotoValidationOrdersPage() {
        return SUCCESS;
    }

    //跳转到归档订单列表页面
    public String gotoReceivingOrdersPage() {
        return SUCCESS;
    }

    //跳转到作废订单列表页面
    public String gotoCancelOrdersPage() {
        return SUCCESS;
    }

    //审核修改订单状态
    public void updateOrdersState() throws ParseException {
        Users users = (Users) request.getSession().getAttribute("users");
        String ordersNo = request.getParameter("h_rordersNo");
        String state = request.getParameter("state");
        String ordersRemark = request.getParameter("ordersRemark");
        state = state.substring(3, 4);
        String stateName = "";
        if (ordersNo != null && !"".equals(ordersNo)) {
            orders = (Orders) ordersService.getObjectByParams(" where o.ordersNo='" + ordersNo + "'");
            if (ordersRemark != null && !"".equals(ordersRemark)) {
                orders.setOrdersRemark(ordersRemark);
                OrdersOPLog ordersOPLog = new OrdersOPLog();
                ordersOPLog.setOrdersId(orders.getOrdersId());//订单ID
                ordersOPLog.setOrdersNo(orders.getOrdersNo());//订单号
                ordersOPLog.setOoperatorId(users.getUsersId());//操作人ID
                ordersOPLog.setOperatorName(users.getUserName());//操作人姓名
                ordersOPLog.setOoperatorSource("1");//操作人来源
                SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
                String formatTime = sdf.format(new Date());
                Date date = sdf.parse(formatTime);
                ordersOPLog.setOperatorTime(date);
                ordersOPLog.setOrdersOperateState(2);
                ordersOPLog.setComments(users.getUserName() + "在" + formatTime + "时对订单：" + orders.getOrdersNo() + ",添加了留言：" + ordersRemark);
                ordersOPLogService.saveOrUpdateObject(ordersOPLog);
            }
            Integer sendType = orders.getSendType();
            if (sendType.intValue() == 1) {
                if ("2".equals(state)) {
                    orders.setOrdersState(3);
                } else {
                    orders.setOrdersState(Integer.parseInt(state));
                }
            } else {
                orders.setOrdersState(Integer.parseInt(state));
            }
            orders.setIsLocked(0);
            ordersService.saveOrUpdateObject(orders);
            //添加操作日志
            OrdersOPLog ordersOPLog = new OrdersOPLog();
            ordersOPLog.setOrdersId(orders.getOrdersId());//订单ID
            ordersOPLog.setOrdersNo(orders.getOrdersNo());//订单号
            ordersOPLog.setOoperatorId(users.getUsersId());//操作人ID
            ordersOPLog.setOperatorName(users.getUserName());//操作人姓名
            ordersOPLog.setOoperatorSource("1");//操作人来源
            SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
            String formatTime = sdf.format(new Date());
            Date date = sdf.parse(formatTime);
            ordersOPLog.setOperatorTime(date);
            if ("2".equals(state)) {
                stateName = "订单确认";
                ordersOPLog.setOrdersOperateState(4);
            } else if ("3".equals(state)) {
                stateName = "收款确认";
                ordersOPLog.setOrdersOperateState(5);
            } else if ("4".equals(state)) {
                stateName = "正在配货";
                ordersOPLog.setOrdersOperateState(6);
            } else if ("5".equals(state)) {
                stateName = "发货确认";
                ordersOPLog.setOrdersOperateState(7);
            } else if ("6".equals(state)) {
                stateName = "收获确认";
                ordersOPLog.setOrdersOperateState(8);
            } else if ("7".equals(state)) {
                stateName = "订单作废";
                ordersOPLog.setOrdersOperateState(9);
            }
            ordersOPLog.setComments(users.getUserName() + "在" + formatTime + "时操作了订单：" + orders.getOrdersNo() + "," + stateName);
            ordersOPLogService.saveOrUpdateObject(ordersOPLog);
        }
    }

    //判断订单
    public void verdictOrders() throws IOException {
        String isLocked = request.getParameter("isLocked");
        Boolean isSuccess = true;
        if ("1".equals(isLocked)) {
            Users users = (Users) request.getSession().getAttribute("users");
            List<OrdersOPLog> ordersOPLogList = ordersOPLogService.findObjects(" where o.ordersId='" + ordersId + "' and o.ordersOperateState in(10,11) order by o.operatorTime desc ");
            if (ordersOPLogList != null) {
                OrdersOPLog ordersOPLog = ordersOPLogList.get(0);
                Integer ooperatorId = ordersOPLog.getOoperatorId();
                Integer usersId = users.getUsersId();
                if (ooperatorId.intValue() != usersId.intValue()) {
                    isSuccess = false;
                } else {
                    isSuccess = true;
                }
            }
        }
        JSONObject jo = new JSONObject();
        jo.accumulate("isSuccess", isSuccess + "");
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //锁定订单
    public void lockOrders() throws Exception {
        if (ordersId != null && !"".equals(ordersId)) {
            orders = (Orders) ordersService.getObjectByParams(" where o.ordersId='" + ordersId + "'");
            if (orders.getIsLocked() == 0) {
                orders.setIsLocked(1);
                ordersService.saveOrUpdateObject(orders);
                //添加操作日志
                Users users = (Users) request.getSession().getAttribute("users");
                OrdersOPLog ordersOPLog = new OrdersOPLog();
                ordersOPLog.setOrdersId(orders.getOrdersId());//订单ID
                ordersOPLog.setOrdersNo(orders.getOrdersNo());//订单号
                ordersOPLog.setOoperatorId(users.getUsersId());//操作人ID
                ordersOPLog.setOperatorName(users.getUserName());//操作人姓名
                ordersOPLog.setOoperatorSource("1");//操作人来源
                SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
                String formatTime = sdf.format(new Date());
                Date date = sdf.parse(formatTime);
                ordersOPLog.setOperatorTime(date);
                ordersOPLog.setOrdersOperateState(10);
                ordersOPLog.setComments(users.getUserName() + "在" + formatTime + "时锁定了订单：" + orders.getOrdersNo());
                ordersOPLogService.saveOrUpdateObject(ordersOPLog);
            }
        }
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
        JSONObject jo = JSONObject.fromObject(orders, jsonConfig);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //跳转到所有被锁定的订单
    public String gotoCompelLockedPage() {
        return SUCCESS;
    }

    //解锁
    public void relieveLockedState() throws ParseException, IOException {
        Boolean isSuccess = true;
        String h_rordersNo = request.getParameter("h_rordersNo");
        if (h_rordersNo != null && !"".equals(h_rordersNo)) {
            orders = (Orders) ordersService.getObjectByParams(" where o.ordersNo='" + h_rordersNo + "'");
            orders.setIsLocked(0);
            ordersService.saveOrUpdateObject(orders);
            //添加操作日志
            Users users = (Users) request.getSession().getAttribute("users");
            OrdersOPLog ordersOPLog = new OrdersOPLog();
            ordersOPLog.setOrdersId(orders.getOrdersId());//订单ID
            ordersOPLog.setOrdersNo(orders.getOrdersNo());//订单号
            ordersOPLog.setOoperatorId(users.getUsersId());//操作人ID
            ordersOPLog.setOperatorName(users.getUserName());//操作人姓名
            ordersOPLog.setOoperatorSource("1");//操作人来源
            SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
            String formatTime = sdf.format(new Date());
            Date date = sdf.parse(formatTime);
            ordersOPLog.setOperatorTime(date);
            ordersOPLog.setOrdersOperateState(11);
            ordersOPLog.setComments(users.getUserName() + "在" + formatTime + "时解除订单：" + orders.getOrdersNo() + "的锁定");
            ordersOPLogService.saveOrUpdateObject(ordersOPLog);
        }
        JSONObject jo = new JSONObject();
        jo.accumulate("isSuccess", isSuccess + "");
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //修改订单价格
    public void updatePrice() throws IOException, ParseException {
        Boolean isSuccess = true;
        String ordersId = request.getParameter("ordersId");
        String disproductSumNumber = request.getParameter("disproductSumNumber");//新的总金额
        String dispayNumber = request.getParameter("dispayNumber");//新的应付金额
        String hisproductSumNumber = request.getParameter("hisproductSumNumber");//历史总金额
        String hispayNumber = request.getParameter("hispayNumber");//历史应付金额
        if (ordersId != null && !"".equals(ordersId)) {
            orders = (Orders) ordersService.getObjectByParams(" where o.ordersId='" + ordersId + "'");
            if (disproductSumNumber != null && !"".equals(disproductSumNumber)) {
//				orders.setProductSumNumber(Double.parseDouble(disproductSumNumber));
            }
            if (dispayNumber != null && !"".equals(dispayNumber)) {
//				orders.setPayNumber(Double.parseDouble(dispayNumber));
            }
            orders = (Orders) ordersService.saveOrUpdateObject(orders);
            //添加操作日志
            Users users = (Users) request.getSession().getAttribute("users");
            OrdersOPLog ordersOPLog = new OrdersOPLog();
            ordersOPLog.setOrdersId(orders.getOrdersId());//订单ID
            ordersOPLog.setOrdersNo(orders.getOrdersNo());//订单号
            ordersOPLog.setOoperatorId(users.getUsersId());//操作人ID
            ordersOPLog.setOperatorName(users.getUserName());//操作人姓名
            ordersOPLog.setOoperatorSource("1");//操作人来源
            SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
            String formatTime = sdf.format(new Date());
            Date date = sdf.parse(formatTime);
            ordersOPLog.setOperatorTime(date);
            ordersOPLog.setOrdersOperateState(3);
            ordersOPLog.setComments(users.getUserName() + "在" + formatTime + "时修改了订单：" + orders.getOrdersNo() + "的价格，历史总金额和应付金额为：" + hisproductSumNumber + "、" + hispayNumber + ",修改后的总金额和应付金额为：" + disproductSumNumber + "、" + dispayNumber);
            ordersOPLogService.saveOrUpdateObject(ordersOPLog);
            if (orders.getOrdersId() != null) {
                JSONObject jo = new JSONObject();
                jo.accumulate("isSuccess", isSuccess + "");
                response.setContentType("text/html;charset=utf-8");
                PrintWriter out = response.getWriter();
                out.println(jo.toString());
                out.flush();
                out.close();
            }
        }
    }

    //跳转到待评价列表
    public String gotopreEvaluate() {
        return SUCCESS;
    }

    //跳转到已评价列表
    public String gotoEvaluateList() {
        return SUCCESS;
    }

    //跳转到退款退货订单
    public String gotoReturnGoods() {
        return SUCCESS;
    }

    //跳转到以收货
    public String gotoValidationGoods() {
        return SUCCESS;
    }

    //退货订单列表
    public void returnsApplyList() throws IOException {
    	String selectFlag = request.getParameter("selectFlag");
        String ordersNo=request.getParameter("ordersNo");
        String orderSource=request.getParameter("orderSource");
        String sql = "SELECT o.ordersId as ordersId,o.ordersNo as ordersNo,c.loginName as loginName,s.shopName as shopName,s.shopInfoType AS shopInfoType, o.createTime as createTime,o.consignee as consignee,o.finalAmount as finalAmount,o.ordersState as ordersState,o.orderSource as orderSource "
                + " FROM shop_returnsapply r,shop_orders o,shop_shopinfo s, basic_customer c WHERE 1=1 and r.ordersId=o.ordersId  AND o.customerId=c.customerId AND o.shopInfoId=s.shopInfoId";
        String countHql = "SELECT count(o.ordersId) FROM ReturnsApply r,Orders o,Customer c,ShopInfo s WHERE  r.ordersId=o.ordersId AND o.customerId=c.customerId AND o.shopInfoId=s.shopInfoId";
       if(Utils.objectIsNotEmpty(selectFlag)){
    	   if(Utils.objectIsNotEmpty(ordersNo)){
    		   sql+=" and r.ordersNo like '%"+ordersNo.trim()+"%'";
    		   countHql+=" and r.ordersNo like '%"+ordersNo.trim()+"%'";
    	   }
    	   if(Utils.objectIsNotEmpty(shopInfoType)){
	           	sql+=" and s.shopInfoType="+shopInfoType;
	           	countHql+=" and s.shopInfoType="+shopInfoType;
           }
    	   if(Utils.objectIsNotEmpty(orderSource)){
    		   sql+=" and o.orderSource="+orderSource;
    		   countHql+=" and o.orderSource="+orderSource;
    	   }
       }
        sql+=" order by o.createTime desc ";
        //查询总数
        int totalRecordCount = returnsApplyService.getCountByHQL(countHql);
        //分页
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        //查询集合
        List<Map<String, Object>> returnList = returnsApplyService.findListMapPageBySql(sql, pageHelper);
        if (Utils.objectIsNotEmpty(returnList)) {//集合不为空
            Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
            jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
            jsonMap.put("rows", returnList);// rows键 存放每页记录 list
            JsonConfig jsonConfig = new JsonConfig();
            jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
            JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);// 格式化result
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.println(jo.toString());
            out.flush();
            out.close();
        }
    }

    //跳转到已付款和已退货页面
    public String gotoPaidReturnProduct() {
        return SUCCESS;
    }

    /**
     * @功能：已付款和已退货的套餐数量及金额
     * @作者: wyc
     * @参数： @throws ParseException
     * @参数： @throws IOException
     * @返回值：void
     * @日期: 2016年2月17日 下午4:04:44
     */
    public void findPaidReturnProduct() throws ParseException, IOException {
        String headSql = " SELECT e.productFullName,e.salesCount,e.salesPrice,d.refundCount,d.refundPrice FROM( ";
        String middleSql = " SELECT s.productFullName,count(s.count) AS salesCount,SUM(s.memberPrice) AS salesPrice FROM shop_orders o,shop_orderslist s WHERE o.ordersId=s.ordersId AND o.settlementStatus=1 ";
        String footSql = " SELECT s.productFullName,count(r.count) AS refundCount,SUM(s.memberPrice) AS refundPrice FROM shop_orderslist s, shop_orders o ,shop_returnsapply r WHERE s.ordersId=r.ordersId AND s.ordersId = o.ordersId AND r.returnsState=5 ";
        String createTime = request.getParameter("createTime");
        String createTime2 = request.getParameter("createTime2");
        String productFullName = request.getParameter("productName");
        if (productFullName != null && !"".equals(productFullName)) {
            middleSql += " and s.productFullName like '%" + productFullName.trim() + "%'";
            footSql += " and s.productFullName like '%" + productFullName.trim() + "%'";
        }
        if (createTime != null && !"".equals(createTime)) {
            middleSql += " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('" + createTime + "')";
            footSql += " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('" + createTime + "')";
        }
        if (createTime2 != null && !"".equals(createTime2)) {
            middleSql += " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('" + createTime2 + "')";
            footSql += " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('" + createTime2 + "')";
        }
        middleSql += " group by s.productId) e LEFT JOIN (";
        footSql += " group by s.productId) d on e.productFullName=d.productFullName ";
        String sql = headSql + middleSql + footSql;
        String sqlCount = "select count(b.productFullName) as count from (" + sql + ") b";
        List<Map<String, Object>> s = ordersService.findListMapBySql(sqlCount);
        int totalRecordCount = Integer.parseInt(String.valueOf(ordersService.findListMapBySql(sqlCount).get(0).get("count")));
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        List<Map<String, Object>> customerList = ordersService.findListMapPageBySql(sql, pageHelper);
        Map<String, Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("total", totalRecordCount);
        jsonMap.put("rows", customerList);
        JSONObject jo = JSONObject.fromObject(jsonMap);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
	 * 导出统计数据EXCEL
	 */
	public String exportCountModFuleExcel() throws IOException {
		String headSql = " SELECT e.productFullName,e.salesCount,e.salesPrice,d.refundCount,d.refundPrice FROM( ";
        String middleSql = " SELECT s.productFullName,count(s.count) AS salesCount,SUM(s.memberPrice) AS salesPrice FROM shop_orders o,shop_orderslist s WHERE o.ordersId=s.ordersId AND o.settlementStatus=1 ";
        String footSql = " SELECT s.productFullName,count(r.count) AS refundCount,SUM(s.memberPrice) AS refundPrice FROM shop_orderslist s, shop_orders o ,shop_returnsapply r WHERE s.ordersId=r.ordersId AND s.ordersId = o.ordersId AND r.returnsState=5 ";
        String createTime = request.getParameter("createTime");
        String createTime2 = request.getParameter("createTime2");
        String productFullName = request.getParameter("productName");
        if (productFullName != null && !"".equals(productFullName)) {
            middleSql += " and s.productFullName like '%" + productFullName.trim() + "%'";
            footSql += " and s.productFullName like '%" + productFullName.trim() + "%'";
        }
        if (createTime != null && !"".equals(createTime)) {
            middleSql += " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('" + createTime + "')";
            footSql += " and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('" + createTime + "')";
        }
        if (createTime2 != null && !"".equals(createTime2)) {
            middleSql += " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('" + createTime2 + "')";
            footSql += " and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('" + createTime2 + "')";
        }
        middleSql += " group by s.productId) e LEFT JOIN (";
        footSql += " group by s.productId) d on e.productFullName=d.productFullName ";
        String sql = headSql + middleSql + footSql;
		List<Map<String,Object>> customerList = ordersService.findListMapBySql(sql);
		if (Utils.collectionIsNotEmpty(customerList)) {
			session.setAttribute("columnNames", ordersColumnNamesList());// 把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues",ordersColumnValuesList(customerList));// 把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "CountModFule");
			return SUCCESS;
		} else {
			this.addActionError("没有数据");
			return ERROR;
		}
	}

	/** excel列名 **/
	private List<String> ordersColumnNamesList() {
		List<String> typeNameList = new ArrayList<String>();
		typeNameList.add(0, "套餐名称");
		typeNameList.add("已付款套餐数量");
		typeNameList.add("已付款套餐金额");
		typeNameList.add("已退货套餐数量");
		typeNameList.add("已退货套餐金额");
		return typeNameList;
	}

	/** excel对应列的值 **/
	public List<List<String>> ordersColumnValuesList(List<Map<String,Object>> list) throws IOException {
		// 保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		for (Map cc : list) {
			List<String> columnValuesList = null;
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(String.valueOf(cc.get("productFullName")));
			columnValuesList.add(String.valueOf(cc.get("salesCount")));
			columnValuesList.add(String.valueOf(cc.get("salesPrice")));
			columnValuesList.add(String.valueOf(cc.get("refundCount")));
			columnValuesList.add(String.valueOf(cc.get("refundPrice")));
			columnRowsList.add(columnValuesList);// 把当前的行 添加到 列表中
		}
		return columnRowsList;
	}

    //获取市
    public void findCityList() throws IOException {
        cityList = areaService.findObjects(" where o.parentId=" + areaId);
        JSONArray jo = JSONArray.fromObject(cityList);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
     * 更改订单已发货状态
     *
     * @return
     * @throws IOException
     */
    public void changeShipments() throws IOException {
    	boolean isSuccess = false;
        Users users = (Users) session.getAttribute("users");
        if (logisticsType == "1" || "1".equals(logisticsType)) {
            if (users != null && orders != null && orders.getOrdersId() != null && shipping != null) {
                Logistics logistics = (Logistics) logisticsService.getObjectByParams("where o.code='" + shipping.getCode() + "'");
                shipping.setDeliveryUrl(logistics.getDeliveryUrl());
                shipping.setDeliveryCorpName(logistics.getDeliveryCorpName());
                orders = ordersService.saveOrUpdateChangeShipments(orders, shipping, users);
                isSuccess = true;
                try {
                    TaskRequest req = new TaskRequest();
                    //本网站所在路径
                    String callbackurl = String.valueOf(getFileUrlConfig().get("express100_callbackurl"));
                    req.getParameters().put("callbackurl", callbackurl);//回调地址
                    //与快递公司签约key
                    String key = String.valueOf(getFileUrlConfig().get("express100_key"));
                    req.setKey(key);//与快递公司签约key
                    req.setTo(orders.getAddress());//收货人地址
                    req.setCompany(shipping.getCode());//快递公司
                    req.setNumber(shipping.getDeliverySn());//快递公司代号

                    HashMap<String, String> p = new HashMap<String, String>();
                    p.put("schema", "json");
                    p.put("param", JacksonHelper.toJSON(req));
                    //System.out.println("发送信息："+JacksonHelper.toJSON(req));
                    String ret;
                    //请求快递100时的编码
                    String express100Encoding = String.valueOf(getFileUrlConfig().get("express100_encoding"));
                    //订阅快递100时的路径
                    String express100Path = String.valueOf(getFileUrlConfig().get("express100_path"));
                    ret = HttpRequest.postData(express100Path, p, express100Encoding);
                    //重新订阅时的时间，单位秒
                    int time = Integer.parseInt(String.valueOf(getFileUrlConfig().get("express100_time")));
                    //请求失败默认重新请求次数
                    int number = Integer.parseInt(String.valueOf(getFileUrlConfig().get("express100_number")));
                    //请求订阅快递100
                    Express100Thred express100Thred = new Express100Thred(ret, time, number);
                    Thread express100ThredStart = new Thread(express100Thred);
                    express100ThredStart.start();
                } catch (Exception e) {
                    String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
                }
            }
        } else {
            if (users != null && orders != null && orders.getOrdersId() != null && cityCourier != null) {
                CityCourier cityCourierTemp = (CityCourier) cityCourierService.getObjectByParams("where o.cityCourierId='" + cityCourier.getCityCourierId() + "'");
                orders = ordersService.saveOrUpdateChangeShipments(orders, cityCourierTemp, users);
                isSuccess = true;
            }
        }
        Map<String, Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("isSuccess", isSuccess);
        JSONObject jo = JSONObject.fromObject(jsonMap);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
     * 校验快递公司是否存在
     *
     * @throws IOException
     */
    public void checkShipments() throws IOException {
        boolean isHave = false;
        int logisticsCount = logisticsService.getCount(" where o.code='" + code + "'");
        if (logisticsCount > 0) {
            isHave = true;
        }
        JSONObject jo = new JSONObject();
        jo.accumulate("isHave", isHave);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    public Orders getOrders() {
        return orders;
    }

    public void setOrders(Orders orders) {
        this.orders = orders;
    }
    public String getIds() {
        return ids;
    }

    public void setIds(String ids) {
        this.ids = ids;
    }

    public String getOrdersId() {
        return ordersId;
    }

    public void setOrdersId(String ordersId) {
        this.ordersId = ordersId;
    }

    public void setOrdersService(IOrdersService ordersService) {
        this.ordersService = ordersService;
    }

    public void setOrdersOPLogService(IOrdersOPLogService ordersOPLogService) {
        this.ordersOPLogService = ordersOPLogService;
    }

    public void setOrdersListService(IOrdersListService ordersListService) {
        this.ordersListService = ordersListService;
    }

    public String getParams() {
        return params;
    }

    public void setParams(String params) {
        this.params = params;
    }

    public void setCustomerService(ICustomerService customerService) {
        this.customerService = customerService;
    }

    public String getOrderState() {
        return orderState;
    }

    public void setOrderState(String orderState) {
        this.orderState = orderState;
    }

    public String getIsLocked() {
        return isLocked;
    }

    public void setIsLocked(String isLocked) {
        this.isLocked = isLocked;
    }

    public void setProductInfoService(IProductInfoService productInfoService) {
        this.productInfoService = productInfoService;
    }

    public String getOrdersNo() {
        return ordersNo;
    }

    public void setOrdersNo(String ordersNo) {
        this.ordersNo = ordersNo;
    }

    public void setShippingService(IShippingService shippingService) {
        this.shippingService = shippingService;
    }

    public String getSettlementStatus() {
        return settlementStatus;
    }

    public void setSettlementStatus(String settlementStatus) {
        this.settlementStatus = settlementStatus;
    }

    public void setReturnsApplyService(IReturnsApplyService returnsApplyService) {
        this.returnsApplyService = returnsApplyService;
    }

    public void setShopInfoService(IShopInfoService shopInfoService) {
        this.shopInfoService = shopInfoService;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public CityCourier getCityCourier() {
        return cityCourier;
    }

    public void setCityCourier(CityCourier cityCourier) {
        this.cityCourier = cityCourier;
    }

    public String getLogisticsType() {
        return logisticsType;
    }

    public void setLogisticsType(String logisticsType) {
        this.logisticsType = logisticsType;
    }

    public Map<String, Object> getCityCourierMap() {
        return cityCourierMap;
    }

    public void setCityCourierMap(Map<String, Object> cityCourierMap) {
        this.cityCourierMap = cityCourierMap;
    }

    public List<BasicArea> getProvinceList() {
        return provinceList;
    }

    public void setProvinceList(List<BasicArea> provinceList) {
        this.provinceList = provinceList;
    }

    public List<BasicArea> getCityList() {
        return cityList;
    }

    public void setCityList(List<BasicArea> cityList) {
        this.cityList = cityList;
    }

    public String getAreaId() {
        return areaId;
    }

    public void setAreaId(String areaId) {
        this.areaId = areaId;
    }

    public void setAreaService(IAreaService areaService) {
        this.areaService = areaService;
    }

    public void setCityCourierService(ICityCourierService cityCourierService) {
        this.cityCourierService = cityCourierService;
    }

    public void setLogisticsService(ILogisticsService logisticsService) {
        this.logisticsService = logisticsService;
    }

    public Shipping getShipping() {
        return shipping;
    }

    public void setShipping(Shipping shipping) {
        this.shipping = shipping;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public void setLogisticsList(List<Logistics> logisticsList) {
        this.logisticsList = logisticsList;
    }

    public ArrayList<ResultItem> getResultItemList() {
        return resultItemList;
    }

    public void setResultItemList(ArrayList<ResultItem> resultItemList) {
        this.resultItemList = resultItemList;
    }

    public String getPayMode() {
        return payMode;
    }

    public void setPayMode(String payMode) {
        this.payMode = payMode;
    }

    public String getDealId() {
        return dealId;
    }

    public void setDealId(String dealId) {
        this.dealId = dealId;
    }

	public List<Map<String, Object>> getOrdersList() {
		return ordersList;
	}

	public void setOrdersList(List<Map<String, Object>> ordersList) {
		this.ordersList = ordersList;
	}

	public String getShopInfoType() {
		return shopInfoType;
	}

	public void setShopInfoType(String shopInfoType) {
		this.shopInfoType = shopInfoType;
	}

	public void setEvaluateGoodsService(IEvaluateGoodsService evaluateGoodsService) {
		this.evaluateGoodsService = evaluateGoodsService;
	}

}
