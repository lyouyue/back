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
package util.json;

/**
 * fastJson操作工具类
 *
 * @Author: ankang
 * @Date 2016/7/13 0013 下午 12:02
 */

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.alibaba.fastjson.serializer.JSONLibDataFormatSerializer;
import com.alibaba.fastjson.serializer.SerializeConfig;
import com.alibaba.fastjson.serializer.SerializerFeature;
import com.sun.org.apache.xml.internal.security.keys.content.KeyValue;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


public class FastJsonUtils {

    private static final SerializeConfig config;

    static {
        config = new SerializeConfig();
        config.put(java.util.Date.class, new JSONLibDataFormatSerializer()); // 使用和json-lib兼容的日期输出格式
        config.put(java.sql.Date.class, new JSONLibDataFormatSerializer()); // 使用和json-lib兼容的日期输出格式
    }

    private static final SerializerFeature[] features = {SerializerFeature.WriteMapNullValue, // 输出空置字段
            SerializerFeature.WriteNullListAsEmpty, // list字段如果为null，输出为[]，而不是null
            SerializerFeature.WriteNullNumberAsZero, // 数值字段如果为null，输出为0，而不是null
            SerializerFeature.WriteNullBooleanAsFalse, // Boolean字段如果为null，输出为false，而不是null
            SerializerFeature.WriteNullStringAsEmpty // 字符类型字段如果为null，输出为""，而不是null
    };


    /**
     * 对象转json，带预处理
     *
     * @param object
     * @return
     */
    public static String toJSONFeaturesString(Object object) {
        return JSON.toJSONString(object, config, features);
    }

    /**
     * 对象转json，不带预处理
     *
     * @param object
     * @return
     */
    public static String toJSONString(Object object) {
        return JSON.toJSONString(object, config);
    }


    /**
     * josn转对象
     *
     * @param text
     * @return
     */
    public static Object toBean(String text) {
        return JSON.parse(text);
    }

    /**
     * json转指定对象
     *
     * @param text  json串
     * @param clazz 指定类型
     * @param <T>
     * @return
     */
    public static <T> T toBean(String text, Class<T> clazz) {
        return JSON.parseObject(text, clazz);
    }

    /**
     * json转换为数组
     *
     * @param text
     * @param <T>
     * @return
     */
    public static <T> Object[] toArray(String text) {
        return toArray(text, null);
    }

    /**
     * 转换为对象数组
     *
     * @param text
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> Object[] toArray(String text, Class<T> clazz) {
        return JSON.parseArray(text, clazz).toArray();
    }

    /**
     * json转换为List
     *
     * @param text
     * @param clazz
     * @param <T>
     * @return
     */
    public static <T> List<T> toList(String text, Class<T> clazz) {
        return JSON.parseArray(text, clazz);
    }

    /**
     * 将javabean转化为序列化的json字符串
     *
     * @param keyvalue
     * @return
     */
    public static Object beanToJson(KeyValue keyvalue) {
        String textJson = JSON.toJSONString(keyvalue);
        Object objectJson = JSON.parse(textJson);
        return objectJson;
    }

    /**
     * 将string转化为序列化的json字符串
     *
     * @param text
     * @return
     */
    public static Object textToJson(String text) {
        Object objectJson = JSON.parse(text);
        return objectJson;
    }

    /**
     * json字符串转化为map
     *
     * @param s
     * @return
     */
    public static Map stringToCollect(String s) {
        Map m = JSONObject.parseObject(s);
        return m;
    }


    /**
     * json字符串转化为序列化map
     *
     * @param s
     * @return
     */
    public static Map stringToLinkMap(String s) {
        return JSON.parseObject(s, LinkedHashMap.class);
    }
    /**
     * 将map转化为string
     *
     * @param m
     * @return
     */
    public static String collectToString(Map m) {
        String s = JSONObject.toJSONString(m);
        return s;
    }

}
