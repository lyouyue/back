package shop.product.pojo;
import java.util.List;
/**
 * ParamGroupInfo - 套餐参数详细内容
 */
public class ParamGroup {
	private Integer paramGroupId;//参数组	
	private String name;//参数组名称
	private Integer Order ;//参数组排序
	private List<ParamGroupInfo>  paramGroupInfo;
	/***
	 * 当前参数组所在参数 Id
	 */
	private Integer productParametersId;
	/***
	 * 参数所在分类 
	 * */
	private String prodTypeNames;
	
	public Integer getParamGroupId() {
		return paramGroupId;
	}
	public void setParamGroupId(Integer paramGroupId) {
		this.paramGroupId = paramGroupId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Integer getOrder() {
		return Order;
	}
	public void setOrder(Integer order) {
		Order = order;
	}
	public List<ParamGroupInfo> getParamGroupInfo() {
		return paramGroupInfo;
	}
	public void setParamGroupInfo(List<ParamGroupInfo> paramGroupInfo) {
		this.paramGroupInfo = paramGroupInfo;
	}
	
	public Integer getProductParametersId() {
		return productParametersId;
	}
	public void setProductParametersId(Integer productParametersId) {
		this.productParametersId = productParametersId;
	}
	public String getProdTypeNames() {
		return prodTypeNames;
	}
	public void setProdTypeNames(String prodTypeNames) {
		this.prodTypeNames = prodTypeNames;
	}
	
}
