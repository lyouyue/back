package discountcoupon.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.CreateWhereSQLForSelect;
import util.other.JSONFormatDate;
import util.other.Utils;
import discountcoupon.service.ICustomerdiscountcouponService;
/**
 * CustomerdiscountcouponAction - 会员优惠券Action
 */
public class CustomerdiscountcouponAction extends BaseAction{
	/**
	 *
	 */
	private static final long serialVersionUID = 2183823473589355661L;

	private ICustomerdiscountcouponService customerdiscountcouponService;
	private List<Map> customerdiscountcouponlist;
	private String ids;
	private String useStatus;
	private String ispass;
	private List<Map<String, Object>>  mapList = new  ArrayList<Map<String, Object>>();
	/**
	 * 跳转到会员优惠券列表页
	 */
	public String gotoCustomerdiscount(){
		return SUCCESS;
	}
	//查询所有会员优惠券
	public void selcetCustomerdiscount() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
//		StringBuffer hqlsb = new StringBuffer();
		String hql="select o.customerDiscountCouponID as customerDiscountCouponID,"
				+ " o.discountCouponID as discountCouponID,"
				+ " o.customerId as customerId,"
				+ " o.discountCouponCode as discountCouponCode,"
				+ " o.discountCouponName as discountCouponName,"
				+ " o.discountCouponAmount as discountCouponAmount,"
				+ " o.discountCouponLowAmount as discountCouponLowAmount,"
				+ " o.beginTime as beginTime,"
				+ " o.expirationTime as expirationTime,"
				+ " o.useStatus as useStatus,"
				+ " o.status as status,"
				+ " o.createTime as createTime,"
				+ " c.loginName as loginName,"
				+ " o.updateTime as updateTime,"
				+ " o.discountImage as discountImage from Customerdiscountcoupon o,Customer c where o.customerId = c.customerId ";
		String hsql = "select count(*) from Customerdiscountcoupon o,Customer c where o.customerId = c.customerId ";
		if("true".equals(selectFlag)){//判断是否点击查询按钮

			String discountCouponAmount = request.getParameter("discountCouponAmount");
			String beginTime = request.getParameter("beginTime");
			String qdiscountCouponName = request.getParameter("qdiscountCouponName");
			String qdiscountCouponCode = request.getParameter("qdiscountCouponCode");
			String expirationTime = request.getParameter("expirationTime");
			String qloginName = request.getParameter("qloginName");
			String createTime = request.getParameter("createTime");
			StringBuffer sb = CreateWhereSQLForSelect.appendLike(null, null, null);
			if(Utils.objectIsNotEmpty(qloginName)){
//				sb.append(CreateWhereSQLForSelect.appendLike("discountCouponAmount","like",discountCouponAmount));
				hql=hql+" and c.loginName like '%"+qloginName+"%'";
				hsql=hsql+" and c.loginName like '%"+qloginName+"%'";
			}
			if(Utils.objectIsNotEmpty(qdiscountCouponCode)){
//				sb.append(CreateWhereSQLForSelect.appendLike("discountCouponAmount","like",discountCouponAmount));
				hql=hql+" and o.discountCouponCode like '%"+qdiscountCouponCode+"%'";
				hsql=hsql+" and o.discountCouponCode like '%"+qdiscountCouponCode+"%'";
			}
			if(Utils.objectIsNotEmpty(qdiscountCouponName)){
//				sb.append(CreateWhereSQLForSelect.appendLike("discountCouponAmount","like",discountCouponAmount));
				hql=hql+" and o.discountCouponName like '%"+qdiscountCouponName+"%'";
				hsql=hsql+" and o.discountCouponName like '%"+qdiscountCouponName+"%'";
			}
			if(discountCouponAmount!=null&&!"".equals(discountCouponAmount)){
//				sb.append(CreateWhereSQLForSelect.appendLike("discountCouponAmount","like",discountCouponAmount));
				hql=hql+" and o.discountCouponAmount like '%"+discountCouponAmount+"%'";
				hsql=hsql+" and o.discountCouponAmount like '%"+discountCouponAmount+"%'";
			}
			if(useStatus!=null&&!"".equals(useStatus)){
				hql=hql+" and o.useStatus like '%"+useStatus+"%'";
				hsql=hsql+" and o.useStatus like '%"+useStatus+"%'";
//				sb.append(CreateWhereSQLForSelect.appendLike("useStatus","like",useStatus));
			}
			if(ispass!=null&&!"".equals(ispass)){
//				sb.append(CreateWhereSQLForSelect.appendLike("isPass","like",ispass));
				hql=hql+" and o.isPass like '%"+ispass+"%'";
				hsql=hsql+" and o.isPass like '%"+ispass+"%'";
			}
			if(beginTime!=null&&!"".equals(beginTime)){
//				sb.append(CreateWhereSQLForSelect.appendLike("beginTime","like",beginTime));
				hql=hql+" and o.beginTime like '%"+beginTime+"%'";
				hsql=hsql+" and o.beginTime like '%"+beginTime+"%'";
			}
			if(expirationTime!=null&&!"".equals(expirationTime)){
//				sb.append(CreateWhereSQLForSelect.appendLike("expirationTime","like",expirationTime));
				hql=hql+" and o.expirationTime like '%"+expirationTime+"%'";
				hsql=hsql+" and o.expirationTime like '%"+expirationTime+"%'";
			}
			if(createTime!=null&&!"".equals(createTime)){
//				sb.append(CreateWhereSQLForSelect.appendLike("createTime","like",createTime));
				hql=hql+" and o.createTime like '%"+createTime+"%'";
				hsql=hsql+" and o.createTime like '%"+createTime+"%'";
			}
		}
//		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" customerDiscountCouponID desc"));
		hql=hql+" order by  customerDiscountCouponID desc";
		hsql=hsql+" order by  customerDiscountCouponID desc";
		int totalRecordCount = customerdiscountcouponService.getCountByHQL(hsql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		customerdiscountcouponlist = customerdiscountcouponService.findListMapPage(hql, pageHelper);
		if(customerdiscountcouponlist!=null&&customerdiscountcouponlist.size()>0){
			   for(Map m:customerdiscountcouponlist){
			    SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
			    String time = fm.format(m.get("beginTime"));
			    String times = fm.format(m.get("expirationTime"));
			    String timess = fm.format(m.get("createTime"));
			    m.put("beginTime", time);
			    m.put("expirationTime", times);
			    m.put("createTime", timess);
			   }
			  }
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", customerdiscountcouponlist);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//统计查询
	public void selectCouponAmount() throws IOException{
		String sql="select SUM(discountCouponAmount) as unusedCouponAmount from shop_customer_discountcoupon";
		String sqls="select SUM(discountCouponAmount) as useCouponAmount from shop_customer_discountcoupon where useStatus=1";
		mapList = customerdiscountcouponService.findListMapBySql(sql);
		String unusedCouponAmount =String.valueOf(mapList.get(0).get("unusedCouponAmount"));
		mapList = customerdiscountcouponService.findListMapBySql(sqls);
		String useCouponAmount =  String.valueOf(mapList.get(0).get("useCouponAmount"));
		JSONObject jo = new JSONObject();
		  jo.accumulate("unusedCouponAmount", unusedCouponAmount);
		  jo.accumulate("useCouponAmount", useCouponAmount);
		  response.setContentType("text/html;charset=utf-8");
		  PrintWriter out = response.getWriter();
		  out.println(jo.toString());
		  out.flush();
		  out.close();
	}
	//批量删除
	public void deletePromotionApply() throws IOException{
		Boolean isSuccess = customerdiscountcouponService.deleteObjectsByIds("customerDiscountCouponID",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
		}

	public void setCustomerdiscountcouponService(
			ICustomerdiscountcouponService customerdiscountcouponService) {
		this.customerdiscountcouponService = customerdiscountcouponService;
	}
//	public List<Customerdiscountcoupon> getCustomerdiscountcouponlist() {
//		return customerdiscountcouponlist;
//	}
//	public void setCustomerdiscountcouponlist(
//			List<Customerdiscountcoupon> customerdiscountcouponlist) {
//		this.customerdiscountcouponlist = customerdiscountcouponlist;
//	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getUseStatus() {
		return useStatus;
	}
	public void setUseStatus(String useStatus) {
		this.useStatus = useStatus;
	}
	public String getIspass() {
		return ispass;
	}
	public void setIspass(String ispass) {
		this.ispass = ispass;
	}
	public List<Map> getCustomerdiscountcouponlist() {
		return customerdiscountcouponlist;
	}
	public void setCustomerdiscountcouponlist(List<Map> customerdiscountcouponlist) {
		this.customerdiscountcouponlist = customerdiscountcouponlist;
	}
	public List<Map<String, Object>> getMapList() {
		return mapList;
	}
	public void setMapList(List<Map<String, Object>> mapList) {
		this.mapList = mapList;
	}
}
