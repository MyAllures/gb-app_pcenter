<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<html lang="zh-CN">
<head>
    <title>${views.personInfo_auto['修改安全密码']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>

<body class="body-b-none">

<form:form id="editForm" action="" method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input id="7f1a3d0c-f15e-4e7a-8836-fc7182298af9" type="hidden" value="${leftTimes}"/>
    <div class="modal-body" style="height: 145px;">
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['真实姓名']}：</label>
            <div class="col-xs-8 p-x">
                <c:choose>
                    <c:when test="${empty realName}">
                        <input type="text" class="input" name="realName" placeholder="${views.personInfo_auto['请验证真实姓名']}">
                    </c:when>
                    <c:otherwise>
                        <input type="text" class="input" name="realName2" placeholder="${views.personInfo_auto['请验证真实姓名']}">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['当前密码']}：</label>
            <div class="col-xs-8 p-x">
                <input type="password" class="input" name="oldPrivilegePwd" maxlength="6" autocomplete="off"
                       showSuccMsg="false">
            </div>
        </div>

        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['新密码']}：</label>
            <div class="col-xs-8 p-x" style="width: 70%">
                <input type="password" class="input" name="privilegePwd" maxlength="6" autocomplete="off">
            </div>
        </div>
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['确认密码']}：</label>
            <div class="col-xs-8 p-x">
                <input type="password" class="input" name="confirmPrivilegePwd" maxlength="6" autocomplete="off">
            </div>
        </div>
        <div style="display: none" id="privilegeTipDiv">
            <input type="hidden" name="flag" value="false">
            <div class="form-group clearfix line-hi34 m-b-xxs">
                <label class="col-xs-3 al-right">${views.personInfo_auto['验证码']}：</label>
                <div class="col-xs-8 p-x">
                    <input type="text" class="input" name="code"/>
                    <span class="verify-img"><img src="${root}/captcha/securityPwd.html" height="32" reloadable/></span>
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
        <soul:button precall="validateForm" target="${root}/personInfo/password/updatePrivilegePassword.html"
                     text="${views.account['AccountSetting.update']}" opType="ajax" cssClass="btn-blue btn"
                     dataType="json" post="getCurrentFormData"
                     callback="saveCallbak">${views.account['AccountSetting.update']}</soul:button>
        <soul:button target="closePage" text="${views.common['cancel']}" opType="function"
                     cssClass="btn-gray btn btn-big">${views.common['cancel']}</soul:button>
    </div>

</form:form>

</body>
<%@ include file="/include/include.js.jsp" %>
<!--//region your codes 4-->
<soul:import res="site/personInfo/UpdateSecurityPassword"/>
<!--//endregion your codes 4-->
</html>
<!--//endregion your codes １-->
