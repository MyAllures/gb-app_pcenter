package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.common.RegExpConstants;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.RechargeController;
import so.wwb.gamebox.pcenter.fund.controller.ScanElectronicRechargeController;

import javax.validation.constraints.Digits;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;

/**
 * 扫码支付和电子支付合并渠道后存款验证
 * Created by cherry on 18-2-12.
 */
public class ScanElectronicRechargeForm implements IForm {
    private String result_rechargeAmount;
    private String $payerBankcard;
    private String result_payerBankcard;
    private String result_bankOrder;
    private String result_payerName;
    private String account;
    private String $code;

    @Comment("存款金额")
    @NotBlank(message = "fund.rechargeForm.rechargeAmountNotBlank")
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
    @Min(message = "fund.rechargeForm.rechargeAmountMin", value = 0)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = ScanElectronicRechargeController.class, checkMethod = "checkRechargeAmount")
    public String getResult_rechargeAmount() {
        return result_rechargeAmount;
    }

    public void setResult_rechargeAmount(String result_rechargeAmount) {
        this.result_rechargeAmount = result_rechargeAmount;
    }

    @Comment("授权码")
    @Depends(property = {"$isAuthCode"}, operator = {Operator.EQ}, value = {"true"}, jsValueExp = "$(\"[name=isAuthCode]\").val() == 'true'")
    @Length(max = 20, min = 12)
    @Digits(fraction = 0, integer = 20)
    public String get$payerBankcard() {
        return $payerBankcard;
    }

    public void set$payerBankcard(String $payerBankcard) {
        this.$payerBankcard = $payerBankcard;
    }

    @Comment("存款账号")
    @Depends(property = "result.rechargeType", operator = {Operator.IN}, value = {RechargeTypeEnum.RECHARGE_TYPE_WECHATPAY_FAST, RechargeTypeEnum.RECHARGE_TYPE_BDWALLET_FAST, RechargeTypeEnum.RECHARGE_TYPE_JDWALLET_FAST, RechargeTypeEnum.RECHARGE_TYPE_QQWALLET_FAST, RechargeTypeEnum.RECHARGE_TYPE_OTHER_FAST})
    @Length(message = "fund.rechargeForm.payerBankcardLength", max = 20)
    public String getResult_payerBankcard() {
        return result_payerBankcard;
    }

    public void setResult_payerBankcard(String result_payerBankcard) {
        this.result_payerBankcard = result_payerBankcard;
    }

    @Comment("订单号后5位")
    @Pattern(message = "fund.rechargeForm.orderNumber.pattern", regexp = RegExpConstants.BANKORDER)
    public String getResult_bankOrder() {
        return result_bankOrder;
    }

    public void setResult_bankOrder(String result_bankOrder) {
        this.result_bankOrder = result_bankOrder;
    }

    @Comment("支付户名")
    @Depends(property = "result.rechargeType", operator = {Operator.EQ}, value = {RechargeTypeEnum.RECHARGE_TYPE_ALIPAY_FAST})
    public String getResult_payerName() {
        return result_payerName;
    }

    public void setResult_payerName(String result_payerName) {
        this.result_payerName = result_payerName;
    }

    @Comment("验证码")
    @Depends(message = "fund.rechargeForm.code.notBlank", operator = {Operator.GE}, property = {"$rechargeCount"}, value = {"3"}, jsValueExp = {"parseInt($(\"[name=rechargeCount]\").val())"})
    @Remote(message = "fund.rechargeForm.code.correct", checkMethod = "checkCaptcha", checkClass = RechargeController.class)
    public String get$code() {
        return $code;
    }

    public void set$code(String $code) {
        this.$code = $code;
    }

    @Comment("收款账号")
    @NotBlank
    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }
}
