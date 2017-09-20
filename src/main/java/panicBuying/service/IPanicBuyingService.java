/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package panicBuying.service;


import org.apache.poi.ss.formula.functions.T;
import panicBuying.pojo.PanicBuying;
import util.pojo.PageHelper;
import util.service.IBaseService;

import java.util.List;

/**
 * @Author: caiang
 * @Date 2016/9/6 17:16
 */
public interface IPanicBuyingService extends IBaseService<PanicBuying> {
    /**
     * 查询最大行数。
     *
     * @param params
     *            传入条件
     * @return 整数行数。
     */
    public Integer getCountPanic(String params);
    /**
     * 根据SQL语句返回多条数据。
     * @param selectColumns 投影的字段数组
     * @param pageHelper
     *            传入分页
     * @param params
     *            传入条件
     * @return 新的实体javabean集合
     */
    public List<PanicBuying> findPanicListByPageHelper(String [] selectColumns, PageHelper pageHelper, String params);
    /**
     * 根据SQL语句返回一条数据。
     *
     * @param params
     *            传入条件
     * @return 新的实体javabean
     */
    public PanicBuying getPanicBuyingByParams(String params);
    /**
     * 保存或者修改。
     *
     * @param obj
     *            传入实体javabean
     * @return 新的实体javabean
     */
    public PanicBuying saveOrUpdatePanicBuying(PanicBuying obj);
}
