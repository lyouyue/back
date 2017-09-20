package shop.product.service.imp;
import shop.product.dao.IBrandTypeDao;
import shop.product.pojo.BrandType;
import shop.product.service.IBrandTypeService;
import util.service.BaseService;

import java.util.List;

/**
 * 品牌和分类Service接口实现类
 * 
 *
 */
public class BrandTypeService extends BaseService <BrandType> implements IBrandTypeService{
	@SuppressWarnings("unused")
	private IBrandTypeDao brandTypeDao;
	public void setBrandTypeDao(IBrandTypeDao brandTypeDao) {
		this.baseDao=this.brandTypeDao = brandTypeDao;
	}
	/**
	 * 批量保存品牌分类关系
	 * @param brandIds
	 * @param productTypeId
	 * @return
	 */
	public boolean saveMoreBrandType(Integer[] brandIds,Integer productTypeId ){
		boolean flag = true;
		for(Integer brandId:brandIds){
			BrandType brandType = new BrandType();
			brandType.setBrandTypeId(null);
			brandType.setBrandId(brandId);
			brandType.setProductTypeId(productTypeId);
			brandType = brandTypeDao.saveOrUpdateObject(brandType);
			if(brandType.getBrandTypeId()==null){
				flag = false;
			}
		}
		return flag;
	}

	/**
	 * 根据传入产品分类的id，复制上级所有品牌
	 *
	 * @param productTypeId 产品分类的id
	 * @return
	 */
	@Override
	public boolean saveCopyParentProductType(Integer productTypeId) throws Exception{
		//首页获得上级分类的所有品牌
		List<BrandType> list = brandTypeDao.getParentProductType(productTypeId);
		if (list.size() > 0) {
			for (BrandType brandType : list) {
				brandType.setProductTypeId(productTypeId);	//设置本分类id
				brandType.setIsShow(0);		//默认为0，不显示
				brandTypeDao.saveObject(brandType);	// 保存本分类及品牌关系至数据库
			}
		}
		return true;
	}
}