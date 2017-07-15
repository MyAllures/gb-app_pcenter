package so.wwb.gamebox.pcenter.operation.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;


/**
 * 系统公告表单验证对象
 *
 * @author orange
 * @time 2015-11-17 14:57:54
 */
//region your codes 1
public class SystemAnnouncementForm implements IForm {
//endregion your codes 1

    //region your codes 2
    private String content$$;
    private String title$$;

    @NotBlank(message = "setting.anno.content.notBlank")
    @Length(max = 1000)
    @Comment("内容")
    public String getContent$$() {
        return content$$;
    }

    public void setContent$$(String content$$) {
        this.content$$ = content$$;
    }

    @NotBlank(message = "setting.anno.title.notBlank")
    @Length(max = 50)
    @Comment("标题")
    public String getTitle$$() {
        return title$$;
    }

    public void setTitle$$(String title$$) {
        this.title$$ = title$$;
    }
    //endregion your codes 2

}