package shop.customer.action;
import shop.customer.service.ISonaccountService;
import util.action.BaseAction;
@SuppressWarnings("serial")
public class SonaccountAction extends BaseAction {
	/**会员子帐号service**/
	@SuppressWarnings("unused")
	private ISonaccountService sonaccountService;
	public void setSonaccountService(ISonaccountService sonaccountService) {
		this.sonaccountService = sonaccountService;
	}
}
