package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;

import javax.validation.constraints.Pattern;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("修改手机号")
public class PlayerPhoneCaptchaForm2 implements IForm {

    private String phone_contactValue;

    @NotBlank(message = "passport.edit.info.phone.notBlank")
    @Pattern(message = "passport.edit.info.format.error",regexp = FormValidRegExps.NUMBER_PHONE)
    @Comment("手机号")
    public String getPhone_contactValue() {
        return phone_contactValue;
    }

    public void setPhone_contactValue(String phone_contactValue) {
        this.phone_contactValue = phone_contactValue;
    }
}
