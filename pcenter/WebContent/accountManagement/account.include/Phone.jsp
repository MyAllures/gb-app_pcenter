<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="phone">
    <div id="validateRule" style="display: none">${playerPhoneRule}</div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><i class="mark ${not empty noticeContactWay2 && noticeContactWay2.status eq '11'?'success':'plaint'}"></i>
                ${regSettingMailVerifcation ?views.account['AccountSetting.setting.phone.bindPhone']:views.accountManagement_auto['手机号']}
            </td>
            <td class="gray">
                <c:choose>
                    <c:when test="${not empty noticeContactWay2}">
                        <span class="orange">${soulFn:overlayString(noticeContactWay2.contactValue)}</span>
                            <%--${views.account['AccountSetting.setting.phone.message']}--%> <%--此号码可用于接收通知--%>
                            <c:choose>
                                <c:when test="${regSettingMailVerifcation}">
                                    <c:choose>
                                        <c:when test="${noticeContactWay.status eq '12'}">
                                            ${views.accountManagement_auto['绑定提醒1']}
                                        </c:when>
                                        <c:otherwise>
                                            ${views.accountManagement_auto['绑定提醒2']}
                                        </c:otherwise>
                                    </c:choose>
                                </c:when>
                                <c:otherwise>
                                    ${views.accountManagement_auto['此号码可用于接收通知']}
                                </c:otherwise>
                            </c:choose>
                    </c:when>
                    <c:otherwise>
                        ${views.account['AccountSetting.setting.phone.message1']}<%--您还未填写手机号，填写后可直接用于接收通知--%>
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
            <td colspan="3" id="toUpdatePhone">
                <c:choose>
                    <c:when test="${not empty noticeContactWay2}">
                        <div class="accout-retract">
                            <div class="spaces modifypassword">
                                <c:choose>
                                    <c:when test="${regSettingMailVerifcation && noticeContactWay.status ne '22'}">
                                        ${views.account['AccountSetting.setting.phone.bindPhone2']}<%--已绑定手机号--%>
                                    </c:when>
                                    <c:otherwise>
                                        ${views.accountManagement_auto['您的手机号是']}
                                    </c:otherwise>
                                </c:choose>

                                <span class="orange bold">${soulFn:overlayString(noticeContactWay2.contactValue)}</span>，${views.account['AccountSetting.setting.phone.message']}</div>
                            <div class="controls spaces">
                                <c:choose>
                                    <c:when test="${noticeContactWay2.status eq '22'}">
                                        <soul:button target="clearPhone" text="${views.account['AccountSetting.setting.phone.changePhone']}" opType="function" cssClass="btn-gray btn btn-big">${views.account['AccountSetting.setting.phone.changePhone']}</soul:button>
                                    </c:when>
                                    <c:otherwise>
                                        <input type="hidden" value="${noticeContactWay2.status}" name="isClear">
                                        <soul:button target="changePhone" text="${views.account['AccountSetting.setting.phone.changePhone']}" opType="function" cssClass="btn-gray btn btn-big">${views.account['AccountSetting.setting.phone.changePhone']}</soul:button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="accout-retract">
                            <h2>${views.account['AccountSetting.setting.phone.message1']}</h2>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.phone.phoneNumber']}：</label>
                                <div class="controls">
                                    <div class="country" tipsName="phone.contactValue-tips" style="width: auto">
                                        <div class="select-country guj-select" style="width: 110px;">
                                                <p class="select-arr" style="width: 110px;">
                                                     <span class="flag-phone">
                                                        <span id="region_${phoneCodeVo2.countryStandardCode.toLowerCase()}" class="bank-img-block"></span>
                                                        </span>${dicts.region.region[phoneCodeVo2.countryStandardCode]}<span>${phoneCodeVo2.phoneCode}</span>
                                                </p>
                                                <ul style="width: 110px;">
                                                    <c:forEach items="${phoneCodeList}" var="pc">
                                                        <li><a href="javascript:void(0)" rel="${pc.countryStandardCode.toLowerCase()}" data-code="${pc.phoneCode}">
                                                        <span class="flag-phone">
                                                            <span id="region_${pc.countryStandardCode.toLowerCase()}" class="bank-img-block"></span>
                                                        </span>${dicts.region.region[pc.countryStandardCode]}<span>${pc.phoneCode}</span></a></li>
                                                    </c:forEach>
                                                </ul>
                                        </div>
                                        <input type="hidden" value="${phoneCodeVo2.phoneCode}" name="phoneCode">
                                        <input type="text" class="countryinput" name="phone.contactValue">
                                    </div>
                                    <div class="clear"></div>
                                </div>
                            </div>
                            <div class="control-grouptwo sendmCode">
                                <label class="control-left">${views.account['AccountSetting.setting.email.captcha']}：</label>
                                <div class="controls">
                                <input type="text" placeholder="" class="input-code" style="width: 148px;" name="code">
                                <img src="${root}/captcha/phoneCode.html" reloadable tipsName="code-tips"/>
                                </div>
                            </div>
                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls">
                                    <soul:button precall="validateForm" target="${root}/accountSettings/updatePhone.html" text="${views.common['ok']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.common['ok']}</soul:button>
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