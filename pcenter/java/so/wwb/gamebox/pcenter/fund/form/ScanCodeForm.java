package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.OnlineRechargeController;
import so.wwb.gamebox.pcenter.fund.controller.RechargeController;

import javax.validation.constraints.Digits;
import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-24.
 */
@Comment("扫码支付验证")
public class ScanCodeForm implements IForm {
    private String result_rechargeAmount;
    private String result_payerBankcard;
    private String $code;

    @Comment("存款金额")
    @NotBlank(message = "fund.rechargeForm.rechargeAmountNotBlank")
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = OnlineRechargeController.class, checkMethod = "checkRechargeAmount")
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
    @Min(message = "fund.rechargeForm.rechargeAmountMin", value = 0)
    public String getResult_rechargeAmount() {
        return result_rechargeAmount;
    }

    public void setResult_rechargeAmount(String result_rechargeAmount) {
        this.result_rechargeAmount = result_rechargeAmount;
    }

    @Comment("授权码")
    @Depends(property = {"$isAuthCode"}, operator = {Operator.EQ}, value = {"true"},jsValueExp = "$(\"[name=isAuthCode]\").val() == 'true'")
    @Length(max = 20, min = 12)
    @Digits(fraction = 0, integer = 20)
    public String getResult_payerBankcard() {
        return result_payerBankcard;
    }

    public void setResult_payerBankcard(String result_payerBankcard) {
        this.result_payerBankcard = result_payerBankcard;
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
}
