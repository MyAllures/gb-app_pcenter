<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract" id="changeEmail">
    <div id="validateRule" style="display: none">${playerEmailRule}</div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.email.oldEmail']}：</label>
        <div class="controls down-menu-option">
            <span class="pull-down-a" tipsName="oldContactValue-tips">
                <input type="text" class="input inputMailList bn" name="oldContactValue" autocomplete="off">
            </span>
        </div>
    </div>

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.email.newEmail']}：</label>
        <div class="controls down-menu-option">
            <span class="pull-down-a" tipsName="email.contactValue-tips">
                <input type="text"  class="input inputMailList bn" placeholder="" name="email.contactValue" autocomplete="off">
                <input type="hidden" class="input" name="email.id" value="${noticeContactWay.id}">
            </span>
        </div>
    </div>

    <div class="control-grouptwo sendmCode">
        <label class="control-left">${views.account['AccountSetting.setting.email.captcha']}：</label>
        <div class="controls">
            <input type="text" id="input" class="input-code" name="ecode" style="width: 120px;"/>
            <img src="${root}/captcha/emailCode.html" reloadable tipsName="ecode-tips"/>
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-label"></label>
        <div class="controls">
            <soul:button precall="validateForm" target="${root}/accountSettings/updateEmail.html" text="${views.common['ok']}" opType="ajax" cssClass="btn btn-big btn-blue" dataType="json" post="getCurrentFormData"  callback="mySaveCallBack">${views.common['ok']}</soul:button>
            <soul:button target="cancelUpdateEmail" text="${views.accountManagement_auto['取消']}" opType="function" cssClass="btn-gray btn btn-big">${views.accountManagement_auto['取消']}</soul:button>
        </div>
        <div class="warm-tips">
            <p>
                <c:set value="<%=CacheBase.getDefaultCustomerService().getParameter()%>" var="url"></c:set>
                <c:set value="${views.account['AccountSetting.setting.contactCustomer']}" var="name"></c:set>
                <c:set value="<a url=${url} name='customerService'>${name}</a>" var="aurl"></c:set>
                ${fn:replace(views.account['AccountSetting.setting.message13'],"{customerService}" , aurl)}
            </p>
        </div>
    </div>
</div>

<!--//endregion your codes １-->
