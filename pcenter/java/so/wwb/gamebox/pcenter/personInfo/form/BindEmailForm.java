package so.wwb.gamebox.pcenter.personInfo.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.personInfo.controller.PersonalInfoController;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("绑定邮箱弹窗")
public class BindEmailForm implements IForm {

    private String email_contactValue;
    private String verificationCode;

    @NotBlank(message = "passport.edit.info.email.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.EMAIL)
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyEmail2", additionalProperties = {"email_contactValue"}, message = "passport.edit.info.email.error")
    @Comment("邮箱")
    public String getEmail_contactValue() {
        return email_contactValue;
    }

    public void setEmail_contactValue(String email_contactValue) {
        this.email_contactValue = email_contactValue;
    }

    @NotBlank(message = "passport.required.captcha")
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyCode", additionalProperties = {"verificationCode"}, message = "passport.passport.edit.info.captcha.error.due")
    @Comment("邮箱验证码")
    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }
}
