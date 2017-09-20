package shop.homeIndex.service.imp;

import shop.homeIndex.dao.ITopSearchDao;
import shop.homeIndex.pojo.TopSearch;
import shop.homeIndex.service.ITopSearchService;
import util.service.BaseService;
/**
 * 热门搜索Service
 * @author Administrator
 * 2014-05-12
 */
public class TopSearchService extends BaseService<TopSearch> implements
		ITopSearchService {
	@SuppressWarnings("unused")
	private ITopSearchDao topSearchDao;

	public void setTopSearchDao(ITopSearchDao topSearchDao) {
		this.baseDao = this.topSearchDao = topSearchDao;
	}
}
