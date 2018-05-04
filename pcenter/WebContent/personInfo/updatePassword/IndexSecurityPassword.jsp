<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>

<style>
    <%--自定义密码强度样式--%>
    ._password_level .al-right {width: 33.8%}
    ._password_level .p-x.controls {width: 66%}
    .change-password-wrap .control-group .controls .tips{width: 100%}
</style>
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right">
        <a class="cursor">修改密码</a>
    </div>
</div>

<div class="hintotal float-not change-password-wrap">
    <form id="editForm" method="post" action="${root}/personInfo/password/index.html">
        <div id="validateRule" style="display: none">${validateRule}</div>
        <input id="7f1a3d0c-f15e-4e7a-8836-fc7182298af9" type="hidden" value="${leftTimes}"/>

        <div class="change-link-wrap">
            <a href="/personInfo/password/index.html" class="change-link" nav-target="mainFrame">修改登录密码</a>
            <a href="javascript:" class="change-link active" nav-target="mainFrame">修改安全密码</a>
        </div>

        <div class="control-group">
            <label class="control-label">${views.personInfo_auto['真实姓名']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${empty realName}">
                        <input type="text" class="input input-money" name="realName" placeholder="${views.personInfo_auto['请验证真实姓名']}">
                    </c:when>
                    <c:otherwise>
                        <input type="text" class="input input-money" name="realName2" placeholder="${views.personInfo_auto['请验证真实姓名']}">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">${views.personInfo_auto['当前密码']}：</label>
            <div class="controls">
                <input type="password" class="input input-money" name="oldPrivilegePwd" maxlength="6" autocomplete="off"
                       showSuccMsg="false">
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">${views.personInfo_auto['新密码']}：</label>
            <div class="controls">
                <input class="input input-money" type="password" name="privilegePwd" maxlength="6" autocomplete="off">
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">${views.personInfo_auto['确认密码']}：</label>
            <div class="controls">
                <input class="input input-money" type="password" name="confirmPrivilegePwd" maxlength="6" autocomplete="off">
            </div>
        </div>
        <div class="control-group" style="display: none" id="privilegeTipDiv">
            <input type="hidden" name="flag" value="false">
            <div class="form-group clearfix line-hi34 m-b-xxs">
                <label style="width: 21%" class="col-xs-3 al-right">${views.personInfo_auto['验证码']}：</label>
                <div style="width: 66%" class="col-xs-8 p-x">
                    <input type="text" class="input" name="code" maxlength="4"/>
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
        <div class="change-btn">
            <soul:button precall="validateForm" target="${root}/personInfo/password/updatePrivilegePassword.html"
                         text="${views.account['AccountSetting.update']}" opType="ajax" cssClass="btn-blue btn"
                         dataType="json" post="getCurrentFormData"
                         callback="saveCallbak">${views.account['AccountSetting.update']}</soul:button>
        </div>
        <div class="change-btn">
            <a href="/personInfo/password/forgetPwd.html" class="large-big btn btn-link" nav-target="mainFrame">忘记安全密码？</a>
        </div>

    </form>

</div>

<soul:import res="site/personInfo/UpdateSecurityPassword"/>


