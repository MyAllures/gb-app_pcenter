<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-10-20
  Time: 下午5:11
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<div class="theme-popcon">
    <h2 class="popalign">${views.fund_auto['正在努力计算中']}</h2>
    <a style="display: none" name="returnMain" nav-target="mainFrame" href="/player/withdraw/withdrawList.html"></a>
    <div class="text">
        <p>${views.fund_auto['计算本次取款是否达到稽核条件']}</p>
    </div>
    <form class="popbutton">
        <%--<soul:button target="${root}/player/withdraw/abandonWithdraw.html?search.transactionNo=${transactionNo}" text="${views.fund_auto['取消计算']}" cssClass="btn btn-filter btn-lg cancel-btn-css" opType="ajax" dataType="json" callback="calculationCallback"/>--%>
    </form>
</div>
<form id="withdrawAuditForm" action="${root}/player/withdraw/withdrawAudit.html" method="post" >
    <input type="hidden" name="result.transactionNo" id="transactionNo" value="${transactionNo}">
    <input type="hidden" name="result.transactionMoney" id="transactionMoney" value="${transactionMoney}">
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/Calculation"/>
</html>
