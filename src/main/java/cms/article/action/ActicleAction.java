package cms.article.action;
import java.io.File;
import java.io.PrintWriter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import basic.pojo.Users;
import cms.article.pojo.CmsArticle;
import cms.article.service.IArticleService;
import cms.attachement.pojo.ArticleAttachment;
import cms.attachement.service.IArticleAttachmentService;
import cms.category.pojo.CmsCategory;
import cms.category.service.ICategoryService;
/**
 *  
 * 文章
 */
@SuppressWarnings("serial")
public class ActicleAction extends BaseAction {
	private IArticleService articleService;
	private IArticleAttachmentService articleAttachmentService;
	private ICategoryService categoryService;
	private String categoryName;
	private List<Map<String, Object>> articleList;
	private CmsArticle cmsArticle;
	private CmsCategory category;
	private String ids;
	private String id;
	private String categoryId;
	private String params;
	private String attUrls;
	private String attUrlsImg;
	// 修改审核状态使用的
	private String isPass;
	private String articleId;
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	/**
	 * 附件路径初始化 
	 * 
	 */
	public String gotoArticleInfoPage() throws Exception {
		if(!"1".equals(categoryId)){
		CmsCategory cmsCategory = (CmsCategory)categoryService.getObjectById(categoryId);
		categoryName = cmsCategory.getCategoryName();
		request.setAttribute("folderName", String.valueOf(getFileUrlConfig().get("cms")));
		request.setAttribute("doc_file_upload", String.valueOf(getFileUrlConfig().get("doc_file_upload")));
		request.setAttribute("img_file_upload", String.valueOf(getFileUrlConfig().get("img_file_upload")));
		request.setAttribute("zip_file_upload", String.valueOf(getFileUrlConfig().get("zip_file_upload")));
		}
		return SUCCESS;
	}
	/**
	 * 文章列表
	 * 
	 */
	public void listArticle() throws Exception {
		String hqlCount="";
		String sql="SELECT o.articleId AS articleId,o.categoryId AS categoryId,o.articleType AS articleType,o.title AS title, o.brief AS brief,o.content AS content,o.author AS author,o.imgUrl AS imgUrl,o.imgTrueName AS imgTrueName,"+
				" o.outUrl AS outUrl,o.seoTitle AS seoTitle,o.keywords AS keywords,o.clickCount AS clickCount, o.sortCode AS sortCode,o.isDeal AS isDeal,o.isEssence AS isEssence,o.isPass AS isPass,o.isOpenDiscuss AS isOpenDiscuss,"+
				" o.isShow AS isShow,o.createTime AS createTime,o.updateTime AS updateTime,o.publishUser AS publishUser, o.modifyUser AS modifyUser,o.customerId AS customerId,o.fpId AS fpId,o.spId AS spId,o.integral AS integral,o.topCount AS topCount,o.treadCount AS treadCount,c.categoryName AS categoryName "+
				" FROM cms_article o, cms_category c";
		if("1".equals(categoryId)){
			sql+=" where  1=1  AND o.categoryId=c.categoryId ";
			hqlCount=" where  1=1  ";
		}else{
			sql+=" where  1=1  AND o.categoryId=c.categoryId and o.categoryId="+categoryId;
			hqlCount=" where  1=1 and o.categoryId="+categoryId;
		}
		if (params != null && !"".equals(params)) {
			String[] strArr = params.split("_");
			if (!"none".equals(strArr[0])&&!"".equals(strArr[0].trim())) {
				sql += " and o.title like '%" + strArr[0].trim() + "%'";
				hqlCount+=" and o.title like '%" + strArr[0].trim() + "%'";
			}
			if (!"none".equals(strArr[1])) {
				sql += " and o.isShow=" + strArr[1];
				hqlCount +=" and o.isShow=" + strArr[1];
			}
		}
		int totalRecordCount = articleService.getCount(hqlCount);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		articleList = articleService.findListMapPageBySql(sql+" order by o.sortCode,o.articleId desc ", pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", articleList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 保存或修改文章
	 * 
	 */
	public void saveOrUpdateArticle() throws Exception {
		Users users = (Users) request.getSession().getAttribute("users");
	//把上面的三个操作放到同一个 service下进行管理
		if(cmsArticle.getArticleType().equals("0")){
			cmsArticle = (CmsArticle) articleService.saveOrUpdateArticleAndAtt(cmsArticle,"0",users);
		}
		if(cmsArticle.getArticleType().equals("1") ||cmsArticle.getArticleType().equals("2")){
			cmsArticle = (CmsArticle) articleService.saveOrUpdateArticleAndAtt(cmsArticle,attUrlsImg,users);
		}
		if(cmsArticle.getArticleType().equals("3") ||cmsArticle.getArticleType().equals("4")){
			cmsArticle = (CmsArticle) articleService.saveOrUpdateArticleAndAtt(cmsArticle,attUrls,users);
		}
		if (cmsArticle.getCategoryId() != null) {
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
	 * 得到文章对象和得到附件对象 
	 * 
	 */
	public void getArticleObject() throws Exception {
		cmsArticle = (CmsArticle) articleService.getObjectById(id);
		List<ArticleAttachment> attList = articleAttachmentService.getAttrByArticleId(id);
		// cmsArticle yu attList 是一对多的关系 
		Map<String,Object> jsonMap = new HashMap<String,Object>();
		jsonMap.put("cmsArticle", cmsArticle);
		jsonMap.put("attList", attList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 删除文章
	 */
	public void deleteArticle() throws Exception {
		Boolean isSuccess = articleService.deleteArticleAndAttByIds(ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 审核文章
	 * 
	 */
   public void updateIsPass() throws Exception{
	   cmsArticle = (CmsArticle) articleService.updateIsPass(articleId,isPass);
	   if (cmsArticle.getCategoryId() != null) {
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
   }
	public IArticleService getArticleService() {
		return articleService;
	}
	public void setArticleService(IArticleService articleService) {
		this.articleService = articleService;
	}
	public CmsArticle getCmsArticle() {
		return cmsArticle;
	}
	public void setCmsArticle(CmsArticle cmsArticle) {
		this.cmsArticle = cmsArticle;
	}
	public CmsCategory getCategory() {
		return category;
	}
	public void setCategory(CmsCategory category) {
		this.category = category;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
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
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public String getAttUrls() {
		return attUrls;
	}
	public void setAttUrls(String attUrls) {
		this.attUrls = attUrls;
	}
	public void setArticleAttachmentService(IArticleAttachmentService articleAttachmentService) {
		this.articleAttachmentService = articleAttachmentService;
	}
	public String getAttUrlsImg() {
		return attUrlsImg;
	}
	public void setAttUrlsImg(String attUrlsImg) {
		this.attUrlsImg = attUrlsImg;
	}
	public String getIsPass() {
		return isPass;
	}
	public void setIsPass(String isPass) {
		this.isPass = isPass;
	}
	public String getArticleId() {
		return articleId;
	}
	public void setArticleId(String articleId) {
		this.articleId = articleId;
	}
	public String getCategoryName() {
		return categoryName;
	}
	public void setCategoryName(String categoryName) {
		this.categoryName = categoryName;
	}
	public void setCategoryService(ICategoryService categoryService) {
		this.categoryService = categoryService;
	}
	public List<Map<String, Object>> getArticleList() {
		return articleList;
	}
	public void setArticleList(List<Map<String, Object>> articleList) {
		this.articleList = articleList;
	}
	
}
