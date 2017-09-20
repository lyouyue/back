/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package panicBuying.action;

import basic.pojo.Users;
import net.sf.json.JSONObject;
import net.sf.json.JsonConfig;
import panicBuying.pojo.HomePanicRecommend;
import panicBuying.pojo.PanicBuying;
import panicBuying.service.IHomePanicRecommendService;
import panicBuying.service.IPanicBuyingService;
import shop.store.pojo.ShopInfo;
import shop.store.service.IShopInfoService;
import util.action.BaseAction;
import util.other.JSONFormatDate;
import util.other.Utils;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @Author: tangxinli
 * @Date 2016/9/6 18:22
 */
public class PanicBuyingAction extends BaseAction {
    private IPanicBuyingService panicBuyingService;//抢购servicre
    private IHomePanicRecommendService homePanicRecommendService;//SHOP_首页_抢购推荐记录service
    private IShopInfoService shopInfoService;//店铺基本信息的service层
    private List<PanicBuying> panicBuyingList;//抢购套餐List
    private Integer panicId;//抢购ID
    /*跳转到抢购套餐页面*/
    public String gotoPanicBuyingPage(){
        return SUCCESS;
    }
    //查询所有的抢购套餐
    public void listPanicBuying() throws IOException{
        int totalRecordCount=panicBuyingService.getCountPanic("");
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        panicBuyingList=panicBuyingService.findPanicListByPageHelper(null,pageHelper,"");
        Map<String, Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("total", totalRecordCount);
        jsonMap.put("rows", panicBuyingList);
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
        JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }
    public void updateShow() throws IOException {
        Users users= (Users) session.getAttribute("users");
        JSONObject jo = new JSONObject();
        if(Utils.objectIsNotEmpty(users)){
            String userName=users.getUserName();
            int count=panicBuyingService.getCountPanic("where o.isShow=1");
            if(count==1||count==0){//如果当前只有一件抢购套餐在显示，或者没有显示的，则可以显示抢购套餐
                PanicBuying panicBuyingShow=(PanicBuying) panicBuyingService.getPanicBuyingByParams("where o.isShow=1");//获取正在显示的抢购套餐
                PanicBuying panicBuying=(PanicBuying) panicBuyingService.getPanicBuyingByParams("where o.panicId="+panicId);//查询想要显示的抢购套餐
                ShopInfo shopInfo=(ShopInfo) shopInfoService.getObjectById(String.valueOf(panicBuying.getShopInfoId()));//获取店铺信息
                if(Utils.objectIsNotEmpty(panicBuyingShow)){//如果有正在显示的抢购套餐，把它关掉,然后显示正在操作的这个抢购套餐
                    panicBuyingShow.setIsShow(0);
                    panicBuyingService.saveOrUpdateObject(panicBuyingShow);//保存关掉显示的抢购套餐
                    if(Utils.objectIsNotEmpty(panicBuying)){
                        panicBuying.setIsShow(1);
                        panicBuyingService.saveOrUpdatePanicBuying(panicBuying);//修改想要显示的抢购套餐的状态
                        HomePanicRecommend panicRecommend=new HomePanicRecommend();
                        panicRecommend.setPanicId(panicBuying.getPanicId());//抢购ID
                        panicRecommend.setProductId(panicBuying.getProductId());//套餐ID
                        panicRecommend.setShopName(shopInfo.getShopName());//店铺名称
                        panicRecommend.setShopInfoId(panicBuying.getShopInfoId());//店铺ID
                        panicRecommend.setPanicTitle(panicBuying.getPanicTitle());//抢购标题
                        panicRecommend.setPanicPrice(panicBuying.getPanicPrice());//抢购价
                        panicRecommend.setLogoImg(panicBuying.getLogoImg());//抢购套餐图片\
                        panicRecommend.setPanicNum(panicBuying.getPanicNum());//抢购个数
                        panicRecommend.setStartTime(panicBuying.getStartTime());//抢购开始时间
                        panicRecommend.setPublishUser(userName);//操作人
                        panicRecommend.setCreateTime(new Date());
                        homePanicRecommendService.saveOrUpdatePanicRecord(panicRecommend);//保存操作记录
                        jo.accumulate("isSuccess", "true");
                    }else {
                        jo.accumulate("isSuccess", "false");
                    }
                }else{//如果没有显示的抢购套餐，则直接显示这个正在操作的抢购套餐
                    if(Utils.objectIsNotEmpty(panicBuying)){
                        panicBuying.setIsShow(1);
                        panicBuyingService.saveOrUpdatePanicBuying(panicBuying);//修改想要显示的抢购套餐的状态
                        HomePanicRecommend panicRecommend=new HomePanicRecommend();
                        panicRecommend.setPanicId(panicBuying.getPanicId());//抢购ID
                        panicRecommend.setProductId(panicBuying.getProductId());//套餐ID
                        panicRecommend.setShopName(shopInfo.getShopName());//店铺名称
                        panicRecommend.setShopInfoId(panicBuying.getShopInfoId());//店铺ID
                        panicRecommend.setPanicTitle(panicBuying.getPanicTitle());//抢购标题
                        panicRecommend.setPanicPrice(panicBuying.getPanicPrice());//抢购价
                        panicRecommend.setLogoImg(panicBuying.getLogoImg());//抢购套餐图片\
                        panicRecommend.setPanicNum(panicBuying.getPanicNum());//抢购个数
                        panicRecommend.setStartTime(panicBuying.getStartTime());//抢购开始时间
                        panicRecommend.setPublishUser(userName);//操作人
                        panicRecommend.setCreateTime(new Date());
                        homePanicRecommendService.saveOrUpdatePanicRecord(panicRecommend);
                        jo.accumulate("isSuccess", "true");
                    }else {
                        jo.accumulate("isSuccess", "false");
                    }
                }
            }else{//count>1的情况
                jo.accumulate("isSuccess", "false");
            }
        }
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }
    //查询套餐抢购记录列表
    public void listPanicBuyingRecord() throws IOException {
        int totalRecordCount=homePanicRecommendService.getCountPanicRecord("");
        pageHelper.setPageInfo(pageSize, totalRecordCount, currentPage);
        List<HomePanicRecommend>  panicBuyingRecordList=homePanicRecommendService.findPanicRecordListByPageHelper(null,pageHelper,"order by createTime desc");
        Map<String, Object> jsonMap = new HashMap<String, Object>();
        jsonMap.put("total", totalRecordCount);
        jsonMap.put("rows", panicBuyingRecordList);
        JsonConfig jsonConfig = new JsonConfig();
        jsonConfig.registerJsonValueProcessor(Date.class, new JSONFormatDate("yyyy-MM-dd"));
        JSONObject jo = JSONObject.fromObject(jsonMap,jsonConfig);
        response.setContentType("text/html;charset=utf-8");
        PrintWriter out = response.getWriter();
        out.println(jo.toString());
        out.flush();
        out.close();
    }

    public List<PanicBuying> getPanicBuyingList() {
        return panicBuyingList;
    }

    public void setPanicBuyingList(List<PanicBuying> panicBuyingList) {
        this.panicBuyingList = panicBuyingList;
    }

    public IPanicBuyingService getPanicBuyingService() {
        return panicBuyingService;
    }

    public void setPanicBuyingService(IPanicBuyingService panicBuyingService) {
        this.panicBuyingService = panicBuyingService;
    }

    public Integer getPanicId() {
        return panicId;
    }

    public void setPanicId(Integer panicId) {
        this.panicId = panicId;
    }

    public IHomePanicRecommendService getHomePanicRecommendService() {
        return homePanicRecommendService;
    }

    public void setHomePanicRecommendService(IHomePanicRecommendService homePanicRecommendService) {
        this.homePanicRecommendService = homePanicRecommendService;
    }

    public IShopInfoService getShopInfoService() {
        return shopInfoService;
    }

    public void setShopInfoService(IShopInfoService shopInfoService) {
        this.shopInfoService = shopInfoService;
    }
}
