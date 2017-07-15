<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<html lang="zh-CN">
<head>
    <title>${views.personInfo_auto['设置安全密码']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>

<body class="body-b-none">
<form:form id="editForm" action="" method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="modal-body">
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.account['AccountSetting.setting.password.newSecPwd']}：</label>
            <div class="col-xs-8 p-x">
                <input type="password" placeholder="${views.account['AccountSetting.setting.password.setSecPwd']}" class="input" name="privilegePwd" maxlength="6">
            </div>
        </div>
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.account['AccountSetting.setting.password.conSecPwd']}：</label>
            <div class="col-xs-8 p-x">
                <input type="password" placeholder="${views.account['AccountSetting.setting.password.conSecPwd']}" class="input" name="privilegeRePwd" maxlength="6">
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button precall="validateForm" target="${root}/personInfo/password/updatePrivilegePassword.html" text="${views.common['ok']}" opType="ajax" cssClass="btn btn-outline btn-filter" dataType="json" post="getCurrentFormData" callback="query">${views.common['ok']}</soul:button>
        <soul:button target="closePage" text="${views.common['cancel']}" opType="function" cssClass="btn-gray btn btn-big">${views.common['cancel']}</soul:button>
    </div>
</form:form>
</body>
<%@ include file="/include/include.js.jsp" %>
<!--//region your codes 4-->
<soul:import res="site/personInfo/UpdateSecurityPassword"/>
<!--//endregion your codes 4-->
</html>
<!--//endregion your codes １-->
