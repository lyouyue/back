package shop.product.dao;
import shop.product.pojo.BrandType;
import util.dao.IBaseDao;

import java.util.List;
import java.util.Map;

/**
 * 品牌和分类Dao接口
 * 
 *
 */
public interface IBrandTypeDao extends IBaseDao <BrandType>{

    /**
     * 根据产品分类id，获得上级分类的所有品牌
     * @param productTypeId
     * @return
     * @throws Exception
     */
    public List<BrandType> getParentProductType(Integer productTypeId) throws Exception;
}
