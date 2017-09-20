package shop.product.pojo;
import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 套餐答疑实体类
 * 
 *
 */
public class ProductInfoQuestion extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -6579725914686695803L;
	/** 套餐答疑Id*/
	private Integer productInfoQuestionId;
	/** 套餐Id*/
	private Integer productId;
	/** 套餐名称*/
	private String productName;
	/** 会员ID*/
	private Integer customerId;
	/** 会员名称*/
	private String customerName;
	/** 资询类型*/
	private Integer askType;
	/** 资询内容*/
	private String askQuestion;
	/** 资询时间*/
	private Date askTime;
	/**答疑人ID*/
	private Integer answerId;
	/**答疑人名称*/
	private String answerName;
	/**答复*/
	private String answer;
	/**答复时间*/
	private Date answerTime;
	/**店铺审核状态*/
	private Integer shopStatus;
	/**平台审核状态*/
	private Integer status;
	/**审核人ID*/
	private Integer userId;
	/**审核时间*/
	private Date checkTime;
	/**创建时间*/
	private Date createTime;
	/**修改时间*/
	private Date updateTime;
	
	public Integer getProductInfoQuestionId() {
		return productInfoQuestionId;
	}
	public void setProductInfoQuestionId(Integer productInfoQuestionId) {
		this.productInfoQuestionId = productInfoQuestionId;
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
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public String getCustomerName() {
		return customerName;
	}
	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}
	public Integer getAskType() {
		return askType;
	}
	public void setAskType(Integer askType) {
		this.askType = askType;
	}
	public String getAskQuestion() {
		return askQuestion;
	}
	public void setAskQuestion(String askQuestion) {
		this.askQuestion = askQuestion;
	}
	public Date getAskTime() {
		return askTime;
	}
	public void setAskTime(Date askTime) {
		this.askTime = askTime;
	}
	public Integer getAnswerId() {
		return answerId;
	}
	public void setAnswerId(Integer answerId) {
		this.answerId = answerId;
	}
	public String getAnswer() {
		return answer;
	}
	public void setAnswer(String answer) {
		this.answer = answer;
	}
	public Date getAnswerTime() {
		return answerTime;
	}
	public void setAnswerTime(Date answerTime) {
		this.answerTime = answerTime;
	}
	public Integer getStatus() {
		return status;
	}
	public void setStatus(Integer status) {
		this.status = status;
	}
	public Integer getUserId() {
		return userId;
	}
	public void setUserId(Integer userId) {
		this.userId = userId;
	}
	public Date getCheckTime() {
		return checkTime;
	}
	public void setCheckTime(Date checkTime) {
		this.checkTime = checkTime;
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
	public String getAnswerName() {
		return answerName;
	}
	public void setAnswerName(String answerName) {
		this.answerName = answerName;
	}
	public Integer getShopStatus() {
		return shopStatus;
	}
	public void setShopStatus(Integer shopStatus) {
		this.shopStatus = shopStatus;
	}
	
}
