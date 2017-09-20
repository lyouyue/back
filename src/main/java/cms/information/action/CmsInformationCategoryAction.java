package cms.information.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import util.action.BaseAction;
import cms.information.pojo.CmsInformationCategory;
import cms.information.service.ICmsInformationCategoryService;
import cms.information.service.ICmsInformationService;
/**
 *  
 * 信息分类action
 */
@SuppressWarnings("serial")
public class CmsInformationCategoryAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	/**信息分类Service*/
	private ICmsInformationCategoryService cmsInformationCategoryService;
	/** 信息分类实体*/
	private CmsInformationCategory cmsInformationCategory;
	/**树的节点id*/
	private String id;
	/**需要删除的信息分类id*/
	private String ids;
	/**信息分类id*/
	private String informationCategoryId;
	
    /**
     * 跳转信息维护树状图
     */
    public String manageCmsInformationCategoryTree(){
    	return SUCCESS;
    }
    /**
	 * 跳转信息分类维护树状图
	 * 
	 */
    public String gotoCmsInformationCategoryTree(){
    	return SUCCESS;
    }
    /**
	 * 得到树的节点 
	 * 
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public void getNodes() {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/xml;charset=utf-8");
		List<CmsInformationCategory> list = cmsInformationCategoryService.queryByParentId(id);
		StringBuffer sbf = new StringBuffer();
		CmsInformationCategory cmsInformationCategory = null;
		sbf.append("<List>");
		for (Iterator ite = list.iterator(); ite.hasNext();) {
			cmsInformationCategory = (CmsInformationCategory) ite.next();
			if (cmsInformationCategory != null) {
				sbf.append("<Category>");
				sbf.append("<name>").append(cmsInformationCategory.getCategoryName()).append(
						"</name>");
				sbf.append("<id>").append(cmsInformationCategory.getInformationCategoryId()).append(
						"</id>");
				sbf.append("<isleaf>").append(cmsInformationCategory.getIsLeaf()).append(
						"</isleaf>");
				sbf.append("</Category>");
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

	/**
	 * 添加或许修改信息分类 
	 * 
	 */
	public void saveOrEditCmsInformationCategory() throws Exception {
		 //1修改父分类的isLeaf=1 为 非叶子节点 ,这个parentId在前台已经有js 对应上父类的 informationCategoryId 
			if(cmsInformationCategory.getParentId()!=0){
				cmsInformationCategoryService.updateFatherIsLeaf(cmsInformationCategory.getParentId().toString());
			}
		 //2保存新的分类
		 //0为叶子节点 ,可以添加新闻 
			cmsInformationCategory=(CmsInformationCategory)cmsInformationCategoryService.saveOrUpdateObject(cmsInformationCategory);
			if(cmsInformationCategory.getInformationCategoryId()!=null){
				JSONObject jo = new JSONObject();
				jo.accumulate("isSuccess", "true");
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		}
	
	/**
	 * 得到分类对象
	 * 
	 */
	 public void getCmsInformationCategoryObject() throws Exception {
		 CmsInformationCategory cmsInformationCategory = (CmsInformationCategory) cmsInformationCategoryService.getObjectById(informationCategoryId);
			JSONObject jo = JSONObject.fromObject(cmsInformationCategory);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	 /**
		 * 删除分类
		 * 
		 */
	 public void delCmsInformationCategory() throws Exception {
			String strFlag= cmsInformationCategoryService.deleteInformationCategoryAndInformationByIds(ids);
			JSONObject jo = new JSONObject();
			jo.accumulate("strFlag", strFlag);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();  
		}
	 /**
	  * 同步新闻分类到ServletContent中
	  * @throws IOException 
	  */
	/*public void updateInServletContextNewsType() throws IOException{
		 List<cmsInformationCategory> informationCategorys = cmsInformationCategoryService.findObjects(null, " where o.parentId=2 order by o.informationCategoryId asc");
			List<BottomNewsModuleBean> bottomNewsModuleBeans = new ArrayList<BottomNewsModuleBean>();
			for(cmsInformationCategory cc : informationCategorys){
				BottomNewsModuleBean bnmb = new BottomNewsModuleBean();
				bnmb.setNewsTypeName(cc.getCategoryName());
				String hql = "select ca.informationId as informationId,ca.informationCategoryId as informationCategoryId,ca.title as title from Information ca "+
							" where ca.informationCategoryId="+cc.getInformationCategoryId()+" order by ca.sortCode asc";
				List<Map<String, Object>> informationList = informationService.findListMapByHql(hql);
				bnmb.setNewsContentList(informationList);
				bottomNewsModuleBeans.add(bnmb);
			}
			servletContext.setAttribute("bottomNewsModuleBeans", bottomNewsModuleBeans);
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
	}*/
	public CmsInformationCategory getCmsInformationCategory() {
		return cmsInformationCategory;
	}
	public void setCmsInformationCategory(
			CmsInformationCategory cmsInformationCategory) {
		this.cmsInformationCategory = cmsInformationCategory;
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
	public String getInformationCategoryId() {
		return informationCategoryId;
	}
	public void setInformationCategoryId(String informationCategoryId) {
		this.informationCategoryId = informationCategoryId;
	}
	public void setCmsInformationCategoryService(
			ICmsInformationCategoryService cmsInformationCategoryService) {
		this.cmsInformationCategoryService = cmsInformationCategoryService;
	}
	
}
