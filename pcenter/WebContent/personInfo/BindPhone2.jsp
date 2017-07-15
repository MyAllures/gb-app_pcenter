<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div id="validateRule" style="display: none">${validateRule}</div>
<div class="modal-body">
    <div class="form-group clearfix line-hi34 m-b-xxs">
        <label class="col-xs-3 al-right">${views.personInfo_auto['手机号']}：</label>
        <div class="col-xs-8 p-x account-info-warp phone">
            <div class=" control-grouptwo clearfix">
                <div class="country phone" tipsName="phone.contactValue-tips" style="width: 248px;">
                    <div class="select-country guj-select">
                        <p class="select-arr">
                                         <span class="flag-phone">
                                            <span id="region_${phoneCodeVo2.countryStandardCode.toLowerCase()}" class="bank-img-block"></span>
                                            </span><%--${dicts.region.region[phoneCodeVo2.countryStandardCode]}--%><span>${phoneCodeVo2.phoneCode}</span>
                        </p>
                        <ul>
                            <c:forEach items="${phoneCodeList}" var="pc">
                                <li><a href="javascript:void(0)" rel="${pc.countryStandardCode.toLowerCase()}" data-code="${pc.phoneCode}">
                                                            <span class="flag-phone">
                                                                <span id="region_${pc.countryStandardCode.toLowerCase()}" class="bank-img-block"></span>
                                                            </span><%--${dicts.region.region[pc.countryStandardCode]}--%><span>${pc.phoneCode}</span></a></li>
                            </c:forEach>
                        </ul>
                    </div>
                    <input type="hidden" value="${phoneCodeVo2.phoneCode}" name="phoneCode">
                    <%--<input type="hidden" value="false" name="eflag">--%>
                    <input type="text" class="input bn" name="phone.contactValue" id="phoneCode" autocomplete="off" style="height: 32px;width: 184px;margin-top: -1px;">
                    <input type="hidden" class="input" name="phone.id" value="${noticeContactWay.id}">
                </div>
            </div>
        </div>
    </div>
    <div class="form-group clearfix line-hi34 m-b-xxs">
        <label class="col-xs-3 al-right">${views.personInfo_auto['验证码']}：</label>
        <div class="col-xs-8 p-x">
            <input type="text" class="input-code" name="phoneVerificationCode" id="phoneVerificationCode" showSuccMsg="false">
            <soul:button target="sendPhoneCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function"
                         cssClass="btn-gray btn btn-code">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button>
            <span tipsName="phoneVerificationCode-tips"></span>
        </div>
    </div>
</div>
<div class="modal-footer">
    <soul:button precall="validateForm" target="${root}/personInfo/updatePhone.html" text="${views.personInfo_auto['手机绑定']}" opType="ajax" cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.personInfo_auto['手机绑定']}</soul:button>
</div>
<!--//endregion your codes １-->
