/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.action;

import coinMall.pojo.CoinMallProductType;
import coinMall.service.ICoinMallProductService;
import coinMall.service.ICoinMallProductTypeService;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import org.apache.log4j.Logger;
import org.apache.struts2.ServletActionContext;
import shop.product.pojo.ProductType;
import util.action.BaseAction;
import util.common.EnumUtils;
import util.other.JSONFormatDate;
import util.other.Utils;

import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * @Author: tangxinli
 * @Date 2016/9/10 13:45
 */
public class CoinMallProductTypeAction extends BaseAction {
    Logger logger = Logger.getLogger(this.getClass());
    private ICoinMallProductTypeService coinMallProductTypeService;//SHOP_积分商城分类Service
    private ICoinMallProductService coinMallProductService;//SHOP_积分商城套餐Service
    private CoinMallProductType coinMallProductType;
    private String id;
    private String ids;
    private String typeId;
    /**积分商城套餐List**/
    private List<Map> coinMallProductList;


    public String gotoCoinMallProductType(){
        return SUCCESS;
    }

    public void getNodes() throws IOException {
        HttpServletResponse response = ServletActionContext.getResponse();
        response.setContentType("text/xml;charset=utf-8");
        List<ProductType> list = coinMallProductTypeService.queryByParentId(id);
        StringBuffer sbf = new StringBuffer();
        CoinMallProductType coinMallProductType=null;
        if(Utils.collectionIsNotEmpty(list)){
            sbf.append("<List>");
            for (Iterator ite = list.iterator(); ite.hasNext();) {
                coinMallProductType = (CoinMallProductType) ite.next();
                if (coinMallProductType != null) {
                    sbf.append("<CoinMallProductType>");
                    sbf.append("<name>").append(coinMallProductType.getTypeName()).append(
                            "</name>");
                    sbf.append("<id>").append(coinMallProductType.getTypeId()).append(
                            "</id>");
                    sbf.append("<loadType>").append(coinMallProductType.getLoadType()).append(
                            "</loadType>");
                    sbf.append("</CoinMallProductType>");
                }
            }
            sbf.append("</List>");
        }
        PrintWriter out = response.getWriter();
        out.println(sbf.toString());
        out.flush();
        out.close();
    }
    //新增或修改积分商城分类
    public void saveOrEditCoinMallTuanProductType() throws Exception {
        if(coinMallProductType!=null){
            Integer parentId = coinMallProductType.getTypeParentId();
            if(parentId != 0){
                coinMallProductTypeService.updateFatherLoadType(parentId.toString());
            }
            coinMallProductType.setLoadType(1);
            coinMallProductType.setIsShow(1);
            coinMallProductTypeService.saveOrUpdateCoinMallProductType(coinMallProductType);
        }
    }

    //得到积分商城分类对象
    public void getCoinMallProductTypeObject() throws Exception {
        CoinMallProductType coinMallProductType=coinMallProductTypeService.getCoinMallProductTypeByParams("where o.typeId='"+typeId+"'");
        JSONObject jo = JSONObject.fromObject(coinMallProductType);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //删除积分商城分类
    public void delCoinMallProductType() throws Exception {
        Boolean isSuccess;
        List list=coinMallProductTypeService.queryByParentId(typeId);
        if(!Utils.collectionIsNotEmpty(list)){
            //删除的时候要判断此节点的父类还有没有子类，如果没有了就要把父类改成叶子节点，否则不变
            coinMallProductType = coinMallProductTypeService.getCoinMallProductTypeByParams(" where o.typeId='"+typeId+"'");
            Integer parentId = coinMallProductType.getTypeParentId();
            isSuccess=coinMallProductTypeService.deleteCoinMallProductTypeByParams(" where o.typeId='"+typeId+"'");
            Integer count=coinMallProductTypeService.getCountCoinMallProductType("where o.typeParentId='"+parentId+"'");
            if(count==0){
                CoinMallProductType cpt= coinMallProductTypeService.getCoinMallProductTypeByParams("where o.typeId='"+parentId+"'");
                cpt.setLoadType(1);
                coinMallProductTypeService.saveOrUpdateCoinMallProductType(cpt);
            }
        }else{
            isSuccess = false;
        }
        JSONObject jo = new JSONObject();
        jo.accumulate("isSuccess", isSuccess + "");
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //根据分类ID查询套餐
    public void listProductInfoByTypeId() throws IOException{
        String hql="select cp.productName as productName,cp.title as title,cp.allowExchangeNum as allowExchangeNum,cp.customerLevel as customerLevel,cp.expenseCoin as expenseCoin,"
        +"cp.originalPrice as originalPrice,cp.createTime as createTime,cp.isPublish as isPublish,cp.isShow as isShow from CoinMallProduct cp where cp.typeId="+typeId;
        int totalRecordCount=coinMallProductService.getCountCoinMallProduct("where o.typeId="+typeId);
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        coinMallProductList=coinMallProductService.findCoinMallProductListMapPage(hql,pageHelper);
        SimpleDateFormat fm = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
        for(Map<String,Object> m:coinMallProductList){//格式化创建时间
            if(m.get("createTime")!=null){
                Date date = (Date) m.get("createTime");
                String format = fm.format(date);
                m.put("createTime", format);
            }
        }
        Map<String, Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("total", totalRecordCount);
        jsonMap.put("rows", coinMallProductList);
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue()));
        JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    //根据分类查询积分商城套餐
    public String gotoProductInfoListByTypeId(){
        return SUCCESS;
    }

    public ICoinMallProductService getCoinMallProductService() {
        return coinMallProductService;
    }

    public void setCoinMallProductService(ICoinMallProductService coinMallProductService) {
        this.coinMallProductService = coinMallProductService;
    }

    public ICoinMallProductTypeService getCoinMallProductTypeService() {
        return coinMallProductTypeService;
    }

    public void setCoinMallProductTypeService(ICoinMallProductTypeService coinMallProductTypeService) {
        this.coinMallProductTypeService = coinMallProductTypeService;
    }

    public CoinMallProductType getCoinMallProductType() {
        return coinMallProductType;
    }

    public void setCoinMallProductType(CoinMallProductType coinMallProductType) {
        this.coinMallProductType = coinMallProductType;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getIds() {
        return ids;
    }

    public void setIds(String ids) {
        this.ids = ids;
    }

    public String getTypeId() {
        return typeId;
    }

    public void setTypeId(String typeId) {
        this.typeId = typeId;
    }

    public List<Map> getCoinMallProductList() {
        return coinMallProductList;
    }

    public void setCoinMallProductList(List<Map> coinMallProductList) {
        this.coinMallProductList = coinMallProductList;
    }
}
