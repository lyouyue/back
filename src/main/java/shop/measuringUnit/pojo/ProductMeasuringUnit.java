package shop.measuringUnit.pojo;
import java.io.Serializable;
import util.pojo.BaseEntity;
/**
 * 套餐计量单位实体类
 * @author wangya
 *
 */
public class ProductMeasuringUnit extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -6065293454669050838L;
	/**
	 * 套餐计量单位ID
	 */
	private Integer productMeasuringUnitId;
	/**
	 * 套餐分类ID
	 */
	private Integer productTypeId;
	/**
	 * 计量单位ID
	 */
	private Integer measuringUnitId;
	
	
	public Integer getProductMeasuringUnitId() {
		return productMeasuringUnitId;
	}
	public void setProductMeasuringUnitId(Integer productMeasuringUnitId) {
		this.productMeasuringUnitId = productMeasuringUnitId;
	}
	public Integer getProductTypeId() {
		return productTypeId;
	}
	public void setProductTypeId(Integer productTypeId) {
		this.productTypeId = productTypeId;
	}
	public Integer getMeasuringUnitId() {
		return measuringUnitId;
	}
	public void setMeasuringUnitId(Integer measuringUnitId) {
		this.measuringUnitId = measuringUnitId;
	}
	
}
