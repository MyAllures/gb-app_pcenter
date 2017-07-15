package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.RegExpConstants;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.fund.controller.WithdrawController;

import javax.validation.constraints.Pattern;


/**
 * 表单验证对象
 *
 * @author orange
 * @time 2015-10-20 16:12:04
 */
//region your codes 1
public class VPcenterWithdrawForm implements IForm {
//endregion your codes 1

    //region your codes 2
    private String $withdrawAmount;
    private String result_bankcardMasterName;
    private String result_bankcardNumber;

    private String result_bankDeposit;
    private String result_bankName;
//    private String permissionPwd;
    private String $token;
//    private String bankcardNumber2;


    @Comment("取款金额")
    @NotBlank(message = "fund.withdrawForm.withdrawAmountNotBlank")
    @Pattern(message = "fund.withdrawForm.withdrawAmountCorrect", regexp = RegExpConstants.POSITIVE_INTEGER)
    @Remote(message = "fund.withdrawForm.withdrawAmountOver", checkClass = WithdrawController.class, checkMethod = "checkOnlineWithdrawAmount")
    public String get$withdrawAmount() {
        return $withdrawAmount;
    }

    public void set$withdrawAmount(String $withdrawAmount) {
        this.$withdrawAmount = $withdrawAmount;
    }

    @NotBlank(message = "passport.edit.info.notBlank")
    @Length(max = 30)
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

    @Pattern(regexp = FormValidRegExps.REALNAME, message = "fund.VPcenterWithdrawForm.bankDeposit.pattern")
    @Length(max = 20, min = 2, message = "fund.VPcenterWithdrawForm.bankDeposit.pattern")
    @Comment("开户行")
    public String getResult_bankDeposit() {
        return result_bankDeposit;
    }

    public void setResult_bankDeposit(String result_bankDeposit) {
        this.result_bankDeposit = result_bankDeposit;
    }

    @NotBlank(message = "passport.edit.info.select.bank")
    public String getResult_bankName() {
        return result_bankName;
    }

    public void setResult_bankName(String result_bankName) {
        this.result_bankName = result_bankName;
    }

    /*@NotBlank(message = "请输入安全密码")
    @Length(max = 6)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkPermissionPwd", additionalProperties = {"permissionPwd"}, message = "安全密码错误")
    @Comment("安全密码")
    public String getPermissionPwd() {
        return permissionPwd;
    }

    public void setPermissionPwd(String permissionPwd) {
        this.permissionPwd = permissionPwd;
    }*/

    @NotBlank
    public String get$token() {
        return $token;
    }

    public void set$token(String $token) {
        this.$token = $token;
    }

    /*@Length(min = 10,max = 25)
    @Remote(checkClass = WithdrawController.class,checkMethod = "checkCardIsExists",additionalProperties = {"bankcardNumber2"}, message = "银行卡已存在，请更换")
    @Comment("银行卡2")
    public String getBankcardNumber2() {
        return bankcardNumber2;
    }

    public void setBankcardNumber2(String bankcardNumber2) {
        this.bankcardNumber2 = bankcardNumber2;
    }*/

    //endregion your codes 2

}