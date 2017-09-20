package shop.customer.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.log4j.Logger;
import shop.customer.pojo.Customer;
import shop.customer.pojo.Drawing;
import shop.customer.service.ICustomerBankrollService;
import shop.customer.service.ICustomerService;
import shop.customer.service.IDrawingBackService;
import shop.customer.service.IDrawingService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
import basic.pojo.Users;
import basic.service.IUsersService;
/**
 * 提现记录Action
 */
public class DrawingAction extends BaseAction{
	private static final long serialVersionUID = -2677920384996349640L;
	Logger logger = Logger.getLogger(this.getClass());
	private IDrawingService drawingService;//提现Service
	private ICustomerService customerService;//客户Service
	private IUsersService usersService;//用户Service
	private IDrawingBackService drawingBackService;//提现退回Service
	private ICustomerBankrollService customerBankrollService;// 账户资金Service
	private Drawing drawing;
	/**提现编号**/
	private String drawingCode;
	/**开始时间**/
	private String startTime;
	/**结束时间**/
	private String endTime;
	/**充值记录集合**/
	private List<Drawing> drawingList;
	/**提现记录Id**/
	private String drawingId;
	/**状态**/
	private String state;
	/**备注**/
	private String remarks;

	/**
	 * 跳转到提现记录页面
	 * */
	public String gotoDrawingPageList(){
		String purviewId=request.getParameter("purviewId");
		request.getSession().setAttribute("purviewId", purviewId);
		return SUCCESS;
	}
	/**
	 * 提现记录列表
	 * */
	public void drawingPageList(){
		try {
			StringBuffer hqlsb = new StringBuffer();
			hqlsb.append(" where 1=1 ");
			if(Utils.stringIsNotEmpty(drawingCode)){
				hqlsb.append(" and o.drawingCode like '%");
				hqlsb.append(drawingCode);
				hqlsb.append("%'");
			}
			//查询开始时间不为空
			if(Utils.stringIsNotEmpty(startTime)){
				hqlsb.append(" and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('");
				hqlsb.append(startTime);
				hqlsb.append(" 00:00:00')");
			}
			//查询结束时间不为空
			if(Utils.stringIsNotEmpty(endTime)){
				hqlsb.append(" and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('");
				hqlsb.append(endTime);
				hqlsb.append(" 23:59:59')");
			}
			//查询状态
			if(Utils.stringIsNotEmpty(state)&&!"-1".equals(state)){
				hqlsb.append(" and o.state='");
				hqlsb.append(state);
				hqlsb.append("'");
			}
			int totalRecordCount = drawingService.getCount(hqlsb.toString());
			pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
			drawingList = drawingService.findListByPageHelper(null,pageHelper, hqlsb.toString());
			Map<String, Object> jsonMap = new HashMap<String, Object>();
			jsonMap.put("total", totalRecordCount);
			jsonMap.put("rows", drawingList);
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
			JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
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
	 * 审核提现
	 * **/
	public void saveOrUpdateDrawingState() throws IOException{
		boolean isSuccess=false;
		if(Utils.objectIsNotEmpty(drawingId)&&Utils.objectIsNotEmpty(remarks)&&Utils.objectIsNotEmpty(state)){
			drawing=(Drawing) drawingService.getObjectById(drawingId);
			if(Utils.objectIsNotEmpty(drawing)&&Utils.objectIsNotEmpty(drawing.getDrawingId())){
				drawing.setState(Integer.valueOf(state));//状态
				drawing.setRemarks(remarks);//备注
				if("3".equals(state)){//已发放
					drawing.setUpdateTime(new Date());
					Users user=(Users) request.getSession().getAttribute("users");
					if(Utils.objectIsNotEmpty(user)){
						drawing.setUpdateUserId(user.getUsersId());//发放人ID
					}
				}
				Drawing drawing_new =(Drawing) drawingService.saveOrUpdateObject(drawing);
				if(Utils.objectIsNotEmpty(drawing_new)&&Utils.objectIsNotEmpty(drawing_new.getDrawingId())){
					isSuccess=true;
				}
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess",isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 提现记录详情
	 * @throws IOException
	 * **/
	public void getDrawingObject() throws IOException{
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		if(Utils.objectIsNotEmpty(drawingId)){
			//StringBuffer hql= new StringBuffer();
			//hql.append("select d.*,c.customerName,u.userName ");
			//hql.append(" from Users u,Customer c,Drawing d where d.customerId=c.customerId and d.updateUserId=u.usersId and d.drawingId="+drawingId);
			drawing=(Drawing) drawingService.getObjectById(drawingId);
			if(Utils.objectIsNotEmpty(drawing)&&Utils.objectIsNotEmpty(drawing.getDrawingId())){
				if(Utils.objectIsNotEmpty(drawing.getUpdateUserId())){
					Users users=(Users) usersService.getObjectById(String.valueOf(drawing.getUpdateUserId()));
					jsonMap.put("userName",users.getUserName());
				}
				if(Utils.objectIsNotEmpty(drawing.getCustomerId())){
					Customer customer=(Customer) customerService.getObjectById(String.valueOf(drawing.getCustomerId()));
					jsonMap.put("customerName",customer.getLoginName());
				}
			}
		}
		jsonMap.put("drawing",drawing);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}

	/**
	 * 导出统计数据EXCEL
	 * @throws IOException
	 * @throws Base64DecodingException
	 */
	public String exportCountModFuleExcel() throws IOException{
		StringBuffer hqlsb = new StringBuffer();
		hqlsb.append(" where 1=1 ");
		if(Utils.stringIsNotEmpty(drawingCode)){
			hqlsb.append(" and o.drawingCode like '%");
			hqlsb.append(drawingCode);
			hqlsb.append("%'");
		}
		//查询开始时间不为空
		if(Utils.stringIsNotEmpty(startTime)){
			hqlsb.append(" and UNIX_TIMESTAMP(o.createTime) >= UNIX_TIMESTAMP('");
			hqlsb.append(startTime);
			hqlsb.append(" 00:00:00')");
		}
		//查询结束时间不为空
		if(Utils.stringIsNotEmpty(endTime)){
			hqlsb.append(" and UNIX_TIMESTAMP(o.createTime) <= UNIX_TIMESTAMP('");
			hqlsb.append(endTime);
			hqlsb.append(" 23:59:59')");
		}
		//查询状态
		if(Utils.stringIsNotEmpty(state)&&!"-1".equals(state)){
			hqlsb.append(" and o.state='");
			hqlsb.append(state);
			hqlsb.append("'");
		}
		List<Drawing> countList =drawingService.findObjects(hqlsb.toString());
		if (Utils.collectionIsNotEmpty(countList)) {
			session.setAttribute("columnNames",ordersColumnNamesList());// 把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues",ordersColumnValuesList(countList));// 把所需要传递的columnValues列名对应的值集合放在session中。
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
		typeNameList.add(0,"用户名称");
		typeNameList.add("真实姓名");
		typeNameList.add("提现编号");
		typeNameList.add("联系电话");
		typeNameList.add("银行名称");
		typeNameList.add("银行地址");
		typeNameList.add("卡号");
		typeNameList.add("申请时间");
		typeNameList.add("状态");
		typeNameList.add("提现金额");
		typeNameList.add("备注");
		return typeNameList;
	}

	/** excel对应列的值 **/
	public List<List<String>> ordersColumnValuesList(List<Drawing> list) throws IOException {
		//保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		for(Drawing cc : list){
			List<String> columnValuesList = null;
			columnValuesList = new ArrayList<String>();
			Customer customer=(Customer) customerService.getObjectById(String.valueOf(cc.getCustomerId()));
			//Users users=(Users) usersService.getObjectById(String.valueOf(cc.getUpdateUserId()));
			columnValuesList.add(customer.getLoginName());//用户名称
			columnValuesList.add(cc.getRealName());//真实姓名
			columnValuesList.add(cc.getDrawingCode());//提现编号
			columnValuesList.add(cc.getPhone());//联系电话
			columnValuesList.add(cc.getBankName());//银行名称
			columnValuesList.add(cc.getBankAddre());//银行地址
			columnValuesList.add(cc.getCardNum());//卡号
			columnValuesList.add(String.valueOf(cc.getCreateTime()));//申请时间
			//columnValuesList.add(String.valueOf(cc.getUpdateTime()));//发放时间
			/*if(Utils.objectIsNotEmpty(users)){
				columnValuesList.add(users.getUserName());//发放人
			}else{
				columnValuesList.add("--");//发放人
			}*/
			int state=Integer.parseInt(cc.getState().toString());//1:待审核2:已发放3:已退回
			String stateValue="";
			if(state==1){
				stateValue="待审核";
			}else if(state==2){
				stateValue="已发放";
			}else if(state==3){
				stateValue="已退回";
			}
			columnValuesList.add(String.valueOf(stateValue));//状态
			BigDecimal drawingAmount= (BigDecimal)cc.getDrawingAmount();//提现金额
			columnValuesList.add(String.valueOf(drawingAmount));//提现金额
			columnValuesList.add(cc.getRemarks());//备注
			columnRowsList.add(columnValuesList);
		}
		return columnRowsList;
	}

	public void deleteExpiredFinanceSynced(){
		try {
			customerBankrollService.deleteExpiredFinanceSynced();
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}

	public void setDrawingService(IDrawingService drawingService) {
		this.drawingService = drawingService;
	}
	public void setDrawingBackService(IDrawingBackService drawingBackService) {
		this.drawingBackService = drawingBackService;
	}
	public void setCustomerBankrollService(
			ICustomerBankrollService customerBankrollService) {
		this.customerBankrollService = customerBankrollService;
	}
	public Drawing getDrawing() {
		return drawing;
	}
	public void setDrawing(Drawing drawing) {
		this.drawing = drawing;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
	}
	public List<Drawing> getDrawingList() {
		return drawingList;
	}
	public void setDrawingList(List<Drawing> drawingList) {
		this.drawingList = drawingList;
	}
	public String getDrawingCode() {
		return drawingCode;
	}
	public void setDrawingCode(String drawingCode) {
		this.drawingCode = drawingCode;
	}
	public String getDrawingId() {
		return drawingId;
	}
	public void setDrawingId(String drawingId) {
		this.drawingId = drawingId;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public void setUsersService(IUsersService usersService) {
		this.usersService = usersService;
	}

}
