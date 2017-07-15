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
import so.wwb.gamebox.pcenter.fund.controller.WithdrawController;

import javax.validation.constraints.Pattern;


/**
 * 新增银行卡表单验证
 *
 * @author orange
 * @time 2015-10-20 16:12:04
 */
public class AddBankcardForm implements IForm {

    private String result_bankcardMasterName;
    private String result_bankName;
    private String result_bankcardNumber;
    private String result_bankDeposit;

    @NotBlank(message = "passport.edit.info.notBlank")
    @Length(min = 2,max = 30,message = "passport.edit.info.realName")
    @Pattern(regexp = RegExpConstants.REALNAME,message = "passport.edit.info.format.error")
    @Comment("真实姓名")
    public String getResult_bankcardMasterName() {
        return result_bankcardMasterName;
    }

    public void setResult_bankcardMasterName(String result_bankcardMasterName) {
        this.result_bankcardMasterName = result_bankcardMasterName;
    }

    @NotBlank(message = "passport.edit.info.bank.card")
    @Length(min = 10, max = 25,message = "passport.edit.info.bank.card")
    @Pattern(message = "passport.edit.info.bank.card.format.error", regexp = FormValidRegExps.BANK)
    @Remote(checkClass = WithdrawController.class,checkMethod = "checkCardIsExists",additionalProperties = {"result.bankcardNumber"}, message = "passport.edit.info.bank.card.already")
    @Comment("银行卡")
    public String getResult_bankcardNumber() {
        return result_bankcardNumber;
    }

    public void setResult_bankcardNumber(String result_bankcardNumber) {
        this.result_bankcardNumber = result_bankcardNumber;
    }

    @NotBlank(message = "passport.edit.info.select.bank")
    public String getResult_bankName() {
        return result_bankName;
    }

    public void setResult_bankName(String result_bankName) {
        this.result_bankName = result_bankName;
    }


    @Depends(property ={"result_bankName"}, operator = {Operator.EQ}, value = {"true"},jsValueExp = {"$(\"[name=\\'result.bankName\\']:checked\").val()=='other_bank'"},message = "passport.edit.info.bank.deposit.notBlank")
    @Length(max = 200)
    public String getResult_bankDeposit() {
        return result_bankDeposit;
    }

    public void setResult_bankDeposit(String result_bankDeposit) {
        this.result_bankDeposit = result_bankDeposit;
    }
}