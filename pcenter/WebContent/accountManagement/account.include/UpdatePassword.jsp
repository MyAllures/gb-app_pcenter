<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
    <div class="accout-retract" style="display: none" id="updatePassword">
        <h2>${views.account['AccountSetting.setting.password.message1']}：${views.common[accountSecurityLevel.level]}</h2>

        <div class="control-grouptwo">
            <label class="control-left">${views.account['AccountSetting.setting.password.password']}：</label>
            <div class="controls">
                <span class="box">
                    <input type="password" class="input" name="password" maxlength="20"/>
                    <%--<i class="ico-ask hidesmall password"></i>--%>
                    <%--<i class="ico-ask showsmall" style="display: none" tipsName="password-tips"></i>--%>
                </span>
                <%--<p class="m-tt"><a href="#">${views.account['AccountSetting.setting.password.forgetPwd']}</a></p>--%>
            </div>
        </div>

        <div class="control-grouptwo">
            <label class="control-left">${views.account['AccountSetting.setting.password.newPwd']}：</label>
            <div class="controls">
                <span class="box">
                    <input type="password" class="input" name="newPassword" maxlength="20"/>
                    <%--<i class="ico-ask hidesmall"></i>--%>
                    <%--<i class="ico-ask showsmall" style="display: none" tipsName="newPassword-tips"></i>--%>
                </span>

            </div>
        </div>

        <gb:passwordLevel name="passwordLevel" passwordInput="newPassword" label="${views.account['AccountSetting.setting.password.passwordStrength']}"></gb:passwordLevel>

        <div class="control-grouptwo">
            <label class="control-left">${views.account['AccountSetting.setting.password.confirmPwd']}：</label>
            <div class="controls">
                <span class="box">
                    <input type="password" class="input" name="newRePassword" maxlength="20"/>
                    <%--<i class="ico-ask hidesmall"></i>--%>
                    <%--<i class="ico-ask showsmall" style="display: none" tipsName="newRePassword-tips"></i>--%>
                </span>
            </div>
        </div>

        <div class="control-grouptwo">
            <label class="control-label"></label>
            <div class="controls">
                <soul:button precall="validateForm" target="${root}/accountSettings/updatePassword.html" text="${views.account['AccountSetting.update']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.common['AccountSetting.update']}</soul:button>
                <soul:button target="updatePwdPre" text="${views.common['cancel']}" opType="function" cssClass="btn-gray btn btn-big">${views.common['cancel']}</soul:button>
            </div>
        </div>
    </div>
<!--//endregion your codes １-->
