<%--@elvariable id="accounts" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--柜员机/柜台存款-->
<form name="atmCounterForm">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <c:set var="onlinePayMax" value="${rank.onlinePayMax}"/>
    <c:set var="onlinePayMin" value="${rank.onlinePayMin}"/>
    <c:set var="onlinePayMin" value="${empty onlinePayMin || onlinePayMin<=0?0.01:soulFn:formatCurrency(onlinePayMin)}"/>
    <c:set var="onlinePayMax" value="${empty onlinePayMax?'99,999,999':soulFn:formatCurrency(onlinePayMax)}"/>
    <input type="hidden" name="onlinePayMin" value="${onlinePayMin}"/>
    <input type="hidden" name="onlinePayMax" value="${onlinePayMax}"/>
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <gb:token/>
    <div class="notice">
        <div class="notice-left"> <em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
   <%@include file="Channel.jsp"%>
    <c:if test="${fn:length(accounts)<=0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${fn:length(accounts)>0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['选择支付方式']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:if test="${!displayAccounts}">
                            <c:forEach items="${accounts}" var="i" varStatus="vs">
                                <label class="bank ${vs.index==0?'select':''}">
                                    <span class="radio"><input name="account" showSuccMsg="false" value="${payAccountVo.getSearchId(i.id)}" bankCode="${i.bankCode}" account="${i.account}" type="radio" ${vs.index==0?'checked':''}></span>
                                    <span class="radio-bank" title="${dicts.common.bankname[i.bankCode]}"><i class="pay-bank ${i.bankCode}"></i></span>
                                    <span class="bank-logo-name">${dicts.common.bankname[i.bankCode]}</span>
                                </label>
                            </c:forEach>
                        </c:if>
                        <c:if test="${displayAccounts}">
                            <c:forEach items="${accounts}" var="i" varStatus="vs">
                                <label class="bank ${vs.index==0?'select':''}">
                                    <span class="radio"><input name="account" type="radio" showSuccMsg="false" bankCode="${i.bankCode}" account="${i.account}" value="${payAccountVo.getSearchId(i.id)}" ${vs.index==0?'checked':''}/></span>
                                    <span class="radio-bank" title="${i.aliasName}"><i class="pay-bank sm ${i.bankCode}"></i><font class="diy-pay-title">${i.aliasName}</font></span>
                                    <span class="bank-logo-name">${i.aliasName}</span>
                                </label>
                            </c:forEach>
                        </c:if>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message clearfix">
                <h4>${views.fund_auto['请用存款至下方银行账户']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay1.png"></span>
                <c:forEach items="${accounts}" var="payAccount" varStatus="vs">
                    <div name="accountInfo${payAccount.bankCode}${payAccount.account}" class="bank-paidtotal accountInfo" style="${vs.index==0?'':'display:none'}">
                        <ul>
                            <li>
                                <div class="bankinfo linbankinfo-m">
                                    <h1>
                                        <c:set var="isOther" value="${payAccount.bankCode=='other_bank'}"/>
                                        <i class="${isOther?'':'pay-bank '} ${payAccount.bankCode}"></i>
                                        <c:if test="${!isOther}">
                                            <em class="cardlabel debit"></em>
                                        </c:if>
                                        <c:if test="${isOther}">
                                            <i style="font-size: small;">${payAccount.customBankName}</i>
                                        </c:if>
                                    </h1>
                                    <c:choose>
                                        <c:when test="${isHide}">
                                             <span class="orange select">
                                                <i class="orange fontsbig">${views.fund_auto['账号代码']}：${payAccount.code}</i>
                                                <i class="m-bigl">
                                                    <soul:button target="customerService" text="${(empty hideContent.value) ? views.fund_auto['联系客服获取账号'] : hideContent.value}" url="${customerService}" opType="function"/>
                                                </i>
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="orange cardnumber select" data-clipboard-target="bankCard${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                                <em class="bank-number" id="bankCard${payAccount.id}">${soulFn:formatBankCard(payAccount.account)}</em>
                                                <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                    <span class="paidname select" data-clipboard-target="fullName${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                        <em class="gray">${views.fund_auto['银行用户名']}：</em>
                                        <em class="gathering-name" id="fullName${payAccount.id}">${payAccount.fullName}</em>
                                        <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                    </span>
                                    <c:if test="${!empty payAccount.openAcountName}">
                                    <span class="paidname select" data-clipboard-target="openAcountName${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                        <em class="gray">${views.fund_auto['开户支行']}：</em>
                                        <em class="gathering-name" id="openAcountName${payAccount.id}">${payAccount.openAcountName}</em>
                                        <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                    </span>
                                    </c:if>
                                </div>
                            </li>
                        </ul>
                    </div>
                    <c:if test="${!empty payAccount.remark}">
                        <div name="accountInfo${payAccount.bankCode}${payAccount.account}" class="accountInfo" style="${vs.index==0?'':'display:none'}">
                            <pre style="margin: 20px;white-space: pre-wrap;word-wrap: break-word;">${payAccount.remark}</pre>
                        </div>
                    </c:if>
                </c:forEach>
                <ul class="attention-list">
                    <li>
                        <a href="javascript:;" class="openPage" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=9">${views.fund_auto['查看转账演示帮助']}？</a>
                    </li>
                </ul>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请选择银行']}</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay3.png"></span>
                <div class="control-group">
                    <label class="control-label">存款账号：</label>
                    <div class="controls">${userName}</div>
                </div>
                <div class="control-group">
                    <label class="control-label">存款方式：</label>
                    <div class="controls">
                        <label>
                            <span class="radio"><input name="result.rechargeType" showSuccMsg="false" value="atm_money" type="radio" checked>${views.fund_auto['柜员机现金存款']}</span>
                        </label>
                        <label>
                            <span class="radio"><input name="result.rechargeType" showSuccMsg="false" value="atm_recharge" type="radio">${views.fund_auto['柜员机转账']}</span>
                        </label>
                        <label>
                            <span class="radio"><input name="result.rechargeType" showSuccMsg="false" value="atm_counter" type="radio">${views.fund_auto['银行柜台存款']}</span>
                        </label>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">${views.fund_auto['存款金额']}：</label>
                    <div class="controls">
                        <input type="text" class="input" name="result.rechargeAmount" placeholder="* 范围:${onlinePayMin} ~ ${onlinePayMax}" autocomplete="off">
                        <span class="fee"></span>
                    </div>
                </div>
                <%@include file="sale.jsp"%>
                <%@include file="CaptchaCode.jsp"%>
                <div class=" control-group">
                    <label class="control-label"></label>
                    <soul:button target="submit" precall="validateForm" text="${views.fund_auto['确定存款']}" opType="function" tag="button" cssClass="btn-blue btn large-big disabled _submit"/>
                </div>
                <div class="applysale">
                    <ul class="transfer-tips \AMG">
                        <li>先查看要入款的银行信息，然后通过网上银行、	ATM、柜台或手机银行转账。转账成功后再如实提交转账信息，财务专员查收到信息后会及时添加您的款项。</li>
                        <li>请尽可能选择同行办理转账，可快速到账。</li>
                        <li>存款完成后，保留单据以利核对并确保您的权益。</li>
                        <li>
                            如充值后未到账，请联系在线客服，
                            <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <%@include file="CompanyRechargeDialog.jsp"%>
    </c:if>
</form>
<soul:import res="site/fund/recharge/AtmCounterFirst"/>