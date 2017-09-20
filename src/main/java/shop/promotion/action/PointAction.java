package shop.promotion.action;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.promotion.pojo.Point;
import promotion.pojo.Promotion;
import shop.promotion.service.IPointService;
import promotion.service.IPromotionService;
import util.action.BaseAction;
import util.other.CreateWhereSQLForSelect;
import util.other.JSONFormatDate;
/**
 * 金币政策Action类
 * 
 *
 */
@SuppressWarnings("serial")
public class PointAction extends BaseAction {
	private IPointService pointService;//金币政策Service
	private IPromotionService promotionService;//促销活动Service
	private Point point;
	private List<Point> pointList = new ArrayList<Point>();//金币政策List
	private String ids;
	private String pointId;
	private List<Promotion> promotionList = new ArrayList<Promotion>();//促销活动List
	private String params;
	//跳转到金币政策列表页面
	public String gotoPointPage() throws Exception {
		promotionList = promotionService.findObjects(null);
		return SUCCESS;
	}
	//保存或者修改促销活动金币政策
	public void saveOrUpdatePoint() throws Exception {
		if(point!=null){
			point=(Point)pointService.saveOrUpdateObject(point);
		}
		if(point.getPointId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//得到一条记录
	public void getPointObject() throws Exception {
		point = (Point) pointService.getObjectById(pointId);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(point,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除金币政策信息
	public void deletePoint() throws Exception {
		Boolean isSuccess = pointService.deleteObjectsByIds("pointId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//查询促销活动金币政策
	public void listPoint() throws Exception {
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			if(!"-1".equals(request.getParameter("promotionId"))){
				StringBuffer sb=CreateWhereSQLForSelect.appendEqual("promotionId",request.getParameter("promotionId"));
				hqlsb=CreateWhereSQLForSelect.createSQL(sb);
			}
		}
		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" promotionId desc"));
		int totalRecordCount = pointService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		pointList = pointService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", pointList);// rows键 存放每页记录 list
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public Point getPoint() {
		return point;
	}
	public void setPoint(Point point) {
		this.point = point;
	}
	public List<Point> getPointList() {
		return pointList;
	}
	public void setPointList(List<Point> pointList) {
		this.pointList = pointList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getPointId() {
		return pointId;
	}
	public void setPointId(String pointId) {
		this.pointId = pointId;
	}
	public List<Promotion> getPromotionList() {
		return promotionList;
	}
	public void setPromotionList(List<Promotion> promotionList) {
		this.promotionList = promotionList;
	}
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
	public void setPointService(IPointService pointService) {
		this.pointService = pointService;
	}
	public void setPromotionService(IPromotionService promotionService) {
		this.promotionService = promotionService;
	}
}
