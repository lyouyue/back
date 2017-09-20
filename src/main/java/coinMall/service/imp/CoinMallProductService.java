/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.service.imp;

import coinMall.dao.ICoinMallProductDao;
import coinMall.pojo.CoinMallProduct;
import coinMall.service.ICoinMallProductService;
import util.pojo.PageHelper;
import util.service.BaseService;

import java.util.List;
import java.util.Map;

/**
 * @Author: tangxinli
 * @Date 2016/9/9 17:50
 * SHOP_积分商城套餐Service实现
 */
public class CoinMallProductService extends BaseService<CoinMallProduct> implements ICoinMallProductService {
    private ICoinMallProductDao coinMallProductDao;

    public void setCoinMallProductDao(ICoinMallProductDao coinMallProductDao) {
        this.coinMallProductDao = coinMallProductDao;
    }

    /**
     * 查询最大行数。
     *
     * @param params
     *            传入条件
     * @return 整数行数。
     */
    public Integer getCountCoinMallProduct(String params){
        return coinMallProductDao.getCount(params);
    }
    /**
     * 获取list<map>集合
     * 自定义Hql 语句，返回结果为list<map>
     * @param hql
     * @return
     * @author
     */

    public List<Map> findCoinMallProductListMapPage(String hql, PageHelper pageHelper){
        if(pageHelper == null) {
            pageHelper = new PageHelper();
            pageHelper.setPageRecordBeginIndex(0);
            pageHelper.setPageSize(1);
        }
        return coinMallProductDao.findListMapPage(hql, pageHelper.getPageRecordBeginIndex(), pageHelper.getPageSize());
    }
}
