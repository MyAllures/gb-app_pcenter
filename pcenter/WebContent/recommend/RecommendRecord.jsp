<%--@elvariable id="command" type="java.util.list<so.wwb.gamebox.model.master.report.vo.PlayerRecommendAwardRecord>"--%>
<%--@elvariable id="map" type="java.util.Map"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--推荐好友-->
<div class="recode">
    <span class="respace">${views.recommend['recommend.Record.obtainDividendYesterDay']}<i class="orange fontlarge">&nbsp;${soulFn:formatCurrency(map['yesterday'])}&nbsp;</i></span>
    <span class="respace">${views.recommend['recommend.Record.recommendFriend']}<i class="blue fontlarge">${soulFn:formatNumber(map['count'])}</i></span>
    <span class="respace">${views.recommend['recommend.Record.youObtained']}<i class="green fontlarge">${soulFn:formatCurrency(map['amount'])}</i>&nbsp;${views.recommend['recommend.Record.recommendSingelAward']}</span>
    <span class="respace">${views.recommend['recommend.Record.youObtained']}<i class="orange fontlarge">&nbsp;${soulFn:formatCurrency(map['rebate'])}&nbsp;</i>${views.recommend['recommend.Record.recommendedDividend']}</span>
</div>
<!--推荐记录-->
<div class="search-list-container">
    <%@include file="RecommendRecordPartial.jsp"%>
</div>


