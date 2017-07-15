<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-4
  Time: 上午9:55
--%>

<%--@elvariable id="command" type="so.wwb.gamebox.model.master.report.vo.VPlayerTransactionListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div>
    <div class="notice"><div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['资金记录']}</a></div>
    </div>
    <!--选项卡-->
    <div class="tabmenu">
        <ul class="tab">
            <li><a href="/fund/transaction/list.html" nav-target="mainFrame">${views.fund['FundRecord.index.record']}</a></li>
            <li><a href="javascript:void(0)" class="current">${views.fund['FundRecord.index.chart']}</a></li>
        </ul>
    </div>

    <!--图表模式-->
    <form:form action="${root}/fund/transaction/chart.html">
        <div class="rgeechar">
            <%@include file="SearchPartial.jsp"%>
        </div>

        <div class="chart-boxtotal search-list-container">
            <%@include file="ChartPartial.jsp"%>
        </div>

    </form:form>
</div>
<soul:import res="site/fund/transaction/Chart"></soul:import>