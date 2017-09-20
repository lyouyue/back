package phone.back.service.imp;

import java.util.List;

import phone.back.dao.IPhoneKeyBookDao;
import phone.back.pojo.PhoneKeyBook;
import phone.back.service.IPhoneKeyBookService;
import util.service.BaseService;

public class PhoneKeyBookService extends BaseService<PhoneKeyBook> implements IPhoneKeyBookService{
	private IPhoneKeyBookDao phoneKeyBookDao;

	public void setPhoneKeyBookDao(IPhoneKeyBookDao phoneKeyBookDao) {
		this.baseDao=this.phoneKeyBookDao = phoneKeyBookDao;
	}

	/**
	 * 数据字典根据列名去重
	 * 
	 * @param column  列名
	 * 
	 * @param whereCondition  查询条件
	 * 
	 * @return 返回List集合
	 */
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List distinctType(String column,String whereCondition){
		return phoneKeyBookDao.findUnSame(column, whereCondition);
	}
	
}
