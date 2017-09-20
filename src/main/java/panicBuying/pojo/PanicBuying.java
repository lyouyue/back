/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package panicBuying.pojo;

import util.pojo.BaseEntity;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * SHOP_抢购套餐表
 * @Author: caiang
 * @Date 2016/9/6 16:21
 */
public class PanicBuying extends BaseEntity implements Serializable {
    private Integer panicId;//抢购ID
    private Integer productId;//套餐ID
    private Integer shopInfoId;//店铺ID
    private String  panicTitle;//抢购标题，发布时若此项为空，自动保存套餐名称
    private String  productName;//套餐名称
    private BigDecimal originalPrice;//原销售价
    private BigDecimal panicPrice;//抢购价
    private BigDecimal reducePrice;//立省额度
    private String  logoImg;//抢购套餐图片
    private Integer panicNum;//抢购总数量
    private Integer buyNum;//已枪数量
    private Date createTime;//创建时间
    private Date startTime;//抢购开始时间
    private Date updateTime;//修改时间【修改内容时，发布时修改，抢购结束时修改】
    private Integer isPublish;//是否发布【0 不发布，1已发布，默认不发布】只有一次发布机会，发布后不能修改或者中止（结束），设置的抢购开始时间不得早于当前 sytemconfig.panicStartMinTime小时后的时间
    private Integer isOver;//是否结束【0 未结束，1已结束，默认0】达到抢购个量时自动结束
    private Integer isShow;//是否显示在首页推荐栏位【0 不显示，1显示，默认0】，此字段，在表中有且仅有一条记录为1，别的都为0
    public Integer getPanicId() {
        return panicId;
    }

    public Integer getProductId() {
        return productId;
    }

    public Integer getShopInfoId() {
        return shopInfoId;
    }

    public String getPanicTitle() {
        return panicTitle;
    }

    public String getProductName() {
        return productName;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public BigDecimal getPanicPrice() {
        return panicPrice;
    }

    public BigDecimal getReducePrice() {
        return reducePrice;
    }

    public String getLogoImg() {
        return logoImg;
    }

    public Integer getPanicNum() {
        return panicNum;
    }

    public Integer getBuyNum() {
        return buyNum;
    }

    public void setPanicId(Integer panicId) {
        this.panicId = panicId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public void setShopInfoId(Integer shopInfoId) {
        this.shopInfoId = shopInfoId;
    }

    public void setPanicTitle(String panicTitle) {
        this.panicTitle = panicTitle;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public void setPanicPrice(BigDecimal panicPrice) {
        this.panicPrice = panicPrice;
    }

    public void setReducePrice(BigDecimal reducePrice) {
        this.reducePrice = reducePrice;
    }

    public void setLogoImg(String logoImg) {
        this.logoImg = logoImg;
    }

    public void setPanicNum(Integer panicNum) {
        this.panicNum = panicNum;
    }

    public void setBuyNum(Integer buyNum) {
        this.buyNum = buyNum;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public Date getStartTime() {
        return startTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public Integer getIsPublish() {
        return isPublish;
    }

    public Integer getIsOver() {
        return isOver;
    }

    public Integer getIsShow() {
        return isShow;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }

    public void setIsOver(Integer isOver) {
        this.isOver = isOver;
    }

    public void setIsShow(Integer isShow) {
        this.isShow = isShow;
    }
}
