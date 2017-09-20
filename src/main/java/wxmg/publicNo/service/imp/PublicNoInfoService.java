package wxmg.publicNo.service.imp;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import org.apache.struts2.ServletActionContext;
import org.springframework.web.context.ServletContextAware;

import util.other.Utils;
import util.service.BaseService;
import wxmg.util.wx.WXBasicUtil;
import wxmg.publicNo.dao.IPublicNoInfoDao;
import wxmg.publicNo.pojo.PublicNoInfo;
import wxmg.publicNo.service.IPublicNoInfoService;
/**
 * 微信基本信息Service接口实现类
 * @author LQS
 *
 */
public class PublicNoInfoService extends BaseService<PublicNoInfo> implements IPublicNoInfoService , ServletContextAware{
	private IPublicNoInfoDao publicNoInfoDao;
	//servlet 上下文
	private ServletContext servletContext;

	public void setPublicNoInfoDao(IPublicNoInfoDao publicNoInfoDao) {
		this.baseDao =  this.publicNoInfoDao = publicNoInfoDao;
	}
	
	//更新微信Token begin
	@SuppressWarnings("unchecked")
	public void accessTokenInit(){
		try{
			List<PublicNoInfo> pList = publicNoInfoDao.findObjects(null, null);
			if(Utils.objectIsNotEmpty(pList)&&pList.size()>0){
					PublicNoInfo publicNoInfo = pList.get(0);
					servletContext.setAttribute("publicNoInfo",publicNoInfo);
					Map<Object, Object> pMap=new HashMap<Object, Object>();
					for(PublicNoInfo p:pList){
						String accessToken = WXBasicUtil.getAccessToken(p.getAppId(), p.getAppSecret());
						pMap.put(p.getToUserName(), accessToken);
						System.out.println("微信令牌定时加载accessToken："+accessToken);
					}
					pMap.put("atTime", new Date());
					String access_token = (String) pMap.get(publicNoInfo.getToUserName());
					String ticket = WXBasicUtil.getTicket(access_token);
					System.out.println("微信令牌定时加载ticket："+ticket);
					servletContext.setAttribute("accessTokens", pMap);
					servletContext.setAttribute("ticket", ticket);
			}
		}catch (Exception e){
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			//String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public String getToken(PublicNoInfo publicNoInfo) {
		String access_token = null;
		Map<?,?> pMap = (Map<?,?>)ServletActionContext.getServletContext().getAttribute("accessTokens");
		if(Utils.objectIsEmpty(publicNoInfo)){
			publicNoInfo =	(PublicNoInfo)ServletActionContext.getServletContext().getAttribute("publicNoInfo");
		}
		if(Utils.objectIsEmpty(publicNoInfo)){
			//更新微信Token begin
			accessTokenInit();
			List<PublicNoInfo> pList = publicNoInfoDao.findObjects(null, null);
			if(Utils.objectIsNotEmpty(pList)&&pList.size()>0){
				publicNoInfo = pList.get(0);
			}
		}
		if(Utils.objectIsNotEmpty(pMap)&&Utils.objectIsNotEmpty(publicNoInfo)&&Utils.objectIsNotEmpty(publicNoInfo.getToUserName())){
			access_token = (String) pMap.get(publicNoInfo.getToUserName());
		}
		return access_token;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public PublicNoInfo getPublicNoInfo() {
		PublicNoInfo publicNoInfo =	(PublicNoInfo)ServletActionContext.getServletContext().getAttribute("publicNoInfo");
		if(Utils.objectIsEmpty(publicNoInfo)){
			List<PublicNoInfo> pList = publicNoInfoDao.findObjects(null, null);
			if(Utils.objectIsNotEmpty(pList)&&pList.size()>0){
				publicNoInfo = pList.get(0);
			}
		}
		return publicNoInfo;
	}
	
	public ServletContext getServletContext() {
		return servletContext;
	}
	public void setServletContext(ServletContext servletContext) {
		this.servletContext = servletContext;
	}
}
