<%--@elvariable id="payAccountList" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--电子支付平台-->
<form>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['电子支付']}</h2></div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <c:if test="${fn:length(payAccountList)<=0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${fn:length(payAccountList)>0}">
        <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
        <input type="hidden" name="onlinePayMin" value="${soulFn:formatCurrency(rank.onlinePayMin)}"/>
        <input type="hidden" name="onlinePayMax" value="${soulFn:formatCurrency(rank.onlinePayMax)}"/>
        <input type="hidden" name="result.rechargeType" value="${payAccountList.get(0).rechargeType}"/>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请填写存款金额']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                            <label class="bank ${vs.index==0?'select':''}">
                                <c:set var="name" value="${display?i.aliasName:dicts.common.bankname[i.bankCode]}"/>
                                <c:if test="${i.bankCode eq 'other' && !display}">
                                    <c:set var="name" value="${i.customBankName}"/>
                                </c:if>
                                <span class="radio"><input name="result.payAccountId" data-title="${i.bankCode eq 'alipay'}" data-label="${i.bankCode eq 'onecodepay'}" data-type="${i.rechargeType}" value="${i.id}" type="radio" ${vs.index==0?'checked':''}></span>
                                <span class="radio-bank" title="${name}">
                                    <i class="pay-third ${display||i.bankCode eq 'other'?'sm ':''} ${i.bankCode}"></i>
                                    <c:if test="${display || i.bankCode eq 'other'}">
                                        <font class="diy-pay-title">${name}</font>
                                    </c:if>
                                </span>
                                <span class="bank-logo-name">${name}</span>
                                <c:choose>
                                    <c:when test="${i.bankCode eq 'wechatpay'}">
                                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${dicts.common.bank_nickname[i.bankCode]}："/>
                                    </c:when>
                                    <c:when test="${i.bankCode eq 'qqwallet'}">
                                        <c:set var="accountLabel" value="${views.fund_auto['您的']}QQ号码："/>
                                    </c:when>
                                    <c:when test="${i.bankCode eq 'onecodepay'}">
                                        <c:set var="accountLabel" value=""/>
                                    </c:when>
                                    <c:when test="${i.bankCode eq 'other'}">
                                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${i.customBankName}${views.fund_auto['账号']}："/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${dicts.common.bankname[i.bankCode]}${views.fund_auto['账号']}："/>
                                    </c:otherwise>
                                </c:choose>
                                <span name="accountLabel" style="display: none">
                                    ${accountLabel}
                                </span>
                                <c:if test="${vs.index==0}">
                                    <c:set var="firstAccountLabel" value="${accountLabel}"/>
                                    <c:set var="firstBankCode" value="${i.bankCode}"/>
                                </c:if>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message clearfix">
                <h4>${views.fund_auto['请填写存款金额']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                <div class="control-group" name="payerName" style="${firstBankCode=='alipay'?'':'display:none'}">
                    <label class="control-label" for="result.payerName">您的支付户名:</label>
                    <div class="controls">
                        <input type="text" class="input" id="result.payerName" name="result.payerName" autocomplete="off" placeholder="请填写存款时使用的真实姓名">
                    </div>
                </div>
                <div class="control-group" name="payerBankcard" style="${empty firstAccountLabel?'display:none':''}">
                    <label class="control-label" for="result.payerBankcard">${firstAccountLabel}</label>
                    <div class="controls">
                        <input type="text" class="input" value="${payerBankcard}" id="result.payerBankcard" name="result.payerBankcard" autocomplete="off" placeholder="${views.fund_auto['昵称']}">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="result.rechargeAmount">${views.fund_auto['金额']}：</label>
                    <div class="controls" style="width: 525px">
                        <input type="text" class="input" name="result.rechargeAmount" id="result.rechargeAmount" autocomplete="off">
                        <span class="fee"></span>
                    </div>
                </div>
                <%@include file="sale.jsp" %>
                <%@include file="CaptchaCode.jsp" %>
                <div class=" control-group">
                    <label class="control-label"></label>
                    <soul:button target="submit" precall="validateForm" text="${views.fund_auto['立即存款']}" opType="function" cssClass="btn-blue btn large-big disabled _submit"/>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <span class="deposit-info-title">${views.fund_auto['注意事项']}<img src="${resRoot}/images/online-pay3.png"></span>
                <ul class="attention-list">
                    <li class="red">${views.fund_auto['扫码存款提醒']}</li>
                    <li>${fn:replace(fn:replace(fn:replace(views.fund_auto['扫码存款限额范围'], "{0}",siteCurrency ), "{1}", empty rank.onlinePayMin || rank.onlinePayMin == '0'?'0.01':soulFn:formatCurrency(rank.onlinePayMin)),"{2}" , empty rank.onlinePayMax?'99,999,999.00':soulFn:formatCurrency(rank.onlinePayMax))}
                    </li>
                    <li>${views.fund_auto['支付成功后']}</li>
                </ul>
            </div>
        </div>
    </c:if>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/ElectronicPayFirst'], function(Page) {
        page = new Page();
        page.bindButtonEvents();
    });
</script>