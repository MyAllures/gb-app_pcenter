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
@Comment("修改手机号")
public class PlayerPhoneCaptchaForm implements IForm {

    private String oldContactValue;
    private String phone_contactValue;
    private String code;

    @NotBlank(message = "passport.edit.info.phone.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.NUMBER_PHONE)
    @Comment("手机号")
    public String getPhone_contactValue() {
        return phone_contactValue;
    }

    public void setPhone_contactValue(String phone_contactValue) {
        this.phone_contactValue = phone_contactValue;
    }

    @NotBlank(message = "passport.required.captcha")
    @Remote(checkClass = CheckCaptchaController.class, checkMethod = "checkPhoneCaptcha", additionalProperties = {"code"}, message = "passport.edit.info.captcha.error")
    @Comment("验证码")
    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    @NotBlank(message = "passport.edit.info.phone.old")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.NUMBER_PHONE)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "verifyPhone", additionalProperties = {"oldContactValue"}, message = "passport.edit.info.phone.error")
    @Comment("旧手机号")
    public String getOldContactValue() {
        return oldContactValue;
    }

    public void setOldContactValue(String oldContactValue) {
        this.oldContactValue = oldContactValue;
    }
}
