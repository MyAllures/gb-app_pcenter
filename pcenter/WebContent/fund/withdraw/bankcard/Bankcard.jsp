<%--@elvariable id="bankcard" type="so.wwb.gamebox.model.master.player.po.UserBankcard"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<h3>${views.fund_auto['绑定取款银行卡']}</h3>
<h4 class="gray" style="font-weight: normal; padding-top: 10px">${views.fund_auto['绑定银行卡提醒']}</h4>
<div class="m-t-sm line-hi32">
    <div id="validateRule" style="display: none">${validate}</div>
    <div class="control-grouptwo">
        <label class="control-left">${views.fund_auto['真实姓名']}：</label>
        <div class="controls">
            <c:choose>
                <c:when test="${not empty user.realName}">
                    <span>${soulFn:overlayName(user.realName)}</span>
                    <input type="hidden" name="result.bankcardMasterName" value="${user.realName}"/>
                </c:when>
                <c:otherwise>
                    <input type="text" name="result.bankcardMasterName" maxlength="30" class="input bn"/>
                </c:otherwise>
            </c:choose>
        </div>
        <p class="tipsgray">${views.fund_auto['银行卡户名与真实姓名一致才能取款成功']}</p>
    </div>

    <div class="control-grouptwo clearfix ud-select" style="margin-top: 0;">
        <label class="control-left">${views.fund_auto['银行']}：</label>

        <div class="bank-deposit" style="margin-bottom: 0">
            <div class="bank-total">
                <c:forEach items="${bankListVo.result}" var="bank" varStatus="vs" end="14">
                    <label class="bank ${bankcard.bankName eq bank.bankName ? 'select' : ''}" bankcode="${bank.bankName}">
                                <span class="radio">
                                    <input name="result.bankName" showSuccMsg="false" type="radio" value="${bank.bankName}" ${bankcard.bankName eq bank.bankName ? 'checked': ''}/>
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
                    <label class="bank ${bankcard.bankName eq bank.bankName ? 'select':''}" bankcode="${bank.bankName}">
                                <span class="radio">
                                    <input name="result.bankName" showSuccMsg="false" type="radio" value="${bank.bankName}" ${bankcard.bankName eq bank.bankName ? 'checked':''} />
                                </span>
                                <span class="radio-bank" title="${dicts.common.bankname[bank.bankName]}">
                                    <i class="pay-bank ${bank.bankName}"></i>
                                </span>
                        <span class="bank-logo-name">${dicts.common.bankname[bank.bankName]}</span>
                    </label>
                </c:forEach>
            </div>
            <div class="clear"></div>
            <div class="bank-total" name="bankNameMsg" style="display: none">
                <div class="title">
                </div>
            </div>
        </div>
        <c:if test="${fn:length(bankListVo.result)>15}">
            <div class="bank-spreadout set" style="margin-right: 108px; margin-bottom: 0;">
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

    <div class="control-grouptwo">
        <label class="control-left">${views.fund_auto['银行卡号']}：</label>
        <div class="controls">
            <input type="text" class="input bn ignore" placeholder="" maxlength="24" name="bankcardNumber2" tipsName="result.bankcardNumber-tips" autocomplete="off">
            <input type="hidden" class="input" name="result.bankcardNumber"/>
        </div>
    </div>

    <div class="control-grouptwo">
        <label class="control-left">${views.fund_auto['开户行']}：</label>
        <div class="controls">
            <input type="text" autocomplete="off" class="input bn result-bankDeposit" placeholder="${views.fund_auto['选择其它银行时必填']}" name="result.bankDeposit" value=""/>
        </div>
        <p class="tipsgray">${views.fund_auto['如']}</p>
    </div>

    <div class="control-grouptwo">
        <label class="control-label" style="width:132px;"></label>
        <div class="controls" id="submitInfo">
            <soul:button target="resetBankCard" text="${views.fund_auto['重置']}" opType="function" cssClass="btn btn-gray middle-big "/>
            <soul:button precall="validateForm" target="${root}/fund/userBankcard/submitBankCard.html" text="${views.fund_auto['确认']}" opType="ajax" callback="saveBankcardCallback" dataType="json" post="getCurrentFormData"  cssClass="btn btn-blue middle-big btn-bank"/>
        </div>
    </div>
</div>