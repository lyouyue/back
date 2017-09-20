package shop.product.service;

import java.io.File;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import shop.product.pojo.ProductAttrIndex;
import shop.product.pojo.ProductImg;
import shop.product.pojo.ProductInfo;
import util.service.IBaseService;
/**
 * 添加和修改套餐Service 
 */
public interface IAddProductInfoService extends IBaseService<ProductInfo> {
	/**
	 * 根据多条的规格和规格值组，生成多个套餐
	 */
	public void saveOrUpdateListProductInfo(String shopProCategoryId,ProductInfo productInfo,String parameters,List<ProductImg> listProductImage,Map fileUrlConfig,List<File> listProductUploadImgs,List<String>  listProductUploadImgsFileName,JSONArray jsonArray,List<ProductAttrIndex> paiList);
	public void updateFrontProductSpecification(Integer productId,String goods,String parameters);
	/**
	 * 添加套餐没有规格
	 * @param shopProCategoryId店铺内部分类
	 * @param productInfo套餐信息
	 * @param listProductImage套餐图片
	 * @param fileUrlConfig上传图片的配置文件
	 * @param listProductUploadImgs上传图片路径
	 * @param listProductUploadImgsFileName上传图片名称
	 */
	public void saveOrUpdateProductInfo(String shopProCategoryId,ProductInfo productInfo,List<ProductImg> listProductImage,Map fileUrlConfig,List<File> listProductUploadImgs,List<String>  listProductUploadImgsFileName);
	/***
	 * 修改套餐的基本信息
	 * @param product
	 * @param shopProCategoryId
	 */
	public Boolean saveOrUpdateBasicProduct(ProductInfo product,Integer shopProCategoryId);
	/**
	 * 修改套餐图片
	 * @param productInfo套餐信息
	 * @param listProductImage套餐图片集合
	 * @param fileUrlConfig上传路径配置
	 * @param listProductUploadImgs上传路径集合
	 * @param listProductUploadImgsFileName上传名称集合
	 */
	public Boolean saveOrUpdateProdImg(ProductInfo productInfo,List<ProductImg> listProductImage);
	/**
	 * 解除该套餐所在套餐组的规格以及对应的规格值的关联关系
	 * @param productId  套餐Id
	 */
	public boolean removeProductSpecificationValueGoodsGuanlian(Integer productId,String optionProductId);
	/**
	 * 修改规格
	 * @param 
	 * @throws Exception 
	 */
	public boolean updateFrontProductSpecification(String specifications,Integer oldProductId) throws Exception ;
	/**
	 *  详情页滚动图片上传
	 * @param imagePath
	 * @param imagePathFileName
	 * @param productImg
	 * @param fileUrlConfig
	 * @return
	 * @throws Exception 
	 */
	public ProductImg uploadProductImage(File imagePath,String imagePathFileName,ProductImg productImg,Map<Object,Object> fileUrlConfig) throws Exception ;
	/**
	 * @throws Exception 
	 * @功能：将平台基础套餐拷贝一份给店铺
	 * @作者: 
	 * @参数： @param shopInfoIds
	 * @参数： @param productIds
	 * @参数： @param selectshopProCategoryId
	 * @返回值：void
	 * @日期: 2016年5月8日 下午2:20:54 
	 */
	public void saveCopyBasicProductInfo(String shopInfoIds, String productIds,String selectshopProCategoryId) throws Exception;
	/**
	 * @功能：删除套餐及所涉及到的表
	 * @作者: 
	 * @参数： @param productIds 套餐Id字符串
	 * @参数： @return
	 * @返回值：boolean
	 * @日期: 2016年5月9日 下午2:36:21 
	 */
	public boolean deleteProductAll(String productIds);
	/**
	 * @功能：修改套餐基本信息和内部分类
	 * @作者: 
	 * @参数： @param productIds 套餐Id字符串
	 * @参数： @return
	 * @返回值：boolean
	 * @日期: 2016年5月9日 下午2:36:21 
	 */
	public boolean saveOrUpdateProduct(ProductInfo productInfo,Integer shopProCategoryId);
}
