<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract" id="changePhone">
    <div id="validateRule" style="display: none">${playerPhoneRule}</div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.phone.oldPhone']}：</label>
        <div class="controls">
            <input type="text" class="input" style="width: 278px;" name="oldContactValue">
        </div>
    </div>

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.phone.newPhone']}：</label>
        <div class="controls">
            <div class="country" tipsName="phone.contactValue-tips" style="width: auto">
                <div class="select-country guj-select" style="width: 110px;">
                            <p class="select-arr" style="width: auto">
                            <span class="flag-phone">
                                <span id="region_${phoneCodeVo2.countryStandardCode.toLowerCase()}" class="bank-img-block"></span>
                            </span>${dicts.region.region[phoneCodeVo2.countryStandardCode]}<span>${phoneCodeVo2.phoneCode}</span>
                            </p>
                    <ul style="width: 110px;">
                        <c:forEach items="${phoneCodeList}" var="pc">
                            <li><a href="javascript:void(0)" rel="${pc.countryStandardCode.toLowerCase()}" data-code="${pc.phoneCode}">
                                <span class="flag-phone">
                                    <span id="region_${pc.countryStandardCode.toLowerCase()}" class="bank-img-block"></span>
                                </span>
                                ${dicts.region.region[pc.countryStandardCode]}<span>${pc.phoneCode}</span></a></li>
                        </c:forEach>
                    </ul>
                </div>
                <input type="hidden" placeholder="" value="${phoneCodeVo2.phoneCode}" name="phoneCode">
                <input type="hidden" class="input" name="phone.id" value="${noticeContactWay.id}">
                <input type="text"  class="countryinput" placeholder="" name="phone.contactValue">
            </div>
            <div class="clear"></div>
        </div>
    </div>

    <div class="control-grouptwo sendmCode">
        <label class="control-left">${views.account['AccountSetting.setting.email.captcha']}：</label>
        <div class="controls">
            <input type="text" id="input" placeholder=""  class="input-code" style="width: 148px;" name="code"/>
            <img src="${root}/captcha/phoneCode.html" reloadable tipsName="code-tips"/>
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-label"></label>
        <div class="controls">
            <soul:button precall="validateForm" target="${root}/accountSettings/updatePhone.html" text="${views.common['ok']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData"  callback="mySaveCallBack">${views.common['ok']}</soul:button>
        </div>
        <%--<div class="warm-tips"><p>如忘记原手机号码，请<a>${views.accountManagement_auto['联系客服']}</a>${views.accountManagement_auto['验证身份后直接帮您修改']}</p></div>--%>
    </div>
</div>

<!--//endregion your codes １-->
