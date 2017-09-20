package basic.pojo;

import java.io.Serializable;

import javax.persistence.Entity;

import util.pojo.BaseEntity;

/**
 * 基础配置实体类
 * @author FuLei
 * @date 2016年1月8日 上午14:57:52
 * @version V1.0
 */
@Entity
public class SystemConfig extends BaseEntity implements Serializable {
	
	private static final long serialVersionUID = 6847115229265759159L;
	/**
	 * ID
	 */
	private Integer id;
	/**
	 * 名称
	 */
	private String name;
	/**
	 * 类型
	 */
	private String type;
	/**
	 * 值
	 */
	private String value;
	/**
	 * 组别
	 **/
	private String groupColumn;
	
	public Integer getId() {
		return id;
	}
	public void setId(Integer id) {
		this.id = id;
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
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	public String getGroupColumn() {
		return groupColumn;
	}
	public void setGroupColumn(String groupColumn) {
		this.groupColumn = groupColumn;
	}
	
}
