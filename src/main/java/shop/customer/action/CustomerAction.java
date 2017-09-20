package shop.customer.action;

import it.sauronsoftware.base64.Base64;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import net.sf.json.util.CycleDetectionStrategy;
import org.apache.log4j.Logger;
import rating.buyersRecord.pojo.BuyersRecord;
import rating.buyersRecord.service.IBuyersRecordService;
import shop.customer.pojo.*;
import shop.customer.service.*;
import shop.order.pojo.Orders;
import shop.order.service.IOrdersService;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.AESUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
import util.upload.ImageFileUploadUtil;
import wxmg.basicInfo.pojo.FansUserInfo;
import wxmg.basicInfo.service.IFansGroupService;
import wxmg.basicInfo.service.IFansUserInfoService;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 客户信息Action
 *
 * @author 孟琦瑞 --修改布局（增加单条数据的 "修改" "删除"操作）
 */
@SuppressWarnings({"serial", "unused", "rawtypes", "unchecked", "static-access"})
public class CustomerAction extends BaseAction {
    Logger logger = Logger.getLogger(this.getClass());

    private ICustomerService customerService;//客户Service
    private IShopCustomerInfoService shopCustomerInfoService;//个性信息Service
    private IShopInfoService shopInfoService;//店铺基本信息Service
    /**
     * 客户发票信息Service
     */
    private ICustomerInvoiceService customerInvoiceService;
    private IRechargeService rechargeService;//充值记录Service
    private ICustomerBankrollService customerBankrollService;//账户资金记录Service
    private IOrdersService ordersService;//订单Service
    private List<Orders> ordersList = new ArrayList<Orders>();//订单List
    private List<Customer> customerList = new ArrayList<Customer>();//客户List
    private Customer customer;
    private ShopCustomerInfo shopCustomerInfo;
    private String ids;
    private String customerId;
    /**
     * 查询金贝的类型【1总金贝，2总支出，3总收入】
     **/
    private String balanceType;
    // 上传文件路径
    private File imagePath;
    // 上传文件名称
    private String imagePathFileName;
    /**
     * 买家等级升迁记录service
     **/
    private IBuyersRecordService buyersRecordService;
    private BuyersRecord buyersRecord;
    /**
     * 粉丝信息service
     **/
    private IFansUserInfoService fansUserInfoService;
    private IFansGroupService fansGroupService;//粉丝分组Service接口
    /**
     * 充值金额
     */
    private BigDecimal rechargeAmount;
    private List<Recharge> rechargeList;

    //验证用户名是否重复
    public void checkLoginName() throws IOException {
        String loginName = request.getParameter("loginName");
        if (loginName != null && !"".equals(loginName)) {
            Integer count = customerService.getCount(" where o.loginName='" + loginName + "'");
            if (count.intValue() == 0) {
                response.setContentType("text/html;charset=utf-8");
                PrintWriter out = response.getWriter();
                out.print("ok");
                out.flush();
                out.close();
            }
        }
    }

    //验证邮箱是否重复
    public void checkEmail() throws IOException {
        String email = request.getParameter("email");
        if (email != null && !"".equals(email)) {
            Integer count = customerService.getCount(" where o.email='" + email + "'");
            if (count.intValue() == 0) {
                response.setContentType("text/html;charset=utf-8");
                PrintWriter out = response.getWriter();
                out.print("ok");
                out.flush();
                out.close();
            }
        }
    }

    //跳转用户页面
    public String gotoCustomerPage() {
        return SUCCESS;
    }

    // 异步ajax 图片上传
    public void uploadImage() throws Exception {
        JSONObject jo = new JSONObject();
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        // 1图片上传
        if (imagePath != null) {
            String otherImg = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), "image_customer");
            jo.accumulate("photoUrl", otherImg);
            jo.accumulate("visitFileUploadRoot", String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot")));
        } else {
            jo.accumulate("photoUrl", "false1");
        }
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //保存会员基本信息
    public void saveOrUpdateCustomer() throws ParseException {
        if (customer != null) {
            SimpleDateFormat sdf = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
            String formatTime = sdf.format(new Date());
            Date date = sdf.parse(formatTime);
            if (customer.getCustomerId() == null) {
                customer.setRegisterDate(date);
                //获得IP地址
                String ip = request.getHeader("x-forwarded-for");
                if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getHeader("Proxy-Client-IP");
                }
                if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getHeader("WL-Proxy-Client-IP");
                }
                if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
                    ip = request.getRemoteAddr();
                }
                customer.setRegisterIp(ip);
            } else {
                if (customer.getLockedState().intValue() == 1) {
                    customer.setLockedDate(date);
                }
            }
            if (customer.getCustomerId() == null) {
                Utils ut = new Utils();
                String password = customer.getPassword();
                String encodeMd5 = ut.EncodeMd5(password);
                String encodeMd52 = ut.EncodeMd5(encodeMd5);
                customer.setPassword(encodeMd52);
            }
            customerService.saveOrUpdateObject(customer);
        }
    }

    //会员基本信息列表
    public void listCustomer() throws IOException {
        //hql查询语句
        String hql = "SELECT a.loginName as loginName,a.type as userType,a.customerId as customerId,b.trueName as trueName,b.sex as sex,a.type as type," +
                "a.phone as phone,a.email as email,a.registerDate as registerDate,a.registerIp as registerIp,a.lockedState as lockedState,b.wxUserOpenId " +
                " as wxUserOpenId FROM Customer a,ShopCustomerInfo b where a.customerId=b.customerId ";
        String countHql = "SELECT count(a.loginName) FROM Customer a,ShopCustomerInfo b where a.customerId=b.customerId ";
        //获取前台查询参数
        String loginName = request.getParameter("loginName");
        String registerDate = request.getParameter("registerDate");
        String registerDate2 = request.getParameter("registerDate2");
        String email = request.getParameter("email");
        String lockedState = request.getParameter("lockedState");
        String type = request.getParameter("type");
        String phone = request.getParameter("phone");
        String wxUserOpenId = request.getParameter("wxUserOpenId");
        String userType = request.getParameter("userType");
        //追加where条件
        if (type != null && !"".equals(type)) {
            hql += " and a.type like '%" + type + "%'";
            countHql += " and a.type like '%" + type + "%'";
        }
        if (phone != null && !"".equals(phone)) {
            hql += " and a.phone like '%" + phone + "%'";
            countHql += " and a.phone like '%" + phone + "%'";
        }
        if (loginName != null && !"".equals(loginName)) {
            hql += " and a.loginName like '%" + loginName + "%'";
            countHql += " and a.loginName like '%" + loginName + "%'";
        }
        if (registerDate != null && !"".equals(registerDate)) {
            hql += " and UNIX_TIMESTAMP(a.registerDate) >= UNIX_TIMESTAMP('" + registerDate + "')";
            countHql += " and UNIX_TIMESTAMP(a.registerDate) >= UNIX_TIMESTAMP('" + registerDate + "')";
        }
        if (registerDate2 != null && !"".equals(registerDate2)) {
            hql += " and UNIX_TIMESTAMP(a.registerDate) <= UNIX_TIMESTAMP('" + registerDate2 + "')";
            countHql += " and UNIX_TIMESTAMP(a.registerDate) <= UNIX_TIMESTAMP('" + registerDate2 + "')";
        }
        if (email != null && !"".equals(email)) {
            hql += " and a.email like '%" + email + "%'";
            countHql += " and a.email like '%" + email + "%'";
        }
        if (lockedState != null && !"-1".equals(lockedState)) {
            hql += " and a.lockedState=" + lockedState;
            countHql += " and a.lockedState =" + lockedState;
        }

        if ("1".equals(wxUserOpenId)) {
            hql += " and b.wxUserOpenId is not null";
            countHql += " and b.wxUserOpenId is not null";
        }
        if ("0".equals(wxUserOpenId)) {
            hql += " and b.wxUserOpenId is null";
            countHql += " and b.wxUserOpenId is null";
        }
        if (Utils.stringIsNotEmpty(userType) && !"-1".equals(userType)) {
            hql += " and a.type =" + userType;
            countHql += " and a.type =" + userType;
        }
        int totalRecordCount = customerService.getMultilistCount(countHql);
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        List<Map> customerList = customerService.findListMapPage(hql + " order by a.registerDate desc", pageHelper);
        if (customerList != null && customerList.size() > 0) {
            for (Map m : customerList) {
                SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
                if (Utils.objectIsNotEmpty(m.get("registerDate"))) {
                    String time = fm.format(m.get("registerDate"));
                    m.put("registerDate", time);
                }
                if (Utils.objectIsNotEmpty(m.get("wxUserOpenId"))) {
                    m.put("wxUserOpenId", 1);
                } else {
                    m.put("wxUserOpenId", 0);
                }
                if (Utils.objectIsNotEmpty(m.get("customerId"))) {
                    buyersRecord = (BuyersRecord) buyersRecordService.getObjectByParams(" where o.customerId=" + m.get("customerId") + " ORDER BY o.ratingRecordId DESC");
                    if (Utils.objectIsNotEmpty(buyersRecord)) {
                        m.put("buyerRank", buyersRecord.getBuyerRank());
                    } else {
                        m.put("buyerRank", "--");
                    }
                }
            }
        }
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

    //通过粉丝组id查询出会员列表
    public void customerGroup() throws IOException {
        //hql查询语句
        String hql = "SELECT a.loginName as loginName,a.customerId as customerId,b.trueName as trueName,b.sex as sex,a.type as type,a.phone as phone,a.email as email,a" +
                ".registerDate as registerDate,a.registerIp as registerIp,a.lockedState as lockedState,"
                + "b.wxUserOpenId as wxUserOpenId,c.balance as balance FROM Customer a,ShopCustomerInfo b,CustomerBankroll c,FansUserInfo f where a.type=1 and a.customerId=b" +
                ".customerId and a.customerId=c.customerId and a.customerId=f.customerId";
        String countHql = "SELECT count(a.loginName) FROM Customer a,ShopCustomerInfo b,CustomerBankroll c,FansUserInfo f where a.type=1 and a.customerId=b.customerId and a" +
                ".customerId=c.customerId and a.customerId=f.customerId";
        //获取前台查询参数
        String loginName = request.getParameter("loginName");
        String registerDate = request.getParameter("registerDate");
        String registerDate2 = request.getParameter("registerDate2");
        String email = request.getParameter("email");
        String lockedState = request.getParameter("lockedState");
        String type = request.getParameter("type");
        String phone = request.getParameter("phone");
        String wxUserOpenId = request.getParameter("wxUserOpenId");
        String customerGroupId = request.getParameter("customerGroupId");
/*		if(Utils.objectIsNotEmpty(customerGroupId)){
            List<Map> customerIdList=fansUserInfoService.findListMapByHql("select f.customerId as customerId FROM FansUserInfo f where f.fansGroupId="+customerGroupId);
			int totalRecordCount = customerService.getMultilistCount(countHql);
			pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
			for(Map m:customerIdList){
				customerService.findListMapByHql(hql+"where a.customerId="+m.get("customerId"));
			}
		}*/
        //追加where条件
        if (type != null && !"".equals(type)) {
            hql += " and a.type like '%" + type + "%'";
            countHql += " and a.type like '%" + type + "%'";
        }
        if (phone != null && !"".equals(phone)) {
            hql += " and a.phone like '%" + phone + "%'";
            countHql += " and a.phone like '%" + phone + "%'";
        }
        if (loginName != null && !"".equals(loginName)) {
            hql += " and a.loginName like '%" + loginName + "%'";
            countHql += " and a.loginName like '%" + loginName + "%'";
        }
        if (registerDate != null && !"".equals(registerDate)) {
            hql += " and UNIX_TIMESTAMP(a.registerDate) >= UNIX_TIMESTAMP('" + registerDate + "')";
            countHql += " and UNIX_TIMESTAMP(a.registerDate) >= UNIX_TIMESTAMP('" + registerDate + "')";
        }
        if (registerDate2 != null && !"".equals(registerDate2)) {
            hql += " and UNIX_TIMESTAMP(a.registerDate) <= UNIX_TIMESTAMP('" + registerDate2 + "')";
            countHql += " and UNIX_TIMESTAMP(a.registerDate) <= UNIX_TIMESTAMP('" + registerDate2 + "')";
        }
        if (email != null && !"".equals(email)) {
            hql += " and a.email like '%" + email + "%'";
            countHql += " and a.email like '%" + email + "%'";
        }
        if (lockedState != null && !"-1".equals(lockedState)) {
            hql += " and a.lockedState=" + lockedState;
            countHql += " and a. =" + lockedState;
        }
        if (Utils.objectIsNotEmpty(customerGroupId)) {
            hql += " and f.fansGroupId=" + customerGroupId;
            countHql += " and f.fansGroupId=" + customerGroupId;
        }
        if ("1".equals(wxUserOpenId)) {
            hql += " and b.wxUserOpenId is not null";
            countHql += " and b.wxUserOpenId is not null";
        }
        if ("0".equals(wxUserOpenId)) {
            hql += " and b.wxUserOpenId is null";
            countHql += " and b.wxUserOpenId is null";
        }
        int totalRecordCount = customerService.getMultilistCount(countHql);
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        List<Map> customerList = customerService.findListMapPage(hql + " order by a.registerDate desc", pageHelper);
        if (customerList != null && customerList.size() > 0) {
            for (Map m : customerList) {
                SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
                String time = fm.format(m.get("registerDate"));
                m.put("registerDate", time);
                if (Utils.objectIsNotEmpty(m.get("wxUserOpenId"))) {
                    m.put("wxUserOpenId", 1);
                } else {
                    m.put("wxUserOpenId", 0);
                }
            }
        }
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

    //得到Customer对象
    public void getCustomerObject() throws NumberFormatException, Exception {
        if (customerId != null) {
            customer = (Customer) customerService.getObjectByParams(" where o.customerId=" + customerId);
            shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.customerId=" + customerId);
            String result = customerBankrollService.getCustomerBalance(Integer.parseInt(customerId), AESUtils.encrypt(EnumUtils.ShopCustomerBalanceType.Balance.getValue()));
            result = AESUtils.decrypt(result);
            //解密请求结果获得金贝
            BigDecimal balance = new BigDecimal(result);
            Map<String, Object> m = new HashMap<String, Object>();
            m.put("customer", customer);
            m.put("balance", balance);
            if (customer.getCustomerId() != null && Utils.objectIsNotEmpty(shopCustomerInfo)) {
                if (shopCustomerInfo.getSex() == null) {
                    shopCustomerInfo.setSex(3);
                }
                m.put("shopCustomerInfo", shopCustomerInfo);
                //BuyersRecord buyersRecord = (BuyersRecord)buyersRecordService.getObjectByParams(" where o.customerId='"+customerId+"' ORDER BY ratingRecordId DESC");
                //m.put("buyersRecord", buyersRecord);
            }
            Date birthday = shopCustomerInfo.getBirthday();
            SimpleDateFormat fm = new SimpleDateFormat("yyyy-MM-dd");
            if (birthday != null) {
                String format = fm.format(birthday);
                m.put("format", format);
            }
            JsonConfig jsonConfig = new JsonConfig();
            jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
            JSONObject jo = JSONObject.fromObject(m, jsonConfig);
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.print(jo.toString());
            out.flush();
            out.close();
        }
    }

    //删除个性信息
    public void deleteSpCustomer() {
        if (customerId != null && !"".equals(customerId)) {
            ShopCustomerInfo shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.customerId=" + customerId);
            shopCustomerInfoService.deleteObjectByParams(" where o.shopCustomerInfoId=" + shopCustomerInfo.getShopCustomerInfoId());
        }
    }

    //查询用户个性信息
    public void getSpCustomerObject() throws IOException {
        if (customerId != null && !"".equals(customerId)) {
            shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.customerId='" + customerId + "'");
            if (shopCustomerInfo != null && !"".equals(customerId)) {
                JSONObject jo = JSONObject.fromObject(shopCustomerInfo);
                response.setContentType("text/html;charset=utf-8");
                PrintWriter out = response.getWriter();
                out.print(jo.toString());
                out.flush();
                out.close();
            }
        }
    }

    //升级会员为店铺
    public void upgradeShop() throws IOException {
        boolean isSuccess = false;
        if (customerId != null && !"".equals(customerId)) {
            Map<String, Object> map = customerService.saveUpgradeShop(Integer.parseInt(customerId));
            JSONObject jo = JSONObject.fromObject(map);
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.print(jo.toString());
            out.flush();
            out.close();
        }
    }

    //保存用户个性信息
    public void saveOrUpdateShopCustomer() throws IOException {
        if (shopCustomerInfo != null) {
            if ("".equals(shopCustomerInfo.getShopCustomerInfoId())) {
                //shopCustomerInfo.setPreDeposit(0.0);
            }
            shopCustomerInfoService.saveOrUpdateObject(shopCustomerInfo);
        }
    }

    //删除会员信息并把个性信息删除
    public void deleteCustomerAll() throws IOException {
        Boolean isSuccess = null;
        if (ids != null && !"".equals(ids)) {
            isSuccess = customerService.deleteObjectsByIds("customerId", ids);
            shopCustomerInfoService.deleteObjectsByIds("customerId", ids);
        }
        JSONObject jo = new JSONObject();
        jo.accumulate("isSuccess", isSuccess + "");
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //修改用户冻结状态
    public void changeLockedState() throws IOException {
        String value = request.getParameter("params");
        String customerIds = request.getParameter("customerIds");
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH-mm-ss");
        String format = df.format(new Date());
        String sql = "update basic_customer set lockedState=" + value + ",lockedDate='" + format + "' where customerId in (" + customerIds + ")";
        boolean updateObject = customerService.updateObject(sql);
        JSONObject jo = new JSONObject();
        if (updateObject) {
            jo.accumulate("isSuccess", true);
        } else {
            jo.accumulate("isSuccess", false);
        }
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
     * 前往会员金海贝列表
     */
    public String gotoCustomerMallCoinPage() {
        request.setAttribute("customerId", customerId);
        return SUCCESS;
    }
    /**
     * 授信额度与会员等级的维护
     *
     * @data 2014年5月8日 下午4:26:55
     * @版本 V 1.0
     * @return
     *//*
	public void levelAndLineOfCredit()throws IOException{
		String customerId = request.getParameter("customerId");
		//获取会员等级
		String customerLevel = request.getParameter("customerLevel");
		//获取授信额度
		String lineOfCredit = request.getParameter("lineOfCredit");
		//获取授信期限
		String creditDate = request.getParameter("creditDate");
		Customer customer = (Customer) customerService.getObjectByParams(" where o.customerId="+customerId);
		JSONObject jo=new JSONObject();
		if(customer!=null){
			customer.setLevel(Integer.parseInt(customerLevel));//会员等级
			if(lineOfCredit!=null&&!"".equals(lineOfCredit)){
				customer.setLineOfCredit(new BigDecimal(lineOfCredit));//授信额度
			};
			if(creditDate!=null&&!"".equals(creditDate)){
				customer.setCreditDate(Integer.parseInt(creditDate));//授信额度
			};
			Object obj = customerService.saveOrUpdateObject(customer);
			if(obj!=null){
				jo.accumulate("isSuccess","true");
			}else{
				jo.accumulate("isSuccess","false");
			}
		}else{
			jo.accumulate("isSuccess","false");
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	*/

    /**
     * 粉丝信息
     */
    public void getFansUserInfoObject() throws Exception {
        ShopCustomerInfo shopCustomerInfo = (ShopCustomerInfo) shopCustomerInfoService.getObjectByParams(" where o.customerId=" + customerId);
        if (shopCustomerInfo != null && shopCustomerInfo.getWxUserOpenId() != null && shopCustomerInfo.getWxUserOpenId() != "") {
            FansUserInfo fansUserInfo = (FansUserInfo) fansUserInfoService.getObjectByParams("where o.userOpenId='" + shopCustomerInfo.getWxUserOpenId() + "'");
            if (Utils.objectIsNotEmpty(fansUserInfo) && Utils.objectIsNotEmpty(fansUserInfo.getNickName())) {
                fansUserInfo.setNickName(Base64.decode(fansUserInfo.getNickName(), "UTF-8"));
            }
            JsonConfig jsonConfig = new JsonConfig();
            jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
            JSONObject jo = JSONObject.fromObject(fansUserInfo, jsonConfig);
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.println(jo.toString());
            out.flush();
            out.close();
        }
    }

    /**
     * 查询发票信息
     *
     * @throws IOException
     */
    public void findInvoiceInfo() throws IOException {
        CustomerInvoice customerInvoice = (CustomerInvoice) customerInvoiceService.getObjectByParams(" where o.customerId=" + ids);
        Map<String, Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("customerInvoice", customerInvoice);
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
        jsonConfig.setCycleDetectionStrategy(CycleDetectionStrategy.LENIENT);
        JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    /**
     * 会员充值金额
     *
     * @throws Exception
     * @throws NumberFormatException
     */
    public void gotoRechargeMoney() throws NumberFormatException, Exception {
        boolean isSuccess = false;
        if (Utils.objectIsNotEmpty(customerId) && Utils.objectIsNotEmpty(rechargeAmount)) {
            isSuccess = rechargeService.saveRechargeMoney(customerId, rechargeAmount);
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
     * 前往会员充值列表
     */
    public String gotoRechargePage() {
        request.setAttribute("customerId", customerId);
        Customer customer = (Customer) customerService.getObjectById(customerId);
        CustomerBankroll customerBankroll = new CustomerBankroll();
        BigDecimal balance = BigDecimal.ZERO;
        BigDecimal recharge = BigDecimal.ZERO;
        try {
            balance = new BigDecimal(AESUtils.decrypt(customerBankrollService.getCustomerBalance(customer.getCustomerId(), AESUtils.encrypt(EnumUtils.ShopCustomerBalanceType.Balance.getValue()))));
            recharge = new BigDecimal(AESUtils.decrypt(customerBankrollService.getCustomerBalance(customer.getCustomerId(), AESUtils.encrypt(EnumUtils.ShopCustomerBalanceType.BalanceRecharge.getValue()))));
        } catch (Exception e) {
            balance = BigDecimal.ZERO;
            recharge = BigDecimal.ZERO;
        }
        customerBankroll.setBalance(balance);
        customerBankroll.setRechargeBalance(recharge);
        request.setAttribute("customerBankroll", customerBankroll);
        if (Utils.objectIsNotEmpty(customer)) {
            request.setAttribute("customerName", customer.getLoginName());
        }
        return SUCCESS;
    }

    /**
     * 充值列表
     */
    public void customerRechargeList() {
        try {
            StringBuffer hqlsb = new StringBuffer();
            hqlsb.append(" where o.customerId=" + customerId + "order by o.rechargeTime desc");
            int totalRecordCount = rechargeService.getCount(hqlsb.toString());
            pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
            rechargeList = rechargeService.findListByPageHelper(null, pageHelper, hqlsb.toString());
            Map<String, Object> jsonMap = new HashMap<String, Object>();
            jsonMap.put("total", totalRecordCount);
            jsonMap.put("rows", rechargeList);
            JsonConfig jsonConfig = new JsonConfig();
            jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
            JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);// 格式化result
            response.setContentType("text/html;charset=utf-8");
            PrintWriter out = response.getWriter();
            out.println(jo.toString());
            out.flush();
            out.close();
        } catch (IOException e) {
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
    }

    /**
     * 会员订单
     */
    public String gotoListOrdersPage() {
        return SUCCESS;
    }


    /**
     * 获得用户指定类型的总金海贝【仅用于查询可用总金海贝、金海贝总支出、金海贝总收入】
     * 对外提供的加密接口
     * http://192.168.0.111:8855/balance/getBalanceById.action?customerId=8&balanceType=ODkyMjFGODcxQzlGODQ1ODBBQkNGQ0UwQzQ1NTBDM0Q0MzdDNDFENEU2M0VBOThBODcyRTM4MkQyMDE1NTVGRQ==
     * <p/>
     * shop_customer_balance:ODkyMjFGODcxQzlGODQ1ODBBQkNGQ0UwQzQ1NTBDM0Q0MzdDNDFENEU2M0VBOThBODcyRTM4MkQyMDE1NTVGRQ==
     * shop_customer_balanceExpenditure:ODkyMjFGODcxQzlGODQ1ODBBQkNGQ0UwQzQ1NTBDM0QzRDQzQzQ4OTUzMEY3QzZBMTQ4QzhCMkIzRTQ2M0U4OURGMjIyNEFFNjQyMDcwOTI0Mjc2MjVGRTQ2MDIyMUIy
     * shop_customer_balanceIncome:ODkyMjFGODcxQzlGODQ1ODBBQkNGQ0UwQzQ1NTBDM0RDNzk2MzNFOTNDRkZGNjA3NUM0MDdCRkI1NTM2NkJBMg==
     * shop_customer_balanceRecharge:ODkyMjFGODcxQzlGODQ1ODBBQkNGQ0UwQzQ1NTBDM0RCQjNDQjU1MDc1MkYxRkVCOUFGQjM3NUI1NUZGOTRCNw==
     */
    public void getBalanceById() {
        try {
            SimpleDateFormat simpleDateFormat = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s_S.getValue());
            if (Utils.objectIsNotEmpty(customerId)) {
                String balance = customerBankrollService.getCustomerBalance(Integer.parseInt(customerId), balanceType);
                response.setContentType("text/html;charset=utf-8");
                PrintWriter out = response.getWriter();
                out.println(balance);
                out.flush();
                out.close();
            }
        } catch (Exception e) {
            String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
        }
    }

    public List<Customer> getCustomerList() {
        return customerList;
    }

    public void setCustomerList(List<Customer> customerList) {
        this.customerList = customerList;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public String getIds() {
        return ids;
    }

    public void setIds(String ids) {
        this.ids = ids;
    }

    public String getCustomerId() {
        return customerId;
    }

    public void setCustomerId(String customerId) {
        this.customerId = customerId;
    }

    public File getImagePath() {
        return imagePath;
    }

    public void setImagePath(File imagePath) {
        this.imagePath = imagePath;
    }

    public String getImagePathFileName() {
        return imagePathFileName;
    }

    public void setImagePathFileName(String imagePathFileName) {
        this.imagePathFileName = imagePathFileName;
    }

    public void setCustomerService(ICustomerService customerService) {
        this.customerService = customerService;
    }

    public ShopCustomerInfo getShopCustomerInfo() {
        return shopCustomerInfo;
    }

    public void setShopCustomerInfo(ShopCustomerInfo shopCustomerInfo) {
        this.shopCustomerInfo = shopCustomerInfo;
    }

    public void setShopCustomerInfoService(
            IShopCustomerInfoService shopCustomerInfoService) {
        this.shopCustomerInfoService = shopCustomerInfoService;
    }

    public void setBuyersRecordService(IBuyersRecordService buyersRecordService) {
        this.buyersRecordService = buyersRecordService;
    }

    public void setFansUserInfoService(IFansUserInfoService fansUserInfoService) {
        this.fansUserInfoService = fansUserInfoService;
    }

    public void setShopInfoService(IShopInfoService shopInfoService) {
        this.shopInfoService = shopInfoService;
    }

    public void setRechargeService(IRechargeService rechargeService) {
        this.rechargeService = rechargeService;
    }

    public BigDecimal getRechargeAmount() {
        return rechargeAmount;
    }

    public void setRechargeAmount(BigDecimal rechargeAmount) {
        this.rechargeAmount = rechargeAmount;
    }

    public List<Recharge> getRechargeList() {
        return rechargeList;
    }

    public void setRechargeList(List<Recharge> rechargeList) {
        this.rechargeList = rechargeList;
    }

    public void setCustomerBankrollService(
            ICustomerBankrollService customerBankrollService) {
        this.customerBankrollService = customerBankrollService;
    }

    public List<Orders> getOrdersList() {
        return ordersList;
    }

    public void setOrdersList(List<Orders> ordersList) {
        this.ordersList = ordersList;
    }

    public void setOrdersService(IOrdersService ordersService) {
        this.ordersService = ordersService;
    }

    public String getBalanceType() {
        return balanceType;
    }

    public void setBalanceType(String balanceType) {
        this.balanceType = balanceType;
    }

    public IFansGroupService getFansGroupService() {
        return fansGroupService;
    }

    public void setFansGroupService(IFansGroupService fansGroupService) {
        this.fansGroupService = fansGroupService;
    }

    public BuyersRecord getBuyersRecord() {
        return buyersRecord;
    }

    public void setBuyersRecord(BuyersRecord buyersRecord) {
        this.buyersRecord = buyersRecord;
    }

    public void setCustomerInvoiceService(
            ICustomerInvoiceService customerInvoiceService) {
        this.customerInvoiceService = customerInvoiceService;
    }
}
