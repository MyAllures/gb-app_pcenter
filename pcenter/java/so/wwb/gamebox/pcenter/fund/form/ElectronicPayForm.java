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
import so.wwb.gamebox.pcenter.fund.controller.CompanyRechargeController;
import so.wwb.gamebox.pcenter.fund.controller.RechargeController;

import javax.validation.constraints.Max;
import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-24.
 */
@Comment("电子支付验证")
public class ElectronicPayForm implements IForm {
    private String result_rechargeAmount;
    private String result_payerBankcard;
    private String result_bankOrder;
    private String $code;

    @Comment("存款金额")
    @NotBlank
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = CompanyRechargeController.class, checkMethod = "checkAmount")
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
    public String getResult_rechargeAmount() {
        return result_rechargeAmount;
    }

    public void setResult_rechargeAmount(String result_rechargeAmount) {
        this.result_rechargeAmount = result_rechargeAmount;
    }

    @Comment("存款账号")
    @Depends(property = "result.rechargeType", operator = {Operator.NE}, value = {RechargeTypeEnum.RECHARGE_TYPE_ONECODEPAY_FASE})
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
