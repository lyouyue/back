package shop.customer.service.imp;

import shop.customer.dao.IDrawingBackDao;
import shop.customer.pojo.DrawingBack;
import shop.customer.service.IDrawingBackService;
import util.service.BaseService;
/**
 * 提现退回Service接口实现类
 */
public class DrawingBackService extends BaseService<DrawingBack> implements IDrawingBackService {
	@SuppressWarnings("unused")
	private IDrawingBackDao drawingBackDao;

	public void setDrawingBackDao(IDrawingBackDao drawingBackDao) {
		this.baseDao =this.drawingBackDao = drawingBackDao;
	}

	
}
