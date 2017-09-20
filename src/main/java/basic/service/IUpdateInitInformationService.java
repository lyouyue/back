package basic.service;
import java.io.IOException;
import java.util.Map;

import util.service.IBaseService;
import basic.pojo.Users;
/**
 * 数据导入Service接口
 * 
 */
public interface IUpdateInitInformationService  extends IBaseService <Users> {
	/**
	 * 将Excel的数据导入数据库
	 * 文件数据结构需遵从Excel模板
	 * @param map
	 * key==value
	 ***************************
	 * imagePathFileName==imagePathFileName
	 * categoryId==categoryId
	 * imagePath==imagePath
	 ***************************
	 */
	public void saveExcelFile(Map<String,Object> map) throws IOException;
}
