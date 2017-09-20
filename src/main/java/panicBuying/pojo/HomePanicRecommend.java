/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package panicBuying.pojo;

import util.pojo.BaseEntity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * SHOP_首页_抢购推荐记录
 * @Author: caiang
 * @Date 2016/9/6 16:44
 */
public class HomePanicRecommend extends BaseEntity implements Serializable {
    private Integer ID;//ID
    private Integer panicId;//抢购ID
    private Integer productId;//套餐ID
    private Integer shopInfoId;//店铺ID
    private String  panicTitle;//抢购标题，发布时若此项为空，自动保存套餐名称
    private BigDecimal panicPrice;//抢购价
    private String  logoImg;//抢购套餐图片
    private Integer panicNum;//抢购总数量
    private Date startTime;//抢购开始时间
    private String publishUser;//推荐人
    private Date createTime;//创建时间
    private String shopName;//店铺名称

    public Integer getID() {
        return ID;
    }

    public void setID(Integer ID) {
        this.ID = ID;
    }

    public Integer getPanicId() {
        return panicId;
    }

    public void setPanicId(Integer panicId) {
        this.panicId = panicId;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public Integer getShopInfoId() {
        return shopInfoId;
    }

    public void setShopInfoId(Integer shopInfoId) {
        this.shopInfoId = shopInfoId;
    }

    public String getPanicTitle() {
        return panicTitle;
    }

    public void setPanicTitle(String panicTitle) {
        this.panicTitle = panicTitle;
    }

    public BigDecimal getPanicPrice() {
        return panicPrice;
    }

    public void setPanicPrice(BigDecimal panicPrice) {
        this.panicPrice = panicPrice;
    }

    public String getLogoImg() {
        return logoImg;
    }

    public void setLogoImg(String logoImg) {
        this.logoImg = logoImg;
    }

    public Integer getPanicNum() {
        return panicNum;
    }

    public void setPanicNum(Integer panicNum) {
        this.panicNum = panicNum;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public String getPublishUser() {
        return publishUser;
    }

    public void setPublishUser(String publishUser) {
        this.publishUser = publishUser;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public String getShopName() {
        return shopName;
    }

    public void setShopName(String shopName) {
        this.shopName = shopName;
    }
}
