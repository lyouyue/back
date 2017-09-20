package wxmg.material.service.imp;

import java.util.Date;

import basic.pojo.Users;
import util.service.BaseService;
import wxmg.material.dao.IMaterialImageInfoDao;
import wxmg.material.pojo.MaterialImageInfo;
import wxmg.material.service.IMaterialImageInfoService;
import wxmg.publicNo.pojo.PublicNoInfo;
/**
 * 素材图片接口实现类
 * @author 李续
 *
 */
public class MaterialImageInfoService  extends BaseService  <MaterialImageInfo> implements IMaterialImageInfoService{
	@SuppressWarnings("unused")
	private IMaterialImageInfoDao materialImageInfoDao;

	public void setMaterialImageInfoDao(IMaterialImageInfoDao materialImageInfoDao) {
		this.baseDao = this.materialImageInfoDao = materialImageInfoDao;
	}

	//保存套餐一键转换为图片素材
		public MaterialImageInfo saveConvertMaterialImage(MaterialImageInfo materialImageInfo){
			materialImageInfo.setPicFormatEnumId(1);
			materialImageInfo.setDeletedFlag(0);
			materialImageInfo.setInfoSendFlag(1);
			materialImageInfo.setLastUpdateDateDatetime(new Date());
			materialImageInfo.setCreateTime(new Date());
			materialImageInfo.setImageTxtFlag(1);
			materialImageInfo=(MaterialImageInfo)materialImageInfoDao.saveObject(materialImageInfo);
			return materialImageInfo;
		}
	
}
