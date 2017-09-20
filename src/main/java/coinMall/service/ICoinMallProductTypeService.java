/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.service;

import coinMall.pojo.CoinMallProductType;
import util.service.IBaseService;

import java.util.List;

/**
 * @Author: tangxinli
 * @Date 2016/9/9 17:51
 * SHOP_积分商城分类Service
 */
public interface ICoinMallProductTypeService extends IBaseService<CoinMallProductType> {
    /**
     * 修改父亲的节点状态为2
     * 1：叶子：显示删除
     2：非叶子：不显示删除

     * @param typeId   积分商城分类ID
     */
    public void updateFatherLoadType(String typeId);
    /**
     * 根据父ID查询子列表
     *
     * @param id 积分商城分类父ID
     *
     * @return 返回一个list集合
     */
    public List queryByParentId(String id);
    /**
     * 根据SQL语句返回一条数据。
     *
     * @param params
     *            传入条件
     * @return 新的实体javabean
     */
    public CoinMallProductType getCoinMallProductTypeByParams(String params);
    /**
     * 保存或者修改。
     *
     * @param obj
     *            传入实体javabean
     * @return 新的实体javabean
     */
    public CoinMallProductType saveOrUpdateCoinMallProductType(CoinMallProductType obj);
    /**
     * 删除。
     *
     * @param params
     *            传入条件
     * @return 真假，是否删除
     */
    public boolean deleteCoinMallProductTypeByParams(String params);
    /**
     * 查询最大行数。
     *
     * @param params
     *            传入条件
     * @return 整数行数。
     */
    public Integer getCountCoinMallProductType(String params);
}
