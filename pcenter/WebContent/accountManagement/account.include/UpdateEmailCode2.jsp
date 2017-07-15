<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div id="validateRule" style="display: none">${playerEmailRule}</div>
<div class="accout-retract" id="emailNext">
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.email.newEmail']}：</label>
        <div class="controls down-menu-option">
            <span class="pull-down-a" tipsName="email.contactValue-tips">
                <input type="hidden" value="false" name="eflag">
                <input type="text" class="input inputMailList" placeholder="" name="email.contactValue" id="emailCode" autocomplete="off">
                <input type="hidden" class="input" name="email.id" value="${noticeContactWay.id}">
            </span>
        </div>
    </div>
    <div class="control-grouptwo sendmCode">
        <label class="control-left">${views.account['AccountSetting.setting.email.captcha']}：</label>
        <div class="controls">
            <input type="text" placeholder="" class="input-code" name="verificationCode" id="verificationCode" showSuccMsg="false">
            <soul:button target="sendmCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function"
                         cssClass="btn-gray btn btn-code">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button>
            <span tipsName="verificationCode-tips"></span>
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-label"></label>

        <div class="controls">
            <soul:button precall="validateForm" target="${root}/accountSettings/updateEmail.html" text="${views.account['AccountSetting.setting.email.bindEmail3']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.account['AccountSetting.setting.email.bindEmail3']}</soul:button>
        </div>
    </div>
</div>
<!--//endregion your codes １-->
