package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.accountManagement.controller.AccountSettingsController;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.web.captcha.controller.CheckCaptchaController;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("修改邮箱")
public class PlayerEmailCaptchaForm implements IForm {

    private String oldContactValue;
    private String email_contactValue;
    private String ecode;


    @NotBlank(message = "passport.edit.info.email.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.EMAIL)
    @Comment("邮箱")
    public String getEmail_contactValue() {
        return email_contactValue;
    }

    public void setEmail_contactValue(String email_contactValue) {
        this.email_contactValue = email_contactValue;
    }

    @NotBlank(message = "passport.required.captcha")
    @Remote(checkClass = CheckCaptchaController.class, checkMethod = "checkEmailCaptcha", additionalProperties = {"ecode"}, message = "passport.edit.info.captcha.error")
    @Comment("验证码")
    public String getEcode() {
        return ecode;
    }

    public void setEcode(String ecode) {
        this.ecode = ecode;
    }

    @NotBlank(message = "passport.edit.info.email.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.EMAIL)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "verifyEmail", additionalProperties = {"oldContactValue"}, message = "passport.edit.info.email.error")
    @Comment("旧邮箱")
    public String getOldContactValue() {
        return oldContactValue;
    }

    public void setOldContactValue(String oldContactValue) {
        this.oldContactValue = oldContactValue;
    }
}
