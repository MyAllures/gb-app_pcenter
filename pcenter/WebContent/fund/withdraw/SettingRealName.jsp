<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/include/include.inc.jsp" %>

<%@ include file="/include/include.head.jsp" %>
<%@ include file="/include/include.js.jsp" %>

<form:form>
    <div id="validateRule" style="display: none">${settingRealNameRule}</div>
    <div id="realName1">
        <div class="modal-body">
            <div class="withdraw-not" style="margin-left: 10%;">
                <div class="control-group">
                    <div class="controls"><span class="textop orange">${views.account['AccountSetting.personal.message3']}</span></div>
                </div>
                <div class="text al-center">
                    <div class="control-group">
                        <label class="control-label">${views.account['AccountSetting.personal.realName']}：</label>
                        <div class="controls"><input type="text" class="input" placeholder="" name="result.realName" maxlength="30"/></div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <soul:button precall="validateForm" title="ok" target="${root}/player/withdraw/updateRealName.html" text="${views.common['ok']}" opType="ajax" cssClass="btn btn-blue middle-big"  post="getCurrentFormData" callback="closeRealNameDialog" />
            <soul:button target="closeRealNameDialog" title="cc" text="${views.common['cancel']}" opType="function" cssClass="btn btn-default middle-big" />
        </div>
    </div>

</form:form>

<soul:import res="site/fund/withdraw/SettingRealName"/>
