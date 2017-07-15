package so.wwb.gamebox.pcenter.fund.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Compare;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.CompareLogic;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-8.
 */
@Comment("玩家中心账号设置设置真实姓名")
public class SettingRealNameForm implements IForm {

    private String confirmRealName;
    private String result_realName;
    private String $flag;

    @Length(min = 2,max = 30,message = "passport.edit.info.realName")
    @Depends(property = "$flag",operator = Operator.EQ,value = {"true"},jsValueExp ="$(\"[name=\\'flag\\']\").val()=='true'",message = "passport.edit.info.realName.notBlank")
    @Pattern(regexp = FormValidRegExps.REALNAME,message = "passport.edit.info.format.error")
    @Compare(message = "passport.edit.info.i.not.same",logic = CompareLogic.EQ,anotherProperty = "result_realName")
    @Comment("确认姓名")
    public String getConfirmRealName() {
        return confirmRealName;
    }

    public void setConfirmRealName(String confirmRealName) {
        this.confirmRealName = confirmRealName;
    }

    @NotBlank(message = "passport.edit.info.realName.notBlank")
    @Length(min = 2,max = 30,message = "passport.edit.info.realName")
    @Pattern(regexp = FormValidRegExps.REALNAME,message = "passport.edit.info.format.error")
    @Comment("姓名")
    public String getResult_realName() {
        return result_realName;
    }

    public void setResult_realName(String result_realName) {
        this.result_realName = result_realName;
    }

    public String get$flag() {
        return $flag;
    }

    public void set$flag(String $flag) {
        this.$flag = $flag;
    }
}
