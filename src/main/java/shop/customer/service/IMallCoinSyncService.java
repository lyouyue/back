package shop.customer.service;

import shop.customer.pojo.MallCoin;
import shop.customer.pojo.MallCoinSync;
import util.service.IBaseService;

/**
 * 金币流水Service接口
 * @author zhangdingfang
 */
public interface IMallCoinSyncService extends IBaseService<MallCoinSync> {

	/**
	 * 保存金币流水到影子表（待同步）
	 * @param mallCoin
	 * @throws Exception
     */
	public void saveMallCoinSync(MallCoin mallCoin) throws Exception;
}
