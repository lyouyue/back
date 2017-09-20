package shop.customer.service;

import shop.customer.pojo.FundDetail;
import util.service.IBaseService;

import java.math.BigDecimal;

/**
 * 资金流水明细Service接口
 */
public interface IFundDetailService extends IBaseService<FundDetail> {

    /**
     * 保存资金流水明细
     * @param fundDetail
     * @return
     * @throws Exception
     */
    public FundDetail saveOrUpdateObject(FundDetail fundDetail);

    /**
     * 根据用户id查询总支出
     * @param customerId
     * @return
     * @throws Exception
     */
    public BigDecimal getBalanceExpenditureByCustomerId(Integer customerId) throws Exception;

    /**
     * 根据用户id查询总收入
     * @param customerId
     * @return
     * @throws Exception
     */
    public BigDecimal getBalanceIncomeByCustomerId(Integer customerId) throws Exception;
    /**
     * 保存返利资金流水明细
     * @param customerId
     * @param code
     * @param amount
     * @return
     */
    public String saveOrderOver(int customerId,String totalNo,String code,BigDecimal amount,BigDecimal secAmount,BigDecimal thiAmount) throws Exception;
}
