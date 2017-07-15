<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<div class="theme-popcon">
    <h3 class="popalign"><i class="tipbig fail"></i>${views.fund['Deposit.deposit.depositFail']}</h3>
    <div class="text">
        <p>${views.fund['Deposit.deposit.failureReason']}</p>
        <p>
            <c:choose>
                <c:when test="${!empty msg}">
                    ${msg}
                </c:when>
                <c:when test="${checkResult=='N'||checkResult=='INIT'}">
                    ${views.fund['Deposit.deposit.unpaid']}
                </c:when>
                <c:otherwise>
                    ${views.fund['Deposit.deposit.failOtherReason']}
                </c:otherwise>
            </c:choose>
        </p>
    </div>
    <form class="popbutton">
        <soul:button target="rechargeAgain" text="${views.fund_auto['再存一次']}" opType="function" cssClass="btn btn-blue middle-big" tag="button"/>
        <soul:button target="customerService" cssClass="btn btn-gray middle-big" text="${views.common['contactCustomerService']}" url="${customerService}" opType="function"/>
    </form>
</div>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/recharge/SubmitSuccess"/>
</html>

