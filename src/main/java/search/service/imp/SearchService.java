package search.service.imp;

import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.lucene.queryParser.QueryParser;
import org.compass.core.*;
import org.compass.core.CompassQuery.SortDirection;
import org.compass.core.CompassQuery.SortPropertyType;
import org.compass.core.CompassQueryBuilder.CompassBooleanQueryBuilder;
import search.service.ISearchService;
import shop.customer.dao.IEvaluateGoodsDao;
import shop.product.pojo.ProductInfo;
import util.other.Pager;
import util.other.Pager.OrderType;
import util.other.Utils;

import java.math.BigDecimal;
import java.math.BigInteger;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 搜索引擎Service接口实现类
 * @author mqr
 */
public class SearchService implements ISearchService {
	// 搜索引擎模板对象
	private CompassTemplate compassTemplate;
	
	private IEvaluateGoodsDao evaluateGoodsDao;
	/**
	 * 使用搜索引擎搜索套餐，得到套餐集合
	 * @param pager
	 *            分页对象
	 * @return 搜索套餐集合 pager.list
	 */
	@SuppressWarnings("unchecked")
	public Pager searchProductInfos(Pager pager, Integer selfEmployed) throws org.apache.lucene.queryParser.ParseException , org.compass.core.engine.SearchEngineQueryParseException {
		Compass compass = compassTemplate.getCompass();//创建compass对象
		CompassSession session = compass.openSession();//打开compassSession
		CompassQueryBuilder queryBuilder = session.queryBuilder();//使用session建立查询
		CompassBooleanQueryBuilder compassBooleanQueryBuilder = queryBuilder.bool();//将queryBuilder转换成多条件查询 ,也叫布尔查询
		compassBooleanQueryBuilder = compassBooleanQueryBuilder//用addMust方法将queryBuilder的条件组合
				.addMust(queryBuilder.alias(ProductInfo.class.getSimpleName()))//指定搜索对象
				.addMust(queryBuilder.spanEq("isPass", "1"))//套餐是否审批
				.addMust(queryBuilder.spanEq("isPutSale", "2"))//套餐是否上架
				.addMust(queryBuilder.spanEq("isShow", "1"))//套餐是否显示
				.addMust(queryBuilder.spanEq("tisPass", "3"))//店铺是否审核通过
				.addMust(queryBuilder.spanEq("tisClose", "0"));//店铺是否关闭
		//是否是自营套餐
		if(Utils.objectIsNotEmpty(selfEmployed)&&selfEmployed==1){
			compassBooleanQueryBuilder.addMust(queryBuilder.spanEq("shopInfoProductType","1"));
		}
		//如果存在空格时，分开解析关键词
		String [] tmepKeyword = pager.getKeyword().split("[\\s]+");
		int tempLength = tmepKeyword.length;
		if(tempLength>0){
			//匹配套餐名称
			for (int i = 0; i < tempLength; i++) {
				String parserKeyword = QueryParser.escape(tmepKeyword[i]);//主要就是这一句把特殊字符都转义，那么lucene就可以识别
				compassBooleanQueryBuilder = compassBooleanQueryBuilder.addMust(queryBuilder.queryString("productFullName:"+ parserKeyword).toQuery());
			}
		}else{//反之，作为整体关键词，匹配套餐名称
			String parserKeyword = QueryParser.escape(pager.getKeyword());//主要就是这一句把特殊字符都转义，那么lucene就可以识别
			compassBooleanQueryBuilder = compassBooleanQueryBuilder.addMust(queryBuilder.queryString("productFullName:"+parserKeyword).toQuery());
		}
		//匹配套餐名称
		CompassQuery compassQuery = compassBooleanQueryBuilder.toQuery();
		if (StringUtils.isEmpty(pager.getOrderBy()) || pager.getOrderType() == null) {//排序条件为空时，默认排序规则：按照更新时间倒序
			compassQuery.addSort("putSaleDate", SortPropertyType.STRING , SortDirection.REVERSE);
		} else {
			if (pager.getOrderType() == OrderType.asc) {//正序排列asc
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "salesPrice")) {//判断价格是否排序asc
					compassQuery.addSort("salesPrice", SortPropertyType.FLOAT);
				}
			} else {//反序排列desc
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "salesPrice")) {//判断价格是否排序desc
					compassQuery.addSort("salesPrice", SortPropertyType.FLOAT, SortDirection.REVERSE);
				}
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "putSaleDate")) {//判断上架时间是否排序desc
					compassQuery.addSort("putSaleDate", SortPropertyType.STRING , SortDirection.REVERSE );
				}
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "totalSales")) {//判断销售量是否排序desc
					compassQuery.addSort("totalSales", SortPropertyType.AUTO , SortDirection.REVERSE );
				}
			}
		}
		CompassHits compassHits = compassQuery.hits();//搜索引擎查询套餐数据结果集
		//返回分页部分套餐集合
		List<ProductInfo> productList = new ArrayList<ProductInfo>();
		Map<String,Object> evaluateMap = new HashMap<String,Object>();
		//返回全部套餐集合
		List<ProductInfo> productAllList = new ArrayList<ProductInfo>();
		int firstResult = (pager.getPageNumber() - 1) * pager.getPageSize();//第一页套餐结果集
		int maxReasults = pager.getPageSize();//最大每页记录数
		int totalCount = compassHits.length();//套餐总数
		//设置页面详情分页页码
		pager.setPageInfo(pager.getPageSize(), totalCount, pager.getPageNumber());
		//分页最大值
		int end = Math.min(totalCount, firstResult + maxReasults);
		for (int i = firstResult; i < end; i++) {//循环遍历每页显示多少套餐
			Object obj = compassHits.data(i);
			ProductInfo productInfo = (ProductInfo) obj;
			//判断关键字是否包含 数字字母组合，如果包含，则不显示高亮，避免出现数字重复问题
			if(!pager.getKeyword().matches(".*?[\\d][a-zA-Z]+.*?")){
				String productFullName = compassHits.highlighter(i).fragment("productFullName");
				if (StringUtils.isNotEmpty(productFullName)){
					productInfo.setProductFullName(productFullName);
				}
			}
			productList.add(productInfo);
		}
		for (int i = 0; i < totalCount; i++) {
			ProductInfo productInfo = (ProductInfo) compassHits.data(i);
			productAllList.add(productInfo);
			
			String productId = String.valueOf(productInfo.getProductId());
			//查看评价数量
			Integer count = evaluateGoodsDao.getCount(" where o.evaluateState=0 and o.productId = "+productId);
			BigInteger bigInteger = new BigInteger("0");
			if(count!=0){
				//好评比例
				Integer countGood = evaluateGoodsDao.getCount(" where o.level = 1 and o.evaluateState=0 and o.productId = "+productId);
				BigDecimal goodP = new BigDecimal(countGood).divide(new BigDecimal(count),2,BigDecimal.ROUND_CEILING).multiply(new BigDecimal(100));
				bigInteger = goodP.toBigInteger();
			}
			evaluateMap.put("countGood_"+productId, count);
			evaluateMap.put("goodLevel_"+productId, bigInteger);
			
		}
		//session关闭捕获异常
		try {
			if(Utils.objectIsEmpty(session)){
				session.close();
			}
		}catch (Exception e) {
			// String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} finally {
			if(Utils.objectIsEmpty(session)){
				try {
					if(Utils.objectIsEmpty(session)){
						session.close();
					}
				}catch (Exception e) {
					// String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
				} finally {
					session = null;
				}
			}
		}
		pager.setList(productList);
		pager.setListAll(productAllList);
		pager.setTotalCount(totalCount);
		pager.setEvaluateMap(JSONObject.fromObject(evaluateMap));
		return pager;
	}
	/**
	 * 使用搜索引擎搜索套餐，得到套餐集合，条件组拼，选择某一分类
	 * @param pager
	 *            分页对象
	 * @param productTypeId
	 *            分类ID
	 * @param minPrice
	 *            最小价格
	 * @param maxPrice
	 *            最大价格
	 * @return 搜索套餐集合 pager.list
	 */
	@SuppressWarnings("unchecked")
	public Pager searchProductInfos(Pager pager, Integer selfEmployed, Integer productTypeId, BigDecimal minPrice, BigDecimal maxPrice) throws org.apache.lucene.queryParser.ParseException , org.compass.core.engine.SearchEngineQueryParseException  {
		Compass compass = compassTemplate.getCompass();
		CompassSession session = compass.openSession();
		CompassQueryBuilder queryBuilder = session.queryBuilder();
		CompassBooleanQueryBuilder compassBooleanQueryBuilder = queryBuilder.bool();//多条件查询
		//需要追加条件
		compassBooleanQueryBuilder = compassBooleanQueryBuilder
				.addMust(queryBuilder.alias(ProductInfo.class.getSimpleName()))//指定搜索对象
				.addMust(queryBuilder.spanEq("isPass", "1"))//套餐是否审批
				.addMust(queryBuilder.spanEq("isPutSale", "2"))//套餐是否上架
				.addMust(queryBuilder.spanEq("isShow", "1"))//套餐是否显示
				.addMust(queryBuilder.spanEq("tisPass", "3"))//店铺是否审核通过
				.addMust(queryBuilder.spanEq("tisClose", "0"));//店铺是否关闭
		//是否是自营套餐
		if(Utils.objectIsNotEmpty(selfEmployed)&&selfEmployed==1){
			compassBooleanQueryBuilder.addMust(queryBuilder.spanEq("shopInfoProductType","1"));
		}
		//如果存在空格时，分开解析关键词
		String [] tmepKeyword = pager.getKeyword().split("[\\s]+");
		int tempLength = tmepKeyword.length;
		if(tempLength>0){
			//匹配套餐名称
			for (int i = 0; i < tempLength; i++) {
				String parserKeyword = QueryParser.escape(tmepKeyword[i]);//主要就是这一句把特殊字符都转义，那么lucene就可以识别
				compassBooleanQueryBuilder = compassBooleanQueryBuilder.addMust(queryBuilder.queryString("productFullName:"+ parserKeyword).toQuery());
			}
		}else{//反之，作为整体关键词，匹配套餐名称
			String parserKeyword = QueryParser.escape(pager.getKeyword());//主要就是这一句把特殊字符都转义，那么lucene就可以识别
			compassBooleanQueryBuilder = compassBooleanQueryBuilder.addMust(queryBuilder.queryString("productFullName:"+parserKeyword).toQuery());
		}
		if(Utils.objectIsNotEmpty(productTypeId)){//分类ID不等于空
			compassBooleanQueryBuilder = compassBooleanQueryBuilder.addMust(queryBuilder.spanEq("categoryLevel1", productTypeId));
		}
		CompassQuery compassQuery = compassBooleanQueryBuilder.toQuery();//匹配套餐名称
		if (StringUtils.isEmpty(pager.getOrderBy()) || pager.getOrderType() == null) {//排序条件为空时，默认排序规则：按照更新时间倒序
			compassQuery.addSort("putSaleDate", SortPropertyType.STRING , SortDirection.REVERSE);
		} else {
			if (pager.getOrderType() == OrderType.asc) {//正序排列asc
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "salesPrice")) {//判断价格是否排序asc
					compassQuery.addSort("salesPrice", SortPropertyType.FLOAT);
				}
			} else {//反序排列desc
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "salesPrice")) {//判断价格是否排序desc
					compassQuery.addSort("salesPrice", SortPropertyType.FLOAT, SortDirection.REVERSE);
				}
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "putSaleDate")) {//判断上架时间是否排序desc
					compassQuery.addSort("putSaleDate", SortPropertyType.STRING , SortDirection.REVERSE );
				}
				if(StringUtils.equalsIgnoreCase(pager.getOrderBy(), "totalSales")) {//判断销售量是否排序desc
					compassQuery.addSort("totalSales", SortPropertyType.AUTO , SortDirection.REVERSE );
				}
			}
		}
		CompassHits compassHits = compassQuery.hits();//搜索引擎查询套餐数据结果集
		//返回分页部分套餐集合
		List<ProductInfo> productList = new ArrayList<ProductInfo>();
		Map<String,Object> evaluateMap = new HashMap<String,Object>();
		//返回全部套餐集合
		List<ProductInfo> productAllList = new ArrayList<ProductInfo>();
		int firstResult = (pager.getPageNumber() - 1) * pager.getPageSize();//第一页套餐结果集
		int maxReasults = pager.getPageSize();//最大每页记录数
		int totalCount = compassHits.length();//套餐总数
		/*
		 * 价格搜索注释
		 * 取价格在minPric-maxPric中间的套餐
		 */
		if(Utils.objectIsNotEmpty(minPrice)&& Utils.objectIsNotEmpty(maxPrice)){//如果价格不为空，进行价格筛选
			for (int i = 0; i < totalCount; i++) {//循环遍历所有套餐
				ProductInfo productInfo = (ProductInfo) compassHits.data(i);
				//进行价格的筛选
				BigDecimal salesPrice = productInfo.getSalesPrice();
				BigDecimal min = minPrice;
				BigDecimal max = maxPrice;
				if(salesPrice.compareTo(min)>=0 && salesPrice.compareTo(max)<=0){
					//判断关键字是否包含 数字字母组合，如果包含，则不显示高亮，避免出现数字重复问题
					if(!pager.getKeyword().matches(".*?[\\d][a-zA-Z]+.*?")){
						String productFullName = compassHits.highlighter(i).fragment("productFullName");
						if (StringUtils.isNotEmpty(productFullName)){
							productInfo.setProductFullName(productFullName);
						}
					}
					//添加此套餐
					productAllList.add(productInfo);
				}
			}
			totalCount = productAllList.size();//最终的套餐总数
			//分页最大值
			int end = Math.min(totalCount, firstResult + maxReasults);
			for (int i = firstResult; i < end; i++) {//循环遍历每页显示多少套餐
				ProductInfo productInfo = (ProductInfo) productAllList.get(i);
				productList.add(productInfo);
				String productId = String.valueOf(productInfo.getProductId());
				//查看评价数量
				Integer count = evaluateGoodsDao.getCount(" where o.evaluateState=0 and o.productId = "+productId);
				BigInteger bigInteger = new BigInteger("0");
				if(count!=0){
					//好评比例
					Integer countGood = evaluateGoodsDao.getCount(" where o.level = 1 and o.evaluateState=0 and o.productId = "+productId);
					BigDecimal goodP = new BigDecimal(countGood).divide(new BigDecimal(count),2,BigDecimal.ROUND_CEILING).multiply(new BigDecimal(100));
					bigInteger = goodP.toBigInteger();
				}
				evaluateMap.put("countGood_"+productId, count);
				evaluateMap.put("goodLevel_"+productId, bigInteger);
			}
		}else{
			for (int i = 0; i < totalCount; i++) {//循环遍历所有套餐
				ProductInfo productInfo = (ProductInfo) compassHits.data(i);
				//添加此套餐
				productAllList.add(productInfo);
			}
			//分页最大值
			int end = Math.min(totalCount, firstResult + maxReasults);
			for (int i = firstResult; i < end; i++) {//循环遍历每页显示多少套餐
				//取出查询结果高亮显示
				ProductInfo productInfo = (ProductInfo) compassHits.data(i);
				//判断关键字是否包含 数字字母组合，如果包含，则不显示高亮，避免出现数字重复问题
				if(!pager.getKeyword().matches(".*?[\\d][a-zA-Z]+.*?")){
					String productFullName = compassHits.highlighter(i).fragment("productFullName");
					if (StringUtils.isNotEmpty(productFullName)){
						productInfo.setProductFullName(productFullName);
					}
				}	
				productList.add(productInfo);
				String productId = String.valueOf(productInfo.getProductId());
				//查看评价数量
				Integer count = evaluateGoodsDao.getCount(" where o.evaluateState=0 and o.productId = "+productId);
				BigInteger bigInteger = new BigInteger("0");
				if(count!=0){
					//好评比例
					Integer countGood = evaluateGoodsDao.getCount(" where o.level = 1 and o.evaluateState=0 and o.productId = "+productId);
					BigDecimal goodP = new BigDecimal(countGood).divide(new BigDecimal(count),2,BigDecimal.ROUND_CEILING).multiply(new BigDecimal(100));
					bigInteger = goodP.toBigInteger();
				}
				evaluateMap.put("countGood_"+productId, count);
				evaluateMap.put("goodLevel_"+productId, bigInteger);
			}
		}
		//设置页面详情分页页码
		pager.setPageInfo(pager.getPageSize(), totalCount, pager.getPageNumber());
		//session关闭捕获异常
		try {
			if(Utils.objectIsEmpty(session)){
				session.close();
			}
		}catch (Exception e) {
			// String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		} finally {
			if(Utils.objectIsEmpty(session)){
				try {
					if(Utils.objectIsEmpty(session)){
						session.close();
					}
				}catch (Exception e) {
					// String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
				} finally {
					session = null;
				}
			}
		}
		pager.setList(productList);//添加分页过后的套餐
		pager.setListAll(productAllList);//添加全部的套餐
		pager.setTotalCount(totalCount);//添加套餐总数
		pager.setEvaluateMap(JSONObject.fromObject(evaluateMap));
		return pager;
	}
	//setter getter
	public CompassTemplate getCompassTemplate() {
		return compassTemplate;
	}
	public void setCompassTemplate(CompassTemplate compassTemplate) {
		this.compassTemplate = compassTemplate;
	}
	public void setEvaluateGoodsDao(IEvaluateGoodsDao evaluateGoodsDao) {
		this.evaluateGoodsDao = evaluateGoodsDao;
	}
	
}