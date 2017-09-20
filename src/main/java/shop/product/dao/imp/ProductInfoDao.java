package shop.product.dao.imp;
import shop.order.pojo.OrdersList;
import shop.product.dao.IProductInfoDao;
import shop.product.pojo.ProductInfo;
import util.dao.BaseDao;
/**
 * 套餐Dao接口实现类
 * 
 *
 */
public class ProductInfoDao extends BaseDao <ProductInfo> implements IProductInfoDao {

    /**
     * 根据产品id查询产品信息
     *
     * @param productId
     * @return
     * @throws Exception
     */
    public ProductInfo getProductInfoByProductId(Integer productId) {
        return get(" where o.productId=" + productId);
    }
}
