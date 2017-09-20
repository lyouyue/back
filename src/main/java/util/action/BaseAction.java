package util.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;

import org.apache.log4j.Logger;
import org.apache.struts2.interceptor.ServletRequestAware;
import org.apache.struts2.interceptor.ServletResponseAware;
import org.springframework.web.context.ServletContextAware;

import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.pojo.PageHelper;

import com.opensymphony.xwork2.ActionSupport;
/**
 * Action类 - 基础Action
 *
 **/
public class BaseAction extends ActionSupport implements ServletRequestAware,ServletResponseAware,ServletContextAware {
	private static final long serialVersionUID = 179714478054136093L;
	protected PageHelper pageHelper;
	protected HttpServletRequest request;
    protected HttpSession session;
    protected HttpServletResponse response;
    protected Integer pageSize=10;
    protected Integer currentPage=1;
	protected Map<Object,Object> fileUrlConfig = new HashMap<Object,Object>();
	protected ServletContext servletContext;//servlet 上下文

	public BaseAction() {
		pageHelper=new PageHelper();
	}
	public PageHelper getPageHelper() {
		return pageHelper;
	}
	public void setPageHelper(PageHelper pageHelper) {
		this.pageHelper = pageHelper;
	}
	//request session 的 getter setter方法
	public void setServletRequest(HttpServletRequest req) {
		this.request=req;
		this.session = this.request.getSession();
	}
	public void setServletResponse(HttpServletResponse res) {
		this.response=res;
	}
	public HttpServletRequest getRequest() {
		return request;
	}
	public HttpServletResponse getResponse() {
		return response;
	}
	public Integer getPageSize() {
		return pageSize;
	}
	public void setPageSize(Integer pageSize) {
		this.pageSize = pageSize;
	}
	public Integer getCurrentPage() {
		return currentPage;
	}
	public void setCurrentPage(Integer currentPage) {
		this.currentPage = currentPage;
	}
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
	@SuppressWarnings("unchecked")
	public Map<Object, Object> getFileUrlConfig() {
		fileUrlConfig = (Map<Object,Object>) servletContext.getAttribute("fileUrlConfig");
		return fileUrlConfig;
	}
	public void responseWriterMap(Map<String, Object> jsonMap) throws IOException{
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
}
