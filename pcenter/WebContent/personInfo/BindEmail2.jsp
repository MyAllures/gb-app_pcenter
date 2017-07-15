<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div id="validateRule" style="display: none">${validateRule}</div>
<div class="modal-body">
    <div class="form-group clearfix line-hi34 m-b-xxs">
        <label class="col-xs-3 al-right">${views.account['AccountSetting.setting.email.newEmail']}：</label>
        <div class="col-xs-8 p-x sop-down">
            <input type="hidden" value="false" name="eflag">
            <input type="text" class="input inputMailList bn" placeholder="" name="email.contactValue" id="emailCode" autocomplete="off">
            <input type="hidden" class="input" name="email.id" value="${noticeContactWay.id}">
        </div>
    </div>
    <div class="form-group clearfix line-hi34 m-b-xxs sendmCode">
        <label class="col-xs-3 al-right">${views.account['AccountSetting.setting.email.captcha']}：</label>
        <div class="col-xs-8 p-x">
            <input type="text" class="input-code" name="verificationCode" id="verificationCode" showSuccMsg="false">
            <soul:button target="sendmCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function"
                         cssClass="btn-gray btn btn-code">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button>
            <span tipsName="verificationCode-tips"></span>
        </div>
    </div>
</div>
<div class="modal-footer">
    <soul:button precall="validateForm" target="${root}/personInfo/updateEmail.html" text="${views.account['AccountSetting.setting.email.bindEmail3']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.account['AccountSetting.setting.email.bindEmail3']}</soul:button>
</div>

<!--//endregion your codes １-->
