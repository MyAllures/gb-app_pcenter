<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="SecurityPwd">
    <div id="validateRule" style="display: none">${securityPwdRule}</div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><i class="mark ${not empty sysUserVo.result.permissionPwd?'success':'plaint'}"></i>${views.account['AccountSetting.setting.password.securityPwd']}</td>
            <td class="gray">${not empty sysUserVo.result.permissionPwd?views.account['AccountSetting.setting.password.message4']:views.account['AccountSetting.setting.password.message5']}</td>
            <td width="14%">
                <soul:button target="SetAndHide" text="" opType="function" cssClass="btn btn-blue btn-small classtitle" tag="button">
                    <span class="set">${views.account['AccountSetting.set']}</span>
                    <span class="shrink">${views.account['AccountSetting.shrink']}</span>
                </soul:button>
            </td>
        </tr>

        <tr class="bottomline" style="display:none;">
            <td colspan="3">
                <c:choose>
                    <c:when test="${not empty sysUserVo.result.permissionPwd}">
                        <div class="accout-retract" id="modifySecurityPwd">
                            <h2>${views.account['AccountSetting.setting.password.message6']}</h2>
                            <div class="orange spaces modifypassword">${views.account['AccountSetting.setting.password.message7']}</div>
                            <div class="controls spaces">
                                <soul:button target="modifySecurityPwd" text="${views.acccount['AccountSetting.setting.password.updatePwd']}" opType="function" class="btn-gray btn btn-big">${views.account['AccountSetting.setting.password.updatePwd']}</soul:button>
                            </div>
                        </div>

                        <div class="accout-retract" id="updateSecurityPwd" style="display:none;">
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.password.secPassword']}：</label>
                                <div class="controls">
                                    <span class="box">
                                        <input type="password" class="input" name="oldPrivilegePwd" maxlength="6">
                                    <%--<i class="ico-ask hidesmall"></i>--%>
                                    <%--<i class="ico-ask showsmall" style="display: none" tipsName="oldPrivilegePwd-tips"></i>--%>
                                    </span>
                                    <%--<p class="m-tt"><a href="#">${views.account['AccountSetting.setting.password.forgetPwd']}</a></p>--%>

                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.password.newSecPwd']}：</label>
                                <div class="controls">
                                    <span class="box">
                                        <input type="password" class="input" name="privilegePwd" maxlength="6">
                                        <%--<i class="ico-ask hidesmall"></i>--%>
                                        <%--<i class="ico-ask showsmall" style="display: none" tipsName="privilegePwd-tips"></i>--%>
                                    </span>

                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.password.conSecPwd']}：</label>
                                <div class="controls">
                                    <span class="box">
                                        <input type="password" class="input" name="confirmPrivilegePwd"  maxlength="6">
                                        <%--<i class="ico-ask hidesmall"></i>--%>
                                        <%--<i class="ico-ask showsmall" style="display: none" tipsName="confirmPrivilegePwd-tips"></i>--%>
                                    </span>
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls">
                                    <soul:button precall="validateForm" target="${root}/accountSettings/updatePrivilegePassword.html" text="${views.account['AccountSetting.update']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.account['AccountSetting.update']}</soul:button>
                                    <soul:button target="modifySecurityPwdPre" text="${views.common['cancel']}" opType="function" cssClass="btn-gray btn btn-big">${views.common['cancel']}</soul:button>
                                </div>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="accout-retract" >
                            <h2>${views.account['AccountSetting.setting.password.message5']}</h2>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.password.newSecPwd']}：</label>
                                <div class="controls">
                                    <span class="box">
                                        <input type="password" placeholder="${views.account['AccountSetting.setting.password.setSecPwd']}" class="input" name="privilegePwd" maxlength="6">
                                        <%--<i class="ico-ask hidesmall"></i>--%>
                                        <%--<i class="ico-ask showsmall" style="display: none" tipsName="privilegePwd-tips"></i>--%>
                                    </span>

                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.password.conSecPwd']}：</label>
                                <div class="controls">
                                    <span class="box">
                                        <input type="password" placeholder="${views.account['AccountSetting.setting.password.conSecPwd']}" class="input" name="privilegeRePwd" maxlength="6">
                                        <%--<i class="ico-ask hidesmall"></i>--%>
                                        <%--<i class="ico-ask showsmall" style="display: none" tipsName="privilegeRePwd-tips"></i>--%>
                                    </span>
                                </div>
                            </div>

                            <%--<div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.password.loginPwd']}：</label>
                                <div class="controls">
                                    <span class="box">
                                        <input type="password" placeholder="" class="input" name="loginPwd" maxlength="20">
                                        &lt;%&ndash;<i class="ico-ask hidesmall"></i>&ndash;%&gt;
                                        &lt;%&ndash;<i class="ico-ask showsmall" style="display: none" tipsName="loginPwd-tips"></i>&ndash;%&gt;
                                    </span>
                                </div>
                            </div>--%>

                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls">
                                    <soul:button precall="validateForm" target="${root}/accountSettings/updatePrivilegePassword.html" text="${views.common['ok']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.common['ok']}</soul:button>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
</form:form>
<!--//endregion your codes １-->