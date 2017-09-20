package rating.buyersRecord.service.imp;
import java.math.BigDecimal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import rating.buyersRecord.dao.IBuyersRecordDao;
import rating.buyersRecord.pojo.BuyersRecord;
import rating.buyersRecord.service.IBuyersRecordService;
import shop.lineofcreditItem.dao.ILineofcreditItemDao;
import shop.lineofcreditItem.pojo.LineofcreditItem;
import util.common.EnumUtils;
import util.other.SerialNumberUtil;
import util.service.BaseService;
/**
 * 买家等级升迁记录Service接口实现
 * @author wsy
 *
 */
public class BuyersRecordService extends BaseService<BuyersRecord> implements IBuyersRecordService {
	private IBuyersRecordDao buyersRecordDao;//买家等级升迁记录Dao
	private ILineofcreditItemDao lineofcreditItemDao;
	/**保存新升迁记录**/
	@SuppressWarnings("rawtypes")
	public BuyersRecord saveBuyersRecord(BuyersRecord buyersRecord){
		SimpleDateFormat format = new SimpleDateFormat(EnumUtils.DataFormat.Y_M_D_H_m_s.getValue());
		String hql="select o.remainingNumber as remainingNumber,o.customerId as customerId,o.ordersId as ordersId,o.ordersNo as ordersNo,o.serialNumber as serialNumber,o.type as type,"
				+ "o.remainingNumber as remainingNumber,o.tradeTime as tradeTime from LineofcreditItem o where o.customerId="+buyersRecord.getCustomerId()+" order by o.operatorTime desc";
		List<Map> lli = lineofcreditItemDao.findListMapPage(hql, 0 ,1);
		List<Map> lbr=buyersRecordDao.findListMapPage("select o.lineOfCredit as lineOfCredit from BuyersRecord o where o.customerId="+buyersRecord.getCustomerId()+" order by o.optionDate desc",0,1);
		if(lbr!=null&&lbr.size()>0){
			BigDecimal oldEdu = new BigDecimal(lbr.get(0).get("lineOfCredit").toString());//总额度[旧,升迁记录表]
			if(lli!=null&&lli.size()>0){
				BigDecimal oldYuE = new BigDecimal(lli.get(0).get("remainingNumber").toString());//余额(旧)
				BigDecimal newEdu = buyersRecord.getLineOfCredit();//总额度(新,[策略表,传入的最新总额度])
				Integer customerId =buyersRecord.getCustomerId();//用户ID
				Integer type = Integer.valueOf(lli.get(0).get("type").toString());//买家类型
				LineofcreditItem lineofcreditItem = new LineofcreditItem();
				//判断是升级还是降级
				if(newEdu.compareTo(oldEdu)>0){//满足条件说明是升级
					BigDecimal cha = newEdu.subtract(oldEdu);//新旧总额度之间的[差值]
					BigDecimal newYuE = oldYuE.add(cha);//[旧余额]+[差值]=[新余额]
					lineofcreditItem.setCustomerId(customerId);//用户ID
					lineofcreditItem.setSerialNumber(SerialNumberUtil.VirtualCoinNumber());//金币流水号
					lineofcreditItem.setType(type);//买家类型
					lineofcreditItem.setOrdersId(0);//订单ID
					try {
						lineofcreditItem.setTradeTime(format.parse(lli.get(0).get("tradeTime").toString()));//注册时间
					} catch (ParseException e) {
						String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
					}
					lineofcreditItem.setOperatorTime(new Date());//操作时间
					lineofcreditItem.setRemarks("变更等级：升级");
					lineofcreditItem.setTransactionNumber(new BigDecimal(0));//已使用
					lineofcreditItem.setFrozenNumber(new BigDecimal(0));//冻结
					if(oldEdu.compareTo(oldYuE)==0){//如果没使用额度
						lineofcreditItem.setRemainingNumber(newEdu);//新余额
					}else{
						lineofcreditItem.setRemainingNumber(newYuE);//新余额
					}
					lineofcreditItemDao.saveOrUpdateObject(lineofcreditItem);
				}else if(newEdu.compareTo(oldEdu)<0){
					BigDecimal cha = oldEdu.subtract(newEdu);//新旧总额度之间的[差值]
					BigDecimal newYuE = oldYuE.subtract(cha);//[旧余额]-[差值]=[新余额]
					lineofcreditItem.setCustomerId(customerId);//用户ID
					lineofcreditItem.setSerialNumber(SerialNumberUtil.VirtualCoinNumber());//金币流水号
					lineofcreditItem.setType(type);//买家类型
					lineofcreditItem.setOrdersId(0);//订单ID
					try {
						lineofcreditItem.setTradeTime(format.parse(lli.get(0).get("tradeTime").toString()));//注册时间
					} catch (ParseException e) {
						String tryCatch_className = Thread.currentThread().getStackTrace()[1].getClassName();String tryCatch_methodName = Thread.currentThread().getStackTrace()[1].getMethodName();StackTraceElement[] stackTrace = e.getStackTrace();int lineCount_log = 1;for (StackTraceElement stackTraceElement : stackTrace) {int e_lineNumber = stackTraceElement.getLineNumber();String e_className = stackTraceElement.getClassName();String e_methodName = stackTraceElement.getMethodName();logger.error("tryCatch_className: "+tryCatch_className+"    tryCatch_methodName: "+tryCatch_methodName+"    !!!!  "+lineCount_log+++"、  "+"#e.className: "+e_className+"    #e.methodName: "+e_methodName+"    #e.lineNumber: "+e_lineNumber+"    #e.info: "+e);}
					}
					lineofcreditItem.setOperatorTime(new Date());//操作时间
					lineofcreditItem.setRemarks("变更等级：降级");
					lineofcreditItem.setTransactionNumber(new BigDecimal(0));//已使用
					if(oldEdu.compareTo(oldYuE)==0){//如果没使用额度
						lineofcreditItem.setRemainingNumber(newEdu);//新余额
					}else{
						lineofcreditItem.setRemainingNumber(newYuE);//新余额
					}
					lineofcreditItem.setFrozenNumber(new BigDecimal(0));//冻结
					lineofcreditItemDao.saveOrUpdateObject(lineofcreditItem);
				}
			}
			buyersRecord =buyersRecordDao.saveOrUpdateObject(buyersRecord);
		}
		return buyersRecord;
	}
	public void setBuyersRecordDao(IBuyersRecordDao buyersRecordDao) {
		this.baseDao = this.buyersRecordDao = buyersRecordDao;
	}
	public void setLineofcreditItemDao(ILineofcreditItemDao lineofcreditItemDao) {
		this.lineofcreditItemDao = lineofcreditItemDao;
	}
}
