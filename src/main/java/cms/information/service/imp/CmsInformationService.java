package cms.information.service.imp;

import util.service.BaseService;
import cms.information.dao.ICmsInformationDao;
import cms.information.pojo.CmsInformation;
import cms.information.service.ICmsInformationService;
/**
 * 信息Service接口实现
 * @author FuLei
 *
 */
public class CmsInformationService extends BaseService<CmsInformation> implements ICmsInformationService{

	@SuppressWarnings("unused")
	private ICmsInformationDao cmsInformationDao;

	public void setCmsInformationDao(ICmsInformationDao cmsInformationDao) {
		this.baseDao=this.cmsInformationDao = cmsInformationDao;
	}

	
}
