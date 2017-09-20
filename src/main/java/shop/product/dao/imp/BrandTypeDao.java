package shop.product.dao.imp;
import shop.product.dao.IBrandTypeDao;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import util.dao.BaseDao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 品牌和分类Dao接口实现类
 * 
 *
 */
public class BrandTypeDao extends BaseDao <BrandType> implements IBrandTypeDao {
    /**
     * 根据产品分类id，获得上级分类的所有品牌
     * 并与当前分类下的品牌求差集，然后返回当前分类没有的品牌
     * @param productTypeId
     * @return
     * @throws Exception
     */
    @Override
    public List<BrandType> getParentProductType(Integer productTypeId) throws Exception {
        String sql = "select bt.brandId as brandId from shop_brandtype bt, shop_producttype pt where bt.productTypeId = pt.parentId and pt.productTypeId = " + productTypeId;
        List<Map<String,Object>> maps = this.findListMapBySql(sql);
        String sql2 = "select bt.brandId as brandId from shop_brandtype bt, shop_producttype pt where bt.productTypeId = pt.productTypeId and pt.productTypeId = " + productTypeId;
        List<Map<String,Object>> maps2 = this.findListMapBySql(sql2);
        List<BrandType> list = new ArrayList<>();
        if (maps.size() > 0) {
        	maps.removeAll(maps2);//去掉重复的品牌
            for (Map map : maps) {
                BrandType brandType = new BrandType();
                brandType.setBrandId(Integer.parseInt(String.valueOf(map.get("brandId"))));
                brandType.setIsShow(0);
                list.add(brandType);
            }
        }
        return list;
    }
}
