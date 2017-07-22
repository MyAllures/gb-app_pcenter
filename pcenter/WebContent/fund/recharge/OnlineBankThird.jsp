<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form>
    <input type="hidden" name="result.rechargeAmount" value="${playerRechargeVo.result.rechargeAmount}"/>
    <input type="hidden" name="result.payAccountId" value="${playerRechargeVo.result.payAccountId}"/>
    <input type="hidden" name="activityId" value="${playerRechargeVo.activityId}"/>
    <gb:token/>
    <input type="hidden" name="result.payerName" value=""/>
    <input type="hidden" name="result.rechargeType" value="${playerRechargeVo.result.rechargeType}">
    <input type="hidden" name="result.bankOrder" value="${playerRechargeVo.result.bankOrder}"/>
    <input type="hidden" name="result.payerBankcard" value="${playerRechargeVo.result.payerBankcard}"/>
    <input type="hidden" name="result.returnTime" value="${soulFn:formatDateTz(playerRechargeVo.result.returnTime,DateFormat.DAY_SECOND, timeZone)}"/>
    <input type="hidden" name="result.bitAmount" value="<fmt:formatNumber pattern="#.########" value="${playerRechargeVo.result.bitAmount}"/>"/>
    <input type="hidden" name="code" value="${playerRechargeVo.code}"/>
    <input type="hidden" name="rechargeCount" value="<%=SessionManager.getRechargeCount()%>"/>
    <input type="hidden" name="result.rechargeAddress" value=""/>
    <div class="modal-body">
        <c:set var="type" value="${playerRechargeVo.result.rechargeType}"/>
        <div class="withdraw-not text-15p">
            <c:choose>
                <c:when test="${type eq 'bitcoin_fast'}">
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['比特币']}：</label>
                        <div class="col-xs-6 p-x  f-size26"><fmt:formatNumber pattern="#.########" value="${playerRechargeVo.result.bitAmount}"/></div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['存款金额']}：</label>
                        <div class="col-xs-6 p-x  f-size26">${soulFn:formatCurrency(playerRechargeVo.result.rechargeAmount)}</div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['手续费/返手续费']}：</label>
                        <div class="col-xs-6 p-x">
                            <em class="${fee<0?'green m-l':'red'} f-size26">${fee>0?'+':''}${soulFn:formatCurrency(fee)}</em>
                        </div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['实际到账']}：</label>
                        <div class="col-xs-6 p-x">
                            <em class="red  f-size26">${soulFn:formatCurrency(playerRechargeVo.result.rechargeAmount+fee)}</em>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="clearfix bg-gray p-t-xs al-center">
            <div class="clearfix line-hi25 p-sm caution-pop">
                <em><i class="mark plaintsmall"></i>${views.fund_auto['审核提醒']}</em>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <c:choose>
            <c:when test="${type=='online_bank'}">
                <c:set var="url" value="onlineBankSubmit"/>
            </c:when>
            <c:when test="${type=='other_fast'||type=='alipay_fast'||type=='wechatpay_fast'}">
                <c:set var="url" value="electronicPaySubmit"/>
            </c:when>
            <c:when test="${type=='bitcoin_fast'}">
                <c:set var="url" value="bitCoinSubmit"/>
            </c:when>
            <c:when test="${type=='atm_money'||type=='atm_recharge'||type=='atm_counter'}">
                <c:set var="url" value="atmCounterSubmit"/>
            </c:when>
            <c:otherwise>
                <c:set var="url" value="onlineBankSubmit"/>
            </c:otherwise>
        </c:choose>
        <soul:button target="submit" data="${url}" text="${views.fund_auto['已存款确认提交']}" opType="function" cssClass="btn btn-filter"/>
        <soul:button target="closePage" text="${views.fund_auto['取消提交']}" opType="function" cssClass="btn btn-outline btn-filter"/>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/recharge/OnlineBankThird"/>
</html>


