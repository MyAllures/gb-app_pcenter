package so.wwb.gamebox.pcenter.personInfo.form;

import org.hibernate.validator.constraints.Length;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Qq;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.personInfo.controller.PersonalInfoController;

import javax.validation.constraints.Pattern;
import java.util.Date;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("玩家中心个人信息编辑页面表单验证")
public class PersonInfoForm implements IForm {

    private String qq_contactValue;
    private String result_nickname;
    private String result_realName;
    private String $sysUserProtection_question1;
    private String $sysUserProtection_answer1;

    private String email_contactValue;
    private String weixin_contactValue;
    private String verificationCode;
    private String emailFlag;

    private String phone_contactValue;
    private String phoneVerificationCode;
    private String phoneFlag;

    private Date result_birthday;
    private String result_constellation;

    @Qq(message = "passport.edit.info.format.error")
    @Length(min = 5,max = 11,message = "passport.edit.info.qq")
    @Comment("qq")
    public String getQq_contactValue() {
        return qq_contactValue;
    }

    public void setQq_contactValue(String qq_contactValue) {
        this.qq_contactValue = qq_contactValue;
    }

    @Length(min=3,max = 15,message = "passport.edit.info.nickname")
    @Pattern(regexp = FormValidRegExps.CNANDEN_NUMBER,message = "passport.edit.info.format.error")
    public String getResult_nickname() {
        return result_nickname;
    }

    public void setResult_nickname(String result_nickname) {
        this.result_nickname = result_nickname;
    }

    @Length(min = 2,max = 30,message = "passport.edit.info.realName")
//    @Depends(property = "$flag",operator = Operator.EQ,value = {"0"},jsValueExp ="$(\"[name=\\'realNameStatus\\']\").val()",message = "请输入真实姓名")
    @Remote(message = "passport.realName.exist",checkMethod = "checkRealNameExist",checkClass = PersonalInfoController.class, additionalProperties = {"realName"})
    @Pattern(regexp = FormValidRegExps.REALNAME,message = "passport.edit.info.format.error")
    @Comment("姓名")
    public String getResult_realName() {
        return result_realName;
    }

    public void setResult_realName(String result_realName) {
        this.result_realName = result_realName;
    }

    public String get$sysUserProtection_question1() {
        return $sysUserProtection_question1;
    }

    public void set$sysUserProtection_question1(String $sysUserProtection_question1) {
        this.$sysUserProtection_question1 = $sysUserProtection_question1;
    }

    @Depends(property ={"$sysUserProtection_question1","$sysUserProtection_question1"}, operator = {Operator.NE,Operator.IS_NOT_NULL}, value = {"",""}, message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    public String get$sysUserProtection_answer1() {
        return $sysUserProtection_answer1;
    }

    public void set$sysUserProtection_answer1(String $sysUserProtection_answer1) {
        this.$sysUserProtection_answer1 = $sysUserProtection_answer1;
    }

    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.EMAIL)
    @Comment("邮箱")
    public String getEmail_contactValue() {
        return email_contactValue;
    }

    public void setEmail_contactValue(String email_contactValue) {
        this.email_contactValue = email_contactValue;
    }

    @Depends(property = {"emailFlag","email.contactValue"},operator = {Operator.EQ,Operator.IS_NOT_EMPTY},value = {"email",""},jsValueExp ="$(\"[name=\\'emailFlag\\']\").val()",message = "passport.required.captcha")
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyCode", additionalProperties = {"verificationCode"}, message = "passport.edit.info.captcha.error.due")
    @Comment("邮箱验证码")
    public String getVerificationCode() {
        return verificationCode;
    }

    public void setVerificationCode(String verificationCode) {
        this.verificationCode = verificationCode;
    }

    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.NUMBER_PHONE)
    @Comment("手机号码")
    public String getPhone_contactValue() {
        return phone_contactValue;
    }

    public void setPhone_contactValue(String phone_contactValue) {
        this.phone_contactValue = phone_contactValue;
    }

    @Depends(property = {"phoneFlag","phone.contactValue"},operator = {Operator.EQ,Operator.IS_NOT_EMPTY},value = {"phone",""},jsValueExp ="$(\"[name=\\'phoneFlag\\']\").val()",message = "passport.required.captcha")
    @Remote(checkClass = PersonalInfoController.class, checkMethod = "verifyPhoneVerificationCode", additionalProperties = {"phoneVerificationCode"}, message = "passport.edit.info.captcha.error.due")
    @Comment("手机号验证码")
    public String getPhoneVerificationCode() {
        return phoneVerificationCode;
    }

    public void setPhoneVerificationCode(String phoneVerificationCode) {
        this.phoneVerificationCode = phoneVerificationCode;
    }

//    @Depends(property ={"result_constellation"}, operator = {Operator.NE,Operator.IS_NOT_NULL}, value = {"",""}, message = "请选择生日")
    @Comment("生日")
    public Date getResult_birthday() {
        return result_birthday;
    }

    public void setResult_birthday(Date result_birthday) {
        this.result_birthday = result_birthday;
    }

    @Depends(property ={"result_birthday"}, operator = {Operator.NE,Operator.IS_NOT_NULL}, value = {"",""}, message = "passport.edit.info.select.constellation")
    @Comment("星座")
    public String getResult_constellation() {
        return result_constellation;
    }

    public void setResult_constellation(String result_constellation) {
        this.result_constellation = result_constellation;
    }

    public String getEmailFlag() {
        return emailFlag;
    }

    public void setEmailFlag(String emailFlag) {
        this.emailFlag = emailFlag;
    }

    public String getPhoneFlag() {
        return phoneFlag;
    }

    public void setPhoneFlag(String phoneFlag) {
        this.phoneFlag = phoneFlag;
    }

    @Length(min = 2,max = 20,message = "passport.edit.info.weixin.format.error")
    //@Depends(property = "$required", operator = Operator.IN, value = "304")
    public String getWeixin_contactValue() {
        return weixin_contactValue;
    }

    public void setWeixin_contactValue(String weixin_contactValue) {
        this.weixin_contactValue = weixin_contactValue;
    }
}
