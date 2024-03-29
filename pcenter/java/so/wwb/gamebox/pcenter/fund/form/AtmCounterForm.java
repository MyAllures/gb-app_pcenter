package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.CompanyRechargeController;
import so.wwb.gamebox.pcenter.fund.controller.RechargeController;

import javax.validation.constraints.Max;
import javax.validation.constraints.Min;
import javax.validation.constraints.Pattern;

/**
 * Created by Cherry on 16-6-26.
 */
@Comment("柜员机/柜台存款")
public class AtmCounterForm implements IForm {
    private String result_rechargeAmount;
    private String result_rechargeType;
    private String account;
    private String $code;
    private String result_rechargeAddress;

    @Comment("收款账号")
    @NotBlank
    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account;
    }

    @Comment("存款金额")
    @NotBlank
    @Pattern(message = "fund.rechargeForm.rechargeAmountCorrect", regexp = FormValidRegExps.MONEY)
    @Remote(message = "fund.rechargeForm.rechargeAmountOver", checkClass = CompanyRechargeController.class, checkMethod = "checkAmount", additionalProperties = {"result.payerBank"}, jsValueExp = {"$(\"[name='result.payerBank']:checked\").val()"})
    @Max(message = "fund.rechargeForm.rechargeAmountMax", value = 99999999)
    @Min(message = "fund.rechargeForm.rechargeAmountMin", value = 0)
    public String getResult_rechargeAmount() {
        return result_rechargeAmount;
    }

    public void setResult_rechargeAmount(String result_rechargeAmount) {
        this.result_rechargeAmount = result_rechargeAmount;
    }

    @Comment("存款方式")
    @NotBlank
    public String getResult_rechargeType() {
        return result_rechargeType;
    }

    public void setResult_rechargeType(String result_rechargeType) {
        this.result_rechargeType = result_rechargeType;
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

    @Comment("存款地址")
    @Length(max = 20)
    public String getResult_rechargeAddress() {
        return result_rechargeAddress;
    }

    public void setResult_rechargeAddress(String result_rechargeAddress) {
        this.result_rechargeAddress = result_rechargeAddress;
    }
}
