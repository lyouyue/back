package phone.back.pojo;

import java.io.Serializable;

import util.pojo.BaseEntity;
/**
 * 手机端数据字典
 * 
 *	2014-01-22
 */
public class PhoneKeyBook extends BaseEntity implements Serializable {
	private static final long serialVersionUID = 1693235566968142980L;
	/**
	 * ID
	 */
	private Integer homeKeyBookId;
	/**
	 * 值
	 */
	private String value;
	/**
	 * 名称
	 */
	private String name;
	/**
	 * 类型
	 */
	private String type;
	/**
	 * 类型名称
	 */
	private String typeName;
	
	public Integer getHomeKeyBookId() {
		return homeKeyBookId;
	}
	public void setHomeKeyBookId(Integer homeKeyBookId) {
		this.homeKeyBookId = homeKeyBookId;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getTypeName() {
		return typeName;
	}
	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}
	
}
