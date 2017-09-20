package shop.customer.service;
import java.util.Map;
import shop.customer.pojo.VirtualCoin;
import util.service.IBaseService;
/**
 * 金币Service接口
 * 
 *
 */
public interface IVirtualCoinService extends IBaseService <VirtualCoin> {
	/**
	 * 注册赠送金币
	 * @param id 用户ID
	 * @param keyBookMap  金币规则keyBookMap
	 */
	public void saveRegisterVirtualCoin(Integer id,Map<String,Object> keyBookMap);
	/**
	 * 推荐赠送金币
	 * @param id  推荐人ID
	 * @param keyBookMap 金币规则keyBookMap
	 */
	public void saveRecommendVirtualCoin(String id,Map<String, Object> keyBookMap);
}
