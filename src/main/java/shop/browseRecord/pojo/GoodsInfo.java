package shop.browseRecord.pojo;
import java.io.Serializable;
import shop.product.pojo.ProductInfo;
/**
 * 购物车套餐信息封装类
 * @author 张攀攀
 *
 */
public class GoodsInfo implements Serializable{
	private static final long serialVersionUID = 3994426440551610097L;
	/**
	 * 套餐数量
	 */
	private Integer goodsNumber;
	/**
	 * 套餐信息
	 */
	private ProductInfo productInfo;
	/**
	 * 套餐总金额
	 */
	private Double totalMoney;
	public Integer getGoodsNumber() {
		return goodsNumber;
	}
	public void setGoodsNumber(Integer goodsNumber) {
		this.goodsNumber = goodsNumber;
	}
	public ProductInfo getProductInfo() {
		return productInfo;
	}
	public void setProductInfo(ProductInfo productInfo) {
		this.productInfo = productInfo;
	}
	public Double getTotalMoney() {
		return totalMoney;
	}
	public void setTotalMoney(Double totalMoney) {
		this.totalMoney = totalMoney;
	}
}