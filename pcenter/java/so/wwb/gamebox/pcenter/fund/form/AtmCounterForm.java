package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.RegExpConstants;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.CompanyRechargeController;
import so.wwb.gamebox.pcenter.fund.controller.RechargeController;

import javax.validation.constraints.Max;
import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-26.
 */
@Comment("柜员机/柜台存款")
public class AtmCounterForm implements IForm {
    private String result_rechargeAmount;
    private String result_payerBank;
    private String result_payAccountId;
    private String $code;

    @Comment("存款金额")
    @NotBlank(message = "fund.rechargeForm.rechargeAmountNotBlank")
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = CompanyRechargeController.class, checkMethod = "checkAmount", additionalProperties = {"result.payerBank"}, jsValueExp = {"$(\"[name='result.payerBank']:checked\").val()"})
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
    public String getResult_rechargeAmount() {
        return result_rechargeAmount;
    }

    public void setResult_rechargeAmount(String result_rechargeAmount) {
        this.result_rechargeAmount = result_rechargeAmount;
    }

    @Comment("存入银行")
    @NotBlank(message = "fund.rechargeForm.payerBankNotBlank")
    public String getResult_payerBank() {
        return result_payerBank;
    }

    public void setResult_payerBank(String result_payerBank) {
        this.result_payerBank = result_payerBank;
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

    @Comment("尾号")
    @NotBlank(message = "fund.rechargeForm.payAccountIdSelect")
    public String getResult_payAccountId() {
        return result_payAccountId;
    }

    public void setResult_payAccountId(String result_payAccountId) {
        this.result_payAccountId = result_payAccountId;
    }
}
