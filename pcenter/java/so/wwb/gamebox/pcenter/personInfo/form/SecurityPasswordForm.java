package so.wwb.gamebox.pcenter.personInfo.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Compare;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.CompareLogic;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.personInfo.controller.UpdateSecurityPasswordController;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("安全密码设置")
public class SecurityPasswordForm implements IForm {

    private String privilegePwd;
    private String privilegeRePwd;

    @NotBlank(message = "passport.edit.info.security.notBlank")
    @Length(max = 6,message = "passport.edit.info.security.format")
    @Pattern(message = "common.valid.securityPWDFormat",regexp = FormValidRegExps.SECURITY_PWD)
    @Remote(checkClass = UpdateSecurityPasswordController.class, checkMethod = "checkPrivilegePwd", additionalProperties = {"privilegePwd"}, message = "passport.edit.info.passport.easy")
    @Comment("安全密码")
    public String getPrivilegePwd() {
        return privilegePwd;
    }

    public void setPrivilegePwd(String privilegePwd) {
        this.privilegePwd = privilegePwd;
    }

    @NotBlank(message = "passport.edit.info.again.security")
    @Length(max = 6,message = "passport.edit.info.security.format")
    @Compare(message = "passport.edit.info.passport.same", logic = CompareLogic.EQ, anotherProperty = "privilegePwd")
    @Comment("新安全密码")
    public String getPrivilegeRePwd() {
        return privilegeRePwd;
    }

    public void setPrivilegeRePwd(String privilegeRePwd) {
        this.privilegeRePwd = privilegeRePwd;
    }
}
