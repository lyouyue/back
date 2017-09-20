package shop.customer.action;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import net.sf.json.JSONObject;
import shop.customer.pojo.CustomerCollectProduct;
import shop.customer.pojo.CustomerCollectShop;
import shop.customer.service.ICustomerCollectProductService;
import shop.customer.service.ICustomerCollectShopService;
import shop.product.pojo.ProductInfo;
import shop.product.service.IProductInfoService;
import util.action.BaseAction;
/**
 * 用户收藏Action
 * 
 *
 */
@SuppressWarnings("serial")
public class CustomerCollectProductAction extends BaseAction {
	private ICustomerCollectProductService customerCollectProductService;//用户收藏Service
	private IProductInfoService productInfoService;//套餐信息Service
	private ICustomerCollectShopService customerCollectShopService;//店铺收藏Service
	private CustomerCollectProduct customerCollectProduct;
	private List<Map<String,Object>> customerCollectProductList = new ArrayList<Map<String,Object>>();//用户收藏List
	private List<ProductInfo> productInfoList = new ArrayList<ProductInfo>();//套餐信息List
	private String ids;
	private String customerCollectProductId;
	private String customerId;
	//跳转到列表页面
	public String findCustomerCollectProductListByCustomerId(){
		request.setAttribute("customerId", customerId);
		return SUCCESS;
	}
	//跳转到列表页面
	public String findCustomerCollectShopInfoListByCustomerId(){
		request.setAttribute("customerId", customerId);
		return SUCCESS;
	}
	//保存或者修改收藏信息
	public void saveOrUpdateCustomerCollectProduct() throws Exception {
		if(customerCollectProduct!=null){
			ProductInfo productInfo = (ProductInfo) productInfoService.getObjectById(customerCollectProduct.getProductId().toString());
			customerCollectProduct.setProductName(productInfo.getProductName());
			customerCollectProduct=(CustomerCollectProduct)customerCollectProductService.saveOrUpdateObject(customerCollectProduct);
		}
		if(customerCollectProduct.getCustomerCollectProductId()!=null){
			JSONObject jo = new JSONObject();
			jo.accumulate("isSuccess", "true");
			response.setContentType("text/html;charset=utf-8");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	//根据ID得到一条收藏信息
	public void getCustomerCollectProductObject() throws Exception {
		customerCollectProduct = (CustomerCollectProduct) customerCollectProductService.getObjectById(customerCollectProductId);
		JSONObject jo = JSONObject.fromObject(customerCollectProduct);
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//删除用户收藏信息
	public void deleteCustomerCollectProduct() throws Exception {
		Boolean isSuccess = customerCollectProductService.deleteObjectsByIds("customerCollectProductId",ids);
		JSONObject jo = new JSONObject();
		jo.accumulate("isSuccess", isSuccess + "");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//查询所有用户套餐收藏
	public void listCustomerCollectProduct() throws Exception {
		int totalRecordCount = customerCollectProductService.getCount(" where o.customerId = "+customerId);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String sql="SELECT c.customerCollectProductId,c.productName,p.logoImg,p.salesPrice,s.shopName FROM shop_customercollectproduct c,shop_shopinfo s,shop_productinfo p WHERE c.productId=p.productId AND s.shopInfoId=p.shopInfoId ";
		customerCollectProductList = customerCollectProductService.findListMapPageBySql(sql+" and c.customerId = "+customerId+" order by c.customerCollectProductId desc", pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", customerCollectProductList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	//查询所有用户店铺收藏
	public void listCustomerCollectShopInfo() throws Exception {
		int totalRecordCount = customerCollectShopService.getCount(" where o.customerId = "+customerId);
		pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
		String sql="SELECT c.customerCollectShopId ,s.shopName,s.logoUrl as logo FROM shop_customercollectshop c,shop_shopinfo s WHERE c.shopInfoId=s.shopInfoId";
		List<Map<String,Object>> customerCollectShopList = customerCollectShopService.findListMapPageBySql(sql+" and c.customerId = "+customerId+" order by c.customerCollectShopId desc", pageHelper);
		Map<String, Object> jsonMap = new HashMap<String, Object>();// 定义map
		jsonMap.put("total", totalRecordCount);// total键 存放总记录数，必须的
		jsonMap.put("rows", customerCollectShopList);// rows键 存放每页记录 list
		JSONObject jo = JSONObject.fromObject(jsonMap);// 格式化result
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println(jo.toString());
		out.flush();
		out.close();
	}
	public CustomerCollectProduct getCustomerCollectProduct() {
		return customerCollectProduct;
	}
	public void setCustomerCollectProduct(
			CustomerCollectProduct customerCollectProduct) {
		this.customerCollectProduct = customerCollectProduct;
	}

	public List<ProductInfo> getProductInfoList() {
		return productInfoList;
	}
	public void setProductInfoList(List<ProductInfo> productInfoList) {
		this.productInfoList = productInfoList;
	}
	public String getIds() {
		return ids;
	}
	public void setIds(String ids) {
		this.ids = ids;
	}
	public String getCustomerCollectProductId() {
		return customerCollectProductId;
	}
	public void setCustomerCollectProductId(String customerCollectProductId) {
		this.customerCollectProductId = customerCollectProductId;
	}
	public String getCustomerId() {
		return customerId;
	}
	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	public void setCustomerCollectProductService(
			ICustomerCollectProductService customerCollectProductService) {
		this.customerCollectProductService = customerCollectProductService;
	}
	public void setProductInfoService(IProductInfoService productInfoService) {
		this.productInfoService = productInfoService;
	}
	public void setCustomerCollectShopService(
			ICustomerCollectShopService customerCollectShopService) {
		this.customerCollectShopService = customerCollectShopService;
	}
	public List<Map<String, Object>> getCustomerCollectProductList() {
		return customerCollectProductList;
	}
	public void setCustomerCollectProductList(
			List<Map<String, Object>> customerCollectProductList) {
		this.customerCollectProductList = customerCollectProductList;
	}
}
