package util.common;

/**
 * Created by Administrator on 2016/8/4 0004下午 5:19.
 */
public class EnumUtils {
    /**
     * 根据传入的值来获得支付方式的枚举对象
     * @param balanceType
     * @return
     */
    public static ShopCustomerBalanceType getBalanceType(String balanceType) {
        if (balanceType.equals(ShopCustomerBalanceType.Balance.getValue())) return ShopCustomerBalanceType.Balance;
        else if (balanceType.equals(ShopCustomerBalanceType.BalanceExpenditure.getValue())) return ShopCustomerBalanceType.BalanceExpenditure;
        else if (balanceType.equals(ShopCustomerBalanceType.BalanceIncome.getValue())) return ShopCustomerBalanceType.BalanceIncome;
        else if (balanceType.equals(ShopCustomerBalanceType.BalanceRecharge.getValue())) return ShopCustomerBalanceType.BalanceRecharge;
        else return null;
    }

    /**
     * 查询余额的类型
     *
     * */
    public static enum ShopCustomerBalanceType {
        Balance("现金钱包/金币的总额", "shop_customer_balance"),
        BalanceExpenditure("现金钱包/金币的总支出", "shop_customer_balanceExpenditure"),
        BalanceIncome("现金钱包/金币的总收入", "shop_customer_balanceIncome"),
        BalanceRecharge("现金充值总金额", "shop_customer_balanceRecharge");
        // 成员变量
        private String name;
        private String value;
        // 构造方法
        private ShopCustomerBalanceType(String name, String value) {
            this.name = name;
            this.value = value;
        }
        // 普通方法
        public static String getName(String index) {
            for (ShopCustomerBalanceType s : ShopCustomerBalanceType.values()) {
                if (s.getValue()==index) {
                    return s.name;
                }
            }
            return null;
        }
        // get set 方法
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public String getValue() {
            return value;
        }
        public void setValue(String value) {
            this.value = value;
        }
    }

    /**
     * 日期格式
     *
     * */
    public static enum DataFormat {
        Y_M_D_H_m_s_S("年-月-日 时:分:秒 毫秒", "yyyy-MM-dd HH:mm:ss.S"),   //24小时制
        Y_M_D_H_m_s("年-月-日 时:分:秒", "yyyy-MM-dd HH:mm:ss"),              //24小时制
        Y_M_D("年-月-日", "yyyy-MM-dd"),
        YMDHmsS("年月日时分秒毫秒", "yyyyMMddHHmmssSSS"),//24小时制
        YMDHms("年月日时分秒", "yyyyMMddHHmmss"),        //24小时制
        YMD("年月日", "yyyyMMdd");
        // 成员变量
        private String name;
        private String value;
        // 构造方法
        private DataFormat(String name, String value) {
            this.name = name;
            this.value = value;
        }
        // 普通方法
        public static String getName(String index) {
            for (DataFormat s : DataFormat.values()) {
                if (s.getValue()==index) {
                    return s.name;
                }
            }
            return null;
        }
        // get set 方法
        public String getName() {
            return name;
        }
        public void setName(String name) {
            this.name = name;
        }
        public String getValue() {
            return value;
        }
        public void setValue(String value) {
            this.value = value;
        }
    }
}