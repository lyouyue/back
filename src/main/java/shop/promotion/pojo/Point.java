package shop.promotion.pojo;
import java.io.Serializable;
import java.util.Date;
import util.pojo.BaseEntity;
/**
 * 金币政策实体类
 * 
 *
 */
public class Point extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -3811181145415728184L;
	/**
	 * 金币政策ID
	 */
	private Integer pointId;
	/**
	 * 促销活动ID
	 */
	private Integer promotionId;
	/**
	 * 最小金额
	 */
	private Double minNumber;
	/**
	 * 最大金额
	 */
	private Double maxNumber;
	/**
	 * 返回金币值
	 */
	private Integer returnPoint;
	/**
	 * 使用结束时间
	 */
	private Date endTimestamp;
	public Integer getPointId() {
		return pointId;
	}
	public void setPointId(Integer pointId) {
		this.pointId = pointId;
	}
	public Integer getReturnPoint() {
		return returnPoint;
	}
	public void setReturnPoint(Integer returnPoint) {
		this.returnPoint = returnPoint;
	}
	public Integer getPromotionId() {
		return promotionId;
	}
	public void setPromotionId(Integer promotionId) {
		this.promotionId = promotionId;
	}
	public Double getMinNumber() {
		return minNumber;
	}
	public void setMinNumber(Double minNumber) {
		this.minNumber = minNumber;
	}
	public Double getMaxNumber() {
		return maxNumber;
	}
	public void setMaxNumber(Double maxNumber) {
		this.maxNumber = maxNumber;
	}
	public Date getEndTimestamp() {
		return endTimestamp;
	}
	public void setEndTimestamp(Date endTimestamp) {
		this.endTimestamp = endTimestamp;
	}
}
