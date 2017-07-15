package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;

/**
 * Created by eagle on 15-11-18.
 */
@Comment("玩家中心账号设置密保修改")
public class SysUserProtectionForm3 implements IForm {

    private String answer1;

    private String answer2;

    private String answer3;

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
//    @Remote(checkClass = AccountSettingsController.class, checkMethod = "yzAnswer1", additionalProperties = {"answer1"}, message = "密保答案错误")
    @Comment("问题1答案")
    public String getAnswer1() {
        return answer1;
    }

    public void setAnswer1(String answer1) {
        this.answer1 = answer1;
    }

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
//    @Remote(checkClass = AccountSettingsController.class, checkMethod = "yzAnswer2", additionalProperties = {"answer2"}, message = "密保答案错误")
    @Comment("问题2答案")
    public String getAnswer2() {
        return answer2;
    }

    public void setAnswer2(String answer2) {
        this.answer2 = answer2;
    }

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
//    @Remote(checkClass = AccountSettingsController.class, checkMethod = "yzAnswer3", additionalProperties = {"answer3"}, message = "密保答案错误")
    @Comment("问题3答案")
    public String getAnswer3() {
        return answer3;
    }

    public void setAnswer3(String answer3) {
        this.answer3 = answer3;
    }
}
