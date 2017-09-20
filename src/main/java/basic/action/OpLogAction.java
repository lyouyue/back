package basic.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.ParseException;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import basic.pojo.OPLog;
import basic.service.IOPLogService;
/**
 * CustomerAction:日志action类
 * @author
 *
 */
@SuppressWarnings("serial")
public class OpLogAction extends BaseAction {
	private String opId;
	private OPLog opLog;
	//客户service层的引用
	private IOPLogService opLogService;
	public String goToOpLog(){
		return SUCCESS;
	}
	@SuppressWarnings("rawtypes")
	public void listOpLog() throws IOException, ParseException{
		//获取查询参数
		String opDesc = request.getParameter("opDesc");
		String startTime = request.getParameter("startTime");
		String endTime = request.getParameter("endTime");
		String params=" where 1=1";
		if(opDesc!=null&&!"".equals(opDesc)){
			params+=" and o.opDesc like '%"+opDesc+"%'";
		}
		if(startTime!=null&&!"".equals(startTime)){
			params+=" and UNIX_TIMESTAMP(o.opDate)>=UNIX_TIMESTAMP('"+startTime+"')";
		}
		if(endTime!=null&&!"".equals(endTime)){
			params+=" and UNIX_TIMESTAMP(o.opDate)<=UNIX_TIMESTAMP('"+endTime+"')";
		}
		int totalRecordCount = opLogService.getCount(params);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List list=opLogService.findListByPageHelper(null, pageHelper, params+" order by o.opDate desc");
		Map<String,Object> jsonMap = new HashMap<String, Object>();//定义map
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", list);//rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取一条记录
	public void getOpLogObject() throws Exception{
		opLog = (OPLog)opLogService.getObjectById(opId);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(opLog,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}


	public void setOpLogService(IOPLogService opLogService) {
		this.opLogService = opLogService;
	}
	public String getOpId() {
		return opId;
	}
	public void setOpId(String opId) {
		this.opId = opId;
	}
	public OPLog getOpLog() {
		return opLog;
	}
	public void setOpLog(OPLog opLog) {
		this.opLog = opLog;
	}
}
