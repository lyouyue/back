package basic.action;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import jxl.Cell;
import jxl.Sheet;
import jxl.Workbook;
import jxl.format.Alignment;
import jxl.format.Colour;
import jxl.format.UnderlineStyle;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableCellFormat;
import jxl.write.WritableFont;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import net.sf.json.JSONObject;
import org.apache.log4j.Logger;
import shop.measuringUnit.pojo.MeasuringUnit;
import shop.measuringUnit.pojo.ProductMeasuringUnit;
import shop.measuringUnit.service.IMeasuringUnitService;
import shop.measuringUnit.service.IProductMeasuringUnitService;
import shop.product.pojo.AttributeValue;
import shop.product.pojo.Brand;
import shop.product.pojo.BrandType;
import shop.product.pojo.ProductAttribute;
import shop.product.pojo.ProductType;
import shop.product.pojo.Specification;
import shop.product.pojo.SpecificationValue;
import shop.product.service.IAttributeValueService;
import shop.product.service.IBrandService;
import shop.product.service.IBrandTypeService;
import shop.product.service.IProductAttributeService;
import shop.product.service.IProductTypeService;
import shop.product.service.ISpecificationService;
import shop.product.service.ISpecificationValueService;
import util.action.BaseAction;
import util.other.Utils;
import basic.service.IUpdateInitInformationService;
/**
 * 更新初始化信息Action
 * 
 */
public class UpdateInitInformationAction extends BaseAction {
	Logger logger = Logger.getLogger(this.getClass());
	private static final long serialVersionUID = 1L;
	/**套餐分类Service**/
	private IProductTypeService productTypeService;
	/**品牌分类Service**/
	private IBrandTypeService brandTypeService;
	/**品牌Service**/
	private IBrandService brandService;
	/**规格service**/
	private ISpecificationService specificationService;
	/**规格值service**/
	private ISpecificationValueService specificationValueService;
	/**套餐扩展属性service**/
	private IProductAttributeService productAttributeService;
	/**套餐扩展属性值service**/
	private IAttributeValueService attributeValueService;
	private IUpdateInitInformationService updateInitInformationService;
	private IMeasuringUnitService measuringUnitService;
	private IProductMeasuringUnitService productMeasuringUnitService;
	// 上传文件路径
	private File imagePath;
	// 上传文件名称
	private String imagePathFileName;
	
	/**
	 * 跳转商城首页维护
	 * @return
	 */
	public String gotoUpdateHomeInitPage(){
		return SUCCESS;
	}
	
	/**
	 * 跳转
	 * @return
	 */
	public String gotoUpdateInitInformationPage(){
		return SUCCESS;
	}
	/**
	 * 导出套餐分类数据excel
	 */
	@SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	public void outExcel() throws IOException{
		try {
			//二级分类
			//获取数据
			System.out.println("#######################获取数据#######################");
			List<Map<String, Object>> xxx = getObjectInfo(String.valueOf(request.getParameter("urlPath")));//二级数据
			System.out.println("================二级数据获取完毕================");
			if(xxx!=null&&xxx.size()>0){
				int f1=1;
				for(Map<String,Object> map:xxx){
//					if(f1==1){
						List<Map<String, Object>> objectInfo = getObjectInfo(String.valueOf(map.get("urlkeyword")));//三级数据
						System.out.println("================三级数据获取完毕================");
						map.put("sanji", objectInfo);
						if(objectInfo!=null&&objectInfo.size()>0){
							int f2=1;
							for(Map<String,Object> map2:objectInfo){
//								if(f2==1){
									String object = (String) map2.get("urlkeyword");
									List<Map<String, Object>> objectInfo4 = getObjectInfo(object);//四级数据
									System.out.println("================四级数据获取完毕================");
									map2.put("siji", objectInfo4);
//								}
								f2++;
							}
						}
//					}
					f1++;
				}
			}
			//创建excel开始
			System.out.println("#######################创建excel#######################");
			// 在path路径下建立一个excel文件
			String fileUploadRoot = String.valueOf(getFileUrlConfig().get("fileUploadRoot"));//获取文件服务器路径
			File toFile=new File(fileUploadRoot+"/excel/productTypeInfo.xls");
			if(!toFile.exists()){
				toFile.createNewFile();// 创建目标文件
			}
			// 设置excel里的字体
			WritableFont wf = new WritableFont(WritableFont.ARIAL, 12, WritableFont.NO_BOLD, false);
			WritableWorkbook wbook = Workbook.createWorkbook(toFile);
			//设置字体;  
	        WritableFont font3 = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.RED);
	        WritableCellFormat cellFormat3 = new WritableCellFormat(font3);  
	        WritableFont font4 = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.GREEN);
	        WritableCellFormat cellFormat4 = new WritableCellFormat(font4);  
	        cellFormat4.setAlignment(Alignment.RIGHT); 
	        WritableCellFormat cellFormat41 = new WritableCellFormat(font4);  
	        cellFormat41.setAlignment(Alignment.LEFT); 
	        
	        WritableFont fontOther = new WritableFont(WritableFont.ARIAL,14,WritableFont.BOLD,false,UnderlineStyle.NO_UNDERLINE,Colour.GREEN);
	        WritableCellFormat cellFormatOther = new WritableCellFormat(fontOther);  
	        cellFormatOther.setAlignment(Alignment.RIGHT); 
			//查询一级分类数据创建sheet
			if(xxx!=null&&xxx.size()>0){
				// 创建一个工作表
				for(int i=0;i<xxx.size();i++){
					//使用每一个一级分类的名称作为sheet名
					String sheetName=String.valueOf(xxx.get(i).get("name"));//获取当前二级分类名称
					WritableSheet wsheet = wbook.createSheet(sheetName, i);//设置sheet
					List<Map> maplist = (List<Map>) xxx.get(i).get("sanji");//获取三级分类数据
					if(maplist!=null&&maplist.size()>0){
						int n=0;//三级数目
						int k=0;//四级数目
						int b=0;//品牌数目
						int f=0;//规格数目
						int y=0;//属性数目
						int size=0;//当前应操作行
						for(Map m:maplist){
							size=n+k+b+f+y;
							//设置三级数据
							Label flag = new Label(0, size, "3",cellFormat3);
							Label name = new Label(1, size, String.valueOf(m.get("name")),cellFormat3);
							n++;// 把值加到工作表中
							wsheet.addCell(flag);
							wsheet.addCell(name);
							//每个三级分类下的四级分类
							List<Map> ml = (List<Map>) m.get("siji");
							if(ml!=null&&ml.size()>0){
								for(Map m2:ml){
									size=n+k+b+f+y;
									k++;// 把值加到工作表中
									//设置四级数据
									Label flag2 = new Label(0, size, "4",cellFormat4);
									Label name2 = new Label(1, size, String.valueOf(m2.get("name")),cellFormat41);
									wsheet.addCell(flag2);
									wsheet.addCell(name2);
									List<String> brandList = (List<String>) m2.get("brandList");
									if(brandList!=null&&brandList.size()>0){
										int p=1;
										for(String str:brandList){
											size=n+k+b+f+y;
											Label flag3 = new Label(0, size, "pp",cellFormatOther);
											Label name3 = new Label(p, size,str);
											p++;
											wsheet.addCell(flag3);
											wsheet.addCell(name3);
										}
										b++;
									}
									//导出规格及属性数据
									Map<String,Object> ggggMap = (Map<String,Object>) m2.get("gggg");
									if(ggggMap!=null){
										Iterator ggggMapIterator=ggggMap.entrySet().iterator();
										while(ggggMapIterator.hasNext()){//只遍历一次,速度快
											size=n+k+b+f+y;
											Label flag3 = new Label(0, size, "gg",cellFormatOther);
											wsheet.addCell(flag3);
											Map.Entry e=(Map.Entry)ggggMapIterator.next();
											Label name3 = new Label(1, size, String.valueOf(e.getKey()));
											wsheet.addCell(name3);
											Map<String,Object> value = (Map<String,Object>)e.getValue();
											if(value!=null){
												int mm=2;
												Iterator valueIterator=value.entrySet().iterator();
												while(valueIterator.hasNext()){//只遍历一次,速度快
													Map.Entry e2=(Map.Entry)valueIterator.next();
													Label name4 = new Label(mm, size, String.valueOf(e2.getKey()));
													wsheet.addCell(name4);
													mm++;
												}
											}
											f++;
										}
									}
									//键入空的属性数据
									for(int attr=0;attr<2;attr++){
										size=n+k+b+f+y;
										Label flag5 = new Label(0, size, "sx",cellFormatOther);
										wsheet.addCell(flag5);
										Label attrname = new Label(1, size, "属性名称");
										wsheet.addCell(attrname);
										for(int attrv=0;attrv<5;attrv++){
											Label name6 = new Label(attrv+2, size, "属性值");
											wsheet.addCell(name6);
										}
										y++;
									}
								}
							}
						}
					}
				}
			}
			// 写入文件
			wbook.write();
			wbook.close();
			System.out.println("#######################文件生成完毕#######################");
			JSONObject jo=new JSONObject();
			jo.accumulate("success", "true");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		} catch (WriteException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			JSONObject jo=new JSONObject();
			jo.accumulate("success", "false");
			PrintWriter out = response.getWriter();
			out.println(jo.toString());
			out.flush();
			out.close();
		}
	}
	@SuppressWarnings("unused")
	public List<Map<String ,Object>> getObjectInfo(String keyword){
		 List<Map<String,Object>> mapList=new ArrayList<Map<String,Object>>();
		 
		//1.抓取套餐分类信息
			String content=getContentInfo(keyword);//抓取数据
			//截取出分类相关的数据片段
		    int beginIx = content.indexOf("<th>分类</th>");
		    int endIx = content.indexOf("</div></td></tr>");  
		    if(beginIx>0){
		    	content=content.substring(beginIx, endIx-11);
		    	//用“</span></li>”对内容进行分割处理
		    	String[] splitContent = content.split("</span></li>");
		    	int d=1;
		    		for(String s:splitContent){
//		    			if(d==1){
		    				Map<String,Object> map=new HashMap<String, Object>();//定义map对象
		    				//对s进行 进一步的截取操作
		    				String substring = s.substring(s.lastIndexOf("<a href="), s.lastIndexOf("</a>"));
		    				String[] split = substring.split(">");
		    				//map中put url标志urlkeyword
		    				String urlkeyword="http://item.grainger.cn"+split[0].substring(9, split[0].length()-1);
		    				map.put("urlkeyword", urlkeyword);
		    				//map中put 产品分类名称name
		    				String name=split[1];
		    				System.out.println(name);
		    				map.put("name",name);
		    				//map中put flag标记当前分类是否为叶子节点
		    				String content2=getContentInfo(urlkeyword);//抓取数据
		    				int indexOf = content2.indexOf("<th>分类</th>");
		    				if(indexOf>0){
		    					map.put("flag", "false");
		    				}else{
		    					map.put("flag", "true");
		    					//2.在map中put一个list对象  里边装的是叶子节点的分类所对应的品牌
		    					String contentbrand=getContentInfo(urlkeyword);//抓取数据
		    					//截取出分类相关的数据片段
		    					int beginIxbrand = contentbrand.indexOf("<th>品牌</th>");
		    					int endIxbrand = contentbrand.indexOf("</div></td></tr>");  
		    					if(beginIxbrand>0){
		    						contentbrand=contentbrand.substring(beginIxbrand, endIxbrand);
		    						String[] splitContentbrand = contentbrand.split("<span class=\"cnt\">");
		    						//测试数据结果
		    						System.out.println("================输出品牌================");
		    						List<String> slist=new ArrayList<String>();
		    						for(String sbd:splitContentbrand){
		    							int indexOf2 = sbd.indexOf("/>");
		    							if(indexOf2>0){
		    								sbd=sbd.substring(sbd.lastIndexOf("/>")+2, sbd.length());
		    								System.out.println(sbd);
		    								slist.add(sbd);
		    							}
		    						}
		    						map.put("brandList", slist);
		    					}
		    					System.out.println("================输出规格================");
		    					String contentbrand3=getContentInfo(urlkeyword);//抓取数据
		    					int beginIxbrand3 = contentbrand3.indexOf("<th>其他选项</th>");
		    					int endIxbrand3 = contentbrand3.indexOf("</ul></td>");  
		    					if(beginIxbrand3>0){
		    						contentbrand3=contentbrand3.substring(beginIxbrand3, endIxbrand3-5);
		    						//用li标签分割一下
		    						String[] split2 = contentbrand3.split("<i class=\"arrow arrow-off\"></i></a>");
		    						Map<String,Object> soMap=new HashMap<String,Object>();
		    						for(String string:split2){
		    							//定义map存放规格值
		    							Map<String,Object> mapggv=new HashMap<String,Object>();
		    							//每一组规格及规格值
		    							//获取规格名称
		    							String ggname = string.substring(string.lastIndexOf(">")+1, string.length());
	    								//<span class="cnt">
		    							if(string.lastIndexOf("<span class=\"cnt\">")-1>0){
		    								String[] ggvnameString=string.substring(0,string.lastIndexOf("<span class=\"cnt\">")-1).split("<span class=\"cnt\">");
		    								System.out.println(ggname);
		    								for(String ggv:ggvnameString){
		    									String ggvname=ggv.substring(ggv.lastIndexOf(">")+1,ggv.length());
		    									mapggv.put(ggvname, ggvname);//向map中存储规格值信息
		    								}
		    								soMap.put(ggname, mapggv);
		    							}
		    						}
		    						map.put("gggg", soMap);
		    					}
		    				}
		    				mapList.add(map);
//		    			}
		    			d++;
		    		}
		    }
		return mapList;
	}
	/***
	 * 通过url获取网页源代码
	 * @param keywork 
	 * 			定义url关键字   如:c-4
	 * @return content 
	 * 			最终的内容 string格式
	 */
	public String getContentInfo(String urlPath){
		StringBuilder contentBuf = new StringBuilder();  //定义StringBuilder 用于动态操作字节内容
		try{
			String strURL = urlPath;//定义URL路径  
		    URL url = new URL(strURL);//定义url
		    HttpURLConnection httpConn = (HttpURLConnection) url.openConnection();//建立连接
		    InputStreamReader input = new InputStreamReader(httpConn.getInputStream(), "UTF-8");//  用InputStreamReader流来读取网页数据 编码utf-8
		    BufferedReader bufReader = new BufferedReader(input);//转换字节流
		    String line = "";  
		    while ((line = bufReader.readLine()) != null) { //循环字节
		    	contentBuf.append(line);  //将字节的内容添加至contentBuf
		    }  
		} catch (Exception e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
		}
		String content = contentBuf.toString();//最终的内容 string格式
	    return content;
	}
	
	/**
	 * 将套餐分类及品牌信息由Excel导入数据库
	 */
	public void uploadExcelFile()throws IOException{
		String categoryId = request.getParameter("categoryId");
		Map<String,Object> map = new HashMap<String,Object>();
		map.put("imagePathFileName", imagePathFileName);
		map.put("imagePath", imagePath);
		map.put("categoryId", categoryId);
		Workbook book;//定义excel文件
//		String categoryId=String.valueOf(map.get("categoryId"));//当前操作的文件归属套餐分类ID
		String imagePathFileName=String.valueOf(map.get("imagePathFileName"));//文件名称
		File imagePath=(File) map.get("imagePath");//文件
		//////////////////一级分类【相当于二级分类  上边有一个主题馆】
		String firstCT_LoadType="2";//tree加载类型【2代表当前为目录 1代表当前为文件】
		Integer firstCT_Level=2;//tree加载类型
		//////////////////二级分类【相当于三级分类  上边有一个主题馆】
		String secCT_LoadType="2";//tree加载类型【2代表当前为目录 1代表当前为文件】
		Integer secCT_Level=3;//tree加载类型
		//////////////////三级分类【相当于四级分类  上边有一个主题馆】
		String thirdCT_LoadType="1";//tree加载类型【2代表当前为目录 1代表当前为文件】
		Integer thirdCT_Level=4;//tree加载类型
		/////////////////单位
		Integer unitStatus = 1; //单位的使用状态
		try {
			//把当前操作的分类改成目录加载类型
			ProductType productType = (ProductType) productTypeService.getObjectByParams(" where o.productTypeId = "+categoryId);
			if(Utils.objectIsNotEmpty(productType)){
				String loadType = productType.getLoadType();
				if(!"2".equals(loadType)){
					productType.setLoadType("2");
					productTypeService.saveOrUpdateObject(productType);
				}
			}
			//获取一级分类的个数
			ProductType pt1=new ProductType();//一级分类
			Integer count = productTypeService.getCount(" where o.parentId = "+categoryId);//查询出当前主题馆下的分类数量【不包括子集】
			pt1.setSortName(imagePathFileName.substring(0, imagePathFileName.lastIndexOf(".")));
			pt1.setSortCode(String.valueOf(count+1));//排序
			pt1.setParentId(Integer.parseInt(categoryId));//父ID
			pt1.setIsShow(1);//展示
			pt1.setIsRecommend(1);//推荐
			pt1.setCategoryDescription(imagePathFileName.substring(0, imagePathFileName.lastIndexOf(".")));//简介
			pt1.setLoadType(firstCT_LoadType);//tree加载类型
			pt1.setLevel(firstCT_Level);//等级
			ProductType ptFirst = (ProductType) productTypeService.saveOrUpdateObject(pt1);
			
			book = Workbook.getWorkbook(new File(imagePath.getPath()));//把文件加载到内存
			Sheet[] sheets = book.getSheets();//获取sheet
			int i=1;
			for(Sheet sheet:sheets){//循环二级分类【相当于三级分类  上边有一个主题馆】
				//获取sheet名称
				String sheetName=sheet.getName();
				ProductType pt2=new ProductType();//二级分类【相当于三级分类  上边有一个主题馆】
				pt2.setSortName(sheetName);
				pt2.setSortCode(String.valueOf(i));
				pt2.setParentId(ptFirst.getProductTypeId());
				pt2.setIsShow(1);
				pt2.setIsRecommend(1);
				pt2.setCategoryDescription(sheetName);
				pt2.setLoadType(secCT_LoadType);
				pt2.setLevel(secCT_Level);
				ProductType ptSec = (ProductType) productTypeService.saveOrUpdateObject(pt2);
				i++;
				//查询当前sheet里边的所有行
			    int rows = sheet.getRows();
			    int j=1;
			    ProductType ptThird=new ProductType();
			    for(int a=0;a<rows;a++){
		    		Cell[] row = sheet.getRow(a);//获取当前行的所有列
		    		String firstColumn="";
		    		if(row.length>0){
		    			firstColumn=row[0].getContents();//获取第一列的值
		    		}
		    		//firstColumn为3 说明当前数据为三级分类数据【相当于四级分类  上边有一个主题馆】
		    		if("3".equals(firstColumn)){
		    			String thirdPTName = row[1].getContents();//三级分类名称【相当于四级分类  上边有一个主题馆】
		    			ProductType pt3=new ProductType();//三级分类【相当于四级分类  上边有一个主题馆】
						pt3.setSortName(thirdPTName);
						pt3.setSortCode(String.valueOf(j));
						pt3.setParentId(ptSec.getProductTypeId());//二级分类的id作为父id
						pt3.setIsShow(1);
						pt3.setIsRecommend(1);
						pt3.setCategoryDescription(thirdPTName);
						pt3.setLoadType(thirdCT_LoadType);
						pt3.setLevel(thirdCT_Level);
						ptThird = (ProductType) productTypeService.saveOrUpdateObject(pt3);
						j++;
		    		}
		    		
		    		//firstColumn为p 说明当前数据为品牌数据
		    		if("pp".equals(firstColumn)){
		    			//定义需要关联分类对象
		    			ProductType nowOptionObj=ptThird;
						//获取当前行
						Cell[] nowRow = sheet.getRow(a);
						int m=0;
						for(Cell cell:nowRow){
							if(m>1){
								String brandName=cell.getContents();//品牌名称
								BrandType bt=new BrandType();
								bt.setProductTypeId(nowOptionObj.getProductTypeId());
								String bn=brandName.replaceAll("'", "''");
								//根据品牌名称去完全匹配
								Brand hasBrand = (Brand) brandService.getObjectByParams(" where brandName='"+bn+"'");
								if(hasBrand==null){
									//1.插入品牌
									Brand brand=new Brand();
									brand.setBrandName(brandName);
									brand.setTitle(brandName);
									brand.setSynopsis(brandName);
									
									//获取brandcount
									Integer brandCount = brandService.getCount(null);
									brand.setSortCode(brandCount+1);
									brand.setIsShow(1);
									brand.setIsRecommend(1);
									brand.setIsHomePage(1);
									brand = (Brand) brandService.saveOrUpdateObject(brand);
									bt.setBrandId(brand.getBrandId());
								}else{
									bt.setBrandId(hasBrand.getBrandId());
								}
								
								//2.插入关联表数据
								bt = (BrandType) brandTypeService.saveOrUpdateObject(bt);
							}
							m++;
						}
		    		}
		    		//firstColumn为gg 说明当前数据为规格数据
		    		if("gg".equals(firstColumn)){
		    			if(row.length>=2){
		    				String ggname = row[1].getContents();//规格名称
		    				//定义需要关联分类对象
		    				ProductType nowOptionObj=ptThird;
		    				String ggnameReturn=ggname.replaceAll("'", "''");
		    				Specification specification = (Specification) specificationService.getObjectByParams(" where o.name='"+ggnameReturn+"' and o.productTypeId="+nowOptionObj.getProductTypeId());
		    				if(specification==null){
		    					//获取当前行
		    					Cell[] nowRow = sheet.getRow(a);
		    					Specification specification2=new Specification();
		    					specification2.setName(ggname);
		    					specification2.setProductTypeId(nowOptionObj.getProductTypeId());
		    					Integer count2 = specificationService.getCount(null);
		    					specification2.setSort(count2+1);
		    					specification2.setType(1);
		    					specification2.setNotes(ggname);
		    					specification2 = (Specification) specificationService.saveOrUpdateObject(specification2);//保存规格数据 返回规格对象
		    					
		    					int m=1;
		    					for(Cell cell:nowRow){
		    						if(m>2){
		    							String ggvname = cell.getContents();
		    							SpecificationValue sfv=new SpecificationValue();
		    							sfv.setSpecificationId(specification2.getSpecificationId());
		    							sfv.setName(ggvname);
		    							Integer count3 = specificationValueService.getCount(null);
		    							sfv.setSort(count3+1);
		    							specificationValueService.saveOrUpdateObject(sfv);
		    						}
		    						m++;
		    					}
		    				}
		    			}
		    			
		    		}
		    		
		    		//firstColumn为 sx 说明当前数据为属性数据
		    		if("sx".equals(firstColumn)){
		    			if(row.length>=2){
		    				String sxname = row[1].getContents();//属性名称
		    				//定义需要关联分类对象
		    				ProductType nowOptionObj=ptThird;
		    				String sxnameReturn=sxname.replaceAll("'", "''");
		    				ProductAttribute productAttribute = (ProductAttribute) productAttributeService.getObjectByParams(" where o.name='"+sxnameReturn+"' and o.productTypeId="+nowOptionObj.getProductTypeId());
		    				if(productAttribute==null){
		    					//获取当前行
		    					Cell[] nowRow = sheet.getRow(a);
		    					ProductAttribute productAttribute2=new ProductAttribute();
		    					productAttribute2.setName(sxname);
		    					productAttribute2.setProductTypeId(nowOptionObj.getProductTypeId());
		    					Integer count2 = productAttributeService.getCount(null);
		    					productAttribute2.setSort(count2+1);
		    					productAttribute2.setIsListShow(1);
		    					productAttribute2 = (ProductAttribute) productAttributeService.saveOrUpdateObject(productAttribute2);//保存套餐扩展属性数据 返回规格对象
		    					
		    					int m=1;
		    					for(Cell cell:nowRow){
		    						if(m>2){
		    							String sxvname = cell.getContents();
		    							AttributeValue abv=new AttributeValue();
		    							abv.setProductAttrId(productAttribute2.getProductAttrId());
		    							abv.setAttrValueName(sxvname);
		    							Integer count3 = attributeValueService.getCount(null);
		    							abv.setSort(count3+1);
		    							attributeValueService.saveOrUpdateObject(abv);
		    						}
		    						m++;
		    					}
		    				}
		    			}
	    			}
		    		
		    		//单位
		    		if("dw".equals(firstColumn)){
		    			if(row.length>=2){
		    				//定义需要关联分类对象
		    				ProductType nowOptionObj=ptThird;
	    					//获取当前行
	    					Cell[] nowRow = sheet.getRow(a);
	    					int m=1;
	    					for(Cell cell:nowRow){
	    						if(m>2){
	    							String dwname = cell.getContents();
	    							String dwnameReturn=dwname.replaceAll("'", "''").trim();
	    							if(Utils.objectIsNotEmpty(dwnameReturn)){
	    								MeasuringUnit measuringUnit = (MeasuringUnit) measuringUnitService.getObjectByParams(" where o.name='"+dwnameReturn+"'");
	    								if(measuringUnit==null){
		    									measuringUnit=new MeasuringUnit();
	    										measuringUnit.setName(dwname);
	    										measuringUnit.setUseState(unitStatus);//单位的使用状态
	    										measuringUnit = (MeasuringUnit) measuringUnitService.saveOrUpdateObject(measuringUnit);//保存
	    									}
	    								//无论当前单位是否存在  均与分类绑定关系
	    								ProductMeasuringUnit pmu = new ProductMeasuringUnit();
	    								pmu.setProductTypeId(nowOptionObj.getProductTypeId());
	    								pmu.setMeasuringUnitId(measuringUnit.getMeasuringUnitId());
	    								productMeasuringUnitService.saveOrUpdateObject(pmu);
	    							}
    							}
	    						m++;
    						}
    					}
	    			}
	    		}
		    }
			System.out.println("====================恭喜您，【"+imagePathFileName.substring(0, imagePathFileName.lastIndexOf("."))+"】导入Excel成功!=======================!");
		} catch (BiffException e) {
			String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
			System.out.println("====================对不起，【"+imagePathFileName.substring(0, imagePathFileName.lastIndexOf("."))+"】导入Excel失败!=======================!");
		} 
	}
	//setter getter
	public void setProductTypeService(IProductTypeService productTypeService) {
		this.productTypeService = productTypeService;
	}
	public File getImagePath() {
		return imagePath;
	}
	public void setImagePath(File imagePath) {
		this.imagePath = imagePath;
	}
	public String getImagePathFileName() {
		return imagePathFileName;
	}
	public void setImagePathFileName(String imagePathFileName) {
		this.imagePathFileName = imagePathFileName;
	}
	public void setBrandTypeService(IBrandTypeService brandTypeService) {
		this.brandTypeService = brandTypeService;
	}
	public void setBrandService(IBrandService brandService) {
		this.brandService = brandService;
	}
	public void setSpecificationService(ISpecificationService specificationService) {
		this.specificationService = specificationService;
	}
	public void setSpecificationValueService(
			ISpecificationValueService specificationValueService) {
		this.specificationValueService = specificationValueService;
	}
	public void setProductAttributeService(
			IProductAttributeService productAttributeService) {
		this.productAttributeService = productAttributeService;
	}
	public void setAttributeValueService(
			IAttributeValueService attributeValueService) {
		this.attributeValueService = attributeValueService;
	}
	public void setUpdateInitInformationService(
			IUpdateInitInformationService updateInitInformationService) {
		this.updateInitInformationService = updateInitInformationService;
	}
	public void setMeasuringUnitService(IMeasuringUnitService measuringUnitService) {
		this.measuringUnitService = measuringUnitService;
	}
	public void setProductMeasuringUnitService(
			IProductMeasuringUnitService productMeasuringUnitService) {
		this.productMeasuringUnitService = productMeasuringUnitService;
	}
}
