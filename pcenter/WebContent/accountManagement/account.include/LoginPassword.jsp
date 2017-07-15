<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="loginPwd">
    <div id="validateRule" style="display: none">${loginPwdRule}</div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td width="20%"><i class="mark ${not empty sysUserVo.result.password?'success':'plaint'}"></i>${views.account['AccountSetting.setting.password.loginPwd']}</td>
            <td width="66%" class="gray">${views.account['AccountSetting.setting.password.passwordLevel']}：
                <gb:passwordLevel level="${accountSecurityLevel.times}"></gb:passwordLevel>
            </td>
            <td width="14%">
                <soul:button target="SetAndHide" text="" opType="function" cssClass="btn btn-blue btn-small classtitle" tag="button">
                    <span class="set" id="set">${views.account['AccountSetting.set']}</span>
                    <span class="shrink" id="shrink">${views.account['AccountSetting.shrink']}</span>
                </soul:button>
            </td>
        </tr>
        <tr class="bottomline" style="display:none;" id="lgoin">
            <td colspan="3">
                <div class="accout-retract" id="modifypassword">
                    <h2>${views.account['AccountSetting.setting.password.message1']}：${views.common[accountSecurityLevel.level]}</h2>
                    <div class="orange spaces modifypassword">${views.account['AccountSetting.setting.password.message2']}</div>
                    <div class="controls spaces">
                        <soul:button target="updatePwd" text="${views.account['AccountSetting.setting.password.updatePwd']}" opType="function" class="btn-gray btn btn-big">${views.account['AccountSetting.setting.password.updatePwd']}</soul:button>
                    </div>
                </div>
                <%@ include file="UpdatePassword.jsp"%>
            </td>
        </tr>
    </table>
</form:form>
<!--//endregion your codes １-->