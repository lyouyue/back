package shop.product.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import shop.product.pojo.Brand;
import shop.product.pojo.ProductInfoQuestion;
import shop.product.service.IBrandService;
import shop.product.service.IProductInfoQuestionService;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;
import basic.pojo.Users;
/**
 * 品牌Action
 * 
 *
 */
@SuppressWarnings({ "serial", "unused" })
public class ProductInfoQuestionAction extends BaseAction {
	private IProductInfoQuestionService productInfoQuestionService;//品牌Servie
	private ProductInfoQuestion productInfoQuestion;
	private List<Map<String, Object>> productInfoQuestionList = new ArrayList<Map<String,Object>>();//品牌list
	private List<Brand> brandList = new ArrayList<Brand>();//品牌List
	private IBrandService brandService;//品牌Service
	/**店铺List**/
	private List<ShopInfo> shopInfoList = new ArrayList<ShopInfo>();
	/**店铺Service**/
	private IShopInfoService shopInfoService;
	private String ids;
	//跳转到套餐品牌列表页面
	public String gotoProductInfoQuestionPage(){
		//得到店铺Lis
		shopInfoList = shopInfoService.findObjects(null);
		//得到品牌Lis
		brandList = brandService.findObjects(null);
		return SUCCESS;
	}
	//查询所有信息列表
	public void listProductInfoQuestion() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		String sql="SELECT q.productInfoQuestionId as productInfoQuestionId,q.productId as productId,q.customerName AS customerName,q.productName AS productName, q.askType AS askType,DATE_FORMAT(q.askTime, '%Y-%m-%d %h:%m')AS askTime,q.answerName AS answerName,"+
						"q.shopStatus AS shopStatus,q.status AS status,s.shopName AS shopName FROM shop_productinfo_question q, shop_productinfo p,"+
						"shop_shopinfo s WHERE 1=1 AND q.productId=p.productId AND p.shopInfoId=s.shopInfoId";
		String countHql="SELECT COUNT(q.productInfoQuestionId) FROM ProductInfoQuestion q, ProductInfo p, ShopInfo s"+
				" WHERE 1=1 AND q.productId=p.productId AND p.shopInfoId=s.shopInfoId ";
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String beginTime = request.getParameter("beginTime");
			String endTime = request.getParameter("endTime");
			String customerName = request.getParameter("customerName");
			String status = request.getParameter("status");
			String askType = request.getParameter("askType");
			if(!"".equals(customerName)){
				sql+=" and q.customerName like '%"+customerName+"%'";
				countHql+=" and q.customerName like '%"+customerName+"%'";
			}
			if(!"-1".equals(askType)){
				sql+=" and q.askType = "+askType;
				countHql+=" and q.askType = "+askType;
			}
			if(!"-1".equals(status)){
				sql+=" and q.status ="+status;
				countHql+=" and q.status ="+status;
			}
			if(Utils.objectIsNotEmpty(beginTime)){
				sql+=" and q.askTime >= '"+beginTime+" 00:00:00'";
				countHql+=" and q.askTime >= '"+beginTime+" 00:00:00'";
			}
			if(Utils.objectIsNotEmpty(endTime)){
				sql+=" and q.askTime < '"+endTime+" 23:59:59'";
				countHql+=" and q.askTime < '"+endTime+" 23:59:59'";
			}
		}
		sql+=" order by q.productInfoQuestionId desc ";
		int totalRecordCount = productInfoQuestionService.getCountByHQL(countHql);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		productInfoQuestionList = productInfoQuestionService.findListMapPageBySql(sql, pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();
		jsonMap.put("total", totalRecordCount);
		jsonMap.put("rows", productInfoQuestionList);
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//保存或者修改
	public void saveOrUpdateProductInfoQuestion() throws IOException{
		if(productInfoQuestion!=null){
			Date date = new Date();
			Users users = (Users)session.getAttribute("users");
			productInfoQuestion.setAnswerId(users.getUsersId());
			productInfoQuestion.setUserId(users.getUsersId());
			productInfoQuestion.setAnswerName(users.getUserName());
			productInfoQuestion.setAnswerTime(date);
			productInfoQuestion.setUpdateTime(date);
			productInfoQuestion.setCheckTime(date);
			productInfoQuestion = (ProductInfoQuestion) productInfoQuestionService.saveOrUpdateObject(productInfoQuestion);
			if(productInfoQuestion.getProductInfoQuestionId()!=null){
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
	//获取一条记录
	public void getProductInfoQuestionInfo() throws IOException{
		productInfoQuestion = (ProductInfoQuestion) productInfoQuestionService.getObjectByParams(" where o.productInfoQuestionId='"+ids+"'");
		JsonConfig jsonConfig = new JsonConfig();
		jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
		JSONObject jo = JSONObject.fromObject(productInfoQuestion,jsonConfig);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除记录
	public void deleteProductInfoQuestion() throws IOException{
		Boolean isSuccess = productInfoQuestionService.deleteObjectsByIds("productInfoQuestionId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public ProductInfoQuestion getProductInfoQuestion() {
		return productInfoQuestion;
	}
	public void setProductInfoQuestion(ProductInfoQuestion productInfoQuestion) {
		this.productInfoQuestion = productInfoQuestion;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public void setProductInfoQuestionService(
			IProductInfoQuestionService productInfoQuestionService) {
		this.productInfoQuestionService = productInfoQuestionService;
	}
	public List<Brand> getBrandList() {
		return brandList;
	}
	public void setBrandList(List<Brand> brandList) {
		this.brandList = brandList;
	}
	public List<ShopInfo> getShopInfoList() {
		return shopInfoList;
	}
	public void setShopInfoList(List<ShopInfo> shopInfoList) {
		this.shopInfoList = shopInfoList;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}
	public void setShopInfoService(IShopInfoService shopInfoService) {
		this.shopInfoService = shopInfoService;
	}
	public List<Map<String, Object>> getProductInfoQuestionList() {
		return productInfoQuestionList;
	}
	public void setProductInfoQuestionList(
			List<Map<String, Object>> productInfoQuestionList) {
		this.productInfoQuestionList = productInfoQuestionList;
	}

}
