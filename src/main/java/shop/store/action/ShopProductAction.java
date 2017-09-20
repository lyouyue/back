package shop.store.action;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import shop.product.pojo.ProductInfo;
import shop.product.service.IProductInfoService;
import shop.store.pojo.ShopInfoProduct;
import shop.store.pojo.ShopProCategory;
import shop.store.pojo.ShopProduct;
import shop.store.service.IShopProCategoryService;
import shop.store.service.IShopProductService;
import util.action.BaseAction;
/**
 * ShopProductAction - 店铺套餐Action类
 * @author 孟琦瑞  
 */
@SuppressWarnings({ "serial", "unused" })
public class ShopProductAction  extends BaseAction{
	private IProductInfoService productInfoService;//套餐Serivice
	private IShopProCategoryService shopProCategoryService;//店铺内部套餐分类Serivice
	private ShopProduct shopProduct=new ShopProduct();//店铺套餐对象
	private String ids;
	private String id;
	private String shopInfoId;
	private String productName;
	private List<ProductInfo> productInfoList = new ArrayList<ProductInfo>();//套餐信息List
	private List<ShopProCategory> shopProCategoryList = new ArrayList<ShopProCategory>();//套餐信息List
	private List<String> productInfos;//提交多个套餐信息 格式：“productId_productName”
	private List<String> shopProducts;//提交的多个促销价
	//根据店铺ID跳转到店铺套餐列表页
	public String gotoProductListByShopInfoPage(){
		request.setAttribute("shopInfoId", shopInfoId);
		return SUCCESS;
	}
	//根据店铺ID跳转到店铺套餐列表页
	public String gotoSelfSupportProductListByShopInfoPage(){
		request.setAttribute("shopInfoId", shopInfoId);
		return SUCCESS;
	}
	//根据店铺ID查询该店铺的套餐
	public void findProductListByShopInfoId() throws IOException {
		int totalRecordCount = productInfoService.getCount(" where o.shopInfoId='"+shopInfoId+"'");
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		productInfoList = productInfoService.findListByPageHelper(null, pageHelper, " where o.shopInfoId='"+shopInfoId+"'");
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", productInfoList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//根据条件查询套餐信息
	public void listProductInfo() throws IOException{
		String hql = "";
		if("".equals(productName) || productName==null){
			hql = " order by o.productId";
		}else{
			hql = " where o.productName like'%"+productName+"%' order by o.productId";
		}
		productInfoList = productInfoService.findObjects(hql);
		JSONArray jo = JSONArray.fromObject(productInfoList);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
/**
 * setter getter
 * @return
 */
	public ShopProduct getShopProduct() {
		return shopProduct;
	}
	public void setShopProduct(ShopProduct shopProduct) {
		this.shopProduct = shopProduct;
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
	public String getShopInfoId() {
		return shopInfoId;
	}
	public void setShopInfoId(String shopInfoId) {
		this.shopInfoId = shopInfoId;
	}
	public List<ProductInfo> getProductInfoList() {
		return productInfoList;
	}
	public void setProductInfoList(List<ProductInfo> productInfoList) {
		this.productInfoList = productInfoList;
	}
	public List<String> getProductInfos() {
		return productInfos;
	}
	public void setProductInfos(List<String> productInfos) {
		this.productInfos = productInfos;
	}
	public List<String> getShopProducts() {
		return shopProducts;
	}
	public void setShopProducts(List<String> shopProducts) {
		this.shopProducts = shopProducts;
	}
	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}
	public String getProductName() {
		return productName;
	}
	public void setProductName(String productName) {
		this.productName = productName;
	}
	public void setShopProCategoryService(
			IShopProCategoryService shopProCategoryService) {
		this.shopProCategoryService = shopProCategoryService;
	}
	public List<ShopProCategory> getShopProCategoryList() {
		return shopProCategoryList;
	}
	public void setShopProCategoryList(List<ShopProCategory> shopProCategoryList) {
		this.shopProCategoryList = shopProCategoryList;
	}
}
