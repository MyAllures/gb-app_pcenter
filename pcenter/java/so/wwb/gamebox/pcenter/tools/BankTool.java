package so.wwb.gamebox.pcenter.tools;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClientBuilder;
import org.json.JSONObject;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.model.company.po.Bank;
import so.wwb.gamebox.model.company.po.BankExtend;
import so.wwb.gamebox.model.company.vo.BankExtendVo;
import so.wwb.gamebox.model.company.vo.BankVo;
import so.wwb.gamebox.web.cache.Cache;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by tony on 16-1-4.
 */
public class BankTool {

    private static final Log LOG = LogFactory.getLog(BankTool.class);

    public static Map<String,String> getBankInfo(String bankNum){
        Map<String,String> map=new HashMap<>();
        if(!StringTool.isBlank(bankNum) && bankNum.length()>6){
            Map<String,Bank> bankMap= Cache.getBank();
            Map<String,BankExtend> bankExtendMap= Cache.getBankExtend();
            BankExtend bankExtend= bankExtendMap.get(bankNum.substring(0, 6));
            Bank bank=null;
            if(bankExtend!=null){
                bank= bankMap.get(bankExtend.getBankName());
            }
            map.put("refresh","false");
            if(bank==null){
                String url = "http://apis.baidu.com/datatiny/cardinfo_vip/cardinfo_vip/?cardnum="+bankNum;

                CloseableHttpClient httpClient = HttpClientBuilder.create().build();
                HttpGet httpGet = new HttpGet(url);
                //执行get请求
                HttpResponse httpResponse = null;
                try {
                    httpGet.addHeader("accept", "application/json");
                    httpGet.addHeader("content-type", "application/json");
                    httpGet.addHeader("apix-key", "您的apix-key");
                    httpResponse = httpClient.execute(httpGet);

                    //获取响应消息实体
                    HttpEntity entity = httpResponse.getEntity();
                    if (entity != null) {
                        //打印响应内容
                        /*{
                            "status": 1, //1表示正常,-1表示输入有误，0表示没有卡号信息
                                "data": {
                            {
                                "cardtype": "借记卡", //银行卡的类型
                                    "cardlength": 19, //卡的长度
                                    "cardprefixnum": "622202", //卡的前缀
                                    "cardname": "E时代卡", //卡的名称
                                    "bankname": "中国工商银行", //银行
                                    "areainfo": [
                                "浙江省-温州" //参考的开卡区域，目前支持工行
                                ],
                                "bankinfo": [
                                {
                                    "servicephone": "95588", //银行客服电话
                                        "logourl": "http://pica.datatiny.com/banklogo/icbc.png", //银行小logo
                                        "bankname": "中国工商银行", //银行名称
                                        "bankurl": "http://www.icbc.com.cn/", //官方网站
                                        "servicecreditphone": "4008205555", //如果是信用卡，则为信用卡客服电话
                                        "crediturl": "http://cc.cmbchina.com/",//如果是信用卡，则为信用卡网址
                                }
                                ],
                                "isLuhn",//代表Luhn校验值，目前大部分银行卡支持Luhn校验，可大概判断输入的银行卡号是否有效
                                        "banknum": "" //保留字段
                            }
                        }*/
                        //String json=EntityUtils.toString(entity, "UTF-8");
                        String json="{\n" +
                                "    \"status\": 1,\n" +
                                "    \"data\": {\n" +
                                "        \"cardtype\": \"借记卡\",\n" +
                                "        \"cardlength\": 19,\n" +
                                "        \"cardprefixnum\": \"622202\",\n" +
                                "        \"cardname\": \"E时代卡\",\n" +
                                "        \"bankname\": \"中国工商银行\",\n" +
                                "        \"areainfo\": [\"浙江省-温州\"],\n" +
                                "        \"bankinfo\": [{\n" +
                                "            \"servicephone\": \"95588\",\n" +
                                "            \"logourl\": \"http://pica.datatiny.com/banklogo/icbc.png\",\n" +
                                "            \"bankname\": \"中国工商银行\",\n" +
                                "            \"bankurl\": \"http://www.icbc.com.cn/\"\n" +
                                "        }],\n" +
                                "        \"isLuhn\": true,\n" +
                                "        \"banknum\": \"\"\n" +
                                "    }\n" +
                                "}";
                        JSONObject jObject = new JSONObject(json);
                        map.put("status", String.valueOf(jObject.getInt("status")));
                        //jObject.
                        if(jObject.getInt("status")==1){
                            bankExtend=new BankExtend();
                            bankExtend.setBankName(((JSONObject)jObject.getJSONObject("data").getJSONArray("bankinfo").get(0)).getString("bankname"));
                            bankExtend.setBankCardBegin(jObject.getJSONObject("data").getString("cardprefixnum"));
                            bankExtend.setCardType(jObject.getJSONObject("data").getString("cardtype"));
                            bankExtend.setCardLength(jObject.getJSONObject("data").getInt("cardlength"));
                            bankExtend.setCardName(jObject.getJSONObject("data").getString("cardname"));
                            bankExtend.setJsonData(json);

                            if(bankMap.get(((JSONObject)jObject.getJSONObject("data").getJSONArray("bankinfo").get(0)).getString("bankname"))==null){
                                bank=new Bank();
                                bank.setBankDistrict("CN");
                                bank.setBankIcon(((JSONObject)jObject.getJSONObject("data").getJSONArray("bankinfo").get(0)).getString("logourl"));
                                bank.setBankName(((JSONObject)jObject.getJSONObject("data").getJSONArray("bankinfo").get(0)).getString("bankname"));
                                BankVo bankVo=new BankVo();
                                bankVo.setResult(bank);
                                bankVo.setBankExtend(bankExtend);

                                ServiceTool.bankService().insert(bankVo);

                                map.put("refresh", "true");

                            }else
                            {
                                BankExtendVo bankExtendVo=new BankExtendVo();
                                bankExtendVo.setResult(bankExtend);
                                ServiceTool.bankExtendService().insert(bankExtendVo);

                            }
                        }
                    }
                    //释放资源
                    httpClient.close();
                } catch (IOException e) {
                    LOG.error(e);
                }
            }
            if(bank!=null){
                map.put("name",bank.getBankName());
                map.put("ico",bank.getBankIcon());
            }
        }
        return map;
    }
}

