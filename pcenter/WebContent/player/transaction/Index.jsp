<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerGameOrderListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<style type="text/css">
    i.successsmall {display: none}
</style>

<form:form action="${root}/vPlayerGameOrder/apiList.html" method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="">
        <div class="notice">
            <div class="notice-left"><em class="path"></em></div>
            <div class="path-right">
                <a class="cursor">${views.sysResource['投注记录']}</a>
            </div>
            <c:if test="${command.search.apiId > 0}">
            <div class="return" style="margin-top: 1px">
                <a href="/vPlayerGameOrder/apiList.html?type=history" class="btn btn-gray btn-big" nav-target="mainFrame">${views.player_auto['返回上一级']}</a>
            </div>
            </c:if>
        </div>
        <!--刷新时间-->
        <!--搜索-->
        <div class="rgeechar">
            <%--<form id="transferForm" class="" method="post">--%>
                <div class="history btnalign">
                    <span class="pull-left">${views.bet['History.list.timeRange']}：</span>
                    <gb:dateRange format="${DateFormat.DAY}" useRange="true" style="width:100px;" inputStyle="width:80px"
                                  btnClass="search" last30Days="false" position="down"
                                  minDate="${command.minday}" maxDate="${command.maxday}"
                                  startDate="${command.minday}" endDate="${command.maxday}"
                                  startName="search.beginBetTime" endName="search.endBetTime" />
                    <div class="pull-right">
                    <input class="form-control search" placeholder="${views.bet['History.list.betOrder']}" type="text" name="search.betId" id="orderNo">
                       <soul:button target="query"  opType="function"  cssClass="btn btn-filter" tag="button" text="">
                            <i class="fa fa-search"></i>
                            <span class="hd">&nbsp;${views.common['search']}</span>
                        </soul:button>
                    </div>
                </div>
            <%--</form>--%>
        </div>
        <input type="hidden" name="search.orderState" value="${command.search.orderState}">
        <div class="search-list-container">
            <%@ include file="IndexPartial.jsp" %>
        </div>

    </div>

</form:form>
<!--//region your codes 3-->
<soul:import res="site/player/transaction/list"/>
<!--//endregion your codes 3-->
