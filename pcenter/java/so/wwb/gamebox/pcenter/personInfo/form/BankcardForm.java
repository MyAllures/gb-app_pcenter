package so.wwb.gamebox.pcenter.personInfo.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.common.RegExpConstants;
import so.wwb.gamebox.pcenter.personInfo.controller.PersonalInfoController;
import so.wwb.gamebox.web.fund.controller.UserBankcardController;

import javax.validation.constraints.Pattern;


/**
 * 新增银行卡表单验证
 *
 * @author orange
 * @time 2015-10-20 16:12:04
 */
public class BankcardForm implements IForm {

    private String result_bankcardMasterName;
    private String result_bankName;
    private String result_bankcardNumber;
    private String result_bankDeposit;

    @NotBlank
    @Length(min = 2,max = 30)
    @Pattern(regexp = RegExpConstants.REALNAME,message = "passport.edit.info.format.realName.error")
    @Comment("真实姓名")
    @Remote(message = "passport.realName.exist",checkMethod = "checkBankNameExist",checkClass = PersonalInfoController.class,additionalProperties = {"$editType"})
    public String getResult_bankcardMasterName() {
        return result_bankcardMasterName;
    }

    public void setResult_bankcardMasterName(String result_bankcardMasterName) {
        this.result_bankcardMasterName = result_bankcardMasterName;
    }

    @NotBlank(message = "银行卡号不能为空")
    @Length(min = 10, max = 25 , message = "银行卡号长度应在10-25范围内")
    @Pattern(message = "edit.info.bank.card.format.error", regexp = RegExpConstants.BANK)
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


    @NotBlank
//    @Depends(property ={"result_bankName"}, operator = {Operator.EQ}, value = {"true"},jsValueExp = {"$(\"[name=\\'result.bankName\\']:checked\").val()=='other_bank'"})
    @Length(max = 200)
    public String getResult_bankDeposit() {
        return result_bankDeposit;
    }

    public void setResult_bankDeposit(String result_bankDeposit) {
        this.result_bankDeposit = result_bankDeposit;
    }
}