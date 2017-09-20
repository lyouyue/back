package shop.store.pojo;
import java.io.Serializable;

import util.pojo.BaseEntity;
/**
 * ShopProCateClass - 店铺内部套餐分类和套餐关系
 */
public class ShopProCateClass extends BaseEntity implements Serializable{
	/**
	 * 
	 */
	private static final long serialVersionUID = 5161051190368852103L;
	/**
	 * 店铺内部套餐分类ID
	 */
	private Integer shopProCategoryId;
	/**
	 * 套餐ID
	 */
	private Integer productId;
	
	public Integer getShopProCategoryId() {
		return shopProCategoryId;
	}
	public void setShopProCategoryId(Integer shopProCategoryId) {
		this.shopProCategoryId = shopProCategoryId;
	}
	public Integer getProductId() {
		return productId;
	}
	public void setProductId(Integer productId) {
		this.productId = productId;
	}
}
