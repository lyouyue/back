package cms.information.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.Utils;
import basic.pojo.Users;
import cms.information.pojo.CmsInformation;
import cms.information.service.ICmsInformationCategoryService;
import cms.information.service.ICmsInformationService;
/**
 * ActicleAction 信息Action实体类
 */
@SuppressWarnings("serial")
public class CmsInformationAction extends BaseAction {
	/**信息Service**/
	private ICmsInformationService cmsInformationService;
	/**信息分类Service**/
	private ICmsInformationCategoryService cmsInformationCategoryService;
	/**信息集合**/
	private List<Map<String, Object>> cmsInformationList=new ArrayList<Map<String, Object>>();
	/**信息实体类**/
	private CmsInformation cmsInformation;
	private String ids;
	/**信息分类id*/
	private String categoryId;
	/**信息id*/
	private String informationId;

	public String gotoCmsInformationPage(){
		//查询出所有信息分类
		List<Map<String, Object>> cmsInformationCategoryList=cmsInformationCategoryService.findListMapBySql("select * from cms_information_category where isLeaf=1");
		if(Utils.objectIsNotEmpty(cmsInformationCategoryList)){
			request.setAttribute("cmsInformationCategoryList", cmsInformationCategoryList);
		}

		return SUCCESS;
	}
	/**
	 * 信息列表
	 */
	public void listCmsInformation() throws Exception {
		String isShow = request.getParameter("isShow");
		String title = request.getParameter("title");
		String sqlCount = "select count(a.informationId) as count from cms_information a,cms_information_category b where a.categoryId = b.informationCategoryId";
		String sql = "select b.categoryName as categoryName,a.informationType as informationType,a.informationId as informationId,a.title as title,a.isShow as isShow,a.publishUser as publishUser,a.createTime as createTime,a.updateTime as updateTime from cms_information a,cms_information_category b where a.categoryId = b.informationCategoryId";
		if(Utils.stringIsNotEmpty(title)){
			sqlCount += " and a.title like '%"+title.trim()+"%'";
			sql += " and a.title like '%"+title.trim()+"%'";
		}
		if(Utils.stringIsNotEmpty(isShow)&&!"-1".equals(isShow)){
			sqlCount += " and a.isShow = "+isShow;
			sql += " and a.isShow = "+isShow;
		}
		if(Utils.stringIsNotEmpty(categoryId)&&!"-1".equals(categoryId)){
			sqlCount += " and a.categoryId = "+categoryId;
			sql += " and a.categoryId = "+categoryId;
		}
	        sql +=" order by a.updateTime desc";
		int totalRecordCount = Integer.parseInt(String.valueOf(cmsInformationService.findListMapBySql(sqlCount).get(0).get("count")));
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		cmsInformationList = cmsInformationService.findListMapPageBySql(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", cmsInformationList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);//格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 添加或者修改
	 */
	public void saveOrUpdateCmsInformation() throws Exception{
		if(cmsInformation!=null){
			Users user = (Users) session.getAttribute("users");
			SimpleDateFormat formatter = new SimpleDateFormat( EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
			String dateString = formatter.format(new Date());
			if(cmsInformation.getInformationId()==null||"".equals(cmsInformation.getInformationId())){
				//添加
				cmsInformation.setCreateTime(dateString);
				cmsInformation.setPublishUser(user.getUserName());
			}
			//修改
			cmsInformation.setUpdateTime(dateString);
			cmsInformation.setModifyUser(user.getUserName());
			cmsInformationService.saveOrUpdateObject(cmsInformation);
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
	 * 得到信息对象
	 * @throws IOException
	 *
	 */
	/*public void getInformationObject() throws Exception {
		String sqlCount = "select count(*) as count from back_information a,back_information_category b where a.categoryId = b.informationCategoryId";
		String sql = "select * from back_information a,back_information_category b where a.categoryId = b.informationCategoryId";
		if(Utils.stringIsNotEmpty(informationId)){
			sqlCount += " and a.informationId='"+informationId+"'";
			sql += " and a.informationId= '"+informationId+"'";
		}
		int totalRecordCount = Integer.parseInt(String.valueOf(informationService.findListMapBySql(sqlCount).get(0).get("count")));
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		informationList = informationService.findListMapPageBySql(sql, pageHelper);
		JSONObject jo = JSONObject.fromObject(informationList.get(0));// 格式化result
		if(informationList.size()==1){
			City city=(City) cityService.getObjectByParams(" where o.cityName='"+informationList.get(0).get("cityName")+"'");
			if(Utils.objectIsNotEmpty(city)){
				if(Utils.stringIsNotEmpty(String.valueOf(city.getCityId()))){
					List<Map<String, Object>> districtList=districtService.findListMapBySql("select c.cityId as cityId ,d.districtName as districtName ,c.cityDistrictId as cityDistrictId  from back_citydistrict c, back_district d where c.districtId=d.districtId and c.cityId="+city.getCityId());
					if(Utils.objectIsNotEmpty(districtList)){
						jo.accumulate("districtList", districtList);
					}
				}
			}
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}*/
	public void getCmsInformationObject() throws IOException{
		//自定义sql语句
		String sql="SELECT a.informationId as informationId,a.categoryId as categoryId,a.title as title, a.brief as brief,a.content as content,a.imgUrl as imgUrl,a.isShow as isShow,a.createTime as createTime,a.updateTime as updateTime,a.publishUser as publishUser,a.modifyUser as modifyUser,b.categoryName as categoryName FROM cms_information a,cms_information_category b WHERE a.categoryId=b.informationCategoryId AND a.informationId="+informationId;
		//通过sql查询出结果
		List<Map<String,Object>> c=  cmsInformationService.findListMapBySql(sql);
		if(Utils.collectionIsNotEmpty(c)){//判断集合不为空
		JSONObject jo = JSONObject.fromObject(c.get(0));
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		}
	}
	/**
	 * 删除信息
	 */
	public void deleteCmsInformation() throws Exception {
		Boolean isSuccess = cmsInformationService.deleteObjectsByIds("informationId", ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public List<Map<String, Object>> getCmsInformationList() {
		return cmsInformationList;
	}
	public void setCmsInformationList(List<Map<String, Object>> cmsInformationList) {
		this.cmsInformationList = cmsInformationList;
	}
	public CmsInformation getCmsInformation() {
		return cmsInformation;
	}
	public void setCmsInformation(CmsInformation cmsInformation) {
		this.cmsInformation = cmsInformation;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getCategoryId() {
		return categoryId;
	}
	public void setCategoryId(String categoryId) {
		this.categoryId = categoryId;
	}
	public String getInformationId() {
		return informationId;
	}
	public void setInformationId(String informationId) {
		this.informationId = informationId;
	}
	public void setCmsInformationService(
			ICmsInformationService cmsInformationService) {
		this.cmsInformationService = cmsInformationService;
	}
	public void setCmsInformationCategoryService(
			ICmsInformationCategoryService cmsInformationCategoryService) {
		this.cmsInformationCategoryService = cmsInformationCategoryService;
	}

}
