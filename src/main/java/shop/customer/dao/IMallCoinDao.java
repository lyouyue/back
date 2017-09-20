package shop.customer.dao;
import shop.customer.pojo.MallCoin;
import util.dao.IBaseDao;

import java.math.BigDecimal;

/**
 * 金币Dao接口
 * @author mf
 */
public interface IMallCoinDao extends IBaseDao <MallCoin>{
    /**
     * 根据用户id及订单号查询金币明细
     * @param customerId
     * @param ordersNo
     * @return
     */
    public MallCoin getObjectByParam(Integer customerId, String ordersNo);

    /**
     * 根据用户id查询总支出
     * @param customerId
     * @return
     * @throws Exception
     */
    public BigDecimal getCoinExpenditureByCustomerId(Integer customerId) throws Exception;

    /**
     * 根据用户id查询总收入
     * @param customerId
     * @return
     * @throws Exception
     */
    public BigDecimal getCoinIncomeByCustomerId(Integer customerId) throws Exception;
}
