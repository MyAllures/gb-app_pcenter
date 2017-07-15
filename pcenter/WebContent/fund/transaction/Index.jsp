<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-10-30
  Time: 下午4:13
--%>

<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.PlayerTransactionListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div>
    <div class="notice"><div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['资金记录']}</a></div>
    </div>
    <!--选项卡-->
    <div class="tabmenu">
        <ul class="tab">
            <li><a href="javascript:void(0)" class="current">${views.fund['FundRecord.index.record']}</a></li>
            <li><a nav-target="mainFrame" href="/fund/transaction/chart.html">${views.fund['FundRecord.index.chart']}</a></li>
        </ul>
    </div>

    <!--列表模式-->
    <form:form action="${root}/fund/transaction/list.html">
        <div class="rgeechar">
            <%@include file="SearchPartial.jsp"%>
        </div>

        <div class="search-list-container">
            <%@include file="IndexPartial.jsp"%>
        </div>
    </form:form>
</div>
<soul:import res="site/fund/transaction/Chart"></soul:import>
