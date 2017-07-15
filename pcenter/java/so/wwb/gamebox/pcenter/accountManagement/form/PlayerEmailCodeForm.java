package so.wwb.gamebox.pcenter.accountManagement.form;

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
@Comment("修改邮箱需要邮箱验证码")
public class PlayerEmailCodeForm implements IForm {

//    private String oldContactValue;
    private String email_contactValue;
    private String verificationCode;
//    private String eflag;
//    private String verificationCode2;

//    @Depends(property = "eflag",operator = Operator.EQ,value = {"true"},jsValueExp ="$(\"[name=\\'eflag\\']\").val()=='true'",message = "请输入邮箱")
    @NotBlank(message = "passport.edit.info.email.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.EMAIL)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "verifyEmail2", additionalProperties = {"email_contactValue"}, message = "passport.edit.info.email.error")
    @Comment("新邮箱")
    public String getEmail_contactValue() {
        return email_contactValue;
    }

    public void setEmail_contactValue(String email_contactValue) {
        this.email_contactValue = email_contactValue;
    }

    @NotBlank(message = "passport.required.captcha")
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "verifyCode", additionalProperties = {"verificationCode"}, message = "passport.edit.info.captcha.error.due")
    @Comment("邮箱验证码")
    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

//    @NotBlank(message = "请输入邮箱")
//    @Pattern(message = "格式不正确",regexp = FormValidRegExps.EMAIL)
//    @Comment("原有邮箱")
//    public String getOldContactValue() {
//        return oldContactValue;
//    }
//
//    public void setOldContactValue(String oldContactValue) {
//        this.oldContactValue = oldContactValue;
//    }
//
//    public String getEflag() {
//        return eflag;
//    }
//
//    public void setEflag(String eflag) {
//        this.eflag = eflag;
//    }
//
//    @Depends(property = "eflag",operator = Operator.EQ,value = {"true"},jsValueExp ="$(\"[name=\\'eflag\\']\").val()=='true'",message = "请输入验证码")
//    @Comment("邮箱验证码")
//    public String getVerificationCode2() {
//        return verificationCode2;
//    }
//
//    public void setVerificationCode2(String verificationCode2) {
//        this.verificationCode2 = verificationCode2;
//    }
}
