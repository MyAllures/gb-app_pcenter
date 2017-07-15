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
@Comment("绑定手机第二步弹窗弹窗")
public class BindPhoneForm2 implements IForm {

    private String phone_contactValue;
    private String phoneVerificationCode;

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
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyPhoneVerificationCode", additionalProperties = {"phoneVerificationCode"}, message = "passport.passport.edit.info.captcha.error.due")
    @Comment("手机验证码")
    public String getPhoneVerificationCode() {
        return phoneVerificationCode;
    }

    public void setPhoneVerificationCode(String phoneVerificationCode) {
        this.phoneVerificationCode = phoneVerificationCode;
    }
}
