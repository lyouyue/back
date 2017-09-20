package shop.store.action;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.store.service.IMemberShipService;
import util.action.BaseAction;
import util.other.JSONFormatDate;
import util.other.Utils;
/**
 * 店铺会员关系
 * @author jxw
 * 2014-10-13
 */
@SuppressWarnings("serial")
public class MemberShipAction extends BaseAction{
	/**店铺会员Service**/
	private IMemberShipService memberShipService;
	/**店铺会员集合**/
	private List<Map<String, Object>> memberShiplist;
	
	/**
	 * 跳转到店铺会员列表页
	 */
	public String gotoMemberShipPage(){
		return SUCCESS;
	}
	/**
	 * 查询所有店铺会员信息
	 * @throws IOException 
	 */
	public void listMemberShip() throws IOException{
		String shopName=request.getParameter("shopName");
		String selectFlag=request.getParameter("selectFlag");
		String state=request.getParameter("state");
		String hqlWhere="SELECT count(m.memberShipId)  FROM MemberShip m WHERE 1=1";
		String sql="SELECT m.loginName AS loginName,m.shopName AS shopName,m.discount AS discount,m.state AS state"+
		" FROM shop_membership m WHERE 1=1";
		if(Utils.objectIsNotEmpty(selectFlag)){
			if(Utils.objectIsNotEmpty(shopName)){
				sql+=" and m.shopName like '%"+shopName.trim()+"%'";
				hqlWhere+=" and m.shopName like '%"+shopName.trim()+"%'";
			}
			if(Utils.objectIsNotEmpty(state)){
				sql+=" and m.state="+state;
				hqlWhere+=" and m.state="+state;
			}
		}
		sql+=" order by m.memberShipId desc ";
		int totalRecordCount = memberShipService.getCountByHQL(hqlWhere);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		memberShiplist = memberShipService.findListMapPageBySql(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", memberShiplist);
		JsonConfig jsonConfig = new JsonConfig();
	    jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
		
	
	public void setMemberShipService(IMemberShipService memberShipService) {
		this.memberShipService = memberShipService;
	}
	public List<Map<String, Object>> getMemberShiplist() {
		return memberShiplist;
	}
	public void setMemberShiplist(List<Map<String, Object>> memberShiplist) {
		this.memberShiplist = memberShiplist;
	}	
}
