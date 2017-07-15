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
@Comment("安全密码设置")
public class SecurityPasswordForm implements IForm {

    private String permissionPwd;

    @NotBlank(message = "passport.edit.info.security.notBlank")
    @Length(max = 6,message = "passport.edit.info.security.format")
    @Pattern(message = "common.valid.securityPWDFormat",regexp = FormValidRegExps.SECURITY_PWD)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "checkPermissionPwd", additionalProperties = {"permissionPwd"}, message = "passport.edit.info.security.error")
    @Comment("安全密码")
    public String getPermissionPwd() {
        return permissionPwd;
    }

    public void setPermissionPwd(String permissionPwd) {
        this.permissionPwd = permissionPwd;
    }
}
