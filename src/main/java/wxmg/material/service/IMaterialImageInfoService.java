package wxmg.material.service;

import util.service.IBaseService;
import wxmg.material.pojo.MaterialImageInfo;
/*
 * /**
 * 素材图片信息Service接口实现类
 * @author 李续
 *
 */
public interface IMaterialImageInfoService  extends IBaseService <MaterialImageInfo>{
	//保存套餐一键转换为图片素材
	public MaterialImageInfo saveConvertMaterialImage(MaterialImageInfo materialImageInfo);
}
