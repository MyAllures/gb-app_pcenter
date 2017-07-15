<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div id="validateRule" style="display: none">${playerEmailRule}</div>
<div class="accout-retract" id="changeEmail">
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.email.oldEmail']}：</label>
        <div class="controls down-menu-option">
            <span class="pull-down-a" tipsName="email.contactValue-tips">
                <input type="text" class="input inputMailList bn" name="email.contactValue" id="emailCode" autocomplete="off">
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
                <soul:button precall="validateForm" target="updateEmailNext" text="${views.common['next']}" opType="function"
                             cssClass="btn-gray btn btn-code">${views.common['next']}</soul:button>
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
