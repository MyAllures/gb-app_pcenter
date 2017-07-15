package so.wwb.gamebox.pcenter.personInfo.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;

import javax.validation.constraints.Pattern;

/**
 *  玩家银行卡验证
 */
//region your codes 1
@Comment("银行卡")
public class UserBankCardForm implements IForm {
//endregion your codes 1

    //region your codes 2
    private String result_bankcardNumber;
    private String result_bankDeposit;
    private String result_bankName;


    @NotBlank(message = "passport.edit.info.bank.card")
    @Length(min = 10,max = 25,message = "passport.edit.info.bank.card")
    @Pattern(message = "agent.bankCardCorrect",regexp = FormValidRegExps.BANK)
    @Comment("银行卡")
    public String getResult_bankcardNumber() {
        return result_bankcardNumber;
    }

    @Pattern(regexp = FormValidRegExps.NAME, message = "passport.edit.info.bank.deposit")
    @Length(max = 20, min = 2, message = "passport.edit.info.bank.deposit")
    public String getResult_bankDeposit() {
        return result_bankDeposit;
    }

    @NotBlank
    @Comment("银行")
    public String getResult_bankName() {
        return result_bankName;
    }

    public void setResult_bankcardNumber(String result_bankcardNumber) {
        this.result_bankcardNumber = result_bankcardNumber;
    }

    public void setResult_bankDeposit(String result_bankDeposit) {
        this.result_bankDeposit = result_bankDeposit;
    }

    public void setResult_bankName(String result_bankName) {
        this.result_bankName = result_bankName;
    }

//endregion your codes 2

}