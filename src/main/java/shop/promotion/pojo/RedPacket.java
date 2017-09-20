package shop.promotion.pojo;
import java.io.Serializable;
import java.util.Date;
import util.pojo.BaseEntity;
/**
 * 红包政策实体类
 * 
 *
 */
public class RedPacket extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 586308921691603829L;
	/**
	 * 红包政策ID
	 */
	private Integer redPacketId;
	/**
	 * 促销活动ID
	 */
	private Integer promotionId;
	/**
	 * 最小金额
	 */
	private Integer minNumber;
	/**
	 * 最大金额
	 */
	private Integer maxNumber;
	/**
	 * 返回金额
	 */
	private Integer returnNumber;
	/**
	 * 结束时间
	 */
	private Date endTime;
	/**
	 * 开始时间
	 */
	private Date startTime;
	public Integer getRedPacketId() {
		return redPacketId;
	}
	public void setRedPacketId(Integer redPacketId) {
		this.redPacketId = redPacketId;
	}
	public Integer getPromotionId() {
		return promotionId;
	}
	public void setPromotionId(Integer promotionId) {
		this.promotionId = promotionId;
	}
	public Integer getMinNumber() {
		return minNumber;
	}
	public void setMinNumber(Integer minNumber) {
		this.minNumber = minNumber;
	}
	public Integer getMaxNumber() {
		return maxNumber;
	}
	public void setMaxNumber(Integer maxNumber) {
		this.maxNumber = maxNumber;
	}
	public Integer getReturnNumber() {
		return returnNumber;
	}
	public void setReturnNumber(Integer returnNumber) {
		this.returnNumber = returnNumber;
	}
	public Date getEndTime() {
		return endTime;
	}
	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}
	public Date getStartTime() {
		return startTime;
	}
	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}
}
