<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-11-4
  Time: 下午4:47
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
<div class="modal-body">
    <div class="theme-popcon">
        <h3 class="popalign"><i class="tipbig cry"></i>${views.fund_auto['自动回复1']}</h3>

        <p>${views.fund_auto['自动回复2']}</p>

        <div class="text">
            <p class="orange">${views.fund_auto['算完后']}：</p>

            <p><span class="bold">1.${views.fund_auto['通过稽核']}：</span>${views.fund_auto['直接审核通过']}</p>

            <p><span class="bold">2.${views.fund_auto['未通过稽核']}：</span>${views.fund_auto['会弹窗通知结果，你可以选择是否要继续取款哦！']}</p>
        </div>
        <form class="popbutton">
            <soul:button target="closePage" text="${views.fund_auto['那就等等吧']}" cssClass="btn btn-blue middle-big" opType="function"/>
            <soul:button target="fundRecord" text="${views.fund_auto['查看资金记录']}" cssClass="btn btn-blue middle-big" opType="function"/>
        </form>
        <p class="popgray">${views.fund_auto['取款订单提交时间']}：${soulFn:formatDateTz(nowTime, DateFormat.DAY_SECOND,timeZone)}</p>
    </div>
</div>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/PWithdraw"/>
</html>
