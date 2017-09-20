package quartz.service;

import tuan.pojo.TuanProduct;
import tuan.service.ITuanProductService;
import util.common.EnumUtils;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 团购套餐锁定定时器Service
 * @author Administrator
 * 2014-12-02
 */
public class QuartzTuanProductStateService {
	/**团购申请Service**/
	private ITuanProductService tuanProductService;

	/**
	 * 团购结束，修改状态
	 */
	@SuppressWarnings("unchecked")
	public void saveCloseState(){
		Date date = new Date();//系统当前时间
		SimpleDateFormat dateformat=new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		String dateEnd = dateformat.format(date);
		/**团购套餐结束集合**/
		List<TuanProduct> tuanProductList = new ArrayList<TuanProduct>();
		tuanProductList = tuanProductService.findObjects(null, " where o.state = 1 and UNIX_TIMESTAMP(o.endTime) < UNIX_TIMESTAMP('"+dateEnd+"')");
		for(TuanProduct tuanProduct:tuanProductList){
			tuanProduct.setState(3);//团购已结束
			tuanProductService.saveOrUpdateObject(tuanProduct);
		}
	}

	public void setTuanProductService(ITuanProductService tuanProductService) {
		this.tuanProductService = tuanProductService;
	}
}