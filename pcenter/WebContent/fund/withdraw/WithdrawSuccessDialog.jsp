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

<c:if test="${(rank.isWithdrawLimit!=null && rank.isWithdrawLimit==true) || (rank.withdrawCheckStatus!=null && rank.withdrawCheckStatus==true)}">
  <div class="theme-popcon">
    <h3 class="popalign"><i class="tipbig success"></i>${views.fund_auto['提交成功']}！</h3>
    <div class="text">
      <c:choose>
        <c:when test="${rank.withdrawExcessCheckStatus && rank.withdrawExcessCheckTime!=null}">
          <c:if test="${not empty withdrawExcessCheckTime}">
            <p>${fn:replace(views.fund_auto['提现提醒'],"{0}" ,withdrawExcessCheckTime )}</p>
          </c:if>
          <c:if test="${empty withdrawExcessCheckTime && not empty withdrawCheckTime}">
            <p>${fn:replace(views.fund_auto['提现提醒'],"{0}" ,withdrawCheckTime )}</p>
          </c:if>
        </c:when>
        <c:otherwise>
          <c:if test="${rank.withdrawCheckStatus && rank.withdrawCheckTime!=null}">
            <c:if test="${not empty withdrawCheckTime}">
              <p>${fn:replace(views.fund_auto['提现提醒'],"{0}" ,withdrawCheckTime )}</p>
            </c:if>
          </c:if>
        </c:otherwise>
      </c:choose>
      <c:if test="${withdrawCount!=null}">
        <p>${fn:replace(views.fund_auto['今日取款剩余次数'],"{0}" ,withdrawCount )}</p>
      </c:if>
    </div>
    <form class="popbutton">
      <soul:button target="closePage" text="${views.fund_auto['好的']}" cssClass="btn btn-blue middle-big" opType="function"/>
      <soul:button target="fundRecord" text="" opType="function" tag="a" cssClass="btn btn-gray middle-big">${views.fund_auto['查看资金记录']}</soul:button>
      <%--<a class="btn btn-gray middle-big" nav-target="mainFrame" href="/fund/transaction/list.html">${views.fund_auto['查看资金记录']}</a>--%>
    </form>
    <p class="popgray">${views.fund_auto['取款订单提交时间']}：${soulFn:formatDateTz(nowTime, DateFormat.DAY_SECOND,timeZone)}</p>
  </div>
</c:if>

<c:if test="${(rank.isWithdrawLimit==null || rank.isWithdrawLimit==false) && (rank.withdrawCheckStatus==null || rank.withdrawCheckStatus==false) }">
  <div class="theme-popcon">
    <h3 class="popalign"><i class="tipbig success"></i>${views.fund_auto['提交成功']}</h3>
    <form class="popbutton">
      <div class="text">
        <p>${views.fund_auto['正在等待系统处理请注意查收']}</p>
      </div>
      <soul:button target="closePage" text="${views.fund_auto['好的']}" cssClass="btn btn-blue middle-big" opType="function"/>
      <soul:button target="fundRecord" text="${views.fund_auto['查看资金记录']}" cssClass="btn btn-blue middle-big" opType="function"/>
    </form>
    <p class="popgray">${views.fund_auto['取款订单提交时间']}：${soulFn:formatDateTz(nowTime, DateFormat.DAY_SECOND,timeZone)}</p>
  </div>
  </c:if>

</body>

<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/PWithdraw"/>
</html>
