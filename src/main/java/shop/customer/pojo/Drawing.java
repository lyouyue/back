package shop.customer.pojo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 提现记录实体类
 */
public class Drawing extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -8141560966966719159L;
	/**提现记录ID**/
	private Integer drawingId;
	/**提现编号**/
    private String drawingCode;
    /**用户ID**/
    private Integer customerId;
    /**联系电话**/
    private String phone;
    /**银行名称**/
    private String bankName;
    /**银行地址**/
    private String bankAddre;
    /**卡号**/
    private String cardNum;
    /**真实姓名**/
    private String realName;
    /**申请时间**/
    private Date createTime;
    /**发放时间**/
    private Date updateTime;
    /**发放人ID**/
    private Integer updateUserId;
    /**状态 1、已提交  2、已完成  3、已退回**/
    private Integer state;
    /**备注**/
    private String remarks;
    /**提现金额**/
    private BigDecimal drawingAmount;
    
	public Integer getDrawingId() {
		return drawingId;
	}
	public void setDrawingId(Integer drawingId) {
		this.drawingId = drawingId;
	}
	public String getDrawingCode() {
		return drawingCode;
	}
	public void setDrawingCode(String drawingCode) {
		this.drawingCode = drawingCode;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getBankName() {
		return bankName;
	}
	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	public String getBankAddre() {
		return bankAddre;
	}
	public void setBankAddre(String bankAddre) {
		this.bankAddre = bankAddre;
	}
	public String getCardNum() {
		return cardNum;
	}
	public void setCardNum(String cardNum) {
		this.cardNum = cardNum;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Date getUpdateTime() {
		return updateTime;
	}
	public void setUpdateTime(Date updateTime) {
		this.updateTime = updateTime;
	}
	public Integer getState() {
		return state;
	}
	public void setState(Integer state) {
		this.state = state;
	}
	public String getRemarks() {
		return remarks;
	}
	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}
	public BigDecimal getDrawingAmount() {
		return drawingAmount;
	}
	public void setDrawingAmount(BigDecimal drawingAmount) {
		this.drawingAmount = drawingAmount;
	}
	public Integer getUpdateUserId() {
		return updateUserId;
	}
	public void setUpdateUserId(Integer updateUserId) {
		this.updateUserId = updateUserId;
	}
}
