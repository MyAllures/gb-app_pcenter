package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.common.RegExpConstants;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.CompanyRechargeController;
import so.wwb.gamebox.pcenter.fund.controller.RechargeController;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-24.
 */
@Comment("网银支付验证")
public class OnlineBankForm implements IForm {
    private String result_rechargeAmount;
    private String result_payerName;
    private String account;
    private String $code;

    @Comment("收款账号")
    @NotBlank
    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    @Comment("存款金额")
    @NotBlank(message = "fund.rechargeForm.rechargeAmountNotBlank")
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = CompanyRechargeController.class, checkMethod = "checkAmount", additionalProperties = {"result.rechargeType"}, jsValueExp = {"$(\"[name='payType']:checked\").val()"})
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
    @Min(message = "fund.rechargeForm.rechargeAmountMin", value = 0)
    public String getResult_rechargeAmount() {
        return result_rechargeAmount;
    }

    public void setResult_rechargeAmount(String result_rechargeAmount) {
        this.result_rechargeAmount = result_rechargeAmount;
    }

    @Comment("存款人")
    @NotBlank
    @Pattern(message = "fund.rechargeForm.payerName.pattern", regexp = RegExpConstants.PAYERNAME)
    @Length(min = 2, max = 30)
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

}
