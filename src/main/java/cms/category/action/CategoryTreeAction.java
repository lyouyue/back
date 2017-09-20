package cms.category.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;
import javax.servlet.http.HttpServletResponse;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import util.action.BaseAction;
import cms.category.pojo.CmsCategory;
import cms.category.service.ICategoryService;
/**
 *  
 * 文章分类action
 */
@SuppressWarnings("serial")
public class CategoryTreeAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private ICategoryService categoryService;
	private String id;
	private String ids;
	private String categoryId;
	/**
	 * 管理分类
	 * 
	 */
    public String manageCategoryTree(){
    	return SUCCESS;
    }
    /**
	 * 管理分类对应文章
	 * 
	 */
    public String gotoCategoryTree(){
    	String purviewId=request.getParameter("purviewId");
		request.getSession().setAttribute("purviewId", purviewId);
    	return SUCCESS;
    }
    /**
	 * 得到树的节点 
	 * 
	 */
	public void getNodes() {
		HttpServletResponse response = ServletActionContext.getResponse();
		response.setContentType("text/xml;charset=utf-8");
		List<CmsCategory> list = categoryService.queryByParentId(id);
		StringBuffer sbf = new StringBuffer();
		CmsCategory category = null;
		sbf.append("<List>");
		for (Iterator ite = list.iterator(); ite.hasNext();) {
			category = (CmsCategory) ite.next();
			if (category != null) {
				sbf.append("<Category>");
				sbf.append("<name>").append(category.getCategoryName()).append(
						"</name>");
				sbf.append("<id>").append(category.getCategoryId()).append(
						"</id>");
				sbf.append("<isleaf>").append(category.getIsLeaf()).append(
						"</isleaf>");
				sbf.append("<parentId>").append(category.getParentId()).append(
						"</parentId>");
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
	 * 新增或许修改新闻分类 
	 * 
	 */
	public void saveOrEditCategory() throws Exception {
		String categoryId = request.getParameter("categoryId");
		String categoryName = request.getParameter("categoryName");
		String parentId = request.getParameter("parentId");
		String keywords = request.getParameter("keywords");
		String sortCode = request.getParameter("sortCode");
		String isLeaf = request.getParameter("isLeaf");
		 //1修改父分类的isLeaf=1 为 非叶子节点 ,这个parentId在前台已经有js 对应上父类的 categoryId 
		if(!"0".equals(parentId)){
			categoryService.updateFatherIsLeaf(parentId);
		}
		 //2保存新的分类
		 //0为叶子节点 ,可以添加新闻 
		 CmsCategory category=new CmsCategory();
		 if(categoryId!=null&&!"".equals(categoryId)){
			 category.setCategoryId(Integer.parseInt(categoryId));
		 }
		 category.setCategoryName(categoryName);
		 category.setParentId(Integer.parseInt(parentId));
		 category.setKeywords(keywords);
		 category.setSortCode(Integer.parseInt(sortCode));
		 if(isLeaf!=null&&!"".equals(isLeaf)){
			 category.setIsLeaf(Integer.parseInt(isLeaf));
		 }else{
			 category.setIsLeaf(1);
		 }
		 category=(CmsCategory)categoryService.saveOrUpdateObject(category);
			if(category.getCategoryId()!=null){
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
	 public void getCategoryObject() throws Exception {
		    CmsCategory category = (CmsCategory) categoryService.getObjectById(categoryId);
			JSONObject jo = JSONObject.fromObject(category);
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
	 public void delCategory() throws Exception {
			String strFlag= categoryService.deleteCategoryAndArticleByIds(ids);
			JSONObject jo = new JSONObject();
			jo.accumulate("strFlag", strFlag);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	public void setCategoryService(ICategoryService categoryService) {
		this.categoryService = categoryService;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
}
