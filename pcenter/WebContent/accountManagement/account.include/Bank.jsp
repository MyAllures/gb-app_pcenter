<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="bankInfo" name="addBankForm">
    <div id="validateRule" style="display: none">${playerBankcardRule}</div>
    <input type="hidden" value="${userBankcard.id}" name="bankId">
    <input type="hidden" value="${token}" name="token"/>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><i class="mark ${not empty userBankcard?'success':'plaint'}"></i>${views.account['AccountSetting.setting.bank.cardInfo']}</td>
            <td class="gray">
                <c:choose>
                    <c:when test="${not empty userBankcard}">
                        ${soulFn:formatBankCard(soulFn:overlayString(userBankcard.bankcardNumber))}
                        <c:if test="${not empty userBankcard.bankName}">
                            <i class="pay-bank ${userBankcard.bankName} m-l"></i>
                        </c:if>
                    </c:when>
                    <c:otherwise>
                        ${views.account['AccountSetting.setting.bank.message4']}
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
            <td colspan="3" id="updateBankInfo" data-realName="${not empty sysUserVo.result.realName}">
                <%--<input type="hidden" name="emptyPwd" value="true" >--%>
                <div class="accout-retract">
                    <c:choose>
                        <c:when test="${not empty userBankcard}">
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.bank.cardNo']}：</label>
                                <div class="controls">
                                    ${soulFn:formatBankCard(soulFn:overlayString(userBankcard.bankcardNumber))}
                                    <c:if test="${not empty userBankcard.bankName}">
                                        <i class="pay-bank ${userBankcard.bankName} m-l"></i>
                                    </c:if>
                                </div>
                            </div>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.bank.cardAddress']}：</label>
                                <div class="controls">
                                    ${soulFn:overlayString(userBankcard.bankDeposit)}
                                </div>
                            </div>
                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls">
                                    <soul:button target="updateBankInfo" text="${views.account['AccountSetting.setting.bank.updateBank']}" opType="function"
                                                 cssClass="btn btn-filter btn-lg real-time-btn">
                                        <span class="hd">${views.account['AccountSetting.setting.bank.updateBank']}</span>
                                    </soul:button>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.personal.realName']}：</label>
                                <div class="controls realName">
                                    <c:choose>
                                        <c:when test="${not empty sysUserVo.result.realName}">
                                            <input type="text" readonly="readonly" class="input bn" placeholder="" value="${soulFn:overlayName(sysUserVo.result.realName)}" name="bankcardMasterName">
                                        </c:when>
                                        <c:otherwise>
                                            <soul:button target="${root}/accountSettings/toSettingRealName.html" text="${views.account['AccountSetting.setting.bank.message1']}" opType="dialog">${views.account['AccountSetting.setting.bank.message1']}</soul:button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="control-grouptwo clearfix ud-select" style="margin-top: 2px;">
                                <label class="control-left">${views.account['AccountSetting.setting.bank.bankName']}：</label>
                                <div>
                                    <div class="bank-deposit" style="margin-left: 0;">
                                        <div class="bank-total">
                                            <c:forEach items="${bankListVo.result}" var="bank" varStatus="vs" end="14">
                                                <c:if test="${vs.index==0}">
                                                </c:if>
                                                <label class="bank ${vs.index==0?' select':''}" bankcode="${bank.bankName}">
                                                    <span class="radio">
                                                        <input name="bankName" type="radio" value="${bank.bankName}" ${vs.index==0?'checked':''} class="ignore"/>
                                                    </span>
                                                    <span class="radio-bank" title="${dicts.common.bankname[bank.bankName]}">
                                                        <i class="pay-bank ${bank.bankName}"></i>
                                                    </span>
                                                    <span class="bank-logo-name">${dicts.common.bankname[bank.bankName]}</span>
                                                </label>
                                            </c:forEach>
                                        </div>

                                        <div name="hideBank" style="display: none;">
                                            <c:forEach items="${bankListVo.result}" var="bank" varStatus="vs" begin="15">
                                                <label class="bank ${vs.index==0?' select':''}" bankcode="${bank.bankName}">
                                                    <span class="radio">
                                                        <input name="bankName" type="radio" value="${bank.bankName}" ${vs.index==0?'checked':''} class="ignore"/>
                                                    </span>
                                                    <span class="radio-bank" title="${dicts.common.bankname[bank.bankName]}">
                                                        <i class="pay-bank ${bank.bankName}"></i>
                                                    </span>
                                                    <span class="bank-logo-name">${dicts.common.bankname[bank.bankName]}</span>
                                                </label>
                                            </c:forEach>
                                        </div>
                                        <div class="clear"></div>
                                    </div>
                                    <c:if test="${fn:length(bankListVo.result)>15}">
                                        <div class="bank-spreadout set" style="margin-top: -10px; margin-right: 75px;">
                                            <span name="extendBank">
                                                <soul:button target="showMoreBank" text="${views.fund['Deposit.deposit.expendBank']}" opType="function"/>
                                                <i class="bank-arrico down"></i>
                                            </span>
                                            <span style="display: none" name="collapseBank">
                                                <soul:button target="showMoreBank" text="${views.fund['Deposit.deposit.shrinkBank']}" opType="function"/>
                                                <i class="bank-arrico up"></i>
                                            </span>
                                        </div>
                                    </c:if>
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.bank.cardNo']}：</label>
                                <div class="controls">
                                    <input type="text" placeholder="" class="input bn" name="bankcardNumber2" tipsName="bankcardNumber-tips" ${empty sysUserVo.result.realName?'disabled':''}>
                                    <input type="hidden" name="bankcardNumber">
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.bank.cardAddress']}：</label>
                                <div class="controls">
                                    <input type="text" placeholder="" class="input bn" name="bankDeposit" showSuccMsg="false" ${empty sysUserVo.result.realName?'disabled':''}>
                                </div>
                                <p class="tipsgray">${views.account['AccountSetting.setting.bank.bankNameAddress']}</p>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls opeBtn">
                                    <soul:button target="clearBankInput" text="${views.account['AccountSetting.reset']}" opType="function" cssClass="btn-gray btn btn-big"/>
                                    <soul:button precall="validateForm" target="${root}/accountSettings/updateBank.html" text="${views.common['ok']}" opType="ajax" cssClass="btn-gray btn btn-big ${empty sysUserVo.result.realName ?'ui-button-disable disable-gray':''}" dataType="json" post="getCurrentFormData" callback="mySaveCallBack">${views.common['ok']}</soul:button>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </td>
        </tr>
    </table>
</form:form>
<!--//endregion your codes １-->
