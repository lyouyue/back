package shop.shareRigster.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.customer.service.ICustomerService;
import shop.shareRigster.pojo.ShareRigster;
import shop.shareRigster.service.IShareRigsterService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
/**
 * 分享注册Action
 * @author lmh
 * **/
@SuppressWarnings("serial")
public class ShareRigsterAction extends BaseAction{
	/**
	 * 分享注册Service
	 * **/
	private IShareRigsterService shareRigsterService;
	/**
	 * 会员Service
	 * **/
	private ICustomerService customerService;
	/**
	 * 分享注册实体类
	 * **/
	private ShareRigster shareRigster;
	/**
	 * 分享注册集合
	 * **/
	private List<Map<String, Object>> shareRigsterList;
	/**导出excel文件的列名称**/
	private List<String> typeNameList = new ArrayList<String>();
	/**
	 * 集合类
	 */
	private List<Map<String, Object>> mapList;

	//跳转到分享注册列表页面
	public String gotoShareRigsterPage(){
		return SUCCESS;
	}
	//查询所有后台分享注册信息
	public void listShareRigster() throws Exception{
		String registerDate = request.getParameter("registerDate");
		String registerDate2 = request.getParameter("registerDate2");
		// sql查询语句
		 String where =" where 1=1 ";
		String shareCustomerName = request.getParameter("shareCustomerName");
		String rigsterCustomerName = request.getParameter("registerCustomerName");
		if(shareCustomerName!=null&&!"".equals(shareCustomerName.trim())){
			where+=" and o.rcName like '%"+shareCustomerName+"%'";
		}
		if(rigsterCustomerName!=null&&!"".equals(rigsterCustomerName)){
			where+=" and o.scName like '%"+rigsterCustomerName+"%'";
		}
		if(registerDate!=null&&!"".equals(registerDate.trim())){
			where += " and UNIX_TIMESTAMP(o.shareTime) >= UNIX_TIMESTAMP('"+registerDate.trim()+" 00:00:00')";
		}
		if(registerDate2!=null&&!"".equals(registerDate2.trim())){
			where += " and UNIX_TIMESTAMP(o.shareTime) <= UNIX_TIMESTAMP('"+registerDate2.trim()+" 23:59:59')";
		}
		Integer totalRecordCount=shareRigsterService.getCount(where);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<ShareRigster> shareRigsterList = shareRigsterService.findListByPageHelper(null, pageHelper, where+" order by o.shareTime desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", shareRigsterList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap, jsonConfig);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**excel列名**/
	private List<String> ordersColumnNamesList(){
		typeNameList.add(0,"注册人姓名");
		typeNameList.add("分享人姓名");
		typeNameList.add("分享时间");
		typeNameList.add("赠送金币数");
		return typeNameList;
	}
	/**
	 * 导出分享记录EXCEL
	 */
	public String exportShareRigsterExcel() throws IOException{
		String registerDate = request.getParameter("registerDate");
		String registerDate2 = request.getParameter("registerDate2");
		// sql查询语句
		 String where =" where 1=1 ";
		String shareCustomerName = request.getParameter("shareCustomerName");
		String rigsterCustomerName = request.getParameter("registerCustomerName");
		if(shareCustomerName!=null&&!"".equals(shareCustomerName.trim())){
			where+=" and o.rcName like '%"+shareCustomerName+"%'";
		}
		if(rigsterCustomerName!=null&&!"".equals(rigsterCustomerName)){
			where+=" and o.scName like '%"+rigsterCustomerName+"%'";
		}
		if(registerDate!=null&&!"".equals(registerDate.trim())){
			where += " and UNIX_TIMESTAMP(o.shareTime) >= UNIX_TIMESTAMP('"+registerDate.trim()+" 00:00:00')";
		}
		if(registerDate2!=null&&!"".equals(registerDate2.trim())){
			where += " and UNIX_TIMESTAMP(o.shareTime) <= UNIX_TIMESTAMP('"+registerDate2.trim()+" 23:59:59')";
		}
		List<ShareRigster> shareRigsterList = shareRigsterService.findObjects(null, where+" order by o.shareTime desc ");
		if(shareRigsterList!=null&&shareRigsterList.size()>0){
			session.setAttribute("columnNames", ordersColumnNamesList());//把所需要传递的columnNames列名集合放在session中。
			session.setAttribute("columnValues", ordersColumnValuesList(shareRigsterList));//把所需要传递的columnValues列名对应的值集合放在session中。
			session.setAttribute("moduleName", "ShareRigster");
			return "success";
		}else {
			this.addActionError("没有数据");
			return "error";
		}
	}
	/**excel对应列的值**/
	public List<List<String>> ordersColumnValuesList(List<ShareRigster> list) throws IOException{
		//保存二维表样式数据 List <List<String>>
		List<List<String>> columnRowsList = new ArrayList<List<String>>();
		List<String> columnValuesList = null;
		for(ShareRigster cc : list){
			columnValuesList = new ArrayList<String>();
			columnValuesList.add(String.valueOf(cc.getRcName()));
			columnValuesList.add(String.valueOf(cc.getScName()));
			columnValuesList.add(String.valueOf(cc.getShareTime()));
			columnValuesList.add(String.valueOf(cc.getGiveCoinNumber()));
			columnRowsList.add(columnValuesList);//把当前的行 添加到 列表中
		}
		return columnRowsList;
	}
	public ShareRigster getShareRigster() {
		return shareRigster;
	}
	public void setShareRigster(ShareRigster shareRigster) {
		this.shareRigster = shareRigster;
	}

	public List<Map<String, Object>> getShareRigsterList() {
		return shareRigsterList;
	}
	public void setShareRigsterList(List<Map<String, Object>> shareRigsterList) {
		this.shareRigsterList = shareRigsterList;
	}
	public void setShareRigsterService(IShareRigsterService shareRigsterService) {
		this.shareRigsterService = shareRigsterService;
	}
	public void setCustomerService(ICustomerService customerService) {
		this.customerService = customerService;
	}
	public List<String> getTypeNameList() {
		return typeNameList;
	}
	public void setTypeNameList(List<String> typeNameList) {
		this.typeNameList = typeNameList;
	}
	public List<Map<String, Object>> getMapList() {
		return mapList;
	}
	public void setMapList(List<Map<String, Object>> mapList) {
		this.mapList = mapList;
	}

}
