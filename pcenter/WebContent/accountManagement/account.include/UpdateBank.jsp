<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract">

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.personal.realName']}：</label>

        <div class="controls">
            <input type="text" readonly="readonly" class="input bn" placeholder=""
                   value="${soulFn:overlayName(sysUserVo.result.realName)}" name="bankcardMasterName">
        </div>
    </div>

    <div class="control-grouptwo clearfix ud-select">
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
            <input type="text" class="input bn" placeholder=""
                   value="${soulFn:formatBankCard(soulFn:overlayString(userBankcard.bankcardNumber))}" name="bankcardNumber2" tipsName="bankcardNumber-tips"/>
            <input type="hidden" name="bankcardNumber" value="${userBankcard.bankcardNumber}"/>
        </div>
        <p class="tipsgray msg2" style="display: none"><i class="mark plaintsmall"></i>${views.account['AccountSetting.setting.bank.message3']}</p>
    </div>

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.bank.cardAddress']}：</label>

        <div class="controls">
            <input type="text" placeholder="" class="input bn" name="bankDeposit" value="${userBankcard.bankDeposit}">
        </div>
        <p class="tipsgray">${views.account['AccountSetting.setting.bank.bankNameAddress']}</p>
    </div>
    <%--<div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.password.securityPwd']}：</label>

        <div class="controls">
            <input type="password" placeholder="" class="input" name="permissionPwd" maxlength="6">
        </div>
    </div>--%>

    <div class="control-grouptwo">
        <label class="control-label"></label>

        <div class="controls">
                <soul:button target="clearBankInput" text="${views.account['AccountSetting.reset']}" opType="function" cssClass="btn-gray btn btn-big"/>
            <soul:button precall="validateForm" target="${root}/accountSettings/updateBank.html" text="${views.common['ok']}" opType="ajax"
                         cssClass="btn-gray btn btn-big" dataType="json" post="getCurrentFormData"
                         callback="mySaveCallBack">${views.common['ok']}</soul:button>
        </div>
    </div>
</div>
<!--//endregion your codes １-->
