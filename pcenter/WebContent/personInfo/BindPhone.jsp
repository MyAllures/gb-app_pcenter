<%@ page import="so.wwb.gamebox.web.common.SiteCustomerServiceHelper" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<html lang="zh-CN">
<head>
    <title>${views.personInfo_auto['绑定手机号']}</title>
    <%@ include file="/include/include.head.jsp" %>
    <style>
        .tips.orange{
            width: 100%;
            float: left;
        }
    </style>
</head>

<body class="body-b-none">

<form:form id="editForm" action="" method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>

    <div class="modal-body">
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">手机号：</label>
            <div class="col-xs-8 p-x phone">
                <input type="hidden" class="input" name="phone.id" value="${noticeContactWay.id}">
                <input type="hidden" class="input bn" name="phone.contactValue" id="phoneCode" value="${noticeContactWay.contactValue}">
                <em>${soulFn:overlayTel(noticeContactWay.contactValue)}</em>
            </div>
        </div>
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.personInfo_auto['验证码']}：</label>
            <div class="col-xs-8 p-x">
                <input type="text" class="input-code" name="phone.phoneVerificationCode" id="phoneVerificationCode" showSuccMsg="false">
                <soul:button target="sendPhoneCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function"
                             cssClass="btn-gray btn btn-code">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button>
                <span tipsName="phoneVerificationCode-tips"></span>
            </div>
        </div>
        <p class="popgray">
            <c:set value="<%=SiteCustomerServiceHelper.getPCCustomerServiceUrl()%>" var="url"></c:set>
                ${views.personInfo_auto['如原手机无法验证，请联系客服验证身份后直接帮您修改']}<a href="${url}" title="" class="orange" target="_blank">${views.personInfo_auto['联系客服']}</a>
        </p>
    </div>
    <div class="modal-footer">
<%--
        <soul:button precall="validateForm" target="updatePhoneNext" text="${views.common['next']}" opType="function"
                     cssClass="btn-outline btn-filter btn-gray btn btn-code">${views.common['next']}</soul:button>
--%>

        <soul:button precall="validateForm" target="${root}/personInfo/updatePhone.html" text="${views.personInfo_auto['手机绑定']}" opType="ajax"
                     cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.personInfo_auto['手机绑定']}</soul:button>
    </div>
</form:form>

</body>
<%@ include file="/include/include.js.jsp" %>
<!--//region your codes 4-->
<soul:import res="site/personInfo/BindPhone"/>
<!--//endregion your codes 4-->
</html>
<!--//endregion your codes １-->
