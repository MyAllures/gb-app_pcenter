<%--@elvariable id="payAccountMap" type="java.util.Map<java.lang.String,java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--柜员机/柜台存款-->
<form name="atmCounterForm">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <div class="notice">
        <div class="notice-left"> <em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['柜员机/柜台存款']}</h2></div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
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
                        <label class="bank select teller-b">
                            <span class="radio"><input name="result.rechargeType" value="atm_money" type="radio" checked></span>
                            <span class="radio-bank" title="${views.fund_auto['柜员机现金存款']}"><i class="pay-third bank-a" checked="checked"></i></span>
                            <span class="bank-logo-name">${views.fund_auto['柜员机现金存款']}</span>
                        </label>
                        <label class="bank teller-b">
                            <span class="radio"><input name="result.rechargeType" value="atm_recharge" type="radio"></span>
                            <span class="radio-bank" title="${views.fund_auto['柜员机转账']}"><i class="pay-third bank-b"></i></span>
                            <span class="bank-logo-name">${views.fund_auto['柜员机转账']}</span>
                        </label>
                        <label class="bank teller-b">
                            <span class="radio"><input name="result.rechargeType" value="atm_counter" type="radio"></span>
                            <span class="radio-bank" title="${views.fund_auto['银行柜台存款']}"><i class="pay-third bank-c"></i></span>
                            <span class="bank-logo-name">${views.fund_auto['银行柜台存款']}</span>
                        </label>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请选择银行']}</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                <div class="control-grouptwo">
                    <label class="control-left">${views.fund_auto['存入银行']}：</label>
                    <div class="controls">
                        <select name="result.payerBank" class="selectwidth" showSuccMsg="false">
                            <option value="">${views.common['choose']}</option>
                            <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                                <c:if test="${vs.index==0}">
                                    <c:set var="payAccountId" value="${i.value.get(0).id}"/>
                                </c:if>
                                <c:set var="isOther" value="${i.value.get(0).bankCode=='other_bank'}"/>
                                <option value="${i.key}" ${vs.index==0?'selected':''}>${isOther?i.value.get(0).customBankName:dicts.common.bankname[i.key]}</option>
                            </c:forEach>
                        </select>
                        <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                            <select id="accountMap${i.key}" class="selectwidth tail-number" style="${vs.index==0&&fn:length(i.value)>1?'':'display: none'}">
                                <c:forEach items="${i.value}" var="j" varStatus="in">
                                    <c:set var="len" value="${fn:length(j.account)}"/>
                                    <option value="${j.id}" ${in.index==0?'selected':''}>${fn:substring(j.account, len-4, len)}</option>
                                </c:forEach>
                            </select>
                        </c:forEach>
                        <span name="payAccountIdMsg" style="display: none"></span>
                        <input name="result.payAccountId" value="${payAccountId}" showSuccMsg="false" type="hidden"/>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">${views.fund_auto['存款金额']}：</label>
                    <div class="controls">
                        <input type="text" class="input" name="result.rechargeAmount" autocomplete="off">
                        <span class="fee"></span>
                    </div>
                </div>
                <%@include file="sale.jsp"%>
                <%@include file="CaptchaCode.jsp"%>
                <div class=" control-group">
                    <label class="control-label"></label>
                    <soul:button target="submit" precall="validateForm" text="${views.fund_auto['确定存款']}" opType="function" tag="button" cssClass="btn-blue btn large-big disabled _submit"/>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <span class="deposit-info-title">${views.fund_auto['注意事项']}<img src="${resRoot}/images/online-pay3.png"></span>
                <c:set var="onlinePayMin" value="${empty rank.onlinePayMin || rank.onlinePayMin == '0'?'0.01':soulFn:formatCurrency(rank.onlinePayMin)}"/>
                <c:set var="onlinePayMax" value="${empty rank.onlinePayMax?'99,999,999.00':soulFn:formatCurrency(rank.onlinePayMax)}"/>
                <input type="hidden" name="onlinePayMin" value="${onlinePayMin}"/>
                <input type="hidden" name="onlinePayMax" value="${onlinePayMax}"/>
                <ul class="attention-list">
                    <li>${fn:replace(fn:replace(fn:replace(views.fund_auto['单笔存储限额范围'], "{0}",siteCurrency ), "{1}", onlinePayMin),"{2}" , onlinePayMax)}
                    </li>
                    <li>${views.fund_auto['2、请使用同行存款，加速您的入款速度。']}</li>
                </ul>
            </div>
        </div>
    </c:if>
</form>
<soul:import res="site/fund/recharge/AtmCounterFirst"/>