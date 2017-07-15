<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form:form>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden"  name="oldTimezone" value="${command.oldTimezone}"/>
    <input type="hidden"  name="oldCurrency" value="${command.oldCurrency}"/>
    <input type="hidden"  name="oldRealName" value="${command.oldRealName}"/>

    <div class="theme-popcon">
        <h3 class="popalign"><i class="tipbig fail"></i>${views.account['AccountSetting.personal.message2']}</h3>
        <div class="text">
            <c:if test="${not empty command.oldRealName && command.realNameStatus eq 0}">
                <div class="control-group">
                    <label class="control-label label-big">${views.account['AccountSetting.personal.confirmRealName']}：</label>
                    <div class="controls">
                        <input type="text"  class="input" name="defaultRealName" maxlength="30"/>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty command.oldTimezone && command.timezoneStatus eq 0}">
                <div class="control-group">
                    <label class="control-label label-big">${views.account['AccountSetting.personal.confirmTimeZone']}：</label>
                    <div class="controls">
                        <div class="col-xs-8 p-x">
                            <gb:selectPure name="defaultTimezone" prompt="${views.common['pleaseSelect']}" list="${timeZoneEnum}" value="${command.oldTimezone}"></gb:selectPure>
                        </div>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty command.oldCurrency && command.currencyStatus eq 0}">
                <div class="control-group">
                    <label class="control-label label-big">${views.account['AccountSetting.personal.confirmCurrency']}：</label>
                    <div class="controls">
                        <gb:selectPure name="defaultCurrency" ajaxListPath="${root}/personalInfo/getMainCurrency.html" prompt="${views.account['AccountSetting.personal.pleaseSelect']}" listValue="tran" listKey="code"/>
                    </div>
                </div>
            </c:if>
        </div>
        <div  class="popbutton">
            <soul:button target="sureDialog" text="${views['common']['OK']}" precall="validateForm" cssClass="btn btn-blue middle-big" opType="function">${views.common['ok']}</soul:button>
            <soul:button cssClass="btn btn-gray middle-big" target="closePage" opType="function" text="${views.common.cancel}">${views.common['cancel']}</soul:button>
        </div>
    </div>
</form:form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/accountManagement/PersonalInfo"/>
</html>