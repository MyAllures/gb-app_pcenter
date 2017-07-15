<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerGameorderSitegameVo"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>


<form:form action="${root}/vPlayerGameOrder/singleApiLog.html?type=search" method="post">
    <div class="">

        <div class="notice">
            <div class="notice-left"><em class="path"></em></div>
            <div class="path-right">
                <a class="cursor">${views.sysResource['投注记录']}</a></span>
            </div>
            <div class="return" style="margin-top: 1px">
                <a href="/vPlayerGameOrder/apiList.html?search.apiId=${command.search.apiId}&type=subLog" class="btn btn-gray btn-big" nav-target="mainFrame">${views.player_auto['返回上一级']}</a>
            </div>
        </div>
        <!--搜索-->
        <div class="rgeechar m-l">
            <%--<form id="transferForm" class="" method="post">--%>
                <div class="history btnalign">
                    <span class="pull-left">${views.bet['History.list.timeRange']}：</span>
                    <c:if test="${empty command.search.orderState }">
                        <gb:dateRange format="${DateFormat.DAY}" style="width:100px" inputStyle="width:80px" useRange="true" position="down" btnClass="search"
                                      minDate="${command.minday}" maxDate="${command.maxday}"
                                      startDate="${command.minday}" endDate="${command.maxday}"
                                      startName="search.beginBetTime" endName="search.endBetTime" />
                    </c:if>
                    <div class="pull-right">
                    <input class="form-control search" type="text" name="search.betId" value="${command.search.betId}">

                    <soul:button target="query"  opType="function" cssClass="btn btn-filter" tag="button" text="">
                        <i class="fa fa-search"></i>
                        <span class="hd">&nbsp;${views.common['search']}</span>
                    </soul:button>
                    </div>
                </div>
            <%--</form>--%>
        </div>
        <input type="hidden" name="search.apiId" value="${command.search.apiId}">
        <input type="hidden" name="search.playerId" value="${command.search.playerId}">
        <div class="search-list-container">
            <%@ include file="SingleApiLogPartial.jsp" %>
        </div>


    </div>

</form:form>
<!--//region your codes 3-->
<soul:import res="site/player/transaction/SingleApiLog"/>
<!--//endregion your codes 3-->
