package wxmg.basicInfo.service.imp;

import util.service.BaseService;
import wxmg.basicInfo.dao.IFansPublicnoDao;
import wxmg.basicInfo.pojo.FansPublicno;
import wxmg.basicInfo.service.IFansPublicnoService;
/**
 * 粉丝用户和公众号关联信息Service接口实现类
 * @author 郑月龙
 */
public class FansPublicnoService extends BaseService <FansPublicno> implements IFansPublicnoService {
	@SuppressWarnings("unused")
	private IFansPublicnoDao fansPublicnoDao;
	public void setFansPublicnoDao(IFansPublicnoDao fansPublicnoDao) {
		this.baseDao = this.fansPublicnoDao = fansPublicnoDao;
	}
}
