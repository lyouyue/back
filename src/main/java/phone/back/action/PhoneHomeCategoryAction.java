package phone.back.action;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;

import phone.back.pojo.PhoneHomeCategory;
import phone.back.service.IPhoneHomeCategoryService;
import util.action.BaseAction;
import util.upload.ImageFileUploadUtil;

/**
 * 手机端分类
 * 
 * 2014-01-22
 */
public class PhoneHomeCategoryAction extends BaseAction {
	private static final long serialVersionUID = 1L;
	Logger logger = Logger.getLogger(this.getClass());
	/**中间分类service**/
	private IPhoneHomeCategoryService phoneHomeCategoryService;

	/**中间分类service**/
	private PhoneHomeCategory phoneHomeCategory;

	/**父ID**/
	private String parentId;

	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	/**
	 * 跳转
	 */
	public String gotoPhoneHomeCategoryTree(){
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
		List<PhoneHomeCategory> list = phoneHomeCategoryService.findObjects(null, "where 1=1 and o.parentId="+parentId);
		StringBuffer sbf = new StringBuffer();
		PhoneHomeCategory smc = null;
		sbf.append("<List>");
		for (Iterator ite = list.iterator(); ite.hasNext();) {
			smc = (PhoneHomeCategory) ite.next();
			if (smc!= null) {
				sbf.append("<category>");
				sbf.append("<name>").append(smc.getCategoryName()).append("</name>");
				sbf.append("<parentId>").append(smc.getParentId()).append("</parentId>");
				sbf.append("<id>").append(smc.getCategoryId()).append("</id>");
				sbf.append("<isLeaf>").append(smc.getIsLeaf()).append("</isLeaf>");
				sbf.append("<level>").append(smc.getLevel()).append("</level>");
				sbf.append("</category>");
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
	 *  异步ajax 图片上传
	 */
	public void uploadImage() {
		try {
			Map<String, Object> jsonMap = new HashMap<String, Object>();
			if (imagePath != null) {
				String photoUrl = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, getFileUrlConfig(), "image_phoneCategory");
				String visitFileUploadRoot = String.valueOf(getFileUrlConfig().get("uploadFileVisitRoot"));
				jsonMap.put("photoUrl", photoUrl);
				jsonMap.put("visitFileUploadRoot", visitFileUploadRoot);
			} else {
				String photoUrl = "false1";
				jsonMap.put("photoUrl", photoUrl);
			}
			JSONObject jo = JSONObject.fromObject(jsonMap);
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		// 1图片上传
		} catch (IOException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 保存
	 * @throws IOException
	 */
	public void saveOrEditPhoneHomeCategory()throws IOException{
		if(phoneHomeCategory.getCategoryId()==null){//添加
			phoneHomeCategory.setIsLeaf(1);
			//父对象
			PhoneHomeCategory shm = (PhoneHomeCategory) phoneHomeCategoryService.getObjectByParams(" where o.categoryId="+phoneHomeCategory.getParentId());
			//计算级别
			Integer level=0;
			if(shm!=null){
				level = shm.getLevel();
				shm.setIsLeaf(0);
				phoneHomeCategoryService.saveOrUpdateObject(shm);//更改父对象的节点信息
			}
			phoneHomeCategory.setLevel(level+1);
		}
		Object o = phoneHomeCategoryService.saveOrUpdateObject(phoneHomeCategory);
		JSONObject jo = new JSONObject();
		if(o!=null){
			jo.accumulate("strFlag", true);
		}else{
			jo.accumulate("strFlag", false);
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 获得当前对象
	 */
	public void getPhoneHomeCategoryObj()throws IOException{
		String id = request.getParameter("id");
		PhoneHomeCategory smc = (PhoneHomeCategory) phoneHomeCategoryService.getObjectByParams(" where o.categoryId="+id);
		JSONObject jo = JSONObject.fromObject(smc);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 删除分类
	 */
	public void delPhoneHomeCategory()throws IOException{
		String id = request.getParameter("id");
		PhoneHomeCategory phoneHomeCategory = (PhoneHomeCategory) phoneHomeCategoryService.getObjectByParams(" where o.categoryId="+id);
		boolean bool = phoneHomeCategoryService.deleteObjectByParams(" where o.categoryId="+id);
		Integer count=0;
		if(phoneHomeCategory!=null){
			count = phoneHomeCategoryService.getCount(" where o.parentId="+phoneHomeCategory.getParentId());
		}
		if(count==0){
			//更改父对象isLeaf状态
			PhoneHomeCategory phoneHomeCategoryParent = (PhoneHomeCategory) phoneHomeCategoryService.getObjectByParams(" where o.categoryId="+phoneHomeCategory.getParentId());
			phoneHomeCategoryParent.setIsLeaf(1);
			phoneHomeCategoryService.saveOrUpdateObject(phoneHomeCategoryParent);
		}
		JSONObject jo = new JSONObject();
		if(bool){
			jo.accumulate("strFlag", true);
		}else{
			jo.accumulate("strFlag", false);
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 通过树来维护列表
	 */
	public String gotoPhoneHomeCategoryTablePage(){
		return SUCCESS;
	}
	//setter getter
	public String getParentId() {
		return parentId;
	}
	public void setParentId(String parentId) {
		this.parentId = parentId;
	}
	public File getImagePath() {
		return imagePath;
	}
	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}
	public String getImagePathFileName() {
		return imagePathFileName;
	}
	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}
	public PhoneHomeCategory getPoneHomeCategory() {
		return phoneHomeCategory;
	}
	public void setPoneHomeCategory(PhoneHomeCategory phoneHomeCategory) {
		this.phoneHomeCategory = phoneHomeCategory;
	}
	public void setPhoneHomeCategoryService(
			IPhoneHomeCategoryService phoneHomeCategoryService) {
		this.phoneHomeCategoryService = phoneHomeCategoryService;
	}
}
