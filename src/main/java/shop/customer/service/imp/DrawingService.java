package shop.customer.service.imp;

import shop.customer.dao.IDrawingDao;
import shop.customer.pojo.Drawing;
import shop.customer.service.IDrawingService;
import util.service.BaseService;
/**
 * 充值记录Service接口实现类
 */
public class DrawingService extends BaseService<Drawing> implements IDrawingService {
	@SuppressWarnings("unused")
	private IDrawingDao drawingDao;

	public void setDrawingDao(IDrawingDao drawingDao) {
		this.baseDao =this.drawingDao = drawingDao;
	}

}
