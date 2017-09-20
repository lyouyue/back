package shop.product.service.imp;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import shop.browseRecord.dao.IProBrRecordDao;
import shop.product.dao.IProductImgDao;
import shop.product.dao.IProductInfoDao;
import shop.product.dao.IProductSpecificationDao;
import shop.product.dao.IProductSpecificationValueDao;
import shop.product.pojo.ProductImg;
import shop.product.pojo.ProductInfo;
import shop.product.service.IProductInfoService;
import promotion.dao.IStoreApplyPromotionDao;
import shop.store.pojo.ShopInfo;
import util.other.Utils;
import util.service.BaseService;
/**
 * 套餐Service接口实现类
 *
 * 
 *
 */
public class ProductInfoService extends BaseService<ProductInfo> implements IProductInfoService {
	private IProductInfoDao productInfoDao;// 套餐dao
	private IProductImgDao productImgDao;// 套餐图片dao
	private IProBrRecordDao proBrRecordDao;// 浏览记录dao
	private IProductSpecificationValueDao productSpecificationValueDao;// 套餐规格值中间表dao
	private IProductSpecificationDao productSpecificationDao;// 套餐规格中间表dao
	private IStoreApplyPromotionDao storeApplyPromotionDao;// 套餐申请参加促销活动dao
	// 删除套餐 同时删除相关表中的数据
	public void deleteProduct(Integer productId,ShopInfo shopInfo) {
		ProductInfo productInfo= productInfoDao.get(" where o.productId="+productId+" and o.shopInfoId="+shopInfo.getShopInfoId());
		String params = " where o.productId=" + productId;
		// 删除套餐对应的图片数据
		List<ProductImg> imgList = productImgDao.findObjects(params);
		if (imgList != null && imgList.size() > 0) {
			productImgDao.deleteByParams(params);
		}
		// 删除浏览记录中间表
		if (proBrRecordDao.findObjects(params) != null
				&& proBrRecordDao.findObjects(params).size() > 0) {
			proBrRecordDao.deleteByParams(params);
		}
		// 删除套餐规格之中间表数据
		if (productSpecificationValueDao.findObjects(params) != null
				&& productSpecificationValueDao.findObjects(params).size() > 0) {
			productSpecificationValueDao.deleteByParams(params);
		}
		// 删除套餐申请参加促销活动数据
		if (storeApplyPromotionDao.findObjects(params) != null
				&& storeApplyPromotionDao.findObjects(params).size() > 0) {
			storeApplyPromotionDao.deleteByParams(params);
		}
		// 删除套餐
		productInfoDao.deleteObjectById(String.valueOf(productId));
	}
	/**
	 * 根据套餐查询分类ID、分类名称集合
	 * @param productInfoList
	 * 			套餐集合
	 * @return List<Map>：
	 * 		map.key=productTypeId，map.value=相应的分类ID值；
	 * 		map.key=sortName，map.value=相应的分类名称值；
	 * 		map.key=productInfoTypeTotal，map.value=相应的分类下套餐总数；
	 */
	@SuppressWarnings("unchecked")
	public List<Map> getProductToTypeInfo(List<ProductInfo> productInfoList){
		List productIdList = new ArrayList();//定义套餐ID集合
		for(ProductInfo productInfo : productInfoList){//遍历解析套餐集合
			productIdList.add(productInfo.getProductId());
		}
		String productIds = Utils.listToString(productIdList, ",");
		String hql="SELECT pt.productTypeId as productTypeId , pt.sortName as sortName , count(*) as productInfoTypeTotal FROM ProductInfo pi , ProductType pt WHERE pi.productTypeId=pt.productTypeId AND pi.isPass=1 AND pi.isPutSale=2 AND pi.isShow=1 AND pi.productId in (" + productIds + ") group by pt.productTypeId , pt.sortName ";
		List<Map> findListMapByHql = productInfoDao.findListMapByHql(hql);
		return findListMapByHql;
	}
	/**
	 * 根据套餐查询品牌ID、品牌名称集合
	 * @param productInfoList
	 * 			套餐集合
	 * @return List<Map>：
	 * 		map.key=brandId，map.value=相应的品牌ID值；
	 * 		map.key=brandName，map.value=相应的品牌名称值
	 */
	@SuppressWarnings("unchecked")
	public List<Map> getProductToBrandInfo(List<ProductInfo> productInfoList){
		List productIdList = new ArrayList();//定义套餐ID集合
		for(ProductInfo productInfo : productInfoList){//遍历解析套餐集合
			productIdList.add(productInfo.getProductId());
		}
		String productIds = Utils.listToString(productIdList, ",");
		String hql="SELECT b.brandId as brandId , b.brandName as brandName FROM ProductInfo p , Brand b WHERE p.brandId=b.brandId AND p.isPass=1 AND p.isPutSale=2 AND p.isShow=1 AND p.productId in (" + productIds + ") group by b.brandId , b.brandName ";
		List<Map> findListMapByHql = productInfoDao.findListMapByHql(hql);
		return findListMapByHql;
	}
	 /**
	  * 通过sql语句修改单个对象或者批量对象
	 */
	 public boolean updateBySQL(String sql){
		 return baseDao.updateBySQL(sql);
	 }
	/**
	 * 搜索引擎检索无数据，回传一些随机套餐信息
	 */
	public List<ProductInfo> findRandomProductInfoList(){
		String hql=" WHERE o.isPass=1 AND o.isPutSale=2 AND o.isShow=1 order by o.putSaleDate ";
		return productInfoDao.findSome(0, 8, hql);
	}

	/**
	 * 根据产品id查询产品信息
	 *
	 * @param productId
	 * @return
	 * @throws Exception
	 */
	@Override
	public ProductInfo getProductInfoByProductId(Integer productId){
		return productInfoDao.getProductInfoByProductId(productId);
	}

	// setter getter
	public void setProductInfoDao(IProductInfoDao productInfoDao) {
		this.baseDao = this.productInfoDao = productInfoDao;
	}
	public void setProductImgDao(IProductImgDao productImgDao) {
		this.productImgDao = productImgDao;
	}
	public void setProBrRecordDao(IProBrRecordDao proBrRecordDao) {
		this.proBrRecordDao = proBrRecordDao;
	}
	public void setProductSpecificationValueDao(
			IProductSpecificationValueDao productSpecificationValueDao) {
		this.productSpecificationValueDao = productSpecificationValueDao;
	}
	public void setProductSpecificationDao(
			IProductSpecificationDao productSpecificationDao) {
		this.productSpecificationDao = productSpecificationDao;
	}
	public void setStoreApplyPromotionDao(
			IStoreApplyPromotionDao storeApplyPromotionDao) {
		this.storeApplyPromotionDao = storeApplyPromotionDao;
	}
}