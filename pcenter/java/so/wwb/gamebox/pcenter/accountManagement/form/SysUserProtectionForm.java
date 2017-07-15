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
@Comment("玩家中心账号设置安全问题")
public class SysUserProtectionForm implements IForm {

    private String question1;
    private String answer1;
    private String question2;
    private String answer2;
    private String question3;
    private String answer3;

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    @Compare(message = "passport.edit.info.answer.same", logic = CompareLogic.NE, anotherProperty = "answer3")
    public String getAnswer1() {
        return answer1;
    }

    public void setAnswer1(String answer1) {
        this.answer1 = answer1;
    }

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    @Compare(message = "passport.edit.info.answer.same", logic = CompareLogic.NE, anotherProperty = "answer1")
    public String getAnswer2() {
        return answer2;
    }

    public void setAnswer2(String answer2) {
        this.answer2 = answer2;
    }

    @NotBlank(message = "passport.edit.info.answer.notBlank")
    @Length(min = 1,max = 30)
    @Compare(message = "passport.edit.info.answer.same", logic = CompareLogic.NE, anotherProperty = "answer2")
    public String getAnswer3() {
        return answer3;
    }

    public void setAnswer3(String answer3) {
        this.answer3 = answer3;
    }

    @NotBlank(message = "passport.edit.info.select.question")
    public String getQuestion1() {
        return question1;
    }

    public void setQuestion1(String question1) {
        this.question1 = question1;
    }

    @NotBlank(message = "passport.edit.info.select.question")
    public String getQuestion2() {
        return question2;
    }

    public void setQuestion2(String question2) {
        this.question2 = question2;
    }

    @NotBlank(message = "passport.edit.info.select.question")
    public String getQuestion3() {
        return question3;
    }

    public void setQuestion3(String question3) {
        this.question3 = question3;
    }

}
