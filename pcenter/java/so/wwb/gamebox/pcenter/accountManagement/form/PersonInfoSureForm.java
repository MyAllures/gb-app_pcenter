package so.wwb.gamebox.pcenter.accountManagement.form;

import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Compare;
import org.soul.commons.validation.form.support.Comment;
import org.soul.commons.validation.form.support.CompareLogic;
import org.soul.web.support.IForm;

/**
 * Created by eagle on 15-11-1.
 */
@Comment("个人信息真实姓名/时区/货币弹窗验证")
public class PersonInfoSureForm implements IForm {

    private String oldCurrency;
    private String oldTimezone;
    private String oldRealName;
    private String defaultCurrency;
    private String defaultTimezone;
    private String defaultRealName;

    @NotBlank(message = "passport.edit.info.select.currency")
    @Compare(message = "passport.edit.info.not.same", logic = CompareLogic.EQ, anotherProperty = "oldCurrency")
    @Comment("主货币")
    public String getDefaultCurrency() {
        return defaultCurrency;
    }

    public void setDefaultCurrency(String defaultCurrency) {
        this.defaultCurrency = defaultCurrency;
    }

    @NotBlank(message = "passport.edit.info.realName.notBlank")
    @Compare(message = "passport.edit.info.i.not.same", logic = CompareLogic.EQ, anotherProperty = "oldRealName")
    @Comment("真实姓名")
    public String getDefaultRealName() {
        return defaultRealName;
    }

    public void setDefaultRealName(String defaultRealName) {
        this.defaultRealName = defaultRealName;
    }

    @NotBlank(message = "passport.edit.info.s.timezone")
    @Compare(message = "passport.edit.info.not.same", logic = CompareLogic.EQ, anotherProperty = "oldTimezone")
    @Comment("时区")
    public String getDefaultTimezone() {
        return defaultTimezone;
    }

    public void setDefaultTimezone(String defaultTimezone) {
        this.defaultTimezone = defaultTimezone;
    }

    public String getOldCurrency() {
        return oldCurrency;
    }

    public void setOldCurrency(String oldCurrency) {
        this.oldCurrency = oldCurrency;
    }

    public String getOldRealName() {
        return oldRealName;
    }

    public void setOldRealName(String oldRealName) {
        this.oldRealName = oldRealName;
    }

    public String getOldTimezone() {
        return oldTimezone;
    }

    public void setOldTimezone(String oldTimezone) {
        this.oldTimezone = oldTimezone;
    }
}
