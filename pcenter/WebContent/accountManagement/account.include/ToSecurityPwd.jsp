<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract">
    <div id="validateRule" style="display: none">${rule}</div>
    <h2>${views.account['AccountSetting.setting.question.message8']}</h2>

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.password.securityPwd']}：</label>
        <div class="controls">
            <input type="password" id="" placeholder="" class="input" name="permissionPwd">
        </div>
    </div>

    <div class="control-grouptwo">
        <label class="control-label"></label>
        <div class="controls">
            <c:choose>
                <c:when test="${type eq 'phone'}">
                    <soul:button precall="validateForm" target="clearPhone" text="${views.account['AccountSetting.conifrm']}" opType="function" cssClass="btn-blue btn btn-big">${views.account['AccountSetting.conifrm']}</soul:button>
                </c:when>
                <c:otherwise>
                    <soul:button precall="validateForm" target="changeEmailPage" text="${views.account['AccountSetting.conifrm']}" opType="function" cssClass="btn-blue btn btn-big">${views.account['AccountSetting.conifrm']}</soul:button>
                </c:otherwise>
            </c:choose>
            <c:if test="${isSet}">
                <soul:button target="toConfirmAnswers" text="${views.account['AccountSetting.setting.question.message9']}" opType="function" contactWayType="${type}"><span class="">${views.account['AccountSetting.setting.question.message9']}</span></soul:button>
            </c:if>

        </div>
    </div>
</div>
<!--//endregion your codes １-->
