package cms.information.service.imp;

import java.util.List;

import util.service.BaseService;
import cms.information.dao.ICmsInformationCategoryDao;
import cms.information.pojo.CmsInformationCategory;
import cms.information.service.ICmsInformationCategoryService;
import cms.information.service.ICmsInformationService;
/**
 * 信息分类Service实现类
 * @author FuLei
 *
 */
public class CmsInformationCategoryService extends BaseService<CmsInformationCategory> implements ICmsInformationCategoryService {

	 private ICmsInformationCategoryDao cmsInformationCategoryDao;
     private ICmsInformationService cmsInformationService;
	public void setCmsInformationCategoryDao(ICmsInformationCategoryDao cmsInformationCategoryDao) {
		this.baseDao=this.cmsInformationCategoryDao = cmsInformationCategoryDao;
	}
   
	public void setCmsInformationService(ICmsInformationService cmsInformationService) {
		this.cmsInformationService = cmsInformationService;
	}
	/**
	 * 根据id查找子分类对象
	 * 
	 * @param id
	 *            
	 * @return List
	 */
	@SuppressWarnings({"rawtypes" })
	public List queryByParentId(String id) {
		return cmsInformationCategoryDao.findObjects(null,"where 1=1 and o.parentId="+id+" order by sortCode asc");
	}
	/**
	 * 修改父亲的节点状态为1
	 * 
	 * @param categoryId
	 *            
	 * @return 
	 */
	public void updateFatherIsLeaf(String informationCategoryId) {
		CmsInformationCategory cmsInformationCategory = (CmsInformationCategory)cmsInformationCategoryDao.getObjectById(informationCategoryId);
		cmsInformationCategory.setIsLeaf(0);
		cmsInformationCategoryDao.saveOrUpdateObject(cmsInformationCategory);
	}
	/**
	 * 根据id删除分类
	 * 
	 * @param key, ids
	 *            
	 * @return Boolean
	 */
	public Boolean deleteInformationCategoryByIds(String key, String ids) {
		String [] idss=ids.split(",");
		String queryParams=" where 1=1 and ";
		if(idss.length>1){//删除多个对象
			queryParams+="(";
			for(int i=0;i<idss.length;i++){
				if(i==0){
					queryParams+="o."+key+"='"+idss[i]+"'";
				}else{
					queryParams+=" or o."+key+"='"+idss[i]+"'";
				}
			}
			queryParams+=")";
		}else{
			queryParams+=" o."+key+"='"+idss[0]+"'";//删除一个对象
		}
		CmsInformationCategory cmsInformationCategory = (CmsInformationCategory)cmsInformationCategoryDao.getObjectById(idss[0]);
		if(cmsInformationCategory.getIsLeaf()==1){
			return baseDao.deleteByParams(queryParams);
		}else{
			return false;
		}
	}
	/**
	 * 删除当前分类 
	 * 
	 * @param ids
	 *            
	 * @return String
	 */
	@SuppressWarnings({ "unchecked", "unused" })
	public String deleteInformationCategoryAndInformationByIds(String ids) {
		 //strFlag="1"，有信息 。strFlag="2" 可以删除，既是叶子节点也没有信息
		 String strFlag="";
			 //1判断当前分类下面是否有信息，有信息则不能删除
			 Integer count = cmsInformationService.getCount(" where 1=1 and o.categoryId="+ids);
			 if(count==0){
			 //2删除
				 //2.1 删除前先取出来给后面的使用 ,当前分类的父分类 
				 Integer informationCategoryId = ((CmsInformationCategory)getObjectById(ids)).getParentId();
				 boolean boole = cmsInformationCategoryDao.deleteObjectById(ids);
				 strFlag="2";
		        //2.2修改节点,检查父分类下面是否还有子分类 ，如果没有把isLeaf置为：0 ,否则不变  1是叶子，0 不是叶子 
				 List<CmsInformationCategory> list = cmsInformationCategoryDao.findObjects(null," where 1=1 and o.parentId="+informationCategoryId);
				 //通过上面整个方法验证，当没查到数据的时候，getCount得到的长度是1
				 Integer count2 = cmsInformationCategoryDao.getCount(" where 1=1 and o.parentId="+informationCategoryId);
					if(count2==1){
						CmsInformationCategory cmsInformationCategory2 = (CmsInformationCategory)cmsInformationCategoryDao.getObjectById(informationCategoryId.toString());
						cmsInformationCategory2.setIsLeaf(1);
						cmsInformationCategoryDao.saveOrUpdateObject(cmsInformationCategory2);
					}
			 }else{
				 strFlag="1";
			 }
		 
		return strFlag;
	}
	
	 
	 

}
