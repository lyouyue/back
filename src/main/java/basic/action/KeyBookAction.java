package basic.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.other.CreateWhereSQLForSelect;
import basic.pojo.KeyBook;
import basic.service.IKeyBookService;
import cms.article.pojo.CmsArticle;
import cms.article.service.IArticleService;
import cms.category.pojo.CmsCategory;
import cms.category.service.ICategoryService;

import com.opensymphony.xwork2.ActionContext;
/**
 * 数据字典Action类
 * 
 *
 */
@SuppressWarnings({"serial","rawtypes"})
public class KeyBookAction extends BaseAction{
	private IKeyBookService keyBookService;
	private KeyBook keyBook;
	private List<KeyBook> keyBookList = new ArrayList<KeyBook>();
	private String keyBookId;
	private String ids;
	/** 底部文章集合 **/
	private IArticleService articleService;//引用文章Service
	private ICategoryService categoryService;//引用文章分类Service
	private Map categoryMap = new LinkedHashMap();//套餐分类
	private Map categoryBrandMap = new LinkedHashMap();//套餐分类下的品牌
	private Integer value;
	private String onOrOff;
	//跳转到数据字典列表页面
	public String gotoKeyBookPage(){
		return SUCCESS;
	}
	//跳转到支付方式管理列表页面
	public String gotoPayManagementPage(){
		return SUCCESS;
	}
	public String gotoPayTypePage(){
		return SUCCESS;
	}
	//查询所有信息列表
	public void listKeyBook() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String name = request.getParameter("name");
			String typeName = request.getParameter("typeName");
			StringBuffer sb = CreateWhereSQLForSelect.appendLike(null, null, null);
			if(name!=null&&!"".equals(name.trim())){
				sb.append(CreateWhereSQLForSelect.appendLike("name","like",name.trim()));
			}
			if(typeName!=null&&!"".equals(typeName.trim())){
				sb.append(CreateWhereSQLForSelect.appendLike("typeName","like",typeName.trim()));
			}
			if(!"".equals(sb.toString()) && sb != null){
				hqlsb=CreateWhereSQLForSelect.createSQL(sb);
			}
		}
		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" keyBookId desc"));
		int totalRecordCount = keyBookService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String [] selectColumns={"keyBookId","value","name","type","typeName"};
		keyBookList = keyBookService.findListByPageHelper(selectColumns,pageHelper, hqlsb.toString());
		//keyBookList = keyBookService.findListByPageHelper(null,pageHelper, " order by o.keyBookId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", keyBookList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//查询支付方式管理列表
	public void listPayManagement() throws IOException{
		//String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		//if("true".equals(selectFlag)){//判断是否点击查询按钮
		String name = request.getParameter("name");
		String typeName = request.getParameter("typeName");
		StringBuffer sb = CreateWhereSQLForSelect.appendLike(null, null, null);
		if(name!=null&&!"".equals(name.trim())){
			sb.append(CreateWhereSQLForSelect.appendLike("name","like",name.trim()));
		}
		if(typeName!=null&&!"".equals(typeName.trim())){
			sb.append(CreateWhereSQLForSelect.appendLike("typeName","like",typeName.trim()));
		}
		sb.append(CreateWhereSQLForSelect.appendEqual("type", "payMethod"));//只查类型为支付方式的数据
		hqlsb=CreateWhereSQLForSelect.createSQL(sb);
		//}
		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" keyBookId desc"));
		int totalRecordCount = keyBookService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String [] selectColumns={"keyBookId","value","name","type","typeName"};
		keyBookList = keyBookService.findListByPageHelper(selectColumns,pageHelper, hqlsb.toString());
		//keyBookList = keyBookService.findListByPageHelper(null,pageHelper, " order by o.keyBookId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", keyBookList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//查询支付方式信息列表
	public void listPayType() throws IOException{
		List<KeyBook> keyBookList = keyBookService.findObjects(" where o.type = 'commConfig'");//根据类型名称查出对象集合
		String type = keyBookList.get(0).getValue();
		String[] types = type.split(",");
		String str = "";
		for(String s:types){
			str += "'"+s+"',";
		}
		str = str.substring(0, str.length()-1);
		int totalRecordCount = keyBookService.getCount(" where o.type in ("+str+")");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String [] selectColumns={"keyBookId","value","name","type","typeName"};
		keyBookList = keyBookService.findListByPageHelper(selectColumns,pageHelper, " where o.type in ("+str+") order by o.keyBookId");
		//keyBookList = keyBookService.findListByPageHelper(null,pageHelper, " order by o.keyBookId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", keyBookList);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateKeyBook() throws IOException{
		if(keyBook!=null){
			keyBook = (KeyBook) keyBookService.saveOrUpdateObject(keyBook);
			if(keyBook.getKeyBookId()!=null){
				JSONObject jo = new JSONObject();
				jo.accumulate("isSuccess", "true");
				response.setContentType("text/html;charset=utf-8");
				PrintWriter out = response.getWriter();
				out.println(jo.toString());
				out.flush();
				out.close();
			}
		}
	}
	//修改支付方式显示状态
	public void updatePayType() throws IOException{
		String sql = "UPDATE basic_keybook SET value="+value+" WHERE keyBookId in ("+ids+")";
		keyBookService.updateObject(sql);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", "true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * @功能：修改支付方式开启/关闭状态
	 * @作者:  cyy
	 * @参数： @throws IOException
	 * @返回值：void
	 * @日期: 2016年3月31日 下午1:23:43
	 */
	public void updatePayMethodById() throws IOException{
		boolean isSuccess=false;
		String sql = "UPDATE basic_keybook SET value='"+onOrOff+"' WHERE keyBookId ='"+keyBookId+"'";
		isSuccess=keyBookService.updateObject(sql);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess",isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//获取一条记录
	public void getKeyBookInfo() throws IOException{
		keyBook = (KeyBook) keyBookService.getObjectByParams(" where o.keyBookId='"+keyBookId+"'");
		JSONObject jo = JSONObject.fromObject(keyBook);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteKeyBook() throws IOException{
		Boolean isSuccess = keyBookService.deleteObjectsByIds("keyBookId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//更新初始化数据字典
	public void updateInServletContextKeyBook() throws IOException{
		Map<String, Object> servletContext = ActionContext.getContext().getApplication();
		Boolean isSuccess = false;//返回值，是否更新成功，默认是否
		if (servletContext != null) {
			Map<String,List<KeyBook>> map = new HashMap<String,List<KeyBook>>();
			List<String> typeNameList = keyBookService.distinctType("type", "");//查找类型名称
			for(String typeName : typeNameList){
				List<KeyBook> keyBookList = keyBookService.findObjects(" where o.type = '"+typeName+"' order by o.value ");//根据类型名称查出对象集合
				map.put(typeName, keyBookList);
			}
			servletContext.put("keybook", map);
			//全局底部文章加载
			servletContext.put("footrtArticleMap", findFooterArticle());
			isSuccess = true;
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	
	/**
	 * 全局底部文章加载
	 */
	public Map<String,List<CmsArticle>> findFooterArticle(){
		Map<String,List<CmsArticle>> footrtArticleMap = new LinkedHashMap<String,List<CmsArticle>>();
		List<CmsCategory>  cmsCategoryList = categoryService.findObjects(" where o.parentId = 92 ");
		for(CmsCategory cmsCategory : cmsCategoryList){
			List<CmsArticle> cmsArticlesList = articleService.findObjects("where o.isShow = 1 and o.categoryId = "+cmsCategory.getCategoryId());
			String str = cmsCategory.getCategoryName();
			footrtArticleMap.put(str, cmsArticlesList);
		}
		return footrtArticleMap;
	}
	public KeyBook getKeyBook() {
		return keyBook;
	}
	public void setKeyBook(KeyBook keyBook) {
		this.keyBook = keyBook;
	}
	public List<KeyBook> getKeyBookList() {
		return keyBookList;
	}
	public void setKeyBookList(List<KeyBook> keyBookList) {
		this.keyBookList = keyBookList;
	}
	public String getKeyBookId() {
		return keyBookId;
	}
	public void setKeyBookId(String keyBookId) {
		this.keyBookId = keyBookId;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setKeyBookService(IKeyBookService keyBookService) {
		this.keyBookService = keyBookService;
	}
	public void setArticleService(IArticleService articleService) {
		this.articleService = articleService;
	}
	public void setCategoryService(ICategoryService categoryService) {
		this.categoryService = categoryService;
	}
	
	public Map getCategoryMap() {
		return categoryMap;
	}
	
	public void setCategoryMap(Map categoryMap) {
		this.categoryMap = categoryMap;
	}
	
	public Map getCategoryBrandMap() {
		return categoryBrandMap;
	}
	
	public void setCategoryBrandMap(Map categoryBrandMap) {
		this.categoryBrandMap = categoryBrandMap;
	}
	public Integer getValue() {
		return value;
	}
	public void setValue(Integer value) {
		this.value = value;
	}
	public String getOnOrOff() {
		return onOrOff;
	}
	public void setOnOrOff(String onOrOff) {
		this.onOrOff = onOrOff;
	}
	
}
