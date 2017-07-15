<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
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
    <div class="theme-popcon">
        <h2>${views.fund['Deposit.deposit.onlinePendPay']}</h2>
        <div class="text">
            <p>${views.fund['Deposit.deposit.payTips']}</p>
            <p>
                ${views.fund['Deposit.deposit.longTime']}
                <i class="service call"></i>
                <soul:button target="customerService" text="${views.common['contactCustomerService']}" url="${customerService}" opType="function"/>
            </p>
        </div>
        <div class="popbutton">
            <soul:button target="despoitFinish" text="${views.fund['Deposit.deposit.finish']}" opType="function" cssClass="btn btn-blue middle-big"/>&nbsp;
            <c:choose>
                <c:when test="${playerRechargeVo.search.payerName eq 'online'}">
                    <soul:button target="closePage" text="${views.fund['Deposit.deposit.selectBank']}" opType="function" tag="a" cssClass="btn btn-gray middle-big"/>
                </c:when>
                <c:otherwise>
                    <soul:button target="closePage" text="${views.fund['Deposit.deposit.inputAmount']}" opType="function" tag="a" cssClass="btn btn-gray middle-big"/>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/recharge/OnlinePendingPay"/>
</html>

