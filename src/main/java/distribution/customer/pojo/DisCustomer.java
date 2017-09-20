package distribution.customer.pojo;
import java.io.Serializable;
import java.util.Date;

import util.pojo.BaseEntity;
/**
 * 分销用户关系表上下级
 */
public class DisCustomer extends BaseEntity implements Serializable{
	private static final long serialVersionUID = -7775741606701224241L;
	private Integer discustomerId;
    private Integer customerId;//用户ID
    private Integer level1id;//上1级分销商ID
    private Integer level2id;//上2级分销商ID
    private Integer level3id;//上3级分销商ID
    private Integer isJMS;//自己是否加盟商
    private Integer JMSId;//加盟商ID
    private Date createTime;//创建时间
    private Integer isCriticalValue;//是否消费满临界值 改成1，不可逆转
    private String visitingCard;//二维码明信片地址
    private String cardOverTime;//二维码明信片失效时间
     
	public Integer getDiscustomerId() {
		return discustomerId;
	}
	public void setDiscustomerId(Integer discustomerId) {
		this.discustomerId = discustomerId;
	}
	public Integer getCustomerId() {
		return customerId;
	}
	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}
	public Integer getLevel1id() {
		return level1id;
	}
	public void setLevel1id(Integer level1id) {
		this.level1id = level1id;
	}
	public Integer getLevel2id() {
		return level2id;
	}
	public void setLevel2id(Integer level2id) {
		this.level2id = level2id;
	}
	public Integer getLevel3id() {
		return level3id;
	}
	public void setLevel3id(Integer level3id) {
		this.level3id = level3id;
	}
	public Date getCreateTime() {
		return createTime;
	}
	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}
	public Integer getIsCriticalValue() {
		return isCriticalValue;
	}
	public void setIsCriticalValue(Integer isCriticalValue) {
		this.isCriticalValue = isCriticalValue;
	}
	public String getVisitingCard() {
		return visitingCard;
	}
	public void setVisitingCard(String visitingCard) {
		this.visitingCard = visitingCard;
	}
	public String getCardOverTime() {
		return cardOverTime;
	}
	public void setCardOverTime(String cardOverTime) {
		this.cardOverTime = cardOverTime;
	}
	public Integer getIsJMS() {
		return isJMS;
	}
	public void setIsJMS(Integer isJMS) {
		this.isJMS = isJMS;
	}
	public Integer getJMSId() {
		return JMSId;
	}
	public void setJMSId(Integer jMSId) {
		JMSId = jMSId;
	}
}
