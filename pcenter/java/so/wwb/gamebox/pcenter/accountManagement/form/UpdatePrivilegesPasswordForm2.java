package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.Length;
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
@Comment("修改安全密码设置")
public class UpdatePrivilegesPasswordForm2 implements IForm {

    private String privilegePwd;
    private String confirmPrivilegePwd;
    private String oldPrivilegePwd;

    @NotBlank(message = "passport.edit.info.security.notBlank")
    @Length(max = 6)
    @Pattern(message = "common.valid.securityPWDFormat",regexp = FormValidRegExps.SECURITY_PWD)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkPrivilegePassword", additionalProperties = {"oldPrivilegePwd"}, message = "passport.edit.info.security.error")
    @Comment("旧安全密码")
    public String getOldPrivilegePwd() {
        return oldPrivilegePwd;
    }

    public void setOldPrivilegePwd(String oldPrivilegePwd) {
        this.oldPrivilegePwd = oldPrivilegePwd;
    }

    @NotBlank(message = "passport.edit.info.security.notBlank")
    @Length(max = 6)
    @Pattern(message = "common.valid.securityPWDFormat",regexp = FormValidRegExps.SECURITY_PWD)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkPrivilegePwd", additionalProperties = {"privilegePwd"}, message = "passport.edit.info.passport.easy")
    @Comment("新安全密码")
    public String getPrivilegePwd() {
        return privilegePwd;
    }

    public void setPrivilegePwd(String privilegePwd) {
        this.privilegePwd = privilegePwd;
    }

    @NotBlank(message = "passport.edit.info.again.security")
    @Length(max = 6)
    @Compare(message = "passport.edit.info.passport.same", logic = CompareLogic.EQ, anotherProperty = "privilegePwd")
    @Comment("确认新安全密码")
    public String getConfirmPrivilegePwd() {
        return confirmPrivilegePwd;
    }

    public void setConfirmPrivilegePwd(String confirmPrivilegePwd) {
        this.confirmPrivilegePwd = confirmPrivilegePwd;
    }
}
