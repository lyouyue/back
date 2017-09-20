package shop.customer.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 提现退回实体类
 */
public class DrawingBack extends BaseEntity implements Serializable{
	private static final long serialVersionUID = 2616509403883234383L;
	/**提现退回ID**/
	private Integer backdrawingId;
	/**提现退回编号**/
    private String backdrawingCode;
    /**提现编码**/
    private String  drawingCode;//提现编号
    /**用户ID**/
    private Integer customerId;//用户ID
    /**提现总金额**/
    private BigDecimal drawingAmount;
    /**回退时间**/
    private Date backTime;
    /**备注**/
    private String remark;
    /**发放人ID**/
    private Integer updateUserId;
    
	public Integer getBackdrawingId() {
		return backdrawingId;
	}
	public void setBackdrawingId(Integer backdrawingId) {
		this.backdrawingId = backdrawingId;
	}
	public String getBackdrawingCode() {
		return backdrawingCode;
	}
	public void setBackdrawingCode(String backdrawingCode) {
		this.backdrawingCode = backdrawingCode;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public BigDecimal getDrawingAmount() {
		return drawingAmount;
	}
	public void setDrawingAmount(BigDecimal drawingAmount) {
		this.drawingAmount = drawingAmount;
	}
	public Date getBackTime() {
		return backTime;
	}
	public void setBackTime(Date backTime) {
		this.backTime = backTime;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public String getDrawingCode() {
		return drawingCode;
	}
	public void setDrawingCode(String drawingCode) {
		this.drawingCode = drawingCode;
	}
	public Integer getUpdateUserId() {
		return updateUserId;
	}
	public void setUpdateUserId(Integer updateUserId) {
		this.updateUserId = updateUserId;
	}
}
