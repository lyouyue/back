package phone.back.service;

import java.util.List;

import phone.back.pojo.PhoneKeyBook;
import util.service.IBaseService;

public interface IPhoneKeyBookService  extends IBaseService <PhoneKeyBook> {
	/**
	 * 数据字典根据列名去重
	 * 
	 * @param column  列名
	 * 
	 * @param whereCondition  查询条件
	 * 
	 * @return 返回List集合
	 */
	public List<String> distinctType(String column,String whereCondition);
}
