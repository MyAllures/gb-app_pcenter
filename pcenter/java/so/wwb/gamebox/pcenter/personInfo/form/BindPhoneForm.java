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
@Comment("绑定手机弹窗")
public class BindPhoneForm implements IForm {

    private String phone_contactValue;
    private String phone_phoneVerificationCode;

    @NotBlank(message = "passport.edit.info.phone.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.NUMBER_PHONE)
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyCellPhone", additionalProperties = {"phone_contactValue"}, message = "passport.edit.info.phone.error")
    @Comment("手机号")
    public String getPhone_contactValue() {
        return phone_contactValue;
    }

    public void setPhone_contactValue(String phone_contactValue) {
        this.phone_contactValue = phone_contactValue;
    }

    @NotBlank(message = "passport.required.captcha")
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyPhoneVerificationCode", additionalProperties = {"phone_phoneVerificationCode"}, message = "passport.passport.edit.info.captcha.error.due")
    @Comment("手机验证码")
    public String getPhone_phoneVerificationCode() {
        return phone_phoneVerificationCode;
    }

    public void setPhone_phoneVerificationCode(String phone_phoneVerificationCode) {
        this.phone_phoneVerificationCode = phone_phoneVerificationCode;
    }
}
