package util.pojo;

/**
 * 调用存储过程
 * Created by Administrator on 2016/8/10 0010下午 6:16.
 */
public class ProcedureBean {

    private Schema schema;  //参数模式 不可为空
    private Object inputValue;   //传入参数 如果参数模式是（in），此项不可为空，请传入值；
    private Integer outputType;//输出参数的类型 如果参数模式是（out）, 此项不可为空，类型为 java.sql.Types
    private String outputKey;   // 接收输出参数 Map中的key 如果参数模式是（out），此项不可为空，请传入返回值的键名称

    public ProcedureBean(){}

    /**
     * 构造器，设置传入参数
     * @param schema
     * @param inputValue 传入参数值
     */
    public ProcedureBean(Schema schema, Object inputValue){
        this.schema = schema;
        this.inputValue = inputValue;
    }

    /**
     * 构造器，设置输出参数
     * @param schema
     * @param outputType 输出参数的类型，引用类为 java.sql.Types
     * @param outputKey 接收输出参数 Map中的key
     */
    public ProcedureBean(Schema schema, Integer outputType, String outputKey){
        this.schema = schema;
        this.outputType = outputType;
        this.outputKey = outputKey;
    }

    /**
     * 函数中传入参数的模式,in out inout
     * */
    public static enum Schema {
        IN("输入", "in"),
        OUT("输出", "out");
        // 成员变量
        private String name;
        private String value;
        // 构造方法
        private Schema(String name, String value) {
            this.name = name;
            this.value = value;
        }
        // 普通方法
        public static String getName(String index) {
            for (Schema s : Schema.values()) {
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

    public Object getInputValue() {
        return inputValue;
    }

    public void setInputValue(Object inputValue) {
        this.inputValue = inputValue;
    }

    public Schema getSchema() {
        return schema;
    }

    public void setSchema(Schema schema) {
        this.schema = schema;
    }

    public Integer getOutputType() {
        return outputType;
    }

    public void setOutputType(Integer outputType) {
        this.outputType = outputType;
    }

    public String getOutputKey() {
        return outputKey;
    }

    public void setOutputKey(String outputKey) {
        this.outputKey = outputKey;
    }
}
