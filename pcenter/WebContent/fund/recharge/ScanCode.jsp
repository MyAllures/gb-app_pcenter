<%--@elvariable id="payAccountMap" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--扫码支付-->
<form name="scanCode">
<gb:token/>
<div id="validateRule" style="display: none">${validateRule}</div>
<input type="hidden" name="isRealName" value="${isRealName}"/>
<input type="hidden" name="realNameDialog" value="${realNameDialog}">
<input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
<a href="javascript:;" name="realNameDialog" style="display: none"></a>
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right">
        <a href="javascript:;">${views.sysResource['存款专区']}</a>
    </div>
</div>
<div class="deposit-info-warp  clearfix">
    <div class="titleline pull-left"><h2>${views.fund_auto['扫码支付']}</h2></div>
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
                    <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                        <c:if test="${vs.index==0}">
                            <c:set var="onlinePayMax" value="${i.value.singleDepositMax}"/>
                            <c:set var="onlinePayMin" value="${i.value.singleDepositMin}"/>
                        </c:if>
                        <label class="bank ${vs.index==0?'select':''}">
                            <c:if test="${i.key=='wechatpay'}">
                                <span class="radio">
                                    <input name="result.rechargeType" value="${'wechatpay_scan'}" type="radio" ${vs.index==0?'checked':''}>
                                    <%--<a type="hidden" class="randomAmount" value="${i.value.randomAmount}"/>--%>
                                </span>

                            </c:if>
                            <c:if test="${i.key=='alipay'}">
                                <span class="radio">
                                    <input name="result.rechargeType" value="${'alipay_scan'}" type="radio" ${vs.index==0?'checked':''}>
                                    <%--<a type="hidden" class="randomAmount" value="${i.value.randomAmount}"/>--%>
                                </span>
                            </c:if>
                            <c:if test="${i.key=='qqwallet'}">
                                <span class="radio">
                                    <input name="result.rechargeType" value="${'qqwallet_scan'}" type="radio" ${vs.index==0?'checked':''}>
                                    <%--<a type="hidden" class="randomAmount" value="${i.value.randomAmount}"/>--%>
                                </span>
                            </c:if>
                            <span class="radio-bank" title="${dicts.common.bankname[i.key]}"><i class="pay-third ${i.key}"></i></span>
                            <span class="bank-logo-name">${dicts.common.bankname[i.key]}</span>
                            <input type="hidden" class="onlinePayMax" value="${empty i.value.singleDepositMax?'99,999,999.00':soulFn:formatCurrency(i.value.singleDepositMax)}"/>
                            <input type="hidden" class="onlinePayMin" value="${empty i.value.singleDepositMin?'0.01':soulFn:formatCurrency(i.value.singleDepositMin)}"/>
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
            <div class="control-group">
                <label class="control-label">${views.fund_auto['存款账号']}：</label>
                <div class="controls">${username}</div>
            </div>
            <div class="control-group">
                <label class="control-label" for="result.rechargeAmount">${views.fund_auto['存款金额']}：</label>
                <div class="controls">
                    <input type="text" class="input" name="result.rechargeAmount" id="result.rechargeAmount" autocomplete="off"/>
                    <span class="fee"></span>
                </div>
            </div>
            <!--优惠-->
            <%@include file="sale.jsp"%>
            <c:set var="rechargeCount" value="<%=SessionManager.getRechargeCount()%>"/>
            <c:if test="${rechargeCount>=3}">
                <div class="control-group  code">
                    <label class="control-label">${views.common['verificationCode']}</label>
                    <div class="controls">
                        <input type="hidden" name="rechargeCount" value="${rechargeCount}"/>
                        <input type="text" name="code" class="input" showSuccMsg="false"/>
                        <img class="captcha-code" src="${root}/captcha/recharge.html?t=${random}" reloadable>
                        <span name="codeTitle"></span>
                    </div>
                </div>
            </c:if>
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
                <li>${views.fund_auto['请正确填写金额']}</li>
                <li>${fn:replace(fn:replace(fn:replace(views.fund_auto['存款限额范围'], "{0}",siteCurrency ), "{1}", empty onlinePayMin || onlinePayMin == '0'?'0.01':soulFn:formatInteger(onlinePayMin).concat(soulFn:formatDecimals(onlinePayMin))),"{2}" , empty onlinePayMax?'99,999,999':soulFn:formatInteger(onlinePayMax).concat(soulFn:formatDecimals(onlinePayMax)))}</li>
            </ul>
            <div>
            </div>
        </div>
    </div>
</c:if>
</form>
<soul:import res="site/fund/recharge/ScanCode"/>