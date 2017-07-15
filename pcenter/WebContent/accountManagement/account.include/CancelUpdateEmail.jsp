<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract" id="cancelUpdateEmail">
    <div id="validateRule" style="display: none">${playerEmailRule}</div>
        <div class="spaces modifypassword">
            <c:choose>
                <c:when test="${regSettingMailVerifcation}">
                    ${views.account['AccountSetting.setting.email.bindEmail2']}<span class="orange bold">${soulFn:overlayEmaill(noticeContactWay.contactValue)}</span>，${views.account['AccountSetting.setting.email.message']}
                </c:when>
                <c:otherwise>
                    ${views.accountManagement_auto['您的邮箱是']}<span class="orange bold">${soulFn:overlayEmaill(noticeContactWay.contactValue)}</span>，${views.account['AccountSetting.setting.email.message1']}
                </c:otherwise>
            </c:choose>
        </div>
        <div class="controls spaces">
            <input type="hidden" value="${noticeContactWay.status}" name="isClear">
            <soul:button target="changeEmailPage" text="${views.account['AccountSetting.setting.email.changeEmail']}" opType="function" cssClass="btn-gray btn btn-big">${views.account['AccountSetting.setting.email.changeEmail']}</soul:button>
        </div>
</div>

<!--//endregion your codes １-->
