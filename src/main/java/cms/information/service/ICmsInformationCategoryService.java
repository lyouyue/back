package cms.information.service;

import java.util.List;

import util.service.IBaseService;
import cms.information.pojo.CmsInformationCategory;
/**
 * 信息分类Service
 * @author FuLei
 *
 */
public interface ICmsInformationCategoryService extends IBaseService<CmsInformationCategory> {
	/**
	 * 根据id查找子分类对象
	 * 
	 * @param id
	 *            
	 * @return List
	 */
	@SuppressWarnings("rawtypes")
	public List queryByParentId(String id);
	/**
	 * 修改父亲的节点状态为1
	 * 
	 * @param categoryId
	 *            
	 * @return 
	 */
	public void updateFatherIsLeaf(String informationCategoryId);
	/**
	 * 根据id删除分类
	 * 
	 * @param key, ids
	 *            
	 * @return Boolean
	 */
	public Boolean deleteInformationCategoryByIds(String string, String ids);
	/**
	 * 删除当前分类 
	 * 
	 * @param ids
	 *            
	 * @return String
	 */
	public String deleteInformationCategoryAndInformationByIds(String ids);

}
