package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Compare;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.CompareLogic;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.accountManagement.controller.AccountSettingsController;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("玩家中心账号设置密码修改")
public class UpdatePasswordForm implements IForm {

    private String password;
    private String newPassword;
    private String newRePassword;

    @NotBlank(message = "passport.edit.info.passport.notBlank")
//    @Length(max = 20,min = 8,message = "请输入8-20个半角符号(由大小写英文字母、数字和特殊符号组成)")
    @Pattern(message = "common.valid.loginPWDFormat",regexp = FormValidRegExps.LOGIN_PWD)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkWeakPassword", additionalProperties = {"newPassword"}, message = "passport.edit.info.passport.easy")
    @Compare(anotherProperty = "password",logic = CompareLogic.NE,message = "passport.edit.info.passport.old.same")
    @Comment("新密码")
    public String getNewPassword() {
        return newPassword;
    }

    public void setNewPassword(String newPassword) {
        this.newPassword = newPassword;
    }

    @NotBlank(message = "passport.edit.info.passport.notBlank")
//    @Length(max = 20,min = 8,message = "请输入8-20个半角符号(由大小写英文字母、数字和特殊符号组成)")
    @Compare(message = "passport.edit.info.passport.same", logic = CompareLogic.EQ, anotherProperty = "newPassword")
    @Comment("确认密码")
    public String getNewRePassword() {
        return newRePassword;
    }

    public void setNewRePassword(String newRePassword) {
        this.newRePassword = newRePassword;
    }

    @NotBlank(message = "passport.edit.info.passport.notBlank")
//    @Length(max = 20,min = 8,message = "请输入8-20个半角符号(由大小写英文字母、数字和特殊符号组成)")
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkPassword", additionalProperties = {"password"}, message = "passport.edit.info.passport.error")
    @Comment("旧密码")
    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }
}
