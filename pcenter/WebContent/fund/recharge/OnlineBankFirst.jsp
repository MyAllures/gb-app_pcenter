<%--@elvariable id="payAccountMap" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="accounts" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--网银存款步奏1-->
<form>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="onlinePayMin" value="${soulFn:formatCurrency(rank.onlinePayMin)}"/>
    <input type="hidden" name="onlinePayMax" value="${soulFn:formatCurrency(rank.onlinePayMax)}"/>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <div class="notice">
        <div class="notice-left"> <em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left">
            <h2>${views.fund_auto['网银存款']}</h2>
        </div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <c:if test="${(fn:length(payAccountMap)<=0&&!displayAccounts)||(fn:length(accounts)<=0&&displayAccounts)}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${(fn:length(payAccountMap)>0&&!displayAccounts)||(fn:length(accounts)>0&&displayAccounts)}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请选择银行']}</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:if test="${!displayAccounts}">
                            <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                                <label class="bank ${vs.index==0?'select':''}">
                                    <span class="radio"><input name="result.payAccountId" value="${i.value.id}" type="radio" ${vs.index==0?'checked':''}></span>
                                    <span class="radio-bank" title="${dicts.common.bankname[i.key]}"><i class="pay-bank ${i.key}"></i></span>
                                    <span class="bank-logo-name">${dicts.common.bankname[i.key]}</span>
                                </label>
                            </c:forEach>
                        </c:if>
                        <c:if test="${displayAccounts}">
                            <c:forEach items="${accounts}" var="i" varStatus="vs">
                                <label class="bank ${vs.index==0?'select':''}">
                                    <span class="radio"><input name="result.payAccountId" value="${i.id}" type="radio" ${vs.index==0?'checked':''}></span>
                                    <span class="radio-bank" title="${dicts.common.bankname[i.bankCode]}"><i class="pay-bank ${i.bankCode}"></i></span>
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
            <div class="left-ico-message">
                <h4>请填写存款金额：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                <div class="control-group">
                    <label class="control-label" for="result.rechargeAmount">${views.fund_auto['存款金额']}：</label>
                    <div class="controls">
                        <input type="text" value="${playerRechargeVo.result.rechargeAmount}" class="input" name="result.rechargeAmount" id="result.rechargeAmount" autocomplete="off">
                        <span class="fee"></span>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="result.payerName">${views.fund_auto['存款人姓名']}：</label>
                    <div class="controls">
                        <input type="text" id="result.payerName" name="result.payerName" placeholder="${views.fund_auto['您转账时使用的银行卡姓名']}" class="input">
                    </div>
                </div>
                <%@include file="sale.jsp"%>
                <%@include file="CaptchaCode.jsp"%>
                <div class=" control-group">
                    <label class="control-label"></label>
                    <soul:button target="submit" precall="validateForm" text="${views.fund_auto['确定存款']}" opType="function" cssClass="btn-blue btn large-big disabled _submit"/>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <span class="deposit-info-title">${views.fund_auto['注意事项']}<img src="${resRoot}/images/online-pay3.png"></span>
                <ul class="attention-list">
                    <li>${fn:replace(fn:replace(fn:replace(views.fund_auto['单笔存储限额范围'], "{0}",siteCurrency ), "{1}", empty rank.onlinePayMin || rank.onlinePayMin == '0'?'0.01':soulFn:formatCurrency(rank.onlinePayMin)),"{2}" , empty rank.onlinePayMax?'99,999,999.00':soulFn:formatCurrency(rank.onlinePayMax))}</li>
                    <li>${views.fund_auto['2、请使用同行存款，加速您的入款速度。']}</li>
                </ul>
            </div>
        </div>
    </c:if>
</form>
<soul:import res="site/fund/recharge/OnlineBankFirst"/>