/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.pojo;

import util.pojo.BaseEntity;

import java.math.BigDecimal;
import java.util.Date;

/**
 * @Author: tangxinli
 * @Date 2016/9/9 16:42
 */
public class CoinMallProduct extends BaseEntity implements java.io.Serializable {
    private static final long serialVersionUID = 8368736014131230844L;
    private Integer id;//主键ID
    private Integer productId;//套餐ID
    private Integer shopInfoId;//店铺ID
    private Integer typeId;//积分商城分类ID
    private String title;//标题，发布时若此项为空，自动保存套餐名称
    private String productName;//套餐名称
    private Integer allowExchangeNum;//当天允许兑换件数(默认1)
    private Integer customerLevel;//兑换所需会员级别
    private BigDecimal expenseCoin;//兑换所需积分
    private BigDecimal originalPrice;//原销售价
    private Date createTime;//创建时间
    private Date updateTime;//修改时间，默认与创建时间保持一致
    private Integer isPublish;//是否发布(0否，1是)
    private Integer isShow;//是否显示(0否，1是)
    private String logoImg;//套餐图片LOGO



    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getAllowExchangeNum() {
        return allowExchangeNum;
    }

    public void setAllowExchangeNum(Integer allowExchangeNum) {
        this.allowExchangeNum = allowExchangeNum;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Integer getCustomerLevel() {
        return customerLevel;
    }

    public void setCustomerLevel(Integer customerLevel) {
        this.customerLevel = customerLevel;
    }

    public BigDecimal getExpenseCoin() {
        return expenseCoin;
    }

    public void setExpenseCoin(BigDecimal expenseCoin) {
        this.expenseCoin = expenseCoin;
    }

    public Integer getIsPublish() {
        return isPublish;
    }

    public void setIsPublish(Integer isPublish) {
        this.isPublish = isPublish;
    }

    public Integer getIsShow() {
        return isShow;
    }

    public void setIsShow(Integer isShow) {
        this.isShow = isShow;
    }

    public BigDecimal getOriginalPrice() {
        return originalPrice;
    }

    public void setOriginalPrice(BigDecimal originalPrice) {
        this.originalPrice = originalPrice;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public Integer getShopInfoId() {
        return shopInfoId;
    }

    public void setShopInfoId(Integer shopInfoId) {
        this.shopInfoId = shopInfoId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    public String getLogoImg() {
        return logoImg;
    }

    public void setLogoImg(String logoImg) {
        this.logoImg = logoImg;
    }
}
