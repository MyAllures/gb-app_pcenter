<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.PlayerGameOrderListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form action="${root}/gameOrder/index.html" method="post">
    <div class="main-wrap">
        <div class="notice">
            <div class="notice-left"><em class="path"></em></div>
            <div class="path-right">
                <a class="cursor">${views.sysResource['投注记录']}</a>
            </div>
        </div>
        <div class="rgeechar">
            <div class="history btnalign">
                <span class="pull-left">${views.gameOrder_auto['投注日期']}：</span>
                <gb:dateRange style="width:170px;" inputStyle="width:150px" format="${DateFormat.DAY_SECOND}" useToday="true" useRange="true" position="down" btnClass="search"  minDate="${command.minDate}" startName="search.beginBetTime" endName="search.endBetTime" startDate="${command.search.beginBetTime}" endDate="${command.search.endBetTime}"/>
                <soul:button target="queryByCondition" text="${views.gameOrder_auto['搜索']}" opType="function" cssClass="btn btn-filter"/>
                <c:if test="${isLottery.paramValue!='true'}">
                    <div class="pull-right">
                        ${views.gameOrder_auto['游戏类型']}：
                        <soul:button target="${root}/gameOrder/game.html" callback="gameCallBack" cssClass="btn btn-gray" text="${views.gameOrder_auto['选取']}" title="${views.gameOrder_auto['游戏分类']}" opType="dialog" tag="button"/>
                    </div>
                </c:if>
            </div>
        </div>
        <div class="count">
            <div class="lightgray text-left select-games-t">
                <span class="al-bold">${views.gameOrder_auto['已选择游戏']}：</span>
                <i id="gameSpan"></i>
            </div>
            <span class="pull-right"> <input type="checkbox" class="i-checks" name="search.pending" value="true"/>${views.gameOrder_auto['只查阅待结算注单']}</span>
        </div>
        <div class="search-list-container">
            <%@include file="IndexPartial.jsp" %>
        </div>
    </div>
</form>
<soul:import res="site/gameOrder/Index"/>

