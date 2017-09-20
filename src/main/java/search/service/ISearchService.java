package search.service;

import org.apache.lucene.queryParser.ParseException;
import org.compass.core.engine.SearchEngineQueryParseException;
import util.other.Pager;

import java.math.BigDecimal;

/**
 * 搜索引擎Service接口类
 *
 * @author mqr
 */
public interface ISearchService {
    /**
     * 使用搜索引擎搜索套餐，得到套餐集合
     *
     * @param pager        分页信息
     * @param selfEmployed 自营标识
     * @return 搜索套餐集合
     * @throws SearchEngineQueryParseException
     * @throws ParseException
     */
    public Pager searchProductInfos(Pager pager, Integer selfEmployed) throws ParseException, SearchEngineQueryParseException;

    /**
     * 使用搜索引擎搜索套餐，得到套餐集合，条件组拼，选择某一分类
     *
     * @param pager         分页对象
     * @param productTypeId 分类ID
     * @param minPrice      最小价格
     * @param maxPrice      最大价格
     * @return 搜索套餐集合 pager.list
     * @throws SearchEngineQueryParseException
     * @throws ParseException
     */
    public Pager searchProductInfos(Pager pager, Integer selfEmployed, Integer productTypeId, BigDecimal minPrice, BigDecimal maxPrice) throws ParseException,
            SearchEngineQueryParseException;
}
