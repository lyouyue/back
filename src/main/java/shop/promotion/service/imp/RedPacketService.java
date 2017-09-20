package shop.promotion.service.imp;
import shop.promotion.dao.IRedPacketDao;
import shop.promotion.pojo.RedPacket;
import shop.promotion.service.IRedPacketService;
import util.service.BaseService;
public class RedPacketService extends BaseService  <RedPacket> implements IRedPacketService{
	@SuppressWarnings("unused")
	private IRedPacketDao redPacketDao;
	public void setRedPacketDao(IRedPacketDao redPacketDao) {
		this.baseDao =this.redPacketDao= redPacketDao;
	}
}