package shop.customer.dao;

import shop.customer.pojo.CustomerBankroll;
import util.dao.IBaseDao;

import java.math.BigDecimal;

/**
 * 账户资金Dao接口
 */
public interface ICustomerBankrollDao extends IBaseDao<CustomerBankroll> {
    /**
     * 根据用户id查询现金钱包总余额
     * @param customer_id
     * @return
     */
    public BigDecimal getCustomerBalanceByCustomerId(Integer customer_id) throws Exception;

    /**
     * 根据用户id查询现金钱包充值总额
     * @param customer_id
     * @return
     */
    public BigDecimal getBalanceRechargeByCustomerId(Integer customer_id) throws Exception;

    /**
     * 根据用户id查询 现金钱包金币 总额
     * @param customer_id
     * @return
     * @throws Exception
     */
    public BigDecimal getBalanceCoinByCustomerId(Integer customer_id) throws Exception;

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
     * @param beforeSeconds 在...秒以前
     * @throws Exception
     */
    public void deleteExpiredFinanceSynced(Integer beforeSeconds) throws Exception;
}