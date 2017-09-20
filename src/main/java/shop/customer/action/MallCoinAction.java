package shop.customer.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.log4j.Logger;
import shop.customer.pojo.MallCoin;
import shop.customer.service.IMallCoinService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;

/**
 * 金币Action
 * @author mf
 */
public class MallCoinAction extends BaseAction{
	Logger logger = Logger.getLogger(this.getClass());
	private static final long serialVersionUID = 7034206694063394841L;
	/**金币service**/
	private IMallCoinService mallCoinService;
	/**用户id**/
	private Integer customerId;
	/**查询金币余额的类型[1收入，2支出]**/
	private String balanceType;
	/**金币service**/
	private List<MallCoin> mallCoinList;
	/**用户id**/
	private Integer mallCoinId;
	private MallCoin mallCoin;
	/***************************************end*********************************************/
	/**
	 * 跳转到金币页面
	 * @return
	 */
	public String gotoMallCoin(){
		String purviewId=request.getParameter("purviewId");
		request.getSession().setAttribute("purviewId", purviewId);
		return SUCCESS;
	}
	/**
	 * 查询用户金币list
	 */
	public void mallCoinList(){
		try {
			String loginName = request.getParameter("loginName");
			String ordersNo = request.getParameter("ordersNo");
			String registerDate = request.getParameter("registerDate");
			String registerDate2 = request.getParameter("registerDate2");
			String balanceType=request.getParameter("balanceType");
			String condition = "";
			if(loginName!=null&&!"".equals(loginName.trim())){
				condition += " and b.loginName like '%"+loginName.trim()+"%' ";
			}
			if(ordersNo!=null&&!"".equals(ordersNo.trim())){
				condition += " and a.ordersNo like '%"+ordersNo.trim()+"%' ";
			}
			if(balanceType!=null&&!"".equals(balanceType.trim())){
				condition += " and a.type ="+balanceType;
			}
			if(registerDate!=null&&!"".equals(registerDate.trim())){
				condition += " and UNIX_TIMESTAMP(a.tradeTime) >= UNIX_TIMESTAMP('"+registerDate.trim()+" 00:00:00') ";
			}
			if(registerDate2!=null&&!"".equals(registerDate2.trim())){
				condition += " and UNIX_TIMESTAMP(a.tradeTime) <= UNIX_TIMESTAMP('"+registerDate2.trim()+" 23:59:59') ";
			}
			String countHql = "select count(a.mallCoinId)  from MallCoin a ,Customer b where a.customerId = b.customerId ";
			String hql = "select a.mallCoinId as mallCoinId,a.ordersNo as ordersNo,a.serialNumber as serialNumber,a.type as type,a.transactionNumber as transactionNumber,a.tradeTime as tradeTime,a.proportion as proportion,a.customerId as customerId,b.loginName as loginName from shop_mall_coin a ,basic_customer b where a.customerId = b.customerId "+condition+" order by a.tradeTime desc";
			int totalRecordCount = mallCoinService.getMoreTableCount(countHql+condition);
			pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
			List<Map<String,Object>> mallCoinList = mallCoinService.findListMapPageBySql(hql, pageHelper);
			if(mallCoinList!=null&&mallCoinList.size()>0){
				for(Map<String,Object> map:mallCoinList){
					Object object = map.get("tradeTime");
					if(object!=null){
						//定义SimpleDateFormat对象参数为需要刷格式化的时间格式
						SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
						String format = fm.format(object);
						map.put("tradeTime", format);
					}
				}
			}
			Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
			jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
			jsonMap.put("rows", mallCoinList);// rows键 存放每页记录 list
			JsonConfig jsonConfig = new JsonConfig();
			jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
			JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out;
			out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 通过用户Id查找金币明细
	 */
	public void getVirtualCoinById(){
		String mallCoinId = request.getParameter("mallCoinId");
		try {
			if(mallCoinId!=null&&!"".equals(mallCoinId)){
				MallCoin mallCoin = (MallCoin) mallCoinService.getObjectByParams(" where o.mallCoinId="+mallCoinId);
				JsonConfig jsonConfig = new JsonConfig();
				jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
				JSONObject jo = JSONObject.fromObject(mallCoin,jsonConfig);
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out;
				out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	public void customerMallCoinList(){
		try {
			StringBuffer hqlsb = new StringBuffer();
			hqlsb.append(" where o.customerId="+customerId+"order by o.tradeTime desc");
			int totalRecordCount = mallCoinService.getCount(hqlsb.toString());
			pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
			mallCoinList = mallCoinService.findListByPageHelper(null,pageHelper, hqlsb.toString());
			Map<String, Object> jsonMap = new HashMap<String, Object>();
			jsonMap.put("total", totalRecordCount);
			jsonMap.put("rows", mallCoinList);
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

	public void getMallCoinObjectById(){
		try {
			if(mallCoinId!=null){
				mallCoin = (MallCoin)mallCoinService.getObjectByParams(" where o.mallCoinId='"+mallCoinId+"'");
				if(mallCoin != null && !"".equals(mallCoinId)){
					JsonConfig jsonConfig = new JsonConfig();
				    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
					JSONObject jo = JSONObject.fromObject(mallCoin,jsonConfig);// 格式化result
					PrintWriter out = response.getWriter();
					out.println(jo.toString());
					out.flush();
					out.close();
				}
			}
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}

	/**
	 * 获得用户指定类型的总金币【仅用于查询可用总金币、金币总支出、金币总收入】
	 * 对外提供的加密接口
	 */
	public String getMallCoinBalanceById() {
		try {
			if (Utils.objectIsNotEmpty(customerId)) {
				String balance = mallCoinService.getCustomerMallCoin(customerId, balanceType);
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(balance);
				out.flush();
				out.close();
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return SUCCESS;
	}

	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public void setMallCoinService(IMallCoinService mallCoinService) {
		this.mallCoinService = mallCoinService;
	}
	public List<MallCoin> getMallCoinList() {
		return mallCoinList;
	}
	public void setMallCoinList(List<MallCoin> mallCoinList) {
		this.mallCoinList = mallCoinList;
	}
	public Integer getMallCoinId() {
		return mallCoinId;
	}
	public void setMallCoinId(Integer mallCoinId) {
		this.mallCoinId = mallCoinId;
	}
	public MallCoin getMallCoin() {
		return mallCoin;
	}
	public void setMallCoin(MallCoin mallCoin) {
		this.mallCoin = mallCoin;
	}
	public String getBalanceType() {
		return balanceType;
	}
	public void setBalanceType(String balanceType) {
		this.balanceType = balanceType;
	}
}
