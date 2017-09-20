package shop.measuringUnit.service;
import shop.measuringUnit.pojo.ProductMeasuringUnit;
import util.service.IBaseService;
/**
 * 套餐计量单位Service接口
 * @author wangya
 *
 */
public interface IProductMeasuringUnitService  extends IBaseService <ProductMeasuringUnit> {
	public boolean saveMoreProductMeasuringUnit(Integer[] measuringUnitIds,Integer productTypeId );
}
