package shop.customer.service;

import shop.customer.pojo.CustomerBankroll;
import util.service.IBaseService;

/**
 * 账户资金Service接口
 */
public interface ICustomerBankrollService extends IBaseService<CustomerBankroll> {

    /**
     * 获得用户指定类型的总余额【仅用于查询总余额、余额总支出、余额总收入】
     *
     * @param customerId
     * @param shopCustomerBalanceType 加密后的查询余额的类型
     * @return 加密后的余额
     */
    public String getCustomerBalance(Integer customerId, String shopCustomerBalanceType) throws Exception;

    /**
     * 根据用户id查询金币总余额
     * @param customerId
     * @return 加密后的余额
     * @throws Exception
     */
    public String getBalanceCoinByCustomerId(Integer customerId) throws Exception;

    /**
     * 同步现金钱包，用户余额、充值总额
     * @throws Exception
     */
    public void saveBankRollBySync() throws Exception;

    /**
     * 同步现金钱包，用户总金币
     * @throws Exception
     */
    public void saveBankRollMallCoinBySync() throws Exception;

    /**
     * 删除过期的已同步的财务记录
     * @throws Exception
     */
    public void deleteExpiredFinanceSynced() throws Exception;
}