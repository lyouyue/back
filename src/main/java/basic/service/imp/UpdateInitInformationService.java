package basic.service.imp;
import java.io.File;
import java.io.IOException;
import java.util.Map;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.read.biff.BiffException;
import shop.measuringUnit.dao.IMeasuringUnitDao;
import shop.measuringUnit.dao.IProductMeasuringUnitDao;
import shop.measuringUnit.pojo.MeasuringUnit;
import shop.measuringUnit.pojo.ProductMeasuringUnit;
import shop.product.dao.IAttributeValueDao;
import shop.product.dao.IBrandDao;
import shop.product.dao.IBrandTypeDao;
import shop.product.dao.IProductAttributeDao;
import shop.product.dao.IProductTypeDao;
import shop.product.dao.ISpecificationDao;
import shop.product.dao.ISpecificationValueDao;
import shop.product.pojo.AttributeValue;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductAttribute;
import shop.product.pojo.ProductType;
import shop.product.pojo.Specification;
import shop.product.pojo.SpecificationValue;
import util.other.Utils;
import util.service.BaseService;
import basic.pojo.Users;
import basic.service.IUpdateInitInformationService;
/**
 * 数据导入Dao接口实现类
 * 
 */
public class UpdateInitInformationService extends BaseService  <Users> implements IUpdateInitInformationService {
	/**套餐分类Dao**/
	private IProductTypeDao productTypeDao;
	/**品牌Dao**/
	private IBrandDao brandDao;
	/**品牌分类Dao**/
	private IBrandTypeDao brandTypeDao;
	/**规格Dao**/
	private ISpecificationDao specificationDao;
	/**规格值Dao**/
	private ISpecificationValueDao specificationValueDao;
	/**套餐扩展属性Dao**/
	private IProductAttributeDao productAttributeDao;
	/**套餐扩展属性值Dao**/
	private IAttributeValueDao attributeValueDao;
	/**单位Dao**/
	private IMeasuringUnitDao measuringUnitDao;
	/**套餐分类单位Dao**/
	private IProductMeasuringUnitDao productMeasuringUnitDao;
	/**
	 * 将Excel的数据导入数据库
	 * 文件数据结构需遵从Excel模板
	 * @param map
	 * key==value
	 ***************************
	 * imagePathFileName==imagePathFileName
	 * categoryId==categoryId
	 * imagePath==imagePath
	 ***************************
	 */
	public void saveExcelFile(Map<String,Object> map) throws IOException{
		
	}
	public void setProductTypeDao(IProductTypeDao productTypeDao) {
		this.productTypeDao = productTypeDao;
	}
	public void setBrandDao(IBrandDao brandDao) {
		this.brandDao = brandDao;
	}
	public void setBrandTypeDao(IBrandTypeDao brandTypeDao) {
		this.brandTypeDao = brandTypeDao;
	}
	public void setSpecificationDao(ISpecificationDao specificationDao) {
		this.specificationDao = specificationDao;
	}
	public void setSpecificationValueDao(
			ISpecificationValueDao specificationValueDao) {
		this.specificationValueDao = specificationValueDao;
	}
	public void setProductAttributeDao(IProductAttributeDao productAttributeDao) {
		this.productAttributeDao = productAttributeDao;
	}
	public void setAttributeValueDao(IAttributeValueDao attributeValueDao) {
		this.attributeValueDao = attributeValueDao;
	}
	public void setMeasuringUnitDao(IMeasuringUnitDao measuringUnitDao) {
		this.measuringUnitDao = measuringUnitDao;
	}
	public void setProductMeasuringUnitDao(
			IProductMeasuringUnitDao productMeasuringUnitDao) {
		this.productMeasuringUnitDao = productMeasuringUnitDao;
	}
	
}
