package phone.back.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import basic.pojo.Users;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import phone.back.pojo.PhoneHomeCategoryInfo;
import phone.back.service.IPhoneHomeCategoryInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;

/**
 * 积分商城轮播图Action
 * 
 *
 */
@SuppressWarnings("serial")
public class PhoneIntegralAction extends BaseAction {
	/**分类信息service**/
	private IPhoneHomeCategoryInfoService phoneHomeCategoryInfoService;
	/**分类信息实体类**/
	private PhoneHomeCategoryInfo phoneHomeCategoryInfo=new PhoneHomeCategoryInfo();
	/**轮播图信息ID**/
	private String id;
	private String ids;

	/**
	 * 跳转到积分商城轮播图列表页
	 */
	public String gotoPhoneIntegralPage(){
		return SUCCESS;
	}

	/**
	 * 轮播图列表页面
	 */
	public void listPhoneIntegral()throws IOException{
		//获取查询参数
		String title = request.getParameter("title");
		String isShow = request.getParameter("isShow");
		String where=" where 1=1";
		if(title!=null&&!"".equals(title)){
			where+=" and o.title like '%"+title+"%'";
		}
		if(isShow!=null&&!"".equals(isShow)){
			where+=" and o.isShow = "+isShow;
		}
		Integer totalRecordCount=phoneHomeCategoryInfoService.getCount(where+" and o.categoryId=0");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		List<PhoneHomeCategoryInfo> list = phoneHomeCategoryInfoService.findListByPageHelper(null, pageHelper, where+" and o.categoryId=0 order by o.categoryInfoId desc");
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", list);
		JSONObject jo = JSONObject.fromObject(jsonMap);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 保存
	 * @throws IOException
	 */
	public void saveOrUpdatePhoneIntegral()throws IOException{
		//当前登录对象
		Users users = (Users) session.getAttribute("users");
		Object o=null;
		if(phoneHomeCategoryInfo!=null){
			if(phoneHomeCategoryInfo.getCategoryInfoId()==null){//添加
				//创建人 、创建时间
				phoneHomeCategoryInfo.setCreateTime(new Date());
				phoneHomeCategoryInfo.setPublishUser(users.getUserName());
			}
			phoneHomeCategoryInfo.setCategoryId(0);
			//修改人、修改时间
			phoneHomeCategoryInfo.setUpdateTime(new Date());
			phoneHomeCategoryInfo.setModifyUser(users.getUserName());
			o = phoneHomeCategoryInfoService.saveOrUpdateObject(phoneHomeCategoryInfo);
		}
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
	public void getPhoneIntegralObject()throws IOException{
		PhoneHomeCategoryInfo smcb = (PhoneHomeCategoryInfo) phoneHomeCategoryInfoService.getObjectByParams(" where o.categoryInfoId="+id);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(smcb,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	/**
	 * 删除分类
	 */
	public void deletePhoneIntegralByIds()throws IOException{
		boolean bool = phoneHomeCategoryInfoService.deleteObjectsByIds("categoryInfoId", ids);
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

	public PhoneHomeCategoryInfo getPhoneHomeCategoryInfo() {
		return phoneHomeCategoryInfo;
	}
	public void setPhoneHomeCategoryInfo(PhoneHomeCategoryInfo phoneHomeCategoryInfo) {
		this.phoneHomeCategoryInfo = phoneHomeCategoryInfo;
	}
	public void setPhoneHomeCategoryInfoService(
			IPhoneHomeCategoryInfoService phoneHomeCategoryInfoService) {
		this.phoneHomeCategoryInfoService = phoneHomeCategoryInfoService;
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
}
