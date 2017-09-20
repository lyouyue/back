package shop.customer.service.imp;
import shop.customer.dao.IEvaluateGoodsDao;
import shop.customer.pojo.EvaluateGoods;
import shop.customer.service.IEvaluateGoodsService;
import util.other.Utils;
import util.service.BaseService;
/**
 * 
 * @author
 * 
 */
public class EvaluateGoodsService extends BaseService<EvaluateGoods> implements
		IEvaluateGoodsService {
	private IEvaluateGoodsDao evaluateGoodsDao;
	/**
	 * 修改会员评价的内容和状态
	 * 
	 * @author 刘钦楠
	 */
	public EvaluateGoods updateContentAndEvaluateState(String id,
			String content, String evaluateState) {
		EvaluateGoods evaluateGoods = evaluateGoodsDao.getObjectById(id);
		if (Utils.objectIsNotEmpty(evaluateGoods)) {
			evaluateGoods.setContent(content);
			evaluateGoods.setEvaluateState(Integer.valueOf(evaluateState));
			evaluateGoods=	evaluateGoodsDao.saveOrUpdateObject(evaluateGoods);
		}
		return evaluateGoods;
	}
	public void setEvaluateGoodsDao(IEvaluateGoodsDao evaluateGoodsDao) {
		this.baseDao = this.evaluateGoodsDao = evaluateGoodsDao;
	}
}