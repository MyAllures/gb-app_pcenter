package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.Email;
import org.hibernate.validator.constraints.Length;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.validation.form.constraints.Depends;
import org.soul.commons.validation.form.constraints.Qq;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("玩家中心个人信息编辑页面表单验证")
public class PersonInfoEditForm implements IForm {

    private String skype_contactValue;
    private String msn_contactValue;
    private String qq_contactValue;
    private String result_nickname;
    private String result_realName;

    @Length(min = 1,max = 30,message = "passport.edit.info.msn")
    @Email(message = "passport.edit.info.format.error")
    @Comment("msn")
    public String getMsn_contactValue() {
        return msn_contactValue;
    }

    public void setMsn_contactValue(String msn_contactValue) {
        this.msn_contactValue = msn_contactValue;
    }

    @Qq(message = "passport.edit.info.format.error")
    @Length(min = 5,max = 11,message = "passport.edit.info.qq")
    @Comment("qq")
    public String getQq_contactValue() {
        return qq_contactValue;
    }

    public void setQq_contactValue(String qq_contactValue) {
        this.qq_contactValue = qq_contactValue;
    }

    @Length(min = 6,max = 32,message = "passport.edit.info.skype")
    @Pattern(regexp = FormValidRegExps.SKYPE,message = "passport.edit.info.format.error")
    @Comment("skype")
    public String getSkype_contactValue() {
        return skype_contactValue;
    }

    public void setSkype_contactValue(String skype_contactValue) {
        this.skype_contactValue = skype_contactValue;
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
    @Depends(property = "$flag",operator = Operator.EQ,value = {"0"},jsValueExp ="$(\"[name=\\'realNameStatus\\']\").val()",message = "passport.edit.info.realName.notBlank")
    @Pattern(regexp = FormValidRegExps.REALNAME,message = "passport.edit.info.format.error")
    @Comment("姓名")
    public String getResult_realName() {
        return result_realName;
    }

    public void setResult_realName(String result_realName) {
        this.result_realName = result_realName;
    }
}
