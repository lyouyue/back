package promotion.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONObject;
import shop.product.pojo.ProductInfo;
import promotion.pojo.StoreApplyPromotion;
import promotion.service.IStoreApplyPromotionService;
import util.action.BaseAction;
import util.other.CreateWhereSQLForSelect;
import util.other.Utils;
/** 
* DisproductAction - 店铺申请促销活动Action类
* ============================================================================ 
* 版权所有 2010-2013 XXXX软件有限公司，并保留所有权利。 
* 官方网站：http://www.shopjsp.com
* ============================================================================ 
* ,孟琦瑞
*/ 
@SuppressWarnings("serial")
public class DisproductAction extends BaseAction {
	private IStoreApplyPromotionService storeApplyPromotionService;//店铺申请促销活动Service
	private StoreApplyPromotion storeApplyPromotion;//店铺申请促销互动对象
	private List<StoreApplyPromotion> storeApplyPromotionList = new ArrayList<StoreApplyPromotion>();//店铺申请促销活动List
	private String ids;
	private String id;
	private String promotionId;
	private String productName;
	private String flag;
	private String sortValue;//排序的值
	private List<ProductInfo> productInfoList = new ArrayList<ProductInfo>();//套餐信息List
	//根据促销活动ID跳转到此活动套餐列表页
	public String gotoProductListByPromotionIdPage(){
		request.setAttribute("promotionId", promotionId);
		return SUCCESS;
	}
	//根据促销活动ID查询参加此活动的套餐
	public void findProductListByPromotionId() throws IOException{
		String selectFlag=request.getParameter("selectFlag");
		StringBuffer hqlsb = new StringBuffer();
		if("true".equals(selectFlag)){//判断是否点击查询按钮
			String shopName = request.getParameter("shopName");
			String promotionState = request.getParameter("promotionState");
			StringBuffer sb = CreateWhereSQLForSelect.appendLike(null, null, null);
			if(shopName!=null&&!"".equals(shopName)){
				sb.append(CreateWhereSQLForSelect.appendLike("shopName","like",request.getParameter("shopName")));
			}
			if(!"-1".equals(promotionState)){
				sb.append(CreateWhereSQLForSelect.appendLike("promotionState","like",request.getParameter("promotionState")));
			}else{
				hqlsb.append("where 1=1");
			}
			if(!"".equals(sb.toString()) && sb != null){
				hqlsb=CreateWhereSQLForSelect.createSQL(sb);
			}
			hqlsb.append("and o.promotionId="+promotionId);
		}else{
			hqlsb.append("where o.promotionId="+promotionId);
		}
		hqlsb.append(CreateWhereSQLForSelect.appendOrderBy(" sort desc"));
		int totalRecordCount = storeApplyPromotionService.getCount(hqlsb.toString());
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		storeApplyPromotionList = storeApplyPromotionService.findListByPageHelper(null,pageHelper, hqlsb.toString());
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", storeApplyPromotionList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//通过或拒绝
	public void approveOrReject() throws IOException{
		storeApplyPromotion =(StoreApplyPromotion) storeApplyPromotionService.getObjectById(promotionId);
		List<Map>noHasProductList=null;
		JSONObject jo = new JSONObject();
		if(Utils.objectIsNotEmpty(storeApplyPromotion.getProductId())&&"1".equals(flag)){
			//查找是否其他活动中是否有当前活动套餐
			String hql2="SELECT f.productId from StoreApplyPromotion f,PlatformPromotion plat where f.promotionId=plat.promotionId AND plat.useStatus!=2  and f.promotionState in (0,1,3) AND f.productId="+storeApplyPromotion.getProductId();
			noHasProductList=storeApplyPromotionService.findListMapPage(hql2, pageHelper);
		}
		if(!Utils.collectionIsNotEmpty(noHasProductList)){
			if("1".equals(flag)){
				storeApplyPromotion.setPromotionState(1);
			}else{
				storeApplyPromotion.setPromotionState(2);
			}
			storeApplyPromotionService.saveOrUpdateObject(storeApplyPromotion);
			jo.accumulate("isSuccess","true");
		}else{
			jo.accumulate("isSuccess","false");
		}
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//批量(通过或拒绝)操作
	public void batch() throws IOException{
		String[] aids = ids.split(",");
		if("1".equals(flag)){
			for(String id:aids){
				storeApplyPromotion =(StoreApplyPromotion) storeApplyPromotionService.getObjectById(id);
				storeApplyPromotion.setPromotionState(1);
				storeApplyPromotionService.saveOrUpdateObject(storeApplyPromotion);
			}
		}else{
			for(String id:aids){
				storeApplyPromotion =(StoreApplyPromotion) storeApplyPromotionService.getObjectById(id);
				storeApplyPromotion.setPromotionState(2);
				storeApplyPromotionService.saveOrUpdateObject(storeApplyPromotion);
			}
		}
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess","true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除
	public void deleteDisproduct() throws IOException{
		Boolean isSuccess = storeApplyPromotionService.deleteObjectsByIds("applyPromotionId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//更新排序
	public void updateSort() throws IOException{
		storeApplyPromotion =(StoreApplyPromotion) storeApplyPromotionService.getObjectById(id);
		storeApplyPromotion.setSort(Integer.parseInt(sortValue));
		storeApplyPromotionService.saveOrUpdateObject(storeApplyPromotion);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess","true");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public StoreApplyPromotion getStoreApplyPromotion() {
		return storeApplyPromotion;
	}
	public void setStoreApplyPromotion(StoreApplyPromotion storeApplyPromotion) {
		this.storeApplyPromotion = storeApplyPromotion;
	}
	public List<StoreApplyPromotion> getStoreApplyPromotionList() {
		return storeApplyPromotionList;
	}
	public void setStoreApplyPromotionList(
			List<StoreApplyPromotion> storeApplyPromotionList) {
		this.storeApplyPromotionList = storeApplyPromotionList;
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
	public String getPromotionId() {
		return promotionId;
	}
	public void setPromotionId(String promotionId) {
		this.promotionId = promotionId;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public List<ProductInfo> getProductInfoList() {
		return productInfoList;
	}
	public void setProductInfoList(List<ProductInfo> productInfoList) {
		this.productInfoList = productInfoList;
	}
	public void setStoreApplyPromotionService(
			IStoreApplyPromotionService storeApplyPromotionService) {
		this.storeApplyPromotionService = storeApplyPromotionService;
	}
	public String getFlag() {
		return flag;
	}
	public void setFlag(String flag) {
		this.flag = flag;
	}
	public String getSortValue() {
		return sortValue;
	}
	public void setSortValue(String sortValue) {
		this.sortValue = sortValue;
	}
}
