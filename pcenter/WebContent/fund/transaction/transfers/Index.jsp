<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-5
  Time: 下午4:14
--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.PlayerTransactionListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<html>
<head>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
    <div class="modal-body" id="mainFrame" style="overflow-y: auto;">

        <form action="${root}/fund/transaction/transfers/playerTransfersList.html?search.transactionNo=${command.search.transactionNo}&search.beginCreateTime=${soulFn:formatDateTz(command.search.beginCreateTime, DateFormat.DAY_SECOND, timeZone )}&search.endCreateTime=${soulFn:formatDateTz(command.search.endCreateTime, DateFormat.DAY_SECOND, timeZone )}" method="post">
            <div class="theme-popcon search-list-container">
                <%@include file="IndexPartial.jsp"%>
            </div>
        </form>
    </div>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import type="list" />
<soul:import res="site/fund/transaction/transfers/Index" />
</html>
