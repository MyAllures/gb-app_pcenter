<%--@elvariable id="command" type="org.soul.model.security.privilege.vo.SysUserVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body class="body-b-none">
<form:form>
    <div id="validateRule" style="display: none">${command.validateRule}</div>
    <!--修改密码-->
    <div class="modal-body">
        <p style="text-align: center">${views.account['AccountSetting.setting.bank.message5']}</p>

        <div class="form-group clearfix line-hi34" style="padding-top: 15px">
            <label for="result.permissionPwd"
                   class="col-xs-3 al-right">${views.account['AccountSetting.setting.password.newSecPwd']}：</label>
            <div class="col-xs-7 p-x"><input type="password" class="input form-control" name="result.permissionPwd"
                                             placeholder="${views.account['AccountSetting.setting.password.setSecPwd']}"
                                             autocomplete="off" maxlength="6"></div>
        </div>
        <div class="form-group clearfix line-hi34" style="padding-top: 15px">
            <label for="confirmPermissionPwd"
                   class="col-xs-3 al-right">${views.account['AccountSetting.setting.password.conSecPwd']}：</label>
            <div class="col-xs-7 p-x"><input type="password" class="input form-control" name="confirmPermissionPwd"
                                             placeholder="${views.account['AccountSetting.setting.password.conSecPwd']}"
                                             autocomplete="off" maxlength="6"></div>
        </div>
            <%--<div class="form-group clearfix line-hi34" style="padding-top: 15px">
                <label for="result.password" class="col-xs-3 al-right">${messages.privilege['loginPwd']}：</label>
                <div class="col-xs-8 p-x"><input type="password" placeholder="" class="form-control" name="result.password" maxlength="20"></div>
            </div>--%>
    </div>
    <div class="modal-footer">
        <soul:button cssClass="btn btn-filter" text="${views.common.ok}" opType="ajax" precall="validateForm"
                     target="${root}/privilege/setPrivilegePassword.html" dataType="json" post="getCurrentFormData"
                     callback="mySaveCallBack"/>
        <soul:button cssClass="btn btn-outline btn-filter" target="closePage" opType="function"
                     text="${views.common.cancel}"/>
    </div>
</form:form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="privilege/SetPrivilegePassword"/>
</html>