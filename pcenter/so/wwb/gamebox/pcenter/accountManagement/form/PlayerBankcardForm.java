package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.accountManagement.controller.AccountSettingsController;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("绑定银行卡")
public class PlayerBankcardForm implements IForm {

    private String bankcardNumber;
    private String bankDeposit;
    private String bankName;
//    private String permissionPwd;
    private String flag;

    @NotBlank(message = "passport.edit.info.bank.card")
    @Length(min = 10,max = 25)
    @Pattern(message = "passport.edit.info.bank.card.format.error",regexp = FormValidRegExps.BANK)
    @Remote(checkClass = AccountSettingsController.class,checkMethod = "checkBankCardType",additionalProperties = {"bankcardNumber"},message = "passport.edit.info.bank.card.type.limit")
    @Comment("银行卡")
    public String getBankcardNumber() {
        return bankcardNumber;
    }

    public void setBankcardNumber(String bankcardNumber) {
        this.bankcardNumber = bankcardNumber;
    }

    @Pattern(regexp = FormValidRegExps.REALNAME)
    @Length(min = 2,max = 20,message = "passport.edit.info.bank.deposit")
    @Comment("开户行")
    public String getBankDeposit() {
        return bankDeposit;
    }

    public void setBankDeposit(String bankDeposit) {
        this.bankDeposit = bankDeposit;
    }

    @NotBlank(message = "passport.edit.info.bank.select.bank")
//    @Depends(property = "",operator = Operator.EQ,value = {"0"},jsValueExp ="$(\"[name=\\'realNameStatus\\']\").val()",message = "")
    @Comment("银行")
    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    /*@NotBlank(message = "请输入安全密码")
    @Length(max = 9)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkPermissionPwd", additionalProperties = {"permissionPwd"}, message = "安全密码错误")
    @Comment("安全密码")
    public String getPermissionPwd() {
        return permissionPwd;
    }

    public void setPermissionPwd(String permissionPwd) {
        this.permissionPwd = permissionPwd;
    }*/

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }
}
