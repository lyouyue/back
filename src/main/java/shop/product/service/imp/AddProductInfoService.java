package shop.product.service.imp;
import java.io.File;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang.StringUtils;

import shop.product.dao.IBrandDao;
import shop.product.dao.IProductAttrIndexDao;
import shop.product.dao.IProductImgDao;
import shop.product.dao.IProductInfoDao;
import shop.product.dao.IProductSpecificationValueDao;
import shop.product.dao.ISpecificationValueDao;
import shop.product.pojo.Brand;
import shop.product.pojo.ProductAttrIndex;
import shop.product.pojo.ProductImg;
import shop.product.pojo.ProductInfo;
import shop.product.pojo.ProductSpecification;
import shop.product.pojo.ProductSpecificationValue;
import shop.product.pojo.SpecificationValue;
import shop.product.service.IAddProductInfoService;
import shop.store.dao.IShopInfoDao;
import shop.store.dao.IShopProCateClassDao;
import shop.store.pojo.ShopInfo;
import shop.store.pojo.ShopProCateClass;
import shop.tags.dao.IShopProductTradeSituationTagDao;
import shop.tags.pojo.ShopProductTradeSituationTag;
import util.other.CopyObject;
import util.other.Utils;
import util.service.BaseService;
import util.upload.ImageFileUploadUtil;
import util.upload.ImageUtil;
/**
 * 套餐Service接口实现类
 * @author 
 *
 */
public class AddProductInfoService extends BaseService  <ProductInfo> implements IAddProductInfoService{
	private IShopInfoDao shopInfoDao;
	private IProductInfoDao productInfoDao;
	private IProductSpecificationValueDao productSpecificationValueDao;//套餐和规格值中间表Service 
	private IProductImgDao productImgDao;//套餐图片
	private IShopProCateClassDao shopProCateClassDao;//套餐和店铺内部套餐分类关系
	private ISpecificationValueDao specificationValueDao;//规格值Dao
	private IShopProductTradeSituationTagDao shopProductTradeSituationTagDao;//套餐标签关联表Dao
	private IProductAttrIndexDao productAttrIndexDao;
	private IBrandDao brandDao;
	/**套餐规格中间表实体类**/
	private List<ProductSpecification> productSpecificationList;
	/**套餐规格值中间表**/ 
	private List<ProductSpecificationValue>productSpecificationValueList;
	/**套餐图片**/
	private List<ProductImg> productImgList;
	/**套餐和店铺内部套餐分类关系**/
	private List<ShopProCateClass> shopProCateClassList;
	/**套餐标签关联表**/
	private List<ShopProductTradeSituationTag> shopProductTradeSituationTagList;
	/**套餐扩展属性值 - 类描述信息**/
	private List<ProductAttrIndex> productAttrIndexList;
	
	/**套餐规格中间表实体类**/
	private ProductSpecification productSpecification;
	/**套餐规格值中间表**/ 
	private ProductSpecificationValue productSpecificationValue;
	/**套餐图片**/
	private ProductImg productImg;
	/**套餐和店铺内部套餐分类关系**/
	private ShopProCateClass shopProCateClass;
	/**套餐标签关联表**/
	private ShopProductTradeSituationTag shopProductTradeSituationTag;
	/**套餐扩展属性值 - 类描述信息**/
	private ProductAttrIndex productAttrIndex;
	
	@Override
	public boolean saveOrUpdateProduct(ProductInfo productInfo,
			Integer shopProCategoryId) {
		boolean isFlag = false;
		productInfoDao.saveOrUpdateObject(productInfo);
		ShopProCateClass shopProCateClass = shopProCateClassDao.get(" where o.productId="+productInfo.getProductId());
		if(Utils.objectIsEmpty(shopProCateClass)){
			shopProCateClass = new ShopProCateClass();
			shopProCateClass.setProductId(productInfo.getProductId());
			shopProCateClass.setShopProCategoryId(shopProCategoryId);
			ShopProCateClass shopProCateClassNew =shopProCateClassDao.saveObject(shopProCateClass);
			if(Utils.objectIsNotEmpty(shopProCateClassNew)){
				isFlag = true;
			}
		}else{
			isFlag = shopProCateClassDao.updateBySQL("update shop_shopprocateclass set shopProCategoryId="+shopProCategoryId+" where productId="+productInfo.getProductId());
		}
		return isFlag;
	}
	/**
	 * 添加套餐没有规格
	 * @param shopProCategoryId店铺内部分类
	 * @param productInfo套餐信息
	 * @param listProductImage套餐图片
	 * @param fileUrlConfig上传图片的配置文件
	 * @param listProductUploadImgs上传图片路径
	 * @param listProductUploadImgsFileName上传图片名称
	 */
	@SuppressWarnings("rawtypes")
	public void saveOrUpdateProductInfo(String shopProCategoryId,ProductInfo productInfo,List<ProductImg> listProductImage,Map fileUrlConfig,List<File> listProductUploadImgs,List<String>  listProductUploadImgsFileName){
		try {
			productInfo.setCreateDate(new Date());
			productInfo.setUpdateDate(new Date());
			productInfo.setPutSaleDate(new Date());
			productInfo.setProductFullName(productInfo.getProductName());
			productInfo = productInfoDao.saveOrUpdateObject(productInfo);
			for(int i=0;i<listProductImage.size();i++){
					ProductImg productImg = new ProductImg();
					productImg=listProductImage.get(i);
					productImg.setProductId(productInfo.getProductId());
					productImgDao.saveOrUpdateObject(productImg);
			}
			//保存套餐和店铺内部套餐分类的关系
			ShopProCateClass spcc = new ShopProCateClass();
			spcc.setShopProCategoryId(Integer.parseInt(shopProCategoryId));
			spcc.setProductId(productInfo.getProductId());
			shopProCateClassDao.saveOrUpdateObject(spcc);
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	/**
	 * 根据多条的规格和规格值组，生成多个套餐
	 * @throws Exception 
	 */
	@SuppressWarnings("rawtypes")
	public void saveOrUpdateListProductInfo(String shopProCategoryId,ProductInfo productInfo,String parameters,List<ProductImg> listProductImage, Map fileUrlConfig,List<File> listProductUploadImgs,List<String>  listProductUploadImgsFileName,JSONArray jsonArray,List<ProductAttrIndex> paiList){
		//重新构建套餐名称（带品牌的）
		if(productInfo.getBrandId()!=1){
			Brand brand = brandDao.get(" where o.brandId="+productInfo.getBrandId());
			productInfo.setProductName(brand.getBrandName()+" "+productInfo.getProductName());
		}
		//SKU
		String sku = null;
		String[] selectColumns = {"sku","productId"};
		List<ProductInfo> list = productInfoDao.findSome(selectColumns, 0, 1, " order by o.productId desc");
		if(list!=null&&list.size()>0){
			sku =util.other.SKUUtilityClass.getGeneratedSKU(list.get(0).getSku());
		}else{
			sku =util.other.SKUUtilityClass.getGeneratedSKU(null);
		}
		try {
			productInfo.setIsShow(0);//0：不显示， 1：显示；
			//添加套餐的规格和规格值
			if(parameters!=null && !"".equals(parameters)){
				String[] oneSplit = parameters.split(",");//根据规格组拼生成一个新套餐的规格组
				//更改套餐在列表显示的状态
				Integer k = 0;
				for(int i =0;i<oneSplit.length;i++){
					if(i!=0){
						sku =util.other.SKUUtilityClass.getGeneratedSKU(sku);
					}
					productInfo.setSku(sku);
					/*if(k>0){
						productInfo.setIsShow(0);
					}*/
					k++;
					// specification_89=266&specification_1619=6268@
					// marketPrice=1&salesPrice=1&storeNumber=1
					String[] oneFrontSplit = oneSplit[i].split("@");//把一个新的套餐规格组解析成规格对应规格值
					String[] secSplit = oneFrontSplit[0].split("&");//把一个新的套餐规格组解析成规格对应规格值
					String[] paramSplit = oneFrontSplit[1].split("&");//套餐的价格、库存
					//复制套餐基本信息
					ProductInfo productInfoCopy = null;
					//复制套餐信息
					productInfoCopy = (ProductInfo) new CopyObject().copy(productInfo);
					productInfoCopy = (ProductInfo) productInfoDao.saveOrUpdateObject(productInfoCopy);//复制保存套餐
					if(Utils.stringIsNotEmpty(shopProCategoryId)){
						ShopProCateClass spcc = new ShopProCateClass();
						spcc.setProductId(productInfoCopy.getProductId());
						spcc.setShopProCategoryId(Integer.parseInt(shopProCategoryId));
						shopProCateClassDao.saveOrUpdateObject(spcc);
					}
					for(ProductImg pi:listProductImage){
						ProductImg productImg = new ProductImg();
						productImg.setLarge(pi.getLarge());
						productImg.setMedium(pi.getMedium());
						productImg.setOrders(pi.getOrders());
						productImg.setSource(pi.getSource());
						productImg.setThumbnail(pi.getThumbnail());
						productImg.setTitle(pi.getTitle());
						productImg.setProductId(productInfoCopy.getProductId());
						productImgDao.saveOrUpdateObject(productImg);
					}
					StringBuffer sb = new StringBuffer();
					sb.append(productInfoCopy.getProductName()+" [");
					//for(String ss : secSplit){
					for(int s=0;s<secSplit.length;s++){
						String[] thirSplit = secSplit[s].split("=");//把规格和规格值分开
						String[] fourSplit = thirSplit[0].split("_");//解析规格前缀，如：specification_1
						if("kucun".equals(thirSplit[0])){//库存标识
							productInfoCopy.setStoreNumber(util.other.Utils.parseInt(thirSplit[1], 0));
							continue;
						}else if("bianhao".equals(thirSplit[0])){//编号标识
							productInfoCopy.setProductCode(thirSplit[1]);
							continue;
						}
						/**不同套餐的价格和库存 设置begin**/
						BigDecimal marketPrice = new BigDecimal(0);
						BigDecimal salesPrice = new BigDecimal(0);
						Integer storeNumber = 0;
						for(int p=0 ;p<paramSplit.length;p++){
							String[] paramSecSplit = paramSplit[p].split("=");//把字段和字段值分开  marketPrice=1&salesPrice=1&storeNumber=1
							if("marketPrice".equals(paramSecSplit[0])){
								marketPrice = new BigDecimal(paramSecSplit[1]) ;
							}else if("salesPrice".equals(paramSecSplit[0])){
								salesPrice = new BigDecimal(paramSecSplit[1]) ;
							}else if("storeNumber".equals(paramSecSplit[0])){
								storeNumber = Integer.valueOf(paramSecSplit[1]);
							}
						}
						productInfoCopy.setMarketPrice(marketPrice);//市场价
						productInfoCopy.setSalesPrice(salesPrice);//销售价
						productInfoCopy.setStoreNumber(storeNumber);//库存
						/**不同套餐的价格和库存 设置end**/
						//规格值
						ProductSpecificationValue productSpecificationValue = new ProductSpecificationValue();
						productSpecificationValue.setProductId(productInfoCopy.getProductId());
						//规格值id
						productSpecificationValue.setSpecificationValueId(Integer.parseInt(thirSplit[1]));
						//当前分组号
						productSpecificationValue.setGoodId(productInfoCopy.getGoods());
						//规格id
						productSpecificationValue.setSpecificationId(Integer.parseInt(fourSplit[1]));
						productSpecificationValueDao.saveOrUpdateObject(productSpecificationValue);
						SpecificationValue sv = (SpecificationValue) specificationValueDao.get(" where o.specificationValueId='"+thirSplit[1]+"'");
						sb.append(sv.getName()+",");
					}
					sb.deleteCharAt(sb.lastIndexOf(","));
					sb.append("]");
					productInfoCopy.setProductFullName(sb.toString());
					productInfoDao.saveOrUpdateObject(productInfoCopy); //更新套餐信息;
					//保存套餐与标签表关系.
					//1.删除相关数据
					shopProductTradeSituationTagDao.deleteByParams(" where o.productId="+productInfoCopy.getProductId());
					if(jsonArray!=null&&jsonArray.size()>0){
						//2.将新数据存入数据库中
						int jsonLength = jsonArray.size();
						//对json数组进行循环
						for (int p = 0; p < jsonLength;p++) {
							JSONObject jo=JSONObject.fromObject(jsonArray.get(p));
							String ttId=jo.getString("ttId");
							String ids=jo.getString("ids");
							if(StringUtils.isNotEmpty(ids)){
								String[] split = ids.split(",");
								for(String stId:split){
									ShopProductTradeSituationTag sptst=new ShopProductTradeSituationTag();
									sptst.setProductId(productInfoCopy.getProductId());
									sptst.setStId(Integer.parseInt(stId));
									sptst.setTtId(Integer.parseInt(ttId));
									shopProductTradeSituationTagDao.saveOrUpdateObject(sptst);
								}
							}
						}
					}
					//套餐属性关系表操作
					if(paiList!=null && paiList.size()>0){
						for(ProductAttrIndex pai:paiList){
							ProductAttrIndex p = new ProductAttrIndex();
							p.setAttrValueId(pai.getAttrValueId());
							p.setProductAttrId(pai.getProductAttrId());
							p.setProductId(productInfoCopy.getProductId());
							p.setProductTypeId(productInfoCopy.getProductTypeId());
							productAttrIndexDao.saveOrUpdateObject(p);
						}
					}
				}
			}else{
				//复制套餐基本信息
				productInfo.setSku(sku);
				ProductInfo productInfoCopy = null;
				productInfoCopy = (ProductInfo) new CopyObject().copy(productInfo);
				productInfoCopy.setProductFullName(productInfoCopy.getProductName());
				productInfoCopy.setProductId(null);
				productInfoCopy = (ProductInfo) productInfoDao.saveOrUpdateObject(productInfoCopy);//复制保存套餐
				if(Utils.stringIsNotEmpty(shopProCategoryId)){
					ShopProCateClass spcc = new ShopProCateClass();
					spcc.setProductId(productInfoCopy.getProductId());
					spcc.setShopProCategoryId(Integer.parseInt(shopProCategoryId));
					shopProCateClassDao.saveOrUpdateObject(spcc);
				}
				//保存套餐与标签表关系.
				//1.删除相关数据
				shopProductTradeSituationTagDao.deleteByParams(" where o.productId="+productInfoCopy.getProductId());
				if(jsonArray!=null&&jsonArray.size()>0){
					
					//2.将新数据存入数据库中
					int jsonLength = jsonArray.size();
					//对json数组进行循环
					for (int p = 0; p < jsonLength;p++) {
						JSONObject jo=JSONObject.fromObject(jsonArray.get(p));
						String ttId=jo.getString("ttId");
						String ids=jo.getString("ids");
						if(StringUtils.isNotEmpty(ids)){
							String[] split = ids.split(",");
							for(String stId:split){
								ShopProductTradeSituationTag sptst=new ShopProductTradeSituationTag();
								sptst.setProductId(productInfoCopy.getProductId());
								sptst.setStId(Integer.parseInt(stId));
								sptst.setTtId(Integer.parseInt(ttId));
								shopProductTradeSituationTagDao.saveOrUpdateObject(sptst);
							}
						}
					}
				}
				if(listProductImage!=null && listProductImage.size()>0){
					//套餐详情图片
					for(ProductImg pi:listProductImage){
						ProductImg productImg = new ProductImg();
						productImg.setLarge(pi.getLarge());
						productImg.setMedium(pi.getMedium());
						productImg.setOrders(pi.getOrders());
						productImg.setSource(pi.getSource());
						productImg.setThumbnail(pi.getThumbnail());
						productImg.setTitle(pi.getTitle());
						productImg.setProductId(productInfoCopy.getProductId());
						productImgDao.saveOrUpdateObject(productImg);
					}
				}
				//套餐属性关系表操作
				if(paiList!=null && paiList.size()>0){
					for(ProductAttrIndex pai:paiList){
						ProductAttrIndex p = new ProductAttrIndex();
						p.setAttrValueId(pai.getAttrValueId());
						p.setProductAttrId(pai.getProductAttrId());
						p.setProductId(productInfoCopy.getProductId());
						p.setProductTypeId(productInfoCopy.getProductTypeId());
						productAttrIndexDao.saveOrUpdateObject(p);
					}
				}
			}
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
	}
	//直接修改规格调用的方法
	public void updateFrontProductSpecification(Integer productId,String goods,String parameters){
		List<String> groupProductIdList = new ArrayList<String>();//同组套餐ID
		List<String> retainProductIdList = new ArrayList<String>();//保留套餐ID
		if(productId!=null){
			ProductInfo product = (ProductInfo) productInfoDao.get(" where o.productId="+productId);
			List<ProductInfo> productList = productInfoDao.findObjects(" where o.goods='"+goods+"'");
			for(ProductInfo p : productList){
				groupProductIdList.add(String.valueOf(p.getProductId()));
			}
			//判断是否有删除的现有规格
			if(!StringUtils.isEmpty(parameters)){
				String[] commaSplits = parameters.split(",");//按逗号分割
				for(String commaSplit : commaSplits){
					if(commaSplit.contains("productId")){
						String[] alsoSplits = commaSplit.split("&");
						String[] gtSplits = alsoSplits[0].split("=");//用=符分割
						retainProductIdList.add(gtSplits[1]);
					}
				}
			}
			if(groupProductIdList.size()!=retainProductIdList.size()){
				//比对新传的数据套餐ID和原有组里面的套餐ID，如果有对应不上的就说明此规格的套餐已经删除，那么就把关联的规格和规格值删除
				for(String groupProductId : groupProductIdList){
					if(!retainProductIdList.contains(groupProductId)){
						productInfoDao.deleteByParams(" where o.productId='"+groupProductId+"'");
						productSpecificationValueDao.deleteByParams(" where o.productId='"+groupProductId+"'");
					}
				}
			}
			//循环没有删除的套餐和新添加的套餐，并更新规格和规格值
			if(!StringUtils.isEmpty(parameters)){
				String[] commaSplits = parameters.split(",");//按逗号分割
				for(String commaSplit : commaSplits){
					//判断是修改原始的套餐规格和规格值数据还是添加新的数据
					if(commaSplit.contains("productId")){
						//先删除此套餐挂钩的规格和规格值数据
						String[] alsoSplits = commaSplit.split("&");//用&符分割
						String[] gtSplits = alsoSplits[0].split("=");//用=符分割
						ProductInfo p = (ProductInfo) productInfoDao.get(" where o.productId='"+gtSplits[1]+"'");
						for(String alsoSplit : alsoSplits){
							if(alsoSplit.contains("productId")){
								continue;
							}else{
								productSpecificationValueDao.deleteByParams(" where o.productId='"+p.getProductId()+"'");//删除套餐和规格值关系
								StringBuffer sb = new StringBuffer();
								sb.append(p.getProductName()+" [");
								String[] thirSplit = alsoSplit.split("=");//把规格和规格值分开
								String[] fourSplit = thirSplit[0].split("_");//解析规格前缀，如：specification_1
								//规格值
								ProductSpecificationValue psv = new ProductSpecificationValue();
								psv.setProductId(p.getProductId());
								psv.setSpecificationValueId(Integer.parseInt(thirSplit[1]));
								productSpecificationValueDao.saveOrUpdateObject(psv);
								SpecificationValue sv = (SpecificationValue) specificationValueDao.get(" where o.specificationValueId='"+thirSplit[1]+"'");
								if(sv!=null){
									sb.append(sv.getName()+",");
								}
								if(sb.length()>0){
									sb.deleteCharAt(sb.lastIndexOf(","));
								}
								sb.append("]");
								p.setProductFullName(sb.toString());
							}
						}
						productInfoDao.saveOrUpdateObject(p); //更新套餐信息
					}else{
						try {
							
							//保存新添加的数据
							ProductInfo productInfoCopy = (ProductInfo) new CopyObject().copy(product);
							productInfoCopy.setProductId(null);
							//SKU
							String sku = null;
							String[] selectColumns = {"sku","productId"};
							List<ProductInfo> list = productInfoDao.findSome(selectColumns, 0, 1, " order by o.productId desc");
							if(list!=null&&list.size()>0){
								sku =util.other.SKUUtilityClass.getGeneratedSKU(list.get(0).getSku());
							}else{
								sku =util.other.SKUUtilityClass.getGeneratedSKU(null);
							}
							productInfoCopy.setSku(sku);
							productInfoCopy = (ProductInfo) productInfoDao.saveOrUpdateObject(productInfoCopy);
							//操作套餐标签
							List<ShopProductTradeSituationTag> findObjects = shopProductTradeSituationTagDao.findObjects(" where o.productId="+productId);
							if(findObjects!=null&&findObjects.size()>0){
								for(ShopProductTradeSituationTag sptt:findObjects){
									ShopProductTradeSituationTag st=new ShopProductTradeSituationTag();
									st.setProductId(productInfoCopy.getProductId());
									st.setPtstId(sptt.getPtstId());
									st.setStId(sptt.getStId());
									st.setTtId(sptt.getTtId());
									shopProductTradeSituationTagDao.saveOrUpdateObject(st);
								}
							}
							//把套餐图片复制给新选择的规格
							List<ProductImg> productImgList = productImgDao.findObjects(" where o.productId='"+product.getProductId()+"'");
							if(productImgList!=null && productImgList.size()>0){
								for(ProductImg pi : productImgList){
									ProductImg productImgCopy = new ProductImg();
									productImgCopy = (ProductImg) new CopyObject().copy(pi);
									productImgCopy.setProductImageId(null);
									productImgCopy.setProductId(productInfoCopy.getProductId());
									productImgDao.saveOrUpdateObject(productImgCopy);
								}
							}
							//新添加的规格
							StringBuffer sb = new StringBuffer();
							sb.append(productInfoCopy.getProductName()+" [");
							String[] alsoSplits = commaSplit.split("&");
							for(String alsoSplit : alsoSplits){
								String[] thirSplit = alsoSplit.split("=");//把规格和规格值分开
								String[] fourSplit = thirSplit[0].split("_");//解析规格前缀，如：specification_1
								//规格值
								ProductSpecificationValue productSpecificationValue = new ProductSpecificationValue();
								productSpecificationValue.setProductId(productInfoCopy.getProductId());
								productSpecificationValue.setSpecificationValueId(Integer.parseInt(thirSplit[1]));
								productSpecificationValueDao.saveOrUpdateObject(productSpecificationValue);
								SpecificationValue sv = (SpecificationValue) specificationValueDao.get(" where o.specificationValueId='"+thirSplit[1]+"'");
								if(sv!=null){
									sb.append(sv.getName()+",");
								}
							}
							if(sb.length()>0){
								sb.deleteCharAt(sb.lastIndexOf(","));
							}
							sb.append("]");
							productInfoCopy.setProductFullName(sb.toString());
							productInfoDao.saveOrUpdateObject(productInfoCopy); //更新套餐信息;
						} catch (Exception e) {
							String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
						}
					}
				}
			}
		}
	}
//  详情页滚动图片上传
	public ProductImg uploadProductImage(File imagePath,String imagePathFileName,ProductImg productImg,Map<Object,Object> fileUrlConfig) throws Exception {
		//原图
		imagePathFileName = ImageFileUploadUtil.uploadImageFile(imagePath, imagePathFileName, fileUrlConfig, "image_product");
		productImg.setSource(imagePathFileName);
		//原图片上传至服务器后的全路径
		String url=fileUrlConfig.get("fileUploadRoot") +"/"+imagePathFileName;
		//将路径new成文件
		File f=new File(url);
		//生成原文件名称
		String name=f.getName();
		//去文件名称（去除后缀.jpg）
		String[] nameArray = name.split("\\.");
		if(Utils.objectIsNotEmpty(nameArray)&&nameArray.length>0){
			//原文件的父目录
			//Z:\thshop\shop\image\product\20140220
			String pathParent=f.getParent();
			//配置文件中上传文件路径的长度
			//Z:/thshop/
			String lstr=String.valueOf(fileUrlConfig.get("fileUploadRoot"));
			int l=lstr.length();
			//生成大图
			productImg.setLarge(ImageUtil.scaleByHeightAndWidth(url,pathParent+"/"+nameArray[0]+"_large."+nameArray[1], 1000, 1000, true,l));
			//生成中图
			productImg.setMedium(ImageUtil.scaleByHeightAndWidth(url,pathParent+"/"+nameArray[0]+"_medium."+nameArray[1], 600, 600, true,l));
			//生成小图
			productImg.setThumbnail(ImageUtil.scaleByHeightAndWidth(url,pathParent+"/"+nameArray[0]+"_thumbnail."+nameArray[1], 200, 200, true,l));
		}
		return productImg;
	}
	/***
	 * 修改套餐的基本信息，参数，属性，描述
	 * @param product
	 * @param shopProCategoryId
	 */
	public Boolean saveOrUpdateBasicProduct(ProductInfo product,Integer shopProCategoryId){
		Boolean flag = true;
		if(Utils.objectIsNotEmpty(shopProCategoryId)){
			//店铺内部分类是否修改。若修改了，则修改中间表
			ShopProCateClass shopProCateClass = shopProCateClassDao.get("where o.productId="+product.getProductId());
			if(shopProCateClass!=null && shopProCateClass.getProductId()!=null && shopProCateClass.getShopProCategoryId().compareTo(shopProCategoryId)!=0){
				//使用sql语句的方式对原始数据进行更新
				shopProCateClassDao.updateObject(" update shop_shopprocateclass set shopProCategoryId="+shopProCategoryId+" where productId="+shopProCateClass.getProductId());
			}else{
				if(shopProCateClass==null){
					shopProCateClass = new ShopProCateClass();
					shopProCateClass.setProductId(product.getProductId());
					shopProCateClass.setShopProCategoryId(shopProCategoryId);
					shopProCateClassDao.saveOrUpdateObject(shopProCateClass);
				}
			}
		}
		//修改套餐基本信息
		product.setProductFullName(product.getProductFullName());
		productInfoDao.saveOrUpdateObject(product);
		return flag;
	}
	/**
	 * 修改套餐图片
	 * @param productInfo套餐信息
	 * @param listProductImage套餐图片集合
	 * @param fileUrlConfig上传路径配置
	 * @param listProductUploadImgs上传路径集合
	 * @param listProductUploadImgsFileName上传名称集合
	 */
	public Boolean saveOrUpdateProdImg(ProductInfo productInfo,List<ProductImg> listProductImage){
		Boolean flag = true;
		try {
			productInfo = productInfoDao.saveOrUpdateObject(productInfo);
			for(ProductImg productImg:listProductImage){
				if(productInfo!=null && productImg!=null){
					productImg.setProductId(productInfo.getProductId());
					productImgDao.saveOrUpdateObject(productImg);
				}
			}
		} catch (Exception e) {
			flag = false;
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		return flag;
	}
	/**
	 * 解除该套餐所在套餐组的规格以及对应的规格值的关联关系
	 * @param productId  套餐Id
	 * @actor lqs
	 */
	public boolean removeProductSpecificationValueGoodsGuanlian(Integer productId,String optionProductId) {
		//当前解除关联操作的规格组goodsId
		ProductInfo productInfo = baseDao.get(" where o.productId="+productId);
		Integer goods = productInfo.getGoods();
		//1、先获取套餐表中的goods的最大值
		Integer maxGoods = (Integer) baseDao.getMaxDataSQL("select max(goods) from shop_productinfo");
		//2、将关联表中的goodId加一后进行修改
		String sql="update shop_product_specification_value set goodId = "+(maxGoods+1)+" where productId = "+productId;
		String sql_1="update shop_productinfo set isShow=1 where productId = "+productId;
		boolean isSuccess=baseDao.updateBySQL(sql);
		isSuccess=baseDao.updateBySQL(sql_1);
		//3、将套餐表中的goods加一后进行修改
		sql="update shop_productinfo set goods = "+(maxGoods+1)+" where productId = "+productId;
		isSuccess=baseDao.updateBySQL(sql);
		
		//操作完套餐的修改后 判断当前操作套餐中是否还存在isShow=1的套餐
		//根据goodsID查询当前isShow=1的套餐
		int count = baseDao.getCount(" where o.goods="+goods+" and o.isShow=1");
		if (count == 0) {//等于0说明该goods中已经没有isShow等于1的套餐了
			//将当前套餐的isShow状态改为1,当成主套餐展示在套餐列表中,其他组内套餐为组内产品,在本套餐的详情中展示。
			String sql_2="update shop_productinfo set isShow=1 where productId = "+optionProductId;
			baseDao.updateObject(sql_2);
		}
		return isSuccess;
	}
	/**
	 * 修改规格
	 * @param 
	 * @throws Exception 
	 * @actor lqs
	 */
	@SuppressWarnings("unchecked")
	public boolean updateFrontProductSpecification(String specifications,Integer oldProductId) throws Exception{
		boolean isSuccess=true;
		boolean isSaveFirst=true;
		int eachNum=0;//派生其他套餐时sku循环执行次数
		if(specifications!=null && !"".equals(specifications)){
			/*specifications:
			【goodId-productId-psvId-specification_specificationId=specificationValueId@productIdParam=2803&marketPrice=44&salesPrice=22&storeNumber=2】
			1137-2810-4461-specification_90=271&1137-2810-4462-specification_91=275
			@productIdParam=2810&marketPrice=33&salesPrice=22&storeNumber=2,
			1137-2803-4453-specification_90=270&1137-2803-4454-specification_91=275
			@productIdParam=2803&marketPrice=44&storeNumber=2,
			1137-2802-4457-specification_90=270&1137-2802-4458-specification_91=274
			@productIdParam=2802&marketPrice=33&storeNumber=2,
			specification_90=270&specification_91=276
			@productIdParam=0&marketPrice=22&salesPrice=11&storeNumber=1*/
			boolean delFlag=true;
			String[] oneSplit = specifications.split(",");
			ProductInfo productInfo=null;
			List<ProductImg> piList=null;
			Integer productId=null;
			Integer goodId=null;
			for(String s : oneSplit){
				String[] oneFrontSplit = s.split("@");//把一个新的套餐规格组解析成规格对应规格值
				String[] secSplit = oneFrontSplit[0].split("&");//把一个新的套餐规格组解析成规格对应规格值
				String[] paramSplit = oneFrontSplit[1].split("&");//套餐的价格、库存
				String[] isOldProductSplit=s.split("-");
				if(isOldProductSplit.length>=3){//修改已存在规格
					for(String ss : secSplit){
						String[] thirSplit = ss.split("=");
						Integer specificationValueId=Integer.parseInt(thirSplit[1]);
						String[] fourSplit = thirSplit[0].split("_");
						Integer specificationId=Integer.parseInt(fourSplit[1]);
						String[] fifthSplit =fourSplit[0].split("-");
						if(fifthSplit.length>1){
							if(goodId==null){
								goodId=Integer.parseInt(fifthSplit[0]);
							}
							productId=Integer.parseInt(fifthSplit[1]);
							productInfo=(ProductInfo) productInfoDao.get(" where o.productId="+productId);
						}else{
							productId=productInfo.getProductId();
						}
						if(delFlag){
							delFlag=false;
							isSuccess=productSpecificationValueDao.deleteByParams(" where o.goodId="+goodId);
						}
						isSuccess=saveProductSpecificationValue(goodId,productId,specificationId,specificationValueId);
					}
					StringBuffer sb = new StringBuffer();
					sb=getProductFullName(productInfo,secSplit);
					productInfo.setProductFullName(sb.toString());
					/**不同套餐的价格和库存 设置begin**/
					BigDecimal marketPrice = new BigDecimal(0);
					BigDecimal salesPrice = new BigDecimal(0);
					Integer storeNumber = 0;
					Integer productId_param = 0;
					for(int p=0 ;p<paramSplit.length;p++){
						//把字段和字段值分开  productId=2803&marketPrice=1&salesPrice=1&storeNumber=1
						String[] paramSecSplit = paramSplit[p].split("=");
						if("marketPrice".equals(paramSecSplit[0])){
							marketPrice = new BigDecimal(paramSecSplit[1]) ;
						}else if("salesPrice".equals(paramSecSplit[0])){
							salesPrice = new BigDecimal(paramSecSplit[1]) ;
						}else if("storeNumber".equals(paramSecSplit[0])){
							storeNumber = Integer.valueOf(paramSecSplit[1]);
						}else if("productIdParam".equals(paramSecSplit[0])){
							productId_param = Integer.valueOf(paramSecSplit[1]);
						}
					}
					//套餐id一致时修改市场价、销售价、库存
					if(productId_param.compareTo(productInfo.getProductId())==0){
						productInfo.setMarketPrice(marketPrice);//市场价
						productInfo.setSalesPrice(salesPrice);//销售价
						productInfo.setStoreNumber(storeNumber);//库存
						if(Utils.objectIsNotEmpty(productInfo.getIsPutSale())&&productInfo.getIsPutSale().compareTo(2)!=0){
							//不处于上架状态时 修改审核状态
							productInfo.setIsPutSale(1);//是否上架
							//判断套餐是不是自营 1自营套餐 2店铺套餐
							if(Utils.objectIsNotEmpty(productInfo)&&Utils.objectIsNotEmpty(productInfo.getShopInfoProductType())&&productInfo.getShopInfoProductType().compareTo(1)==0){
								productInfo.setIsPass(3);//自营套餐： 待审核
							}else{
								productInfo.setIsPass(2);//店铺套餐： 待申请
							}
						}
					}
					productInfo=(ProductInfo) productInfoDao.saveOrUpdateObject(productInfo);
					/**不同套餐的价格和库存 设置end**/
				}else{//添加新规格
					eachNum++;//到此添加循环次数
					ProductInfo productInfoCopy=null;
					if(oldProductId!=null){
						productId = oldProductId;
					}
					if(productId!=null){
						//if(productInfo==null){
						productInfo=(ProductInfo) productInfoDao.get(" where o.productId="+productId);
						goodId = productInfo.getGoods();
						int count =productSpecificationValueDao.getCount(" where o.goodId="+goodId+" and o.productId="+productInfo.getProductId());
						if(count==0&&isSaveFirst){//添加套餐时没有添加规格
							StringBuffer sb = new StringBuffer();
							sb=getProductFullName(productInfo,secSplit);
							productInfo.setProductFullName(sb.toString());
							productInfo.setIsPutSale(1);//是否上架
							//判断套餐是不是自营 1自营套餐 2店铺套餐
							if(Utils.objectIsNotEmpty(productInfo)&&Utils.objectIsNotEmpty(productInfo.getShopInfoProductType())&&productInfo.getShopInfoProductType().compareTo(1)==0){
								productInfo.setIsPass(3);//待审核
							}else{
								productInfo.setIsPass(2);//待申请
							}
							productInfoDao.saveOrUpdateObject(productInfo);
							for(int i=0;i<secSplit.length;i++){
								String[] thirSplit = secSplit[i].split("=");
								Integer specificationValueId=Integer.parseInt(thirSplit[1]);
								String[] fourSplit = thirSplit[0].split("_");
								Integer specificationId=Integer.parseInt(fourSplit[1]);
								isSuccess=saveProductSpecificationValue(goodId,productId,specificationId,specificationValueId);
							}
							isSaveFirst = false;
						}else{
							StringBuffer sb = new StringBuffer();
							sb=getProductFullName(productInfo,secSplit);
							productInfoCopy = (ProductInfo) new CopyObject().copy(productInfo);
							productInfoCopy.setProductFullName(sb.toString());
							productInfoCopy.setProductId(null);
							productInfoCopy.setIsShow(0);//不显示
							productInfoCopy.setIsPutSale(1);//未上架
							productInfoCopy.setIsRecommend(0);//不推荐
							//判断套餐是不是自营 1自营套餐 2店铺套餐
							if(Utils.objectIsNotEmpty(productInfo)&&Utils.objectIsNotEmpty(productInfo.getShopInfoProductType())&&productInfo.getShopInfoProductType().compareTo(1)==0){
								productInfoCopy.setIsPass(3);//待审核
							}else{
								productInfoCopy.setIsPass(2);//待申请
							}
							//SKU
							//此处根据上边定义的eachNum进行循环遍历
							String sku = null;
							String[] selectColumns = {"sku","productId"};
							List<ProductInfo> list = productInfoDao.findSome(selectColumns, 0, 1, " order by o.productId desc");
							if(list!=null&&list.size()>0){
								sku =util.other.SKUUtilityClass.getGeneratedSKU(list.get(0).getSku());
								if(eachNum>=2){
									for(int k=0;k<=eachNum-2;k++){
										sku =util.other.SKUUtilityClass.getGeneratedSKU(sku);//凡是超过两次循环的  均采用上边定义的sku进行计算
									}
								}
							}else{
								sku =util.other.SKUUtilityClass.getGeneratedSKU(null);
							}
							productInfoCopy.setSku(sku);
							/**不同套餐的价格和库存 设置begin**/
							BigDecimal marketPrice = new BigDecimal(0);
							BigDecimal salesPrice = new BigDecimal(0);
							Integer storeNumber = 0;
							Integer productId_param = 0;
							for(int p=0 ;p<paramSplit.length;p++){
								//把字段和字段值分开  productId=0&marketPrice=1&salesPrice=1&storeNumber=1
								String[] paramSecSplit = paramSplit[p].split("=");
								if("marketPrice".equals(paramSecSplit[0])){
									marketPrice = new BigDecimal(paramSecSplit[1]) ;
								}else if("salesPrice".equals(paramSecSplit[0])){
									salesPrice = new BigDecimal(paramSecSplit[1]) ;
								}else if("storeNumber".equals(paramSecSplit[0])){
									storeNumber = Integer.valueOf(paramSecSplit[1]);
								}else if("productIdParam".equals(paramSecSplit[0])){
									productId_param = Integer.valueOf(paramSecSplit[1]);
								}
							}
							//套餐id为0时，证明是新添加的套餐，要初始化市场价、销售价、库存
							if(productId_param==0){
								productInfoCopy.setMarketPrice(marketPrice);//市场价
								productInfoCopy.setSalesPrice(salesPrice);//销售价
								productInfoCopy.setStoreNumber(storeNumber);//库存
							}
							productInfoCopy=(ProductInfo) productInfoDao.saveOrUpdateObject(productInfoCopy);
							/**不同套餐的价格和库存 设置end**/
							
							//操作套餐绑定店铺内部分类
							ShopProCateClass oldShopProCateClass = (ShopProCateClass)shopProCateClassDao.get(" where o.productId='"+oldProductId+"'");
							ShopProCateClass shopProCateClass = new ShopProCateClass();
							shopProCateClass.setProductId(productInfoCopy.getProductId());
							shopProCateClass.setShopProCategoryId(oldShopProCateClass.getShopProCategoryId());
							shopProCateClassDao.saveOrUpdateObject(shopProCateClass);
							//操作套餐属性
							List<ProductAttrIndex> productAttrIndexList = productAttrIndexDao.findObjects("where o.productId="+productInfo.getProductId());
							for(ProductAttrIndex pai:productAttrIndexList){
								ProductAttrIndex productAttrIndexCopy = new ProductAttrIndex();
								productAttrIndexCopy.setAttrValueId(pai.getAttrValueId());
								productAttrIndexCopy.setProductAttrId(pai.getProductAttrId());
								productAttrIndexCopy.setProductTypeId(pai.getProductTypeId());
								productAttrIndexCopy.setProductId(productInfoCopy.getProductId());
								productAttrIndexDao.saveObject(productAttrIndexCopy);
							}
							if(productInfoCopy.getProductId()!=null){
								isSuccess=true;
							}else{
								isSuccess=false;
							}
							for(String ss : secSplit){
								String[] thirSplit = ss.split("=");
								Integer specificationValueId=Integer.parseInt(thirSplit[1]);
								String[] fourSplit = thirSplit[0].split("_");
								Integer specificationId=Integer.parseInt(fourSplit[1]);
								isSuccess=saveProductSpecificationValue(goodId,productInfoCopy.getProductId(),specificationId,specificationValueId);
							}
							//复制该组的套餐图片到新添加规格对应生成的套餐图片
							piList=(List<ProductImg>) productImgDao.findObjects(null," where o.productId="+productId);
							if(piList!=null&&piList.size()>0){
								for(ProductImg pi:piList){
									ProductImg productImg = new ProductImg();
									productImg.setLarge(pi.getLarge());
									productImg.setMedium(pi.getMedium());
									productImg.setOrders(pi.getOrders());
									productImg.setSource(pi.getSource());
									productImg.setThumbnail(pi.getThumbnail());
									productImg.setTitle(pi.getTitle());
									productImg.setProductId(productInfoCopy.getProductId());
									productImgDao.saveOrUpdateObject(productImg);
									if(pi.getProductImageId()!=null){
										isSuccess=true;
									}else{
										isSuccess=false;
									}
								}
							}
						}
						//}
					}
				}
			}
		}
		return isSuccess;
	}
	public boolean saveProductSpecificationValue(Integer goodId,Integer productId,Integer specificationId,Integer specificationValueId){
		ProductSpecificationValue psv=new ProductSpecificationValue();
		psv.setGoodId(goodId);
		psv.setProductId(productId);
		psv.setSpecificationId(specificationId);
		psv.setSpecificationValueId(specificationValueId);
		productSpecificationValueDao.saveOrUpdateObject(psv);
		return true;
	}
	public StringBuffer getProductFullName(ProductInfo productInfo,String [] secSplit){
		StringBuffer sb = new StringBuffer();
		sb.append(productInfo.getProductName()+" [");
		for(String ss : secSplit){
			String[] thirSplit = ss.split("=");//把规格和规格值分开
			String[] fourSplit = thirSplit[0].split("_");//解析规格前缀，如：specification_1
			//规格值
			SpecificationValue sv = (SpecificationValue) specificationValueDao.get(" where o.specificationValueId='"+thirSplit[1]+"'");
			sb.append(sv.getName()+",");
		}
		sb.deleteCharAt(sb.lastIndexOf(","));
		sb.append("]");
		return sb;
	}
	/**
	 * @throws Exception 
	 * @功能：将平台基础套餐拷贝一份给店铺
	 * @作者: 
	 * @参数： @param shopInfoId
	 * @参数： @param productIds
	 * @参数： @param selectshopProCategoryId
	 * @返回值：void
	 * @日期: 2016年5月8日 下午2:20:54 
	 */
	public void saveCopyBasicProductInfo(String shopInfoIds, String productIds,String selectshopProCategoryId) throws Exception{
		//所涉及的功能点
		String[] arrayShopInfoIds = shopInfoIds.split(",");
		String[] arrayProductIds = productIds.split(",");
		ProductInfo productInfo = null;
		ProductInfo productInfoCopy =null;
		ShopInfo shopInfo=null;
		//循环店铺Id
		for(String shopInfoId :arrayShopInfoIds){
//			shopInfo = shopInfoDao.getObjectById(shopInfoId);
			//if(Utils.objectIsNotEmpty(shopInfo)){
				//套餐Id
				for(String productId :arrayProductIds){
					productInfo = null;
					productInfoCopy =null;
					//查询套餐Id查询出套餐
					productInfo = productInfoDao.getObjectById(productId);
					//如果套餐不为空则修改将套餐Id设置为null并修改套餐店铺Id
					if(Utils.objectIsNotEmpty(productInfo)){
						
						//保存新添加的数据
						productInfoCopy = (ProductInfo) new CopyObject().copy(productInfo);
						productInfoCopy.setProductId(null);
						productInfoCopy.setShopInfoProductType(2);
						productInfoCopy.setIsPutSale(1);//是否上架
						productInfoCopy.setIsPass(2);//待申请
						productInfoCopy.setPassUserName(null);
						productInfoCopy.setIsShow(1);
						productInfoCopy.setShopInfoId(Integer.valueOf(shopInfoId));
						//保存修改后的套餐新的套餐
						productInfoCopy = productInfoDao.saveOrUpdateObject(productInfoCopy);
						
						//根据新的套餐保存其他数据
						saveProductOther(shopInfoId,productInfoCopy);
					}
				}
//			}
		}
	}
	/**保存新套餐及其他属性 
	 * @throws Exception */
	private void saveProductOther(String oldProductId ,ProductInfo productInfo) throws Exception{
		
		//套餐和规格值中间表Service 
		productSpecificationValueList =productSpecificationValueDao.findObjects("where o.productId="+oldProductId);
		//遍历并一一保存
		if(Utils.collectionIsNotEmpty(productSpecificationValueList)){
			for(ProductSpecificationValue productSpecificationValue:productSpecificationValueList){
				this.productSpecificationValue=(ProductSpecificationValue) new CopyObject().copy(productSpecificationValue);
				this.productSpecificationValue.setSpecificationValueId(null);
				this.productSpecificationValue.setProductId(productInfo.getProductId());
				productSpecificationValueDao.saveOrUpdateObject(this.productSpecificationValue);
			}
		}
		//套餐图片
		productImgList =productImgDao.findObjects("where o.productId="+oldProductId);
		//遍历并一一保存
		if(Utils.collectionIsNotEmpty(productImgList)){
			for(ProductImg productImg:productImgList){
				this.productImg=(ProductImg) new CopyObject().copy(productImg);
				this.productImg.setProductImageId(null);
				this.productImg.setProductId(productInfo.getProductId());
				productImgDao.saveOrUpdateObject(this.productImg);
			}
		}
		//套餐和店铺内部套餐分类关系
		shopProCateClassList =shopProCateClassDao.findObjects("where o.productId="+oldProductId);
		//遍历并一一保存
		if(Utils.collectionIsNotEmpty(shopProCateClassList)){
			for(ShopProCateClass shopProCateClass:shopProCateClassList){
				this.shopProCateClass=(ShopProCateClass) new CopyObject().copy(shopProCateClass);
				this.shopProCateClass.setProductId(productInfo.getProductId());
				shopProCateClassDao.saveOrUpdateObject(this.shopProCateClass);
			}
		}
		//套餐标签关联表Dao
		shopProductTradeSituationTagList =shopProductTradeSituationTagDao.findObjects("where o.productId="+oldProductId);
		//遍历并一一保存
		if(Utils.collectionIsNotEmpty(shopProductTradeSituationTagList)){
			for(ShopProductTradeSituationTag shopProductTradeSituationTag:shopProductTradeSituationTagList){
				this.shopProductTradeSituationTag=(ShopProductTradeSituationTag) new CopyObject().copy(shopProductTradeSituationTag);
				this.shopProductTradeSituationTag.setPtstId(null);
				this.shopProductTradeSituationTag.setProductId(productInfo.getProductId());
				shopProductTradeSituationTagDao.saveOrUpdateObject(this.shopProductTradeSituationTag);
			}
		}
		//套餐扩展属性值 - 类描述信息
		productAttrIndexList =productAttrIndexDao.findObjects("where o.productId="+oldProductId);
		//遍历并一一保存
		if(Utils.collectionIsNotEmpty(productAttrIndexList)){
			for(ProductAttrIndex productAttrIndex:productAttrIndexList){
				this.productAttrIndex=(ProductAttrIndex) new CopyObject().copy(productAttrIndex);
				this.productAttrIndex.setAttributeIndexId(null);
				this.productAttrIndex.setProductId(productInfo.getProductId());
				productAttrIndexDao.saveOrUpdateObject(this.productAttrIndex);
			}
		}
	}
	/**
	 * @功能：删除套餐及所涉及到的表
	 * @作者: 
	 * @参数： @param productIds 套餐Id字符串
	 * @参数： @return
	 * @返回值：boolean
	 * @日期: 2016年5月9日 下午2:36:21 
	 */
	public boolean deleteProductAll(String productIds){
		/*
		1、套餐表
		2、套餐和规格中间表
		3、套餐和规格值中间表
		4、套餐图片表
		5、套餐和店铺内部套餐分类中间关系表
		6、套餐标签关联表
		7、套餐扩展属性值表
		 */
		boolean success=false;
		String[] arrayProductIds=null; 
		StringBuffer sbProductIds=null;
		if(Utils.objectIsNotEmpty(productIds)){
			sbProductIds = new StringBuffer();
			arrayProductIds = productIds.split(",");
			for(int i=0;i<arrayProductIds.length;i++)
			{
				sbProductIds.append(Integer.parseInt(arrayProductIds[i]));
				if(i<arrayProductIds.length-1){
					sbProductIds.append(",");
				}
			}
		}
		if(Utils.objectIsNotEmpty(sbProductIds)){
			String where = "where o.productId in ("+sbProductIds.toString()+")";
			//套餐和规格值中间表Service 
			success = productSpecificationValueDao.deleteByParams(where);
			//套餐图片
			success = productImgDao.deleteByParams(where);
			//套餐和店铺内部套餐分类关系
			success = shopProCateClassDao.deleteByParams(where);
			//套餐标签关联表Dao
			success = shopProductTradeSituationTagDao.deleteByParams(where);
			//套餐扩展属性值 - 类描述信息
			success = productAttrIndexDao.deleteByParams(where);
			success = productInfoDao.deleteByParams(where);
		}
		return success;
	}
	
	public void setProductSpecificationValueDao(IProductSpecificationValueDao productSpecificationValueDao) {
		this.productSpecificationValueDao = productSpecificationValueDao;
	}
	public void setProductImgDao(IProductImgDao productImgDao) {
		this.productImgDao = productImgDao;
	}
	public void setShopProCateClassDao(IShopProCateClassDao shopProCateClassDao) {
		this.shopProCateClassDao = shopProCateClassDao;
	}
	public void setSpecificationValueDao(
			ISpecificationValueDao specificationValueDao) {
		this.specificationValueDao = specificationValueDao;
	}
	public void setShopProductTradeSituationTagDao(
			IShopProductTradeSituationTagDao shopProductTradeSituationTagDao) {
		this.shopProductTradeSituationTagDao = shopProductTradeSituationTagDao;
	}
	public void setProductAttrIndexDao(IProductAttrIndexDao productAttrIndexDao) {
		this.productAttrIndexDao = productAttrIndexDao;
	}
	public void setBrandDao(IBrandDao brandDao) {
		this.brandDao = brandDao;
	}
	public void setProductInfoDao(IProductInfoDao productInfoDao) {
		this.baseDao =this.productInfoDao = productInfoDao;
	}
	public void setShopInfoDao(IShopInfoDao shopInfoDao) {
		this.shopInfoDao = shopInfoDao;
	}
	
}