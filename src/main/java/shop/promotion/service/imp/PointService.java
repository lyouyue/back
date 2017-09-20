package shop.promotion.service.imp;
import shop.promotion.dao.IPointDao;
import shop.promotion.pojo.Point;
import shop.promotion.service.IPointService;
import util.service.BaseService;
/**
 * 金币政策Service接口实现类
 * 
 *
 */
public class PointService extends BaseService  <Point> implements IPointService{
	@SuppressWarnings("unused")
	private IPointDao pointDao;
	public void setPointDao(IPointDao pointDao) {
		this.baseDao =this.pointDao= pointDao;
	}
}