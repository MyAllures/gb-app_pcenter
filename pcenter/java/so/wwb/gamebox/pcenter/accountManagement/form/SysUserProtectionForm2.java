package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Compare;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.CompareLogic;
import org.soul.web.support.IForm;

/**
 * Created by eagle on 15-11-4.
 */
@Comment("玩家中心账号设置确认安全问题答案")
public class SysUserProtectionForm2 implements IForm {

    private String answer1;
    private String answer2;
    private String answer3;
    private String a1;
    private String a2;
    private String a3;
//    private String loginPassword;

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    @Compare(message = "passport.edit.info.i.not.same", logic = CompareLogic.EQ, anotherProperty = "a1")
    @Comment("问题1答案")
    public String getAnswer1() {
        return answer1;
    }

    public void setAnswer1(String answer1) {
        this.answer1 = answer1;
    }

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    @Compare(message = "passport.edit.info.i.not.same", logic = CompareLogic.EQ, anotherProperty = "a2")
    @Comment("问题2答案")
    public String getAnswer2() {
        return answer2;
    }

    public void setAnswer2(String answer2) {
        this.answer2 = answer2;
    }

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    @Compare(message = "passport.edit.info.i.not.same", logic = CompareLogic.EQ, anotherProperty = "a3")
    @Comment("问题3答案")
    public String getAnswer3() {
        return answer3;
    }

    public void setAnswer3(String answer3) {
        this.answer3 = answer3;
    }

//    @Length(min = 6,max = 12)
   /* @NotBlank(message = "请输入登录密码")
    @Pattern(message = "common.valid.loginPWDFormat",regexp = FormValidRegExps.LOGIN_PWD)
    @Remote(checkClass = AccountSettingsController.class, checkMethod = "yzPassword", additionalProperties = {"loginPassword"}, message = "您输入的登录密码有误，请重新输入")
    public String getLoginPassword() {
        return loginPassword;
    }

    public void setLoginPassword(String loginPassword) {
        this.loginPassword = loginPassword;
    }*/

    public String getA1() {
        return a1;
    }

    public void setA1(String a1) {
        this.a1 = a1;
    }

    public String getA2() {
        return a2;
    }

    public void setA2(String a2) {
        this.a2 = a2;
    }

    public String getA3() {
        return a3;
    }

    public void setA3(String a3) {
        this.a3 = a3;
    }
}
