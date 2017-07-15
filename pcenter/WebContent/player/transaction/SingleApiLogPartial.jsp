<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.vplayergameorderlistvo"--%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--//region your codes 1-->
<div class="chart-table m-l">
  <table width="100%" border="0"  class="table table-striped table-hover dataTable" cellpadding="0" cellspacing="0">
    <tr>
      <th width="15%">${views.bet['History.list.betOrder']}</th>
      <th width="19%">${views.bet['History.list.createTime']}</th>
      <th width="15%">
        <select callback="query" class="selectwidth" name="search.gameId" style="width: 150px">
          <option value="">${gbFn:getApiName(command.search.apiId.toString())}</option>
          <c:forEach items="${command.idList}" var="i">
            <option <c:if test="${command.search.gameId eq i.toString() }">selected="selected"</c:if> value="${i}">${gbFn:getGameName(i.toString())}</option>
          </c:forEach>
        </select>
      </th>
      <th width="15%">${views.bet['History.list.betAction']}</th>
      <th width="10%">${views.bet['History.list.betAccount']}</th>
      <th width="10%">${views.bet['History.list.payOut']}</th>
      <th width="8%">
        <gb:selectPure  name="search.orderState" value="${command.search.orderState}" cssClass="disabled" prompt="${views.common['all']}" list="${dicts.game['order_state']}" listKey="key" listValue="value" callback="query"/>
      </th>
      <th width="8%">${views.common['operate']}</th>
    </tr>

    <c:choose>
      <c:when test="${fn:length(command.someApiOrdersDetailList) gt 0}">
        <c:forEach items="${command.someApiOrdersDetailList}" var="entry" varStatus="status">
          <tr>
            <td class="gamegray">${entry["bet_id"]}</td>
            <td class="gamegray">
                ${soulFn:formatDateTz(entry["bet_time"], DateFormat.DAY_SECOND,timeZone)}
            </td>
            <td class="gamegray">
                ${gbFn:getApiName(entry["api_id"].toString())}
              <br/>
                ${gbFn:getGameName(entry["game_id"].toString())}
            </td>
            <td class="gamegray">


            </td>
            <td class="gamegray">${soulFn:formatCurrency(entry["single_amount"])}</td>
            <td class="<c:if test="${entry['profit_amount'] < 0}">green</c:if><c:if test="${entry['profit_amount'] > 0}">orange</c:if>">
              <c:if test="${entry['profit_amount'] eq 0}">
                ---
              </c:if>
              <c:if test="${entry['profit_amount'] ne 0}">
                ${soulFn:formatCurrency(entry["profit_amount"])}
              </c:if>
            </td>
            <td><span class="<c:if test="${entry['orderstate'] eq 'settle'}">green</c:if><c:if test="${entry['orderstate'] eq 'cancel'}">red</c:if><c:if test="${entry['orderstate'] eq 'pending_settle'}">orange</c:if>">
                ${dicts.game.order_state[entry["orderstate"]]}</span></td>
            <td>
              <soul:button target="queryByGame" orderid="${entry['bet_id']}" text="${views.common['detail']}" opType="function"/>
            </td>

          </tr>

        </c:forEach>
      </c:when>
      <c:otherwise>
        <tr>
          <td class="no-content_wrap" colspan="8" style="text-align: center"><i class="fa fa-exclamation-circle"></i> ${views.bet['History.norecord']}</td>
        </tr>
      </c:otherwise>
    </c:choose>

  </table>
</div>
<div class="count"><span class="lightgray">${views.player_auto['当前页总计']}：</span>${command.gameOrderStatistics['bs']}${views.player_auto['笔']}
  <span class="lightgray">${views.player_auto['交易金额']}：</span><span class="blue">${command.gameOrderStatistics['single']}</span>${views.player_auto['元']}<span
          class="lightgray">${views.player_auto['交易盈亏']}：</span><span class="<c:if test="${command.gameOrderStatistics['profit'] < 0}">green</c:if>
     <c:if test="${command.gameOrderStatistics['profit'] > 0}">orange</c:if>">${command.gameOrderStatistics['profit']}</span>${views.player_auto['元']}
</div>
<soul:pagination/>
<!--//endregion your codes 1-->