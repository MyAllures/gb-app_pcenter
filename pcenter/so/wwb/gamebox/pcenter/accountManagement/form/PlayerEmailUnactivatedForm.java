package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
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
@Comment("绑定邮箱")
public class PlayerEmailUnactivatedForm implements IForm {

    private String email_contactValue;
    private String code;
    private String verificationCode;
    private String flag;

    @NotBlank(message = "passport.edit.info.email.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.EMAIL)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "verifyEmail2", additionalProperties = {"email_contactValue"}, message = "passport.edit.info.email.error")
    @Comment("邮箱")
    public String getEmail_contactValue() {
        return email_contactValue;
    }

    public void setEmail_contactValue(String email_contactValue) {
        this.email_contactValue = email_contactValue;
    }

    @NotBlank(message = "passport.required.captcha")
    @Remote(checkClass = CheckCaptchaController.class, checkMethod = "checkEmailCaptcha", additionalProperties = {"code"}, message = "passport.edit.info.captcha.error")
    @Comment("验证码")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @Depends(property = "flag",operator = Operator.EQ,value = {"true"},jsValueExp ="$(\"[name=\\'flag\\']\").val()=='true'",message = "passport.required.captcha")
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "verifyCode", additionalProperties = {"verificationCode"}, message = "passport.edit.info.captcha.error.due")
    @Comment("邮箱验证码")
    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    public String getFlag() {
        return flag;
    }

    public void setFlag(String flag) {
        this.flag = flag;
    }
}
