<%--@elvariable id="payAccountMap" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.content.vo.PayAccountListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--在线支付-->
<div class="modal-backdrop in" style="display: none" id="backdrop"></div>
<form name="onlineForm" id="onlineForm">
    <gb:token/>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <input type="hidden" name="result.rechargeRemark" value=""/>
    <input type="hidden" name="realNameDialog" value="${realNameDialog}">
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
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
                <h4>${views.fund_auto['选择您将使用的银行']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                            <c:set var="onlinePayMax" value="${i.value.singleDepositMax}"/>
                            <c:set var="onlinePayMin" value="${i.value.singleDepositMin}"/>
                            <c:set var="onlinePayMin" value="${empty onlinePayMin || onlinePayMin<=0?0.01:soulFn:formatCurrency(onlinePayMin)}"/>
                            <c:set var="onlinePayMax" value="${empty onlinePayMax?'99,999,999':soulFn:formatCurrency(onlinePayMax)}"/>
                            <c:set var="accountLimit" value="* 范围:${onlinePayMin} ~ ${onlinePayMax}"/>
                            <c:set var="account" value="${command.getSearchId(i.value.id)}"/>
                            <c:if test="${vs.index==0}">
                                <c:set var="firstAccountLimit" value="${accountLimit}"/>
                                <c:set var="firstPayAccount" value="${i.value}"/>
                                <c:set var="firstAccount" value="${account}"/>
                            </c:if>
                            <c:if test="${vs.index==16}"><div name="hideBank" style="display: none"></c:if>
                            <label class="bank ${vs.index==0?'select':''}">
                                <span class="radio"><input showSuccMsg="false" name="result.payerBank" payUrl="${i.value.payUrl}" amountLimit="${accountLimit}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" randomAmount="${i.value.randomAmount}" account="${account}" value="${i.key}" type="radio" ${vs.index==0?'checked':''}></span>
                                <span class="radio-bank" title="${dicts.common.bankname[i.key]}"><i class="pay-bank ${i.key}"></i></span>
                                <span class="bank-logo-name">${dicts.common.bankname[i.key]}</span>
                            </label>
                            <c:if test="${fn:length(payAccountMap)>16&&vs.index==(fn:length(payAccountMap)-1)}"></div></c:if>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
                <c:if test="${fn:length(payAccountMap)>16}">
                    <div class="bank-spreadout set">
                        <soul:button target="expendBank" text="" opType="function">
                            <span>${views.fund_auto['展开更多银行']}</span>  <i class="bank-arrico down"></i>
                        </soul:button>
                    </div>
                </c:if>
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
                        <input type="hidden" value="${firstAccount}" name="account"/>
                        <soul:button target="sumFailureCount" precall="validateForm" url="${root}/fund/recharge/online/onlineSubmit.html" backUrl="${root}/fund/recharge/online/onlinePay.html?realNameDialog=true" text="${views.fund_auto['立即存款']}" callback="back" opType="function" cssClass="btn-blue btn large-big disabled _submit"/>
                    </div>
                    <div class="applysale">
                        <ul class="transfer-tips">
                            <li>温馨提示：</li>
                            <li>单笔储值最低<span style="color:red">${siteCurrency}${onlinePayMin}</span>，最高为<span style="color:red">${siteCurrency}${onlinePayMax}</span>，并须视各家银行转款上限而定。</li>
                            <li>请保留好转账单据作为核对证明。</li>
                            <li>建议您使用Internet Explorer 9以上、360浏览器、Firefox或Google Chrome等浏览器浏览。</li>
                            <li>如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。
                                <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                            </li>
                        </ul>
                    </div>
                </form>
            </div>
        </div>
    </c:if>
    <%--失败多次后弹窗提醒--%>
    <div class="modal inmodal in" style="display: none" id="manyFailures" tabindex="-1" role="dialog">
        <div class="modal-dialog">
            <div class="modal-content animated bounceInRight family">
                <div class="modal-header">
                    <span class="filter"><h3 class="popalign">${views.fund_auto['提示']}</h3></span>
                </div>
                <div class="modal-body">
                    <div class="theme-popcon">
                        <h3 class="popalign"><i class="tipbig fail"></i></h3>
                        <div class="text">
                            <p>${views.fund_auto['失败多次提示信息']}</p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <input type="button" id="onlineContinueDeposit" url="${root}/fund/recharge/online/onlineSubmit.html" value="${views.fund_auto['仍要继续']}" class="btn btn-outline btn-filter"/>
                    <%--<soul:button target="onlineContinueDeposit" text="${views.fund_auto['仍要继续']}" cssClass="btn btn-outline btn-filter" opType="function"/>--%>
                    <input type="button" id="againDeposit" value="${views.fund_auto['重新存款']}" class="btn btn-filter" />
                   <%-- <% double num = Math.random();%>
                    <a href="${root}/#/fund/playerRecharge/recharge.html?t=<%=num%>" class="btn btn-filter">${views.fund_auto['重新存款']}</a>--%>
                </div>
            </div>
        </div>
    </div>
</form>
<soul:import res="site/fund/recharge/OnlinePay"/>