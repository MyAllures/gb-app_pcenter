<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<html lang="zh-CN">
<head>
    <title>${views.personInfo_auto['修改登录密码']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>

<body class="body-b-none">

<form:form id="editForm" action="" method="post">
    <input type="hidden" name="result.id" value="${command.result.id}">
    <input id="remainTimes" type="hidden" value="${remainTimes}"/>
    <div id="validateRule" style="display: none">${validateRule}</div>

    <div class="modal-body" style="height: 145px;">
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['当前密码']}：</label>
            <div class="col-xs-8 p-x">
                <input type="password" class="input" name="password" maxlength="20" autocomplete="off" showSuccMsg="false">
            </div>
        </div>
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['新密码']}：</label>
            <div class="col-xs-8 p-x" style="width: 70%">
                <input type="password" class="input" name="newPassword" maxlength="20" autocomplete="off">
            </div>
        </div>
        <gb:passwordLevel name="passwordLevel" passwordInput="newPassword" label="${views.account['AccountSetting.setting.password.passwordStrength']}"></gb:passwordLevel>

        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['确认密码']}：</label>
            <div class="col-xs-8 p-x">
                <input type="password" class="input" name="newRePassword" maxlength="20" autocomplete="off">
            </div>
        </div>

        <div style="display: none" id="privilegeTipDiv">
            <input type="hidden" name="flag" value="false">
            <div class="form-group clearfix line-hi34 m-b-xxs">
                <label class="col-xs-3 al-right">${views.personInfo_auto['验证码']}：</label>
                <div class="col-xs-8 p-x">
                    <input type="text" class="input" name="code"/>
                    <span class="verify-img"><img src="${root}/captcha/code.html" height="32" reloadable/></span>
                    <div class="form-group clearfix line-hi34 m-b-xxs">
                        <label class="al-right">
                            <i class="fa fa-times-circle co-red3"></i>
                                ${fn:replace(views.share['privilege.password.prefix'],"{0}","<span class=\"co-red3\">0</span>")}
                        </label>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <div class="modal-footer">
        <soul:button precall="validateForm" target="${root}/personInfo/password/updatePassword.html" text="${views.account['AccountSetting.update']}" opType="ajax" cssClass="btn btn-outline btn-filter" dataType="json" post="getCurrentFormData" callback="saveCallbak">${views.common['AccountSetting.update']}</soul:button>
        <soul:button target="closePage" text="${views.common['cancel']}" opType="function" cssClass="btn-gray btn btn-big">${views.common['cancel']}</soul:button>
    </div>
</form:form>

</body>
<%@ include file="/include/include.js.jsp" %>
<!--//region your codes 4-->
<soul:import res="site/personInfo/UpdatePassword"/>
<!--//endregion your codes 4-->
</html>
<!--//endregion your codes １-->
