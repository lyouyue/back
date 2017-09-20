package shop.product.dao;
import shop.product.pojo.ProductInfo;
import util.dao.IBaseDao;
/**
 * 套餐Dao接口
 * 
 *
 */
public interface IProductInfoDao extends IBaseDao <ProductInfo>{

    /**
     * 根据产品id查询产品信息
     *
     * @param productId
     * @return
     * @throws Exception
     */
    public ProductInfo getProductInfoByProductId(Integer productId);
}
