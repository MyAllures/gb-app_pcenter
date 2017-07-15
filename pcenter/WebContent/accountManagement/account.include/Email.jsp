<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="email">
    <div id="validateRule" style="display: none">${playerEmailRule}</div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><i class="mark ${not empty noticeContactWay && noticeContactWay.status eq '11'?'success':'plaint'}"></i>
                ${regSettingMailVerifcation ?views.account['AccountSetting.setting.email.binEmail']:'邮箱'}
            </td>
            <td class="gray">
                <c:choose>
                    <c:when test="${not empty noticeContactWay}">
                        <span class="orange">${soulFn:overlayEmaill(noticeContactWay.contactValue)}</span>
                        <c:choose>
                            <c:when test="${regSettingMailVerifcation}">
                                <c:choose>
                                    <c:when test="${noticeContactWay.status eq '12'}"><%--此邮箱可用于接收通知，绑定后将用于找回密码\!暂未绑定--%>
                                        ${views.account['AccountSetting.setting.email.message5']}
                                    </c:when>
                                    <c:otherwise>
                                        ${views.account['AccountSetting.setting.email.message']}<%--此邮箱可用于接收通知、找回密码--%>
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                ${views.account['AccountSetting.setting.email.message1']}<%--此邮箱可用于接收通知--%>
                            </c:otherwise>
                        </c:choose>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${regSettingMailVerifcation}">
                                ${views.account['AccountSetting.setting.email.message2']}<%--您还未绑定邮箱，绑定后可直接用于接收通知、找回密码--%>
                            </c:when>
                            <c:otherwise>
                                ${views.account['AccountSetting.setting.email.message3']}<%--您还未填写邮箱，填写后可用于接收通知--%>
                            </c:otherwise>
                        </c:choose>
                    </c:otherwise>
                </c:choose>
            </td>
            <td width="14%">
                <soul:button target="SetAndHide" text="" opType="function" cssClass="btn btn-blue btn-small classtitle" tag="button">
                    <span class="set">${views.account['AccountSetting.set']}</span>
                    <span class="shrink">${views.account['AccountSetting.shrink']}</span>
                </soul:button>
            </td>
        </tr>

        <tr class="bottomline" style="display:none;">
            <td colspan="3" id="toUpdateEmail">
                <c:choose>
                    <c:when test="${!regSettingMailVerifcation || noticeContactWay.status eq '22'}"><%-- && noticeContactWay.status eq '11'--%>
                        <div class="accout-retract" id="modifyemail">
                            <div class="spaces modifypassword">
                                <c:choose>
                                    <c:when test="${regSettingMailVerifcation && noticeContactWay.status ne '22'}">
                                        ${views.account['AccountSetting.setting.email.bindEmail2']}<span class="orange bold">${soulFn:overlayEmaill(noticeContactWay.contactValue)}</span>，${views.account['AccountSetting.setting.email.message']}
                                    </c:when>
                                    <c:otherwise>
                                        ${views.accountManagement_auto['您的邮箱是']}<span class="orange bold">${soulFn:overlayEmaill(noticeContactWay.contactValue)}</span>，${views.account['AccountSetting.setting.email.message1']}
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="controls spaces">
                                <input type="hidden" value="${noticeContactWay.status}" name="isClear">
                                <soul:button target="changeEmailPage" text="${views.account['AccountSetting.setting.email.changeEmail']}" opType="function" cssClass="btn-gray btn btn-big">${views.account['AccountSetting.setting.email.changeEmail']}</soul:button>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="accout-retract">
                            <c:choose>
                                <c:when test="${regSettingMailVerifcation}">
                                    <h2>
                                        <c:choose>
                                            <c:when test="${noticeContactWay.status eq '12'}">
                                                ${soulFn:overlayEmaill(noticeContactWay.contactValue)}${views.account['AccountSetting.setting.email.message5']}
                                            </c:when>
                                            <c:otherwise>
                                                ${views.account['AccountSetting.setting.email.message2']}
                                            </c:otherwise>
                                        </c:choose>
                                    </h2>
                                </c:when>
                                <c:otherwise>
                                    <h2>${views.account['AccountSetting.setting.email.message3']}</h2>
                                </c:otherwise>
                            </c:choose>

                            <div class="control-grouptwo clearfix">
                                <label class="control-left">${views.account['AccountSetting.setting.email.email']}：</label>
                                <div class="controls down-menu-option">
                                    <span class="pull-down-a" tipsName="email.contactValue-tips">
                                        <input type="text" placeholder="" class="input inputMailList bn" name="email.contactValue" id="emailCode" autocomplete="off">
                                        <input type="hidden" class="input" name="email.id" value="${noticeContactWay.id}">
                                    </span>
                                </div>
                            </div>

                            <div class="control-grouptwo sendmCode">
                                <label class="control-left">${views.account['AccountSetting.setting.email.captcha']}：</label>
                                <div class="controls">
                                    <c:choose>
                                        <c:when test="${regSettingMailVerifcation}">
                                            <input type="text" class="input-code" name="verificationCode" id="verificationCode" showSuccMsg="false">
                                            <input type="hidden" value="true" name="flag">
                                            <soul:button target="sendmCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function" cssClass="btn-gray btn btn-code">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button><span tipsName="verificationCode-tips"></span>
                                        </c:when>
                                        <c:otherwise>
                                            <input type="text" class="input-code" style="width:120px;" name="ecode">
                                            <img src="${root}/captcha/emailCode.html" reloadable tipsName="ecode-tips"/>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls">
                                    <c:set value="${regSettingMailVerifcation ?views.account['AccountSetting.setting.email.binEmail']:'确认'}" var="btnText"></c:set>
                                    <soul:button precall="validateForm" target="${root}/accountSettings/updateEmail.html" text="${btnText}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${btnText}</soul:button>
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
