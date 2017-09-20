/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.service.imp;

import coinMall.dao.ICoinMallProductTypeDao;
import coinMall.pojo.CoinMallProductType;
import coinMall.service.ICoinMallProductTypeService;
import util.service.BaseService;

import java.util.List;

/**
 * @Author: tangxinli
 * @Date 2016/9/9 17:53
 * SHOP_积分商城分类Service实现
 */
public class CoinMallProductTypeService extends BaseService<CoinMallProductType> implements ICoinMallProductTypeService {
    private ICoinMallProductTypeDao coinMallProductTypeDao;

    public void setCoinMallProductTypeDao(ICoinMallProductTypeDao coinMallProductTypeDao) {
        this.coinMallProductTypeDao = coinMallProductTypeDao;
    }

    /**
     * 修改父亲的节点状态为2
     * 1：叶子：显示删除
     2：非叶子：不显示删除

     * @param typeId   积分商城分类ID
     */
    public void updateFatherLoadType(String typeId){
        CoinMallProductType coinMallProductType=coinMallProductTypeDao.getObjectById(typeId);
        coinMallProductType.setLoadType(0);
        coinMallProductTypeDao.updateObject(coinMallProductType);
    }
    /**
     * 根据父ID查询子列表
     *
     * @param id 积分商城分类父ID
     *
     * @return 返回一个list集合
     */
    public List queryByParentId(String id){
        return coinMallProductTypeDao.findObjects(null,"where 1=1 and o.typeParentId='"+id+"'");
    }
    /**
     * 根据SQL语句返回一条数据。
     *
     * @param params
     *            传入条件
     * @return 新的实体javabean
     */
    public CoinMallProductType getCoinMallProductTypeByParams(String params){
        return coinMallProductTypeDao.get(params);
    }
    /**
     * 保存或者修改。
     *
     * @param obj
     *            传入实体javabean
     * @return 新的实体javabean
     */
    public CoinMallProductType saveOrUpdateCoinMallProductType(CoinMallProductType obj){
        return coinMallProductTypeDao.saveOrUpdateObject(obj);
    }
    /**
     * 删除。
     *
     * @param params
     *            传入条件
     * @return 真假，是否删除
     */
    public boolean deleteCoinMallProductTypeByParams(String params){
        return coinMallProductTypeDao.deleteByParams(params);
    }
    /**
     * 查询最大行数。
     *
     * @param params
     *            传入条件
     * @return 整数行数。
     */
    public Integer getCountCoinMallProductType(String params){
        return coinMallProductTypeDao.getCount(params);
    }
}
