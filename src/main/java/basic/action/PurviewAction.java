package basic.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import util.action.BaseAction;
import util.other.Utils;
import basic.pojo.Purview;
import basic.service.IPurviewService;
/**
 * 权限Action
 * @author LQS
 *
 */
@SuppressWarnings("serial")
public class PurviewAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private IPurviewService purviewService;//权限Service
	private String id;
	private String ids;
	private String purviewId;
	private String oldParentId;
	private Purview purview;
    //管理分类
    public String gotoPurviewPage(){
    	return SUCCESS;
    }
    //得到所有权限,回传时用html，不要用xml，否则&符不能使用
	public void getNodes() {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/xml;charset=utf-8");
		List<Purview> list = purviewService.queryByParentId(id);
		StringBuffer sbf = new StringBuffer();
		Purview purview = null;
		sbf.append("<List>");
		for (Iterator<Purview> ite = list.iterator(); ite.hasNext();) {
			purview = (Purview) ite.next();
			if (purview != null) {
				sbf.append("<Purview>");
				sbf.append("<name>").append(purview.getPurviewName()).append("</name>");
				sbf.append("<id>").append(purview.getPurviewId()).append("</id>");
				sbf.append("<isLeaf>").append(purview.getIsLeaf()).append("</isLeaf>");
				sbf.append("<levelCode>").append(purview.getLevelCode()).append("</levelCode>");
				sbf.append("</Purview>");
			}
		}
		sbf.append("</List>");
		PrintWriter out;
		try {
			out = response.getWriter();
			out.println(sbf.toString());
			out.flush();
			out.close();
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	
	//添加或者修改权限
	public void saveOrUpdatePurview() throws Exception {
		Boolean isSuccess=false;
		if(purview!=null){
			isSuccess=purviewService.saveOrUpdatePurview(purview, oldParentId);
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess.toString());
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//得到权限对象信息
	public void getPurviewObject() throws Exception {
	    Purview purview = (Purview) purviewService.getObjectByParams(" where o.purviewId='"+purviewId+"'");
		JSONObject jo = JSONObject.fromObject(purview);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	 
	//得到权限对象列表
	public void getResetPurviewList() throws Exception {
		List<Purview> purviewList = new ArrayList<>();
		List <Purview> pList1 = purviewService.findObjects(" where  (levelCode=1 or purviewId=1) and purviewId!="+purviewId+"  order by sortCode");
		if(Utils.objectIsNotEmpty(pList1)){
			for(Purview p1:pList1){
				purviewList.add(p1);
				if(p1.getPurviewId()!=1){
					List <Purview> pList2 = purviewService.findObjects(" where parentId="+p1.getPurviewId()+" and purviewId!="+purviewId+"  order by sortCode");
					if(Utils.objectIsNotEmpty(pList2)){
						for(Purview p2:pList2){
							purviewList.add(p2);
						}
					}
				}
			}
		}
		JSONArray jo = JSONArray.fromObject(purviewList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	//删除权限信息
	public void delPurview() throws Exception {
		boolean isSuccess = false;
		if(StringUtils.isNotEmpty(ids)){
			isSuccess = purviewService.deletePurview(ids);
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		//System.out.println(jo.toString());
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getPurviewId() {
		return purviewId;
	}
	public void setPurviewId(String purviewId) {
		this.purviewId = purviewId;
	}
	public Purview getPurview() {
		return purview;
	}
	public void setPurview(Purview purview) {
		this.purview = purview;
	}
	public void setPurviewService(IPurviewService purviewService) {
		this.purviewService = purviewService;
	}
	public String getOldParentId() {
		return oldParentId;
	}
	public void setOldParentId(String oldParentId) {
		this.oldParentId = oldParentId;
	}
}
