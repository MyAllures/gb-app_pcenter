package so.wwb.gamebox.pcenter.operation.form;

import org.hibernate.validator.constraints.Length;
import org.hibernate.validator.constraints.NotBlank;
import org.soul.commons.validation.form.constraints.Remote;
import org.soul.commons.validation.form.support.Comment;
import org.soul.web.support.IForm;
import so.wwb.gamebox.pcenter.operation.controller.AnnouncementMessageController;

/**
 * 追问验证
 * Created by Cherry on 16-4-23.
 */
@Comment("追问验证")
public class AdvisoryMessageForm implements IForm {
    private String result_advisoryTitle;
    private String result_advisoryContent;
    private String $code;

    @Comment("发送标题")
    @NotBlank(message = "operation.advisoryMessage.title.notBlank")
    @Length(min = 2, max = 100, message = "operation.advisoryMessage.title.length")
    public String getResult_advisoryTitle() {
        return result_advisoryTitle;
    }

    public void setResult_advisoryTitle(String result_advisoryTitle) {
        this.result_advisoryTitle = result_advisoryTitle;
    }

    @Comment("发送内容")
    @NotBlank(message = "operation.advisoryMessage.content.notBlank")
    @Length(min = 1, max = 20000, message = "operation.advisoryMessage.content.length")
    public String getResult_advisoryContent() {
        return result_advisoryContent;
    }

    public void setResult_advisoryContent(String result_advisoryContent) {
        this.result_advisoryContent = result_advisoryContent;
    }

    @Comment("验证码")
    @NotBlank
    @Remote(message = "common.captcha.error", checkMethod = "checkCaptcha", checkClass = AnnouncementMessageController.class)
    public String get$code() {
        return $code;
    }

    public void set$code(String $code) {
        this.$code = $code;
    }
}
