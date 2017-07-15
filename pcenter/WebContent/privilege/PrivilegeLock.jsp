<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body class="body-b-none">
<form class="popbutton">
    <div class="modal-body theme-popcon">
        <div>
            <%--<span class="sx"><i class="fa fa-times-circle co-red3"></i></span>--%>
            <div class="sx-data">
                <h1>${views.share['privilege.lock.error.time.limited']}</h1>
                <span>
                    ${fn:replace(views.share['privilege.lock.freeze.prefix'],"{hour}",3)}
                </span>
                <br>
                ${customer}
                ${views.common['Freezetime']}：${soulFn:formatDateTz(curUser.secpwdFreezeStartTime,DateFormat.DAY_SECOND,timeZone)}
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <%--<soul:button cssClass="btn btn-filter" target="${root}/share/reset.html" opType="dialog" post="getCurrentFormData" dataType="json" text="${views.common.resetPassword}"/>--%>
        <%--<soul:button target="${root}/myAccount/toUpdatePrivilegePassword.html" text="${views.common.resetPassword}" opType="dialog" cssClass="btn btn-filter" callback="closePrivilege"></soul:button>--%>
        <soul:button cssClass="btn btn-outline btn-filter" target="closePage" opType="function" text="${views.common.cancel}"/>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="gb/common/Privilege"/>
</html>
