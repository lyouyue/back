package shop.product.service;
import shop.product.pojo.BrandType;
import util.service.IBaseService;
/**
 * 品牌和分类Service接口
 * 
 *
 */
public interface IBrandTypeService  extends IBaseService <BrandType> {
	/**
	 * 批量保存品牌分类关系
	 * @param brandIds
	 * @param productTypeId
	 * @return
	 */
	public boolean saveMoreBrandType(Integer[] brandIds,Integer productTypeId );

	/**
	 * 根据传入产品分类的id，复制上级所有品牌
	 * @param productTypeId 产品分类的id
	 * @return
     */
	public boolean saveCopyParentProductType(Integer productTypeId) throws Exception;
}
