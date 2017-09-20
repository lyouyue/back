package wxmg.material.service.imp;

import util.service.BaseService;
import wxmg.material.dao.ITextMessageInfoDao;
import wxmg.material.pojo.TextMessageInfo;
import wxmg.material.service.ITextMessageInfoService;

/**
 * 素材图文接口实现类
 * @author 李续
 * 
 */
public class TextMessageInfoService extends BaseService<TextMessageInfo>
		implements ITextMessageInfoService {
	@SuppressWarnings("unused")
	private ITextMessageInfoDao textMessageInfoDao;

	public void setTextMessageInfoDao(ITextMessageInfoDao textMessageInfoDao) {
		this.baseDao = this.textMessageInfoDao = textMessageInfoDao;
	}

}
