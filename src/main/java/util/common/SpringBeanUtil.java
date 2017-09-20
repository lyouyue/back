/*
 * Copyright (c) 2016 ShopJsp. All Rights Reserved.
 * ============================================================================
 * 版权所有 2011 - 今 北京华宇盈通科技有限公司，并保留所有权利。
 * ----------------------------------------------------------------------------
 * 提示：在未取得SHOPJSP商业授权之前，您不能将本软件应用于商业用途，否则SHOPJSP将保留追究的权力。
 * ----------------------------------------------------------------------------
 * 官方网站：http://www.shopjsp.com
 * ============================================================================
 */
package util.common;

import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

/**
 * @version : v1.00
 * @author : ankang
 * @Creation Date : 2012-10-27 上午11:47:31
 * @Description : 以静态变量保存Spring ApplicationContext,
 *              可在任何代码任何地方任何时候中取出ApplicaitonContext.
 */
public class SpringBeanUtil {

	private static ApplicationContext applicationContext;

	/**
	 * 初始化类，获取上下文ApplicationContext
	 */
	static {
		ApplicationContext ac = new ClassPathXmlApplicationContext("applicationContext*.xml");
		applicationContext = ac;
	}

	/**
	 * 实现ApplicationContextAware接口的context注入函数, 将其存入静态变量.
	 */
	public void setApplicationContext(ApplicationContext applicationContext) {
		SpringBeanUtil.applicationContext = applicationContext;
	}

	/**
	 * 取得存储在静态变量中的ApplicationContext.
	 */
	public static ApplicationContext getApplicationContext() {
		checkApplicationContext();
		return applicationContext;
	}

	/**
	 * 从静态变量ApplicationContext中取得Bean, 自动转型为所赋值对象的类型.
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getBean(String name) {
		checkApplicationContext();
		return (T) applicationContext.getBean(name);
	}

	/**
	 * 从静态变量ApplicationContext中取得Bean, 自动转型为所赋值对象的类型.
	 */
	@SuppressWarnings("unchecked")
	public static <T> T getBean(Class<T> clazz) {
		checkApplicationContext();
		return (T) applicationContext.getBeansOfType(clazz);
	}

	private static void checkApplicationContext() {
		if (applicationContext == null) {
			throw new IllegalStateException("applicaitonContext未注入,请在applicationContext.xml中定义SpringContextHolder");
		}
	}
}
