<%@ page import="org.soul.model.passport.vo.PassportVo" %>
<%@ page import="org.soul.web.tag.ImageTag" %>
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
    <h3 class="popalign"><i class="tipbig success"></i>${views.fund['Deposit.deposit.submitSuccess']}</h3>
    <div class="text">
        <p class="center">${views.fund['Deposit.deposit.submitSuccessTips']}</p>
    </div>
    <form class="popbutton">
        <soul:button target="rechargeAgain" text="${views.fund['Deposit.deposit.depositAgain']}" opType="function" cssClass="btn btn-blue middle-big" tag="button"/>
        <soul:button target="viewRecharge" text="${views.fund['Deposit.deposit.viewTrasaction']}" opType="function" cssClass="btn btn-gray" tag="button"/>
    </form>
</div>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/recharge/SubmitSuccess"/>
</html>

