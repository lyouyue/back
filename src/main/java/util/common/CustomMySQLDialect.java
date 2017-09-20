package util.common;

import java.sql.Types;

import org.hibernate.Hibernate;
import org.hibernate.dialect.MySQL5Dialect;
import org.hibernate.dialect.function.StandardSQLFunction;

/**
 * 自定义重写hibernate的mysql方言分页limit查询。
 */
public class CustomMySQLDialect extends MySQL5Dialect {
	/**
	 * 自定义重写hibernate的mysql方言分页limit查询。 sql：业务查询最终sql语句 hasOffset：真假，使用哪种limit方法
	 */
	public String getLimitString(String sql, boolean hasOffset) {
		StringBuffer customLimit = new StringBuffer(sql.length() + 20);
		customLimit.append(sql).append(hasOffset ? " limit ?, ?" : " limit ?");
		return customLimit.toString();
	}

	/**
	 * 自定义重写hibernate的mysql方言分页group_concat语法。
	 */
	public CustomMySQLDialect() {
		super();
		registerHibernateType(Types.LONGVARCHAR, Hibernate.TEXT.getName());
		registerHibernateType(Types.LONGVARBINARY, Hibernate.BLOB.getName());
		// 支持MySQl5.5及以上版本（5.1版本程序需转换二进制）
		//使用该语法时，group_concat默认返回的是BLOB大对象，需要外层添加一个转换字符串函数：“concat”
		//例如：concat(group_concat(a.stId))
		registerFunction("group_concat", new StandardSQLFunction("group_concat", Hibernate.STRING));
	}

}
