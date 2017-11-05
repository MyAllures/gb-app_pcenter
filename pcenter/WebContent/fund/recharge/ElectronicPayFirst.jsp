<%--@elvariable id="payAccountList" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--电子支付平台-->
<form>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fucomnd_auto['电子支付']}</h2></div>
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
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['选择存款方式']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                            <label class="bank ${vs.index==0?'select':''}">
                                <c:set var="name" value="${display?i.aliasName:dicts.common.bankname[i.bankCode]}"/>
                                <span class="radio"><input name="result.payAccountId" value="${i.id}" type="radio" ${vs.index==0?'checked':''}></span>
                                <span class="radio-bank" title="${name}"><i class="pay-third ${i.bankCode}"></i></span>
                                <span class="bank-logo-name">${name}</span>
                                <c:choose>
                                    <c:when test="${i.bankCode eq 'wechatpay'}">
                                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${dicts.common.bank_nickname[payAccount.bankCode]}："/>
                                    </c:when>
                                    <c:when test="${i.bankCode eq 'qqwallet'}">
                                        <c:set var="accountLabel" value="${views.fund_auto['您的']}QQ号码:"/>
                                    </c:when>
                                    <c:when test="${i.bankCode eq 'onecodepay'}"></c:when>
                                    <c:otherwise>
                                        <c:set var="accountLabel" value=" ${views.fund_auto['您的']} ${dicts.common.bankname[payAccount.bankCode]}${views.fund_auto['账号']}："/>
                                    </c:otherwise>
                                </c:choose>
                                <span style="display: none">
                                    ${accountLabel}
                                </span>
                                <c:if test="${v.index==0}">
                                    <c:set var="firstAccountLabel" value="${accountLabel}"/>
                                </c:if>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                <div class="left-ico-message clearfix accountMap" id="payAccount${i.id}" style="${vs.index==0?'':'display:none'}">
                    <h4>${fn:replace(views.fund_auto['请存款至以下账户'], "{0}",dicts.common.bankname[i.bankCode])}：</h4>
                    <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                    <div class="control-group" style="${empty firstAccountLabel?'display:none':''}">
                        <label class="control-label" for="result.payerBankcard">${firstAccountLabel}</label>
                        <div class="controls">
                            <input type="text" class="input" value="${payerBankcard}" id="result.payerBankcard" name="result.payerBankcard" autocomplete="off" placeholder="${views.fund_auto['昵称']}">
                            <c:if test="${payAccount.bankCode=='alipay'}">
                                <div class="controls">
                                    <p style="color:#AAAAAA;">${views.fund_auto['支付宝转账到支付宝']}${views.fund_auto['请填写']}<span style="color:#FF7744;">${views.fund_auto['昵称']}</span>；</p>
                                    <p style="color:#AAAAAA;">${views.fund_auto['支付宝转账到银行卡']}${views.fund_auto['请填写']}<span style="color:#FF7744;">${views.fund_auto['真实姓名']}</span>；</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <div class="control-group">
                        <label class="control-label">${views.fund_auto['金额']}：</label>
                        <div class="controls">
                            <input type="text" class="input" name="result.rechargeAmount" autocomplete="off">
                            <span class="fee"></span>
                        </div>
                    </div>
                    <%@include file="sale.jsp" %>
                    <div class="control-group">
                        <label class="control-label"></label>
                        <div class="controls co-gray">
                                ${payAccount.bankCode=='alipay'? views.fund_auto['请填写订单号非商户订单号']:''}
                        </div>
                    </div>
                    <%@include file="CaptchaCode.jsp" %>
                    <div class=" control-group">
                        <label class="control-label"></label>
                        <soul:button target="commonRecharge.confirm" precall="validateForm" text="${views.fund_auto['提交申请']}" opType="function"
                                     cssClass="btn-blue btn large-big disabled _submit"/>
                    </div>
                </div>
            </c:forEach>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay3.png"></span>
                <ul class="attention-list">
                    <li class="red">${views.fund_auto['扫码存款提醒']}</li>
                    <li>${fn:replace(fn:replace(fn:replace(views.fund_auto['扫码存款限额范围'], "{0}",siteCurrency ), "{1}", empty rank.onlinePayMin || rank.onlinePayMin == '0'?'0.01':soulFn:formatCurrency(rank.onlinePayMin)),"{2}" , empty rank.onlinePayMax?'99,999,999.00':soulFn:formatCurrency(rank.onlinePayMax))}
                    </li>
                </ul>
                <div class=" control-group">
                    <soul:button target="submit" text="${views.fund_auto['已完成存款，下一步']}" opType="function" cssClass="btn-blue btn large-big  m-l"/>
                </div>
            </div>
        </div>
    </c:if>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/ElectronicPayFirst','site/fund/recharge/CommonRecharge'], function(Page, CommonRecharge) {
        page = new Page();
        page.bindButtonEvents();
        page.commonRecharge = new CommonRecharge();
    });
</script>