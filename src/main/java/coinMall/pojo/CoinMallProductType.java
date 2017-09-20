/*
* Copyright (c) 2016 ShopJsp. All Rights Reserved.
*/
package coinMall.pojo;

import util.pojo.BaseEntity;

/**
 * @Author: tangxinli
 * @Date 2016/9/9 16:43
 */
public class CoinMallProductType extends BaseEntity implements java.io.Serializable{
    private static final long serialVersionUID = -2407120755608013836L;
    private Integer typeId;//套餐分类ID
    private String typeName;//名称
    private Integer typeParentId;//父ID
    private Integer sort;//排序编号
    private Integer loadType;//是否为叶子节点(0否，1是)
    private Integer isShow;//是否显示(0否，1是)

    public Integer getIsShow() {
        return isShow;
    }

    public void setIsShow(Integer isShow) {
        this.isShow = isShow;
    }

    public Integer getLoadType() {
        return loadType;
    }

    public void setLoadType(Integer loadType) {
        this.loadType = loadType;
    }

    public static long getSerialVersionUID() {
        return serialVersionUID;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getTypeId() {
        return typeId;
    }

    public void setTypeId(Integer typeId) {
        this.typeId = typeId;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public Integer getTypeParentId() {
        return typeParentId;
    }

    public void setTypeParentId(Integer typeParentId) {
        this.typeParentId = typeParentId;
    }
}
