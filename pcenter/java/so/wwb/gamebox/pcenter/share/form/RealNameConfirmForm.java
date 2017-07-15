package so.wwb.gamebox.pcenter.share.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.share.controller.ShareController;

/**
 * Created by cherry on 16-1-7.
 */
@Comment("确认真实姓名验证")
public class RealNameConfirmForm implements IForm {
    private String $confirmRealName;

    @Comment("确认真实姓名")
    @NotBlank
    @Length(min = 2, max = 30)
    @Remote(message = "share.realNameForm.confirmRealName.remote", checkClass = ShareController.class, checkMethod = "compareRealName")
    public String get$confirmRealName() {
        return $confirmRealName;
    }

    public void set$confirmRealName(String $confirmRealName) {
        this.$confirmRealName = $confirmRealName;
    }
}
