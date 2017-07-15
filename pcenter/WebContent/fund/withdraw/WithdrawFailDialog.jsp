<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-10-28
  Time: 下午3:00
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

<form class="popbutton">
    <div class="modal-body theme-popcon">
        <div class="poptable">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="45%" class="popalignr">${views.fund_auto['本次取款稽核']}：</td>
                    <td width="55%"><span class="orange">${views.fund_auto['未通过']}</span></td>
                </tr>
                <tr>
                    <td class="popalignr">${views.fund_auto['扣除行政费']}：</td>
                    <td><span class="orange">${soulFn:formatCurrency(map.administrativeFee)}</span></td>
                </tr>
                <tr>
                    <td class="popalignr">${views.fund_auto['扣除优惠']}：</td>
                    <td><span class="orange">${soulFn:formatCurrency(map.deductFavorable)}</span></td>
                </tr>
                <tr>
                    <td class="popalignr">${views.fund_auto['手续费']}：</td>
                    <td>
                        <span class="orange">${map.withdrawFeeMoney==0?'0.00':soulFn:formatCurrency(map.withdrawFeeMoney)}</span>
                    </td>
                </tr>
                <tr>
                    <td class="popalignr">${views.fund_auto['申请取款金额']}：</td>
                    <td><span class="orange">${soulFn:formatCurrency(map.withdrawAmount)}</span></td>
                </tr>
                <tr>
                    <td class="popalignr">${views.fund_auto['实际可到账']}：</td>
                    <td>
                        <span class="orange fontmiddle">${soulFn:formatCurrency(map.actualWithdraw)}</span>
                    </td>
                </tr>
            </table>
        </div>
        <div class="">
            <input type="hidden" name="search.transactionNo" value="${map.transactionNo}"/>
            <input type="hidden" name="result.administrativeFee" value="<fmt:formatNumber value="${map.administrativeFee}" pattern="0.00"/>"/>
            <input type="hidden" name="result.deductFavorable" value="<fmt:formatNumber value="${map.deductFavorable}" pattern="0.00"/>"/>
            <input type="hidden" name="result.counterFee" value="<fmt:formatNumber value="${map.withdrawFeeMoney}" pattern="0.00"/>"/>
            <input type="hidden" name="result.withdrawActualAmount" value="<fmt:formatNumber value="${map.actualWithdraw}" pattern="0.00"/>"/>
            <input type="hidden" name="result.withdrawAmount" value="<fmt:formatNumber value="${map.withdrawAmount}" pattern="0.00"/>"/>

            <soul:button target="continueWithdraw" text="${views.fund_auto['继续取款']}" opType="function"
                         cssClass="btn btn-blue middle-big ${map.actualWithdraw<=0?'disable-gray ui-button-disable disabled':''}"
                         callback="query"/>
            <soul:button target="abandonWithdraw" text="${views.fund_auto['放弃取款']}" opType="function" cssClass="btn btn-blue middle-big"
                         callback="setReturnValue"/>
            <a href="/player/withdraw/withdrawList.html" style="display: none" name="returnMain"
               nav-target="mainFrame"></a>

            <p class="popgray">${views.fund_auto['取款订单提交时间']}：${soulFn:formatDateTz(nowTime, DateFormat.DAY_SECOND,timeZone)}</p>
        </div>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/PWithdraw"/>
</html>
