<%@ page import="so.wwb.gamebox.web.common.SiteCustomerServiceHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<html lang="zh-CN">
<head>
    <title>${views.personInfo_auto['绑定邮箱']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>

<body class="body-b-none">

<form:form id="editForm" action="" method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>

    <div class="modal-body">
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.account['AccountSetting.setting.email.oldEmail']}：</label>
            <div class="col-xs-8 p-x sop-down">
                <input type="text" class="input inputMailList bn" name="email.contactValue" id="emailCode" autocomplete="off">
            </div>
        </div>
        <div class="form-group clearfix line-hi34 m-b-xxs sendmCode">
            <label class="col-xs-3 al-right">${views.account['AccountSetting.setting.email.captcha']}：</label>
            <div class="col-xs-8 p-x">
                <input type="text" class="input-code" name="verificationCode" id="verificationCode" showSuccMsg="false">
                <soul:button target="sendmCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function"
                             cssClass="btn-gray btn btn-code">
                             ${views.account['AccountSetting.setting.email.freeCaptcha']}
                </soul:button>
                <span tipsName="verificationCode-tips"></span>
            </div>
        </div>
        <p class="popgray">
            <c:set value="<%=SiteCustomerServiceHelper.getPCCustomerServiceUrl()%>" var="url"></c:set>
            <c:set value="${views.account['AccountSetting.setting.contactCustomer']}" var="name"></c:set>
            <c:set value="<a url=${url} name='customerService'>${name}</a>" var="aurl"></c:set>
                ${fn:replace(views.account['AccountSetting.setting.message13'],"{customerService}" , aurl)}
        </p>
    </div>
    <div class="modal-footer">
        <soul:button precall="validateForm" target="updateEmailNext" text="${views.common['next']}" opType="function"
                     cssClass="btn-outline btn-filter btn-gray btn btn-code">${views.common['next']}</soul:button>
    </div>
</form:form>

</body>
<%@ include file="/include/include.js.jsp" %>
<!--//region your codes 4-->
<soul:import res="site/personInfo/BindEmail"/>
<!--//endregion your codes 4-->
</html>
<!--//endregion your codes １-->
