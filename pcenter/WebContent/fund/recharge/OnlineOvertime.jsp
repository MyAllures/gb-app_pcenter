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
    <h3 class="popalign"><i class="tipbig fail"></i>${views.fund['Deposit.deposit.overTime']}</h3>
    <div class="text">
        <p>${views.fund['Deposit.deposit.overTimeMsg1']}</p>
        <p>${views.fund['Deposit.deposit.overTimeMsg2']}</p>
    </div>
    <form class="popbutton">
        <soul:button target="rechargeAgain" text="${views.fund['Deposit.deposit.depositAgain']}" opType="function" cssClass="btn btn-blue middle-big" tag="button"/>&nbsp;
        <soul:button tag="button" target="customerService" url="${customerService}" text="${views.common['contactCustomerService']}" opType="function" cssClass="btn btn-gray middle-big"/>
    </form>
</div>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/recharge/SubmitSuccess"/>
</html>

