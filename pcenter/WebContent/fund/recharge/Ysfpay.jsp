<%--@elvariable id="payAccountMap" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.content.vo.PayAccountListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--易收付支付-->
<form name="ysfForm">
    <gb:token/>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <%@include file="Channel.jsp"%>
    <c:if test="${fn:length(payAccountMap)<=0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${fn:length(payAccountMap)>0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['选择支付方式']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                            <c:set var="bankCode" value="${i.key}"/>
                            <c:set var="account" value="${i.value}"/>
                            <c:set var="onlinePayMax" value="${account.singleDepositMax}"/>
                            <c:set var="onlinePayMin" value="${account.singleDepositMin}"/>
                            <c:set var="onlinePayMin" value="${empty onlinePayMin || onlinePayMin<=0?0.01:soulFn:formatCurrency(onlinePayMin)}"/>
                            <c:set var="onlinePayMax" value="${empty onlinePayMax?'99,999,999':soulFn:formatCurrency(onlinePayMax)}"/>
                            <c:set var="accountLimit" value="* 范围:${onlinePayMin} ~ ${onlinePayMax}"/>
                            <c:set var="searchId" value="${command.getSearchId(account.id)}"/>
                            <c:if test="${vs.index==0}">
                                <c:set var="firstAccountLimit" value="${accountLimit}"/>
                                <c:set var="firstPayAccount" value="${account}"/>
                            </c:if>
                            <c:set var="name" value="${dicts.common.bankname[bankCode]}"/>
                            <label class="bank ${vs.index == 0?'select':''}">
                                <span class="radio"><input name="account" showSuccMsg="false" amountLimit="${accountLimit}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" type="radio" randomAmount="${account.randomAmount}" ${vs.index == 0?'checked':''} value="${searchId}"></span>
                                <span class="radio-bank" title="${name}">
                                    <i class="pay-third sm ${bankCode}"></i><font class="diy-pay-title">${name}</font>
                                </span>
                                <span class="bank-logo-name">${name}</span>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请填写存款金额']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                <form>
                    <div class="control-group">
                        <label class="control-label">${views.fund_auto['存款账号']}：</label>
                        <div class="controls">${username}</div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="result.rechargeAmount" autocomplete="off">${views.fund_auto['存款金额']}：</label>
                        <div class="controls">
                            <input type="text" class="input" name="rechargeAmount" placeholder="${firstAccountLimit}">
                            <input type="hidden" class="input" name="result.rechargeAmount" id="result.rechargeAmount">
                            <input type="hidden" class="input" name="result.rechargeType" value="easy_pay">
                            <input type="hidden" name="rechargeDecimals" value="${rechargeDecimals}"/>
                            <span class="right-decimals" style="${firstPayAccount.randomAmount?'':'display:none'}" id="rechargeDecimals">.${rechargeDecimals}</span>
                            <span tipsName="result.rechargeAmount-tips"></span>
                            <span class="fee"></span>
                        </div>
                    </div>
                    <%@include file="sale.jsp"%>
                    <%@include file="CaptchaCode.jsp"%>
                    <div class=" control-group">
                        <label class="control-label"></label>
                        <soul:button target="submit" precall="validateForm" text="${views.fund_auto['立即存款']}" callback="back" opType="function" cssClass="btn-blue btn large-big disabled _submit"/>
                    </div>
                    <div class="applysale">
                        <ul class="transfer-tips">
                            <li>请尽可能选择同行办理转账，可快速到账。</li>
                            <li>请保留好转账单据作为核对证明。</li>
                            <li>如充值后未到账，请联系在线客服。
                                <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                            </li>
                        </ul>
                    </div>
                </form>
            </div>
        </div>
    </c:if>

</form>
<soul:import res="site/fund/recharge/YsfPay"/>