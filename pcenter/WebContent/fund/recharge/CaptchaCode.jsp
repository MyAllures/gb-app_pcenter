<%@ page import="so.wwb.gamebox.pcenter.session.SessionManager" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:set var="rechargeCount" value="<%=SessionManager.getRechargeCount()%>"/>
<c:if test="${rechargeCount>=3}">
    <div class="control-group  code">
        <label class="control-label">${views.common['verificationCode']}</label>
        <div class="controls">
            <input type="hidden" name="rechargeCount" value="${rechargeCount}"/>
            <input type="text" name="code" class="input" showSuccMsg="false"/>
            <img class="captcha-code" src="${root}/captcha/recharge.html?t=${random}" reloadable>
            <span name="codeTitle"></span>
        </div>
    </div>
</c:if>
