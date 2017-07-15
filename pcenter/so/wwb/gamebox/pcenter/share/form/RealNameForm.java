package so.wwb.gamebox.pcenter.share.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.model.common.RegExpConstants;

import javax.validation.constraints.Pattern;

/**
 * Created by cherry on 16-1-7.
 */
@Comment("填写真实姓名验证")
public class RealNameForm implements IForm {
    private String $realName;

    @Comment("真实姓名")
    @NotBlank
    @Pattern(message = "share.RealNameForm.realName.pattern", regexp = RegExpConstants.REALNAME)
    @Length(min = 2, max = 30)
    public String get$realName() {
        return $realName;
    }

    public void set$realName(String $realName) {
        this.$realName = $realName;
    }
}
