package shop.product.service;
import java.util.List;
import java.util.Map;

import shop.product.pojo.ProductInfo;
import shop.store.pojo.ShopInfo;
import util.service.IBaseService;
/**
 * 套餐Service接口
 * 
 *
 */
public interface IProductInfoService  extends IBaseService <ProductInfo> {
	/**
	 * 删除套餐 同时删除相关表中的数据
	 *
	 * @param productId
	 *            套餐ID
	 */
	public void deleteProduct(Integer productId,ShopInfo shopInfo);
	/**
	 * 根据套餐查询分类ID、分类名称集合
	 * @param productInfoList
	 * 			套餐集合
	 * @return List<Map>：map.key=productTypeId，map.value=相应的分类ID值；map.key=sortName，map.value=相应的分类名称值
	 */
	@SuppressWarnings("unchecked")
	public List<Map> getProductToTypeInfo(List<ProductInfo> productInfoList);
	/**
	 * 根据套餐查询品牌ID、品牌名称集合
	 * @param productInfoList
	 * 			套餐集合
	 * @return List<Map>：map.key=brandId，map.value=相应的品牌ID值；map.key=brandName，map.value=相应的品牌名称值
	 */
	@SuppressWarnings("unchecked")
	public List<Map> getProductToBrandInfo(List<ProductInfo> productInfoList);
	 /**
	  * 通过sql语句修改单个对象或者批量对象
	 */
	 public boolean updateBySQL(String sql);

	/**
	 * 搜索引擎检索无数据，回传一些随机套餐信息
	 */
	public List<ProductInfo> findRandomProductInfoList();
	/**
	 * 根据产品id查询产品信息
	 *
	 * @param productId
	 * @return
	 * @throws Exception
	 */
	public ProductInfo getProductInfoByProductId(Integer productId);
}
