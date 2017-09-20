/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package panicBuying.service.imp;

import panicBuying.dao.IHomePanicRecommendDao;
import panicBuying.pojo.HomePanicRecommend;
import panicBuying.service.IHomePanicRecommendService;
import util.pojo.PageHelper;
import util.service.BaseService;

import java.util.List;

/**
 * @Author: caiang
 * @Date 2016/9/6 17:24
 */
public class HomePanicRecommendService extends BaseService<HomePanicRecommend> implements IHomePanicRecommendService {
    /*注入dao层*/
    private IHomePanicRecommendDao homePanicRecommendDao;

    public void setHomePanicRecommendDao(IHomePanicRecommendDao homePanicRecommendDao) {
        this.homePanicRecommendDao = homePanicRecommendDao;
    }
    /**
     * 查询最大行数。
     *
     * @param params
     *            传入条件
     * @return 整数行数。
     */
    public Integer getCountPanicRecord(String params){
        return homePanicRecommendDao.getCount(params);
    }
    /**
     * 保存或者修改。
     *
     * @param obj
     *            传入实体javabean
     * @return 新的实体javabean
     */
    public HomePanicRecommend saveOrUpdatePanicRecord(HomePanicRecommend obj){
        return homePanicRecommendDao.saveOrUpdateObject(obj);
    }
    /**
     * 根据SQL语句返回多条数据。
     * @param selectColumns 投影的字段数组
     * @param pageHelper
     *            传入分页
     * @param params
     *            传入条件
     * @return 新的实体javabean集合
     */
    public List<HomePanicRecommend> findPanicRecordListByPageHelper(String [] selectColumns, PageHelper pageHelper, String params){
        if(pageHelper == null) {
            pageHelper = new PageHelper();
            pageHelper.setPageRecordBeginIndex(0);
            pageHelper.setPageSize(1);
        }
        return homePanicRecommendDao.findSome(selectColumns,pageHelper.getPageRecordBeginIndex(), pageHelper.getPageSize(), params);
    }
}
