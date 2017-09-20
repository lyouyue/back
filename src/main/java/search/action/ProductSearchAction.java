package search.action;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import search.service.ISearchService;
import shop.customer.service.IEvaluateGoodsService;
import shop.product.pojo.*;
import shop.product.service.*;
import util.action.BaseAction;
import util.json.FastJsonUtils;
import util.other.Escape;
import util.other.Pager;
import util.other.Pager.OrderType;
import util.other.Utils;

import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.*;
/**
 * getBrandsAndProductInfos - 品牌套餐Action类
 */

/**
 * @author CTR
 */
@SuppressWarnings("serial")
public class ProductSearchAction extends BaseAction {
    private Logger logger = Logger.getLogger(ProductSearchAction.class);
    private IProductInfoService productInfoService;//套餐信息Service
    private IProductTypeService productTypeService;//分类Service
    private List<ProductType> productTypeList = new ArrayList<ProductType>();
    private List<Map> productTypeList1;
    @SuppressWarnings("rawtypes")
    private List productInfoList = new ArrayList();//非顶置套餐集合
    @SuppressWarnings("rawtypes")
    private List productInfoList1 = new ArrayList();//顶置套餐集合
    private String prodTypeNames = "";
    private ProductType productType;//套餐分类
    private Integer productTypeId;//套餐分类ID
    private String level = "1";
    private Integer pageIndex = 1;//当前页
    private Integer pageSize = 20;//分页-每一页显示的个数
    private BigDecimal minPrice;//价格
    private BigDecimal maxPrice;//价格范围：minPrice-maxPrice之间
    private String orderBy;//标记(用于排序)
    private Integer selfEmployed;//是否选择自营套餐
    /**
     * 品牌service
     **/
    private IBrandService brandService;
    private IBrandTypeService brandTypeService;
    private List<Map> brandList = new ArrayList<Map>();//品牌列表集合(下方图片展示)
    @SuppressWarnings("rawtypes")
    private List<Map> brandList2 = new ArrayList<Map>();//品牌列表集合(查询条件)
    /**
     * 用于参数的回显
     **/
    private Map<String, Object> mapParams = new LinkedHashMap<String, Object>();
    /**
     * 套餐hql语句select部分
     **/
    private StringBuffer hqlSelect = new StringBuffer(" SELECT distinct a.goods as goods,a.productName as productName,a.productFullName as productFullName, "
            + "a.productId as productId, a.describle as describle,a.marketPrice as marketPrice,a.salesPrice as salesPrice,"
            + "a.logoImg as logoImg,c.shopName as shopName,a.brandId as brandId,a.shopInfoId as shopInfoId "
            + "FROM ProductInfo a,ShopInfo c ");
    /**
     * 套餐hql语句where部分
     **/
    private StringBuffer hqlWhere = new StringBuffer(" WHERE  a.shopInfoId=c.shopInfoId and a.isPass=1 and a.isPutSale=2 and c.isPass=3 and c.isClose=0 and a.isShow=1 and a" +
            ".isTop=0");
    /**
     * 套餐的总条数select部分
     **/
    private StringBuffer coutHql = new StringBuffer(" SELECT count(a.productId)  FROM ProductInfo a,ShopInfo c ");
    /**
     * 分类ids
     **/
    private String categoryIds = "";
    private String brandParams;
    /**
     * 全文检索定义所需属性
     **/
    @SuppressWarnings("rawtypes")
    private List<Map> productToBrandList = new ArrayList<Map>();//根据套餐查找品牌列表集合(查询条件)
    @SuppressWarnings("rawtypes")
    private List<Map> productToTypeList = new ArrayList<Map>();//根据套餐查找分类列表集合(查询条件)
    private Pager pager;//定义pager对象，保存分页和分页查询集合
    private String orderType;//排序字段(套餐排序)
    private String viewType;//展示字段(套餐展示方式：表格列表，图片)
    /*****
     * 判断是否是4级节点
     ******/
    private Boolean isTrue = true;//如果是false则不是4级节点
    /**
     * 根据点击的品牌查询套餐
     **/
    private String brandId;
    /***
     * 规格
     ***/
    private ISpecificationService specificationService;
    /**
     * 指定分类下的规格
     **/
    List<Specification> specificationList = new ArrayList<Specification>();
    private ISpecificationValueService specificationValueService;
    private List<SpecificationValue> specificationValueList;
    private String specificationValueId;
    private String attrValueId;
    private String attrIds;
    /**
     * 价格
     **/
    private String before;
    private String after;
    /**
     * 搜索引擎service
     **/
    private ISearchService searchService;
    private IEvaluateGoodsService evaluateGoodsService;

    /**
     * 全局搜索查询套餐图片
     * 查询套餐需要满足的条件：isTop=0(默认非置顶)、isPass=1(默认审核通过)、isPutSale=2(默认上架)、isShow=1(套餐显示)
     */
    public void search() throws Exception {
        Map<String, Object> params = new HashMap<>();
        Integer resultViewType = 1;//0无结果;1有结果,列表;2有结果缩略图
        //推荐品牌
        List<Brand> brandList = brandService.findSome(0, 5, "where o.isShow=1 and o.isRecommend=1 order by o.sortCode");
        String keyword = pager.getKeyword();
        if (!StringUtils.isEmpty(keyword)) {
            keyword = Escape.unescape((keyword.trim()));
            if (Utils.stringIsNotEmpty(keyword)) pager.setKeyword(keyword);
        }
        //对象如果为空
        if (pager == null) {
            pager = new Pager();
            //搜索结果为空，随机查询套餐集合
            resultViewType = 0;
        } else {
            if (StringUtils.isNotEmpty(pager.getKeyword())) {
                String str = pager.getKeyword().trim();
                //过滤特殊字符，包括[]符合，去除关键词中间空格，便于搜索引擎分词器进行优化分词
//				str = str.replaceAll("[()\\[\\]\\|~|$|^|<|>|\\||\\+|=?]*", "");
                if (Utils.objectIsNotEmpty(str)) {
                    pager.setKeyword(str);//清除首尾空格
                } else {
                    //替换特殊字符为空
                    resultViewType = 0;
                }
            } else {
                //搜索结果为空，随机查询套餐集合
                resultViewType = 0;
            }
        }
        pager.setPageSize(12);//设置默认每页显示多少条
        if (StringUtils.equalsIgnoreCase(orderType, "salesPriceAsc")) {//判断价格是否排序asc
            pager.setOrderBy("salesPrice");
            pager.setOrderType(OrderType.asc);
        } else if (StringUtils.equalsIgnoreCase(orderType, "salesPriceDesc")) {//判断价格是否排序desc
            pager.setOrderBy("salesPrice");
            pager.setOrderType(OrderType.desc);
        } else if (StringUtils.equalsIgnoreCase(orderType, "putSaleDateDesc")) {//判断上架时间是否排序desc
            pager.setOrderBy("putSaleDate");
            pager.setOrderType(OrderType.desc);
        } else if (StringUtils.equalsIgnoreCase(orderType, "totalSalesDesc")) {//判断销售量是否排序desc
            pager.setOrderBy("totalSales");
            pager.setOrderType(OrderType.desc);
        } else {//排序条件为空时，默认排序规则：按照更新时间倒序
            pager.setOrderBy("putSaleDate");
            pager.setOrderType(OrderType.desc);
        }
        try {
            //根据某一分类搜索
            if (Utils.objectIsEmpty(productTypeId) && Utils.objectIsEmpty(minPrice) && Utils.objectIsEmpty(maxPrice)) {
                //根据分页内容，全文检索套餐，返回套餐检索集合 pager.getList()
                pager = searchService.searchProductInfos(pager, selfEmployed);
            } else {
                //根据分页内容，查询条件，全文检索套餐，返回套餐检索集合 pager.getList()
                pager = searchService.searchProductInfos(pager, selfEmployed, productTypeId, minPrice, maxPrice);
            }
        } catch (org.apache.lucene.queryParser.ParseException e) {
            resultViewType = 0;
            logger.error("抛出特殊字符异常");//抛出特殊字符异常转发到无结果
        } catch (org.compass.core.engine.SearchEngineQueryParseException e) {
            resultViewType = 0;
            logger.error("抛出特殊字符异常");//抛出特殊字符异常转发到无结果
        }
        //转换分页中套餐集合
        productInfoList = pager.getList();
        if (Utils.collectionIsNotEmpty(productInfoList)) {//搜索套餐集合不为空
            List productListAll = pager.getListAll();//取出查询的全部套餐信息
            //根据全部套餐ID查询套餐对应分类信息
            productToTypeList = productInfoService.getProductToTypeInfo(productListAll);
            //根据全部套餐ID查询套餐对应品牌信息
            productToBrandList = productInfoService.getProductToBrandInfo(productListAll);
            //查询分类下的推荐品牌
            ProductInfo productInfo = (ProductInfo) productInfoList.get(0);
            //如果套餐集合不为空 则统计套餐种类数量
            for (Object o : productListAll) {
                String goodsCountHql = "select count(a.goods) as goodsCount from ProductInfo a where a.goods=" + ((ProductInfo) o).getGoods() + " and a.isPutSale=2 and a.isPass=1";
                int goodsCount = productInfoService.getCountByHQL(goodsCountHql);
                ((ProductInfo) o).setGoodsCount(goodsCount);
            }
        } else {
            //搜索结果为空，随机查询套餐集合
            productInfoList = productInfoService.findRandomProductInfoList();
            resultViewType = 1;
        }
        if (StringUtils.equalsIgnoreCase(viewType, "tableType")) {
            resultViewType = 1;
        } else {
            resultViewType = 2;
        }
        params.put("totalCount", pager.getPageCount());
        params.put("selfEmployed", selfEmployed);
        params.put("keyword", keyword);
        params.put("viewType", viewType);
        params.put("brandList", brandList);
        params.put("productTypeId", productTypeId);
        params.put("minPrice", minPrice);
        params.put("maxPrice", maxPrice);
        params.put("orderType", orderType);
        params.put("productInfoList", productInfoList);
        params.put("resultView", resultViewType);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(FastJsonUtils.collectToString(params));
        out.flush();
        out.close();
    }


    public void setProductInfoService(IProductInfoService productInfoService) {
        this.productInfoService = productInfoService;
    }

    public String getOrderBy() {
        return orderBy;
    }

    public void setOrderBy(String orderBy) {
        this.orderBy = orderBy;
    }

    public void setProductTypeService(IProductTypeService productTypeService) {
        this.productTypeService = productTypeService;
    }

    public ProductType getProductType() {
        return productType;
    }

    public void setProductType(ProductType productType) {
        this.productType = productType;
    }

    public List<ProductType> getProductTypeList() {
        return productTypeList;
    }

    public void setProductTypeList(List<ProductType> productTypeList) {
        this.productTypeList = productTypeList;
    }

    @SuppressWarnings("rawtypes")
    public List getProductInfoList() {
        return productInfoList;
    }

    @SuppressWarnings("rawtypes")
    public void setProductInfoList(List productInfoList) {
        this.productInfoList = productInfoList;
    }

    @SuppressWarnings("rawtypes")
    public List getProductInfoList1() {
        return productInfoList1;
    }

    @SuppressWarnings("rawtypes")
    public void setProductInfoList1(List productInfoList1) {
        this.productInfoList1 = productInfoList1;
    }

    public Integer getProductTypeId() {
        return productTypeId;
    }

    public void setProductTypeId(Integer productTypeId) {
        this.productTypeId = productTypeId;
    }

    public Map<String, Object> getMapParams() {
        return mapParams;
    }

    public void setMapParams(Map<String, Object> mapParams) {
        this.mapParams = mapParams;
    }

    public Integer getPageIndex() {
        return pageIndex;
    }

    public void setPageIndex(Integer pageIndex) {
        this.pageIndex = pageIndex;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    @SuppressWarnings("rawtypes")
    public List<Map> getProductToBrandList() {
        return productToBrandList;
    }

    @SuppressWarnings("rawtypes")
    public void setProductToBrandList(List<Map> productToBrandList) {
        this.productToBrandList = productToBrandList;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(BigDecimal minPrice) {
        this.minPrice = minPrice;
    }

    public BigDecimal getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(BigDecimal maxPrice) {
        this.maxPrice = maxPrice;
    }

    @SuppressWarnings("rawtypes")
    public List<Map> getProductToTypeList() {
        return productToTypeList;
    }

    @SuppressWarnings("rawtypes")
    public void setProductToTypeList(List<Map> productToTypeList) {
        this.productToTypeList = productToTypeList;
    }

    public Pager getPager() {
        return pager;
    }

    public void setPager(Pager pager) {
        this.pager = pager;
    }

    public String getOrderType() {
        return orderType;
    }

    public void setOrderType(String orderType) {
        this.orderType = orderType;
    }

    public String getViewType() {
        return viewType;
    }

    public void setViewType(String viewType) {
        this.viewType = viewType;
    }

    public String getProdTypeNames() {
        return prodTypeNames;
    }

    public void setProdTypeNames(String prodTypeNames) {
        this.prodTypeNames = prodTypeNames;
    }

    public List<Map> getBrandList() {
        return brandList;
    }

    public void setBrandList(List<Map> brandList) {
        this.brandList = brandList;
    }

    @SuppressWarnings("rawtypes")
    public List<Map> getBrandList2() {
        return brandList2;
    }

    @SuppressWarnings("rawtypes")
    public void setBrandList2(List<Map> brandList2) {
        this.brandList2 = brandList2;
    }

    public void setBrandService(IBrandService brandService) {
        this.brandService = brandService;
    }

    public String getBrandParams() {
        return brandParams;
    }

    public void setBrandParams(String brandParams) {
        this.brandParams = brandParams;
    }

    public Boolean getIsTrue() {
        return isTrue;
    }

    public void setIsTrue(Boolean isTrue) {
        this.isTrue = isTrue;
    }

    public String getBrandId() {
        return brandId;
    }

    public void setBrandId(String brandId) {
        this.brandId = brandId;
    }

    public void setSpecificationService(ISpecificationService specificationService) {
        this.specificationService = specificationService;
    }

    public void setSpecificationValueService(
            ISpecificationValueService specificationValueService) {
        this.specificationValueService = specificationValueService;
    }

    public List<SpecificationValue> getSpecificationValueList() {
        return specificationValueList;
    }

    public void setSpecificationValueList(
            List<SpecificationValue> specificationValueList) {
        this.specificationValueList = specificationValueList;
    }

    public List<Specification> getSpecificationList() {
        return specificationList;
    }

    public void setSpecificationList(List<Specification> specificationList) {
        this.specificationList = specificationList;
    }

    public void setBrandTypeService(IBrandTypeService brandTypeService) {
        this.brandTypeService = brandTypeService;
    }

    public String getSpecificationValueId() {
        return specificationValueId;
    }

    public void setSpecificationValueId(String specificationValueId) {
        this.specificationValueId = specificationValueId;
    }

    public List<Map> getProductTypeList1() {
        return productTypeList1;
    }

    public void setProductTypeList1(List<Map> productTypeList1) {
        this.productTypeList1 = productTypeList1;
    }

    public void setSearchService(ISearchService searchService) {
        this.searchService = searchService;
    }


    public String getAttrValueId() {
        return attrValueId;
    }

    public void setAttrValueId(String attrValueId) {
        this.attrValueId = attrValueId;
    }

    public String getAttrIds() {
        return attrIds;
    }

    public void setAttrIds(String attrIds) {
        this.attrIds = attrIds;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getBefore() {
        return before;
    }

    public void setBefore(String before) {
        this.before = before;
    }

    public String getAfter() {
        return after;
    }

    public void setAfter(String after) {
        this.after = after;
    }

    public void setEvaluateGoodsService(IEvaluateGoodsService evaluateGoodsService) {
        this.evaluateGoodsService = evaluateGoodsService;
    }

    public Integer getSelfEmployed() {
        return selfEmployed;
    }

    public void setSelfEmployed(Integer selfEmployed) {
        this.selfEmployed = selfEmployed;
    }
}
