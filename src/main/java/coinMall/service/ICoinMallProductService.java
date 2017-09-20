/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.service;

import coinMall.pojo.CoinMallProduct;
import util.pojo.PageHelper;
import util.service.IBaseService;

import java.util.List;
import java.util.Map;

/**
 * @Author: tangxinli
 * @Date 2016/9/9 17:48
 * SHOP_积分商城套餐Service
 */
public interface ICoinMallProductService extends IBaseService<CoinMallProduct> {
    /**
     * 查询最大行数。
     *
     * @param params
     *            传入条件
     * @return 整数行数。
     */
    public Integer getCountCoinMallProduct(String params);
    /**
     * 获取list<map>集合
     * 自定义Hql 语句，返回结果为list<map>
     * @param hql
     * @return
     * @author
     */

    public List<Map> findCoinMallProductListMapPage(String hql, PageHelper pageHelper);
}
