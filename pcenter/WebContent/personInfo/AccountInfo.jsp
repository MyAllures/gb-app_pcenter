<%@ page import="so.wwb.gamebox.model.master.player.enums.UserBankcardTypeEnum" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="rgeechar">
    <div class="title">
        <c:set value="${(empty noticeContactWayMap['110'].contactValue && noticeContactWayMap['110'].status ne 22) ||
                        (empty noticeContactWayMap['201'].contactValue && noticeContactWayMap['201'].status ne 22) ||
                        empty sysUserProtectionVo.result.question1 ||
                        empty sysUserProtectionVo.result.answer1 ||
                        empty sysUserVo.result.realName ||
                        empty sysUserVo.result.defaultLocale ||
                        empty sysUserVo.result.sex ||
                        empty sysUserVo.result.birthday ||
                        (empty noticeContactWayMap['304'].contactValue && noticeContactWayMap['304'].status ne 22) ||
                        (empty noticeContactWayMap['301'].contactValue && noticeContactWayMap['301'].status ne 22) }" var="showTips"></c:set>
        <c:choose>
            <c:when test="${showTips}">
                <span class="tips"><i class="mark plaintsmall"></i>${views.personInfo_auto['完善个人资料能提升账户安全，设置后只能联系客服修改，请谨慎填写!']}<a href="${customerServiceUrl}" target="_blank">${views.personInfo_auto['联系客服']}</a></span>
            </c:when>
            <c:otherwise>
                <span class="tips"><i class="mark plaintsmall"></i>${views.personInfo_auto['为最大程度保护您账户安全，您只能通过联系客服修改资料!']}<a href="${customerServiceUrl}" target="_blank">${views.personInfo_auto['联系客服']}</a></span>
            </c:otherwise>
        </c:choose>

    </div>
</div>

<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <span class="account-info-title">${views.personInfo_auto['账户安全']}<img src="${resRoot}/images/safety-b.png"></span>

        <c:if test="${not empty regFieldSortsMap['110']}">
            <c:choose>
                <c:when test="${empty noticeContactWayMap['110'].contactValue && noticeContactWayMap['110'].status ne 22}">
                    <div class="control-grouptwo clearfix">
                        <label class="control-left">${views.personInfo_auto['手机号码']}：</label>
                        <div class="controls">
                            <div class="country phone" tipsName="phone.contactValue-tips">
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
                                <input type="hidden" value="${noticeContactWayMap['110'].id}" name="phone.id">
                                <input type="text" class="countryinput field-input" name="phone.contactValue">
                            </div>
                        </div>
                    </div>
                    <c:if test="${regSettingPhoneVerifcation}">
                        <div class="control-grouptwo">
                            <label class="control-left">${views.personInfo_auto['手机验证码']}：</label>
                            <div class="controls">
                                <input type="text" class="input-code" name="phoneVerificationCode" id="phoneVerificationCode" showSuccMsg="false">
                                <input type="hidden" value="phone" name="phoneFlag">
                                <soul:button target="sendPhoneCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function" cssClass="btn btn-outline btn-filter">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button><span tipsName="phoneVerificationCode-tips"></span></span>
                            </div>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <div class="control-grouptwo clearfix">
                        <label class="control-left">${views.personInfo_auto['手机号码']}：</label>
                        <div class="controls">
                            <c:if test="${noticeContactWayMap['110'].status eq 12}">
                                <c:choose>
                                    <c:when test="${regSettingPhoneVerifcation}">
                                        <em class="orange">${soulFn:overlayTel(noticeContactWayMap['110'].contactValue)}</em>${views.personInfo_auto['此号码可用于接收通知、绑定后可用于找回密码']}
                                        <soul:button target="${root}/personInfo/toBindPhone.html" text="${views.personInfo_auto['绑定手机号']}" opType="dialog" cssClass="btn btn-outline btn-filter"/>
                                    </c:when>
                                    <c:otherwise>
                                        <em class="orange">${soulFn:overlayTel(noticeContactWayMap['110'].contactValue)}</em>${views.personInfo_auto['此号码可用于接收通知']}
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${noticeContactWayMap['110'].status eq 22}">
                                ${views.personInfo_auto['已被设为最高级别隐私，不予显示！']}
                            </c:if>
                            <c:if test="${noticeContactWayMap['110'].status eq 11}">
                                <em class="orange">${soulFn:overlayTel(noticeContactWayMap['110'].contactValue)}</em>${views.personInfo_auto['此号码可用于接收通知,找回密码']}
                                <%--开通电销且玩家可以联系站长--%>
                                <c:if test="${playerCallMaster && openPhoneCall}">
                                    <soul:button target="callPlayer" text="联系站长" opType="function" playerId="${sysUser.id}"></soul:button>
                                </c:if>

                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>


        <c:if test="${not empty regFieldSortsMap['201']}">
            <c:choose>
                <c:when test="${empty noticeContactWayMap['201'].contactValue && noticeContactWayMap['201'].status ne 22}">
                    <div class="control-grouptwo clearfix">
                        <label class="control-left">${views.personInfo_auto['邮箱']}：</label>
                        <div class="controls">
                            <span class="sop-down">
                                <input type="text" class="input inputMailList field-input" name="email.contactValue" id="emailCode" autocomplete="off">
                                <input type="hidden" class="input" name="email.id" value="${noticeContactWayMap['201'].id}">
                            </span>
                        </div>
                    </div>
                    <c:if test="${regSettingMailVerifcation}">
                        <div class="control-grouptwo">
                            <label class="control-left">${views.personInfo_auto['邮箱验证码']}：</label>
                            <div class="controls">
                                <input type="text" class="input-code" name="verificationCode" id="verificationCode" showSuccMsg="false">
                                <input type="hidden" value="email" name="emailFlag">
                                <soul:button target="sendmCode" text="${views.account['AccountSetting.setting.email.freeCaptcha']}" opType="function" cssClass="btn-gray btn btn-code">${views.account['AccountSetting.setting.email.freeCaptcha']}</soul:button><span tipsName="verificationCode-tips"></span></span>
                            </div>
                        </div>
                    </c:if>
                </c:when>
                <c:otherwise>
                    <%--//如果状态等于12并且开启原则   此邮箱可用于接收通知、绑定后可用于找回密码
                        //如果状态等于12并且不开启验证  此邮箱可用于接收通知
                        //如果状态等于22              已被设为最高级别隐私，不予显示！
                        //如果状态等于11   此邮箱可用于接收通知,找回密码--%>
                    <div class="control-grouptwo clearfix">
                        <label class="control-left">${views.personInfo_auto['邮箱']}：</label>
                        <div class="controls">
                            <c:if test="${noticeContactWayMap['201'].status eq 12}">
                                <c:choose>
                                    <c:when test="${regSettingMailVerifcation}">
                                        <em class="orange">${soulFn:overlayEmaill(noticeContactWayMap['201'].contactValue)}</em>${views.personInfo_auto['此号码可用于接收通知、绑定后可用于找回密码']}
                                        <soul:button target="${root}/personInfo/toBindEmail.html" text="${views.personInfo_auto['绑定邮箱']}" opType="dialog" cssClass="btn btn-outline btn-filter"/>
                                    </c:when>
                                    <c:otherwise>
                                        <em class="orange">${soulFn:overlayEmaill(noticeContactWayMap['201'].contactValue)}</em>${views.personInfo_auto['此邮箱可用于接收通知']}
                                    </c:otherwise>
                                </c:choose>
                            </c:if>
                            <c:if test="${noticeContactWayMap['201'].status eq 22}">
                                ${views.personInfo_auto['已被设为最高级别隐私，不予显示！']}
                            </c:if>
                            <c:if test="${noticeContactWayMap['201'].status eq 11}">
                                <em class="orange">${soulFn:overlayEmaill(noticeContactWayMap['201'].contactValue)}</em>${views.personInfo_auto['此号码可用于接收通知,找回密码']}
                            </c:if>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </c:if>

        <c:choose>
            <c:when test="${empty sysUserProtectionVo.result.question1 && empty sysUserProtectionVo.result.answer1}">
                <div class="control-grouptwo">
                    <label class="control-left">${views.personInfo_auto['安全问题']}：</label>
                    <div class="controls">
                        <gb:selectPure name="sysUserProtection.question1"
                                       prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                       value="${sysUserProtectionVo.result.question1}"
                                       ajaxListPath="${root}/selectCommonController/getMasterQuestions.html" listKey="dictCode"
                                       listValue="remark"
                                       cssClass="selectwidth"/>
                    </div>
                </div>
                <div class="control-grouptwo">
                    <label class="control-left">${views.personInfo_auto['答案']}：</label>
                    <div class="controls">
                        <input type="text" class="input field-input" name="sysUserProtection.answer1">
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <div class="control-grouptwo">
                    <label class="control-left">${views.personInfo_auto['安全问题']}：</label>
                    <div class="controls">${views.personInfo_auto['已设置安全保护问题，安全问题是您找回密码的方式之一']}</div>
                        <%--<input type="hidden" name="sysUserProtection.question1" value="${sysUserProtectionVo.result.question1}">
                        <input type="hidden" name="sysUserProtection.answer1" value="${sysUserProtectionVo.result.answer1}">--%>
                </div>
            </c:otherwise>
        </c:choose>
        <c:set var="bankType" value="<%=UserBankcardTypeEnum.TYPE_BANK%>"/>
        <c:set var="btcType" value="<%=UserBankcardTypeEnum.TYPE_BTC%>"/>
        <c:set var="bank" value="${bankcardMap.get(bankType)}"/>
        <c:set var="btc" value="${bankcardMap.get(btcType)}"/>
        <c:if test="${!empty bank || !empty btc}">
            <div class="control-grouptwo">
                <label class="control-left">${views.personInfo_auto['当前使用']}：</label>
            </div>
            <c:forEach items="${bankcardMap}" var="i">
                <div class=" control-group">
                    <label class="control-label"></label>
                    <div class="controls">
                        <div class="hintbank" style="width: 410px">
                            <c:if test="${i.value.bankName=='bitcoin'}">
                                <i class="pay-third ${i.value.bankName}"></i>
                                ${i.value.bankcardNumber}
                            </c:if>
                            <c:if test="${i.value.bankName!='bitcoin'}">
                                <i class="pay-bank ${i.value.bankName}"></i>
                                ${i.value.bankcardNumber}
                                <span>${soulFn:overlayName(i.value.bankcardMasterName)}</span>
                            </c:if>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:if>
        <c:if test="${cashParam.paramValue=='true' && empty bank}">
            <div class=" control-group">
                <label class="control-label"></label>
                <div class="controls">${views.personInfo_auto['您当前尚未设置银行卡']}<a href="/personInfo/toUserBank.html" nav-target="mainFrame">${views.personInfo_auto['立即新增']}</a></div>
            </div>
        </c:if>
        <c:if test="${bitcoinParam.paramValue=='true' && empty btc}">
            <div class=" control-group">
                <label class="control-label"></label>
                <div class="controls">${views.personInfo_auto['您当前尚未设置比特币钱包']}<soul:button target="${root}/fund/userBankcard/btcDialog.html" title="${views.personInfo_auto['绑定比特币']}" callback="bankSaveCallBack" text="${views.personInfo_auto['立即新增']}" opType="dialog"/></div>
            </div>
        </c:if>
    </div>

    <hr>
    <%--个人信息--%>
    <div class="left-ico-message">
        <span class="account-info-title">${views.personInfo_auto['个人信息']}<img src="${resRoot}/images/info-b.png"></span>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.realName']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${empty sysUserVo.result.realName}">
                        <input type="text" class="input field-input" value="${sysUserVo.result.realName}" name="result.realName"
                               maxlength="30">
                            <span class="orange line-hi30"><i
                                    class="mark plaintsmall"></i>${views.account['AccountSetting.personal.message']}</span>
                        <%--<input type="hidden" id="realNameStatus" value="0" name="realNameStatus"/>--%>
                    </c:when>
                    <c:otherwise>
                        <span class="">${soulFn:overlayName(sysUserVo.result.realName)}</span>
                        <input type="hidden" name="result.realName" value="${sysUserVo.result.realName}"/>
                        <input type="hidden" name="realName" value="${sysUserVo.result.realName}">
                        <%--<input type="hidden" id="realNameStatus" value="1" name="realNameStatus"/>--%>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="control-group clearfix">
            <label class="control-label">${views.account['AccountSetting.personal.language']}：</label>
            <div class="controls">

                <c:choose>
                    <c:when test="${empty sysUserVo.result.defaultLocale}">
                    <span class="input-group pull-left">
                    <gb:selectPure name="result.defaultLocale"
                                   prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                   value="${sysUserVo.result.defaultLocale}"
                                   ajaxListPath="${root}/selectCommonController/getDefaultLocale.html" listKey="language"
                                   listValue="tran" cssClass="field-input"/>
                    </span>
                        <span class="orange line-hi30"><i class="mark plaintsmall"></i>${views.personInfo_auto['一旦设置，不可修改']}</span>
                    </c:when>
                    <c:otherwise>
                        <span class="">${dicts.common.local[sysUserVo.result.defaultLocale]}</span>
                        <input type="hidden" class="input" name="result.defaultLocale" value="${sysUserVo.result.defaultLocale}">
                    </c:otherwise>
                </c:choose>

            </div>
        </div>


        <%--<div class="control-group clearfix">
            <label class="control-label">${views.account['AccountSetting.personal.country']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${empty sysUserVo.result.country || empty sysUserVo.result.region}">
                        <span class="input-group pull-left">
                        <gb:selectPure name="result.country"
                                   prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                   value="${sysUserVo.result.country}"
                                   listValue="remark"
                                   listKey="dictCode"
                                   relSelect="result.region"
                                   ajaxListPath="${root}/regions/site.html" cssClass="field-input"/>
                        </span>
                        <span class="input-group pull-left">
                            <gb:selectPure name="result.region"
                                           prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                           value="${sysUserVo.result.region}"
                                           listValue="remark"
                                           listKey="dictCode"
                                           relSelect="result.city"
                                           relSelectPath="${root}/regions/states/#result.country#.html" cssClass="field-input"/>
                        </span>
                        <span class="input-group pull-left">
                            <gb:selectPure name="result.city"
                                           prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                           value="${sysUserVo.result.city}"
                                           listValue="remark" listKey="dictCode"
                                           relSelectPath="${root}/regions/cities/#result.country#-#result.region#.html" cssClass="field-input"/>
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="">${dicts.region.region[sysUserVo.result.country]}-${dicts.state[sysUserVo.result.country][sysUserVo.result.region]}
                        <c:if test="${not empty sysUserVo.result.city}">-${dicts.city[(sysUserVo.result.country).concat("_").concat(sysUserVo.result.region)][sysUserVo.result.city]}</c:if></span>
                        <input type="hidden" class="input" name="result.country" value="${sysUserVo.result.country}">
                        <input type="hidden" class="input" name="result.region" value="${sysUserVo.result.region}">
                        <input type="hidden" class="input" name="result.city" value="${sysUserVo.result.city}">
                    </c:otherwise>
                </c:choose>
            </div>
        </div>--%>

        <%--<div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.nickName']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${empty sysUserVo.result.nickname}">
                        <input type="text" class="input field-input" maxlength="15"
                               value="${sysUserVo.result.nickname}" name="result.nickname">
                    </c:when>
                    <c:otherwise>
                        <span class="">${sysUserVo.result.nickname}</span>
                        <input type="hidden" class="input" name="result.nickname" value="${sysUserVo.result.nickname}">
                    </c:otherwise>
                </c:choose>

            </div>
        </div>--%>
        <c:if test="${siteId!=119}">
        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.sex']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${empty sysUserVo.result.sex}">
                        <span class="radio"><input name="result.sex" value="male" class="field-input"
                                                   type="radio" ${sysUserVo.result.sex eq 'male'?'checked':''}></span>${views.account['AccountSetting.personal.sex.male']}
                    <span class="radio m-l"><input name="result.sex" value="female" class="field-input"
                                                   type="radio" ${sysUserVo.result.sex eq 'female'?'checked':''}></span>${views.account['AccountSetting.personal.sex.female']}
                    <span class="radio m-l"><input name="result.sex" value="secret" class="field-input"
                                                   type="radio" ${sysUserVo.result.sex eq 'secret'?'checked':''}></span>${views.account['AccountSetting.personal.sex.any']}
                    </c:when>
                    <c:otherwise>
                        <span class="">${dicts.common.sex[sysUserVo.result.sex]}</span>
                        <input type="hidden" name="result.sex" value="${sysUserVo.result.sex}"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.birthday']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${empty sysUserVo.result.birthday}">
                        <gb:dateRange format="${DateFormat.DAY}" style="width:100px;" inputStyle="width:80px"  id="birthday" showDropdowns="true"
                                      name="result.birthday" value="${sysUserVo.result.birthday}" maxDate="${dateQPicker.today}"
                                      callback="chooseConstellation"></gb:dateRange>
                    </c:when>
                    <c:otherwise>
                        <span class="">${soulFn:formatDateTz(sysUserVo.result.birthday,DateFormat.DAY,timeZone)}</span>
                        <input type="hidden" name="result.birthday" value="${soulFn:formatDateTz(sysUserVo.result.birthday,DateFormat.DAY,timeZone)}"/>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
        </c:if>
        <c:if test="${siteId==119}">
            <input type="hidden" name="result.birthday" value="${empty sysUserVo.result.birthday?null:soulFn:formatDateTz(sysUserVo.result.birthday,DateFormat.DAY,timeZone)}"/>
        </c:if>

        <%--<div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.constellation']}：</label>
            <div class="controls">
                    <c:choose>
                        <c:when test="${empty sysUserVo.result.constellation}">
                            <span class="input-group pull-left" id="constellation">
                                <gb:selectPure name="result.constellation"
                                               prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                               value="${sysUserVo.result.constellation}"
                                               ajaxListPath="${root}/selectCommonController/getConstellations.html" listKey="dictCode"
                                               listValue="remark" cssClass="field-input"/>
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="">${dicts.common.constellation[sysUserVo.result.constellation]}</span>
                            <input type="hidden" name="result.constellation" value="${sysUserVo.result.constellation}"/>
                        </c:otherwise>
                </c:choose>
            </div>
        </div>--%>
        <c:if test="${siteId!=185}">
            <c:if test="${not empty regFieldSortsMap['304']}">
                <div class="control-group">
                    <label class="control-label">${views.personInfo_auto['微信']}：</label>
                    <div class="controls">

                        <c:choose>
                            <c:when test="${noticeContactWayMap['304'].status eq '22'}">
                                ${views.personInfo_auto['已被设为最高级别隐私，不予显示！']}
                                <input type="hidden" name="weixin.contactValue"
                                       value="${noticeContactWays gt 0?noticeContactWayMap["304"].contactValue:''}">
                                <input type="hidden" value="${noticeContactWayMap["304"].id}" name="weixin.id">
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${empty noticeContactWayMap['304'].contactValue}">
                                        <input type="text" class="input field-input" name="weixin.contactValue"
                                               value="${noticeContactWays gt 0?noticeContactWayMap["304"].contactValue:''}"
                                               maxlength="30">
                                        <input type="hidden" value="${noticeContactWayMap["304"].id}" name="weixin.id">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="">${soulFn:overlayString(noticeContactWayMap["304"].contactValue)}</span>
                                        <input type="hidden" name="weixin.contactValue"
                                               value="${noticeContactWays gt 0?noticeContactWayMap["304"].contactValue:''}">
                                        <input type="hidden" value="${noticeContactWayMap["304"].id}" name="weixin.id">
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty regFieldSortsMap['301']}">
                <div class="control-group">
                    <label class="control-label">QQ：</label>
                    <div class="controls">
                        <c:choose>
                            <c:when test="${noticeContactWayMap['301'].status eq '22'}">
                                ${views.personInfo_auto['已被设为最高级别隐私，不予显示！']}
                                <input type="hidden" name="qq.contactValue"
                                       value="${noticeContactWays gt 0?noticeContactWayMap["301"].contactValue:''}">
                                <input type="hidden" value="${noticeContactWayMap["301"].id}" name="qq.id">
                            </c:when>
                            <c:otherwise>
                                <c:choose>
                                    <c:when test="${empty noticeContactWayMap['301'].contactValue}">
                                        <input type="text" class="input field-input" name="qq.contactValue"
                                               value="${noticeContactWays gt 0?noticeContactWayMap["301"].contactValue:''}"
                                               maxlength="30">
                                        <input type="hidden" value="${noticeContactWayMap["301"].id}" name="qq.id">
                                    </c:when>
                                    <c:otherwise>
                                        <span class="">${soulFn:overlayString(noticeContactWayMap["301"].contactValue)}</span>
                                        <input type="hidden" name="qq.contactValue"
                                               value="${noticeContactWays gt 0?noticeContactWayMap["301"].contactValue:''}">
                                        <input type="hidden" value="${noticeContactWayMap["301"].id}" name="qq.id">
                                    </c:otherwise>
                                </c:choose>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </c:if>
        </c:if>


        <c:if test="${showTips}">
            <div class="control-group" id="submitInfo" style="margin-left:255px;">
                <soul:button cssClass="btn-blue btn large-big" text="${views.account['AccountSetting.personal.msg']}"
                             opType="function" target="updatePerson" callback="mySaveCallBack" precall="validateForm">${views.personInfo_auto['提交']}</soul:button>
            </div>
        </c:if>

    </div>
</div>
<!--//endregion your codes １-->