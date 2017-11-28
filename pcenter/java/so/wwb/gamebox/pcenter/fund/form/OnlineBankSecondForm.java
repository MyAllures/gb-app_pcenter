package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.common.RegExpConstants;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.CompanyRechargeController;

import javax.validation.constraints.Max;
import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-24.
 */
@Comment("网银存款第二步")
public class OnlineBankSecondForm implements IForm {
    private String result_payAccountId;
    private String result_rechargeAmount;
    private String result_payerName;

    @Comment("存入银行")
    @NotBlank(message = "fund.rechargeForm.payAccountIdNotBlank")
    public String getResult_payAccountId() {
        return result_payAccountId;
    }

    public void setResult_payAccountId(String result_payAccountId) {
        this.result_payAccountId = result_payAccountId;
    }

    @Comment("存款金额")
    @NotBlank(message = "fund.rechargeForm.rechargeAmountNotBlank")
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = CompanyRechargeController.class, checkMethod = "checkAmount", additionalProperties = {"result.rechargeType"}, jsValueExp = {"$(\"[name='payType']:checked\").val()"})
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
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
}
