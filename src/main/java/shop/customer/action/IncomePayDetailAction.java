package shop.customer.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import basic.pojo.Users;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.common.pojo.CoinRules;
import shop.customer.pojo.Customer;
import shop.customer.pojo.IncomePayDetail;
import shop.customer.pojo.VirtualCoin;
import shop.customer.service.ICustomerService;
import shop.customer.service.IIncomePayDetailService;
import shop.customer.service.IVirtualCoinService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.SerialNumberUtil;
import util.other.Utils;
/**
 * 收支明细Action类
 * 
 */
@SuppressWarnings("serial")
public class IncomePayDetailAction extends BaseAction{
	private IIncomePayDetailService incomePayDetailService;//收支明细Service
	private IVirtualCoinService virtualCoinService;//金币
	private ICustomerService customerService;//客户Service
	private List<IncomePayDetail> IncomePayDetailList = new ArrayList<IncomePayDetail>();//收支明细List
	private List<Customer> customerList = new ArrayList<Customer>();//客户List
	private IncomePayDetail incomePayDetail;
	private String detailId;
	private String ids;
	private String params;//查询参数
	/**导出excel文件的列名称**/
	private List<String> typeNameList = new ArrayList<String>();
	/**
	 * 集合类
	 */
	private List<Map> mapList;
	//跳转到收支明细列表页面
	public String gotoIncomePayDetailPage(){
		//客户
		customerList = customerService.findObjects(null);
		return SUCCESS;
	}
	//根据用户ID得到用户收支明细信息
	public void listIncomePayDetail() throws Exception {
		String cardHolder=request.getParameter("cardHolder");
		String cardNumber=request.getParameter("cardNumber");
		String phone=request.getParameter("phone");
		String state=request.getParameter("state");
		String where=" where 1=1";
		if(cardHolder!=null&&!"".equals(cardHolder)){
			where+=" and o.cardHolder like '%"+cardHolder+"%'";
		}
		if(cardNumber!=null&&!"".equals(cardNumber)){
			where+=" and o.cardNumber like '%"+cardNumber+"%'";
		}
		if(phone!=null&&!"".equals(phone)){
			where+=" and o.phone like '%"+phone+"%'";
		}
		if(state!=null&&!"".equals(state)){
			where+=" and o.state="+state;
		}
		if(cardHolder!=null&&!"".equals(cardHolder)){
			where+=" and o.cardHolder like '%"+cardHolder+"%'";
		}
		int totalRecordCount = incomePayDetailService.getCount(where);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		IncomePayDetailList = incomePayDetailService.findListByPageHelper(null,pageHelper, where+" order by o.updateTime desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", IncomePayDetailList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除用户收支明细
	public void deleteIncomePayDetail() throws Exception {
		Boolean isSuccess = incomePayDetailService.deleteObjectsByIds("detailId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//得到一条用户收支明细信息
	public void getIncomePayDetailObject() throws Exception {
		incomePayDetail = (IncomePayDetail) incomePayDetailService.getObjectById(detailId);
		Map<String,Object> map = new HashMap<String,Object>();
		if(incomePayDetail!=null){
			String hql=" where 1=1 ";
			if(incomePayDetail.getPayeeId()!=null){
				hql+="and o.customerId="+incomePayDetail.getPayeeId();
				if(incomePayDetail.getPayerId()!=null){
					hql+=" or o.customerId="+incomePayDetail.getPayerId();
				}
			}else if(incomePayDetail.getPayerId()!=null){
				hql+=" and o.customerId="+incomePayDetail.getPayerId();
			}
			Customer customer=(Customer) customerService.getObjectByParams(hql);
			map.put("incomePayDetail", incomePayDetail);
			map.put("customer", customer);
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
			JSONObject jo = JSONObject.fromObject(map,jsonConfig);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//金币提现状态更改
	@SuppressWarnings("unchecked")
	public void saveOrUpdateIncomePayDetail() throws Exception {
		Users users = (Users) session.getAttribute("users");
		String optId = request.getParameter("optId");
		String optState = request.getParameter("optState");
		incomePayDetail = (IncomePayDetail) incomePayDetailService.getObjectByParams(" where o.detailId="+optId);
		incomePayDetail.setState(Integer.parseInt(optState));
		incomePayDetail.setOperatorId(users.getUsersId());
		incomePayDetail.setOperatorName(users.getUserName());
		incomePayDetail.setOperatorTime(new Date());
		//更新记录
		incomePayDetailService.saveOrUpdateObject(incomePayDetail);
		if(incomePayDetail.getState()==3){//如果平台支付失败，则解除当前记录所冻结的金币数量
			//扣除金币相应数量
			VirtualCoin v=new VirtualCoin();
			v.setCustomerId(incomePayDetail.getPayeeId());//客户id
			v.setSerialNumber(SerialNumberUtil.VirtualCoinNumber());
			v.setType(1);//交易类型为支出  1
			//金币提现比例
			Map<String,Object> map= (Map<String, Object>) servletContext.getAttribute("coinRules");
			List<CoinRules> crList = (List<CoinRules>) map.get("thbtxBL");
			String thbtxBL=crList.get(0).getValue();
			v.setProportion(Integer.parseInt(thbtxBL));//当时分享比例
			BigDecimal bd1=incomePayDetail.getTransactionAmount();
			BigDecimal bd2=new BigDecimal(thbtxBL);
			BigDecimal multiply = bd1.multiply(bd2);
			v.setTransactionNumber(multiply);//交易数量
			//更改状态后扣除余额
			List<VirtualCoin> vcList = virtualCoinService.findObjects(" where o.customerId="+incomePayDetail.getPayeeId()+" order by o.virtualCoinId desc limit 1");
			BigDecimal remainingNumber = vcList.get(0).getRemainingNumber();//当前用户剩余金币数量  即：当前账户余额
			remainingNumber = remainingNumber.add(multiply);//解除冻结金币后的账户余额
			v.setRemainingNumber(remainingNumber);
			v.setTradeTime(incomePayDetail.getCreateTime());
			v.setOperatorTime(new Date());
			v.setFrozenNumber(new BigDecimal(0));
			v.setRemarks("平台支付失败,解除冻结金币:"+multiply+"个!");
			virtualCoinService.saveOrUpdateObject(v);
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess","true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**excel列名**/
	private List<String> ordersColumnNamesList(){
		typeNameList.add(0, "流水号");
		typeNameList.add("持卡人");
		typeNameList.add("银行卡号");
		typeNameList.add("预留手机号");
		typeNameList.add("交易状态");
		typeNameList.add("交易金额");
		typeNameList.add("操作人");
		typeNameList.add("操作时间");
		typeNameList.add("创建时间");
		return typeNameList;
	}
	/**
	 * 导出分享记录EXCEL
	 */
	public String exportXNBTXExcel() throws IOException{
		String cardHolder=request.getParameter("cardHolder");
		String cardNumber=request.getParameter("cardNumber");
		String phone=request.getParameter("phone");
		String state=request.getParameter("state");
		String hql="select o.serialNumber as serialNumber,o.cardHolder as cardHolder,o.cardNumber as cardNumber,o.phone as phone,o.state as state,o.transactionAmount as transactionAmount,o.operatorName as operatorName,o.operatorTime as operatorTime,o.tradeTime as tradeTime from IncomePayDetail o where 1=1";
		if(cardHolder!=null&&!"".equals(cardHolder)){
			hql+=" and o.cardHolder like '%"+cardHolder+"%'";
		}
		if(cardNumber!=null&&!"".equals(cardNumber)){
			hql+=" and o.cardNumber like '%"+cardNumber+"%'";
		}
		if(phone!=null&&!"".equals(phone)){
			hql+=" and o.phone like '%"+phone+"%'";
		}
		if(state!=null&&!"".equals(state)){
			hql+=" and o.state="+state;
		}
		if(cardHolder!=null&&!"".equals(cardHolder)){
			hql+=" and o.cardHolder like '%"+cardHolder+"%'";
		}
		mapList = incomePayDetailService.findListMapByHql(hql+" order by o.tradeTime desc");
		if(mapList!=null&&mapList.size()>0){
			//格式化日期
			for(Map map:mapList){
				if(map.get("tradeTime") != null&&!"".equals(map.get("tradeTime"))){
					map.put("tradeTime", (new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()).format((Date)map.get("tradeTime"))).toString());
				}
				if(map.get("operatorTime") != null&&!"".equals(map.get("operatorTime"))){
					map.put("operatorTime", (new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()).format((Date)map.get("operatorTime"))).toString());
				}
			}
			session.setAttribute("columnNames", ordersColumnNamesList());//把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues", ordersColumnValuesList(mapList));//把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "XNBTXList");
			return "success";
		}else {
			this.addActionError("没有数据");
			return "error";
		}
	}
	/**excel对应列的值**/
	public List<List<String>> ordersColumnValuesList(List<Map> list) throws IOException{
		//保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		List<String> columnValuesList = null;
		for(Map<String,Object> cc : list){
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(String.valueOf(cc.get("serialNumber")));
			columnValuesList.add(String.valueOf(cc.get("cardHolder")));
			columnValuesList.add(String.valueOf(cc.get("cardNumber")));
			columnValuesList.add(String.valueOf(cc.get("phone")));
			if("1".endsWith(String.valueOf(cc.get("state")))){
				columnValuesList.add("申请提现");
			}else if("2".endsWith(String.valueOf(cc.get("state")))){
				columnValuesList.add("平台支付完成");
			}else{
				columnValuesList.add("平台支付失败");
			}
			columnValuesList.add(String.valueOf(cc.get("transactionAmount")));
			if(Utils.objectIsNotEmpty(cc.get("operatorName"))){
				columnValuesList.add(String.valueOf(cc.get("operatorName")));
			}else{
				columnValuesList.add("");
			}
			if(Utils.objectIsNotEmpty(cc.get("operatorTime"))){
				columnValuesList.add(String.valueOf(cc.get("operatorTime")));
			}else{
				columnValuesList.add("");
			}
			columnValuesList.add(String.valueOf(cc.get("tradeTime")));
			columnRowsList.add(columnValuesList);//把当前的行 添加到 列表中
		}
		return columnRowsList;
	}
	public List<IncomePayDetail> getIncomePayDetailList() {
		return IncomePayDetailList;
	}
	public void setIncomePayDetailList(List<IncomePayDetail> incomePayDetailList) {
		IncomePayDetailList = incomePayDetailList;
	}
	public IncomePayDetail getIncomePayDetail() {
		return incomePayDetail;
	}
	public void setIncomePayDetail(IncomePayDetail incomePayDetail) {
		this.incomePayDetail = incomePayDetail;
	}
	public String getDetailId() {
		return detailId;
	}
	public void setDetailId(String detailId) {
		this.detailId = detailId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public void setIncomePayDetailService(
			IIncomePayDetailService incomePayDetailService) {
		this.incomePayDetailService = incomePayDetailService;
	}
	public List<Customer> getCustomerList() {
		return customerList;
	}
	public void setCustomerList(List<Customer> customerList) {
		this.customerList = customerList;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public void setVirtualCoinService(IVirtualCoinService virtualCoinService) {
		this.virtualCoinService = virtualCoinService;
	}
	public List<String> getTypeNameList() {
		return typeNameList;
	}
	public void setTypeNameList(List<String> typeNameList) {
		this.typeNameList = typeNameList;
	}
	public List<Map> getMapList() {
		return mapList;
	}
	public void setMapList(List<Map> mapList) {
		this.mapList = mapList;
	}
}
