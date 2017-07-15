<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerGameorderSitegameVo"--%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--//region your codes 1-->
<div class="chart-table">
    <input name="search.logType" type="hidden" value="${command.search.logType}">
  <table width="100%" border="0" class="table table-striped table-hover dataTable" cellpadding="0" cellspacing="0">
    <tr>
        <th width="18%">
            <%-- 一级分类列表--%>
            <c:if test="${empty command.search.logType }">
                <select callback="query" class="selectwidth" name="search.apiId"  prompt="${views.player_auto['选择游戏']}">
                    <option value="">${views.column['game.order.all.api']}</option>
                    <c:forEach items="${command.idList}" var="i">
                        <option <c:if test="${command.search.apiId eq i.toString() }"> selected="selected"</c:if> value="${i}">${gbFn:getApiName(i.toString())}</option>
                    </c:forEach>
                </select>
            </c:if>
            <%-- 二级分类列表 --%>
            <c:if test="${!empty command.search.logType }">
                <select callback="query" class="selectwidth" name="search.gameType" prompt="${views.player_auto['选择游戏']}">
                    <option value="">${gbFn:getApiName(command.search.apiId.toString())}</option>
                    <c:forEach items="${command.apiSubGameClassfiedStatistics}" var="entry">
                        <option <c:if test="${command.search.apiId eq i.toString() }">selected="selected"</c:if> value="${entry['game_type']}">${gbFn:getGameTypeName(entry['game_type'])}</option>
                    </c:forEach>
                </select>
            </c:if>
        </th>
      <th width="18%">${views.bet['History.list.betCount']}</th>
      <th width="17%"><c:if test="${command.search.orderState ne 'pending_settle'}">${views.bet['History.list.effective']}</c:if>${views.bet['History.list.transaction']}</th>
      <th width="13%">${views.bet['History.list.profitLoss']}</th>
    </tr>


          <c:if test="${empty command.gameOrderClassfiedStatistics && empty  command.search.logType}">
              <tr>
                  <td class="no-content_wrap" colspan="4" style="text-align: center"><i class="fa fa-exclamation-circle"></i> ${views.bet['History.norecord']}</td>
              </tr>
          </c:if>

      <c:choose>
          <%-- 所有Api 投注记录统计列表--%>
          <c:when test="${empty command.search.logType }">
              <c:forEach items="${command.gameOrderClassfiedStatistics}" var="entry" varStatus="status">
                  <tr>
                      <td class="blue">
                          <soul:button target="queryLogOfApiGameType" apiid="${entry['api_id']}" gametype="${entry['game_type']}" text="${gbFn:getApiName(entry['api_id'].toString())}" opType="function"/>
                      </td>
                      <td class="blue">
                          <b><soul:button target="queryByApi" apiid="${entry['api_id']}"  text="${soulFn:formatNumber(entry['bs'])}" opType="function"/></b>
                      </td>
                      <td>
                          <c:if test="${command.search.orderState ne 'pending_settle'}">
                              <span class="blue">${soulFn:formatCurrency(entry['effective_trade_amount'])}</span>/
                          </c:if>
                              ${soulFn:formatCurrency(entry['single_amount'])}</td>
                      <td>
                          <c:choose>
                              <c:when test="${command.search.orderState ne 'pending_settle'}">
                                  <span class="<c:if test="${entry['profit_amount'] < 0}">green</c:if>
                                  <c:if test="${entry['profit_amount'] > 0}">orange</c:if>">${soulFn:formatCurrency(entry['profit_amount'])}</span>
                              </c:when>
                              <c:otherwise>
                                  ---
                              </c:otherwise>
                          </c:choose>
                      </td>
                  </tr>
              </c:forEach>
          </c:when>
          <%-- 某Api二级分类交易列表--%>
          <c:otherwise>
              <input type="hidden" name="apiId" value="${command.search.apiId}">
              <c:forEach items="${command.apiSubGameClassfiedStatistics}" var="entry" varStatus="status">
                  <tr>
                      <td class="gamegray">
                              ${gbFn:getGameTypeName(entry['game_type'])}
                      </td>
                      <td class="blue">
                          <b><soul:button target="queryByApiSub" gametype="${entry['game_type']}" text="${entry['bs']}" opType="function"/></b>
                      </td>
                      <td>
                          <c:if test="${command.search.orderState ne 'pending_settle'}">
                              <span class="blue">${soulFn:formatCurrency(entry['effective_trade_amount'])}</span>/
                          </c:if>
                              ${soulFn:formatCurrency(entry['single_amount'])}</td>
                      <td>
                          <c:choose>
                              <c:when test="${command.search.orderState ne 'pending_settle'}">
                                  <span class="<c:if test="${entry['profit_amount'] < 0}">green</c:if><c:if test="${entry['profit_amount'] > 0}">orange</c:if>">
                                  ${soulFn:formatCurrency(entry['profit_amount'])}</span>
                              </c:when>
                              <c:otherwise>---</c:otherwise>
                          </c:choose>
                      </td>
                  </tr>
              </c:forEach>
          </c:otherwise>

      </c:choose>



  </table>
</div>
<div class="count"><span class="lightgray">${views.bet['History.list.total']}：</span>${soulFn:formatNumber(command.gameOrderStatistics['bs'])}${views.player_auto['笔']}
  <span class="lightgray">${views.bet['History.list.effectiveTransaction']}：</span><span class="blue">${soulFn:formatCurrency(command.gameOrderStatistics['effective'])}</span>
  <span class="lightgray">${views.bet['History.list.transaction']}：</span><span class="blue">${soulFn:formatCurrency(command.gameOrderStatistics['single'])}</span>
  <span class="lightgray">${views.bet['History.list.profitLoss']}：</span>
  <span class="<c:if test="${command.gameOrderStatistics['profit'] < 0}">green</c:if>
     <c:if test="${command.gameOrderStatistics['profit'] > 0}">orange</c:if>">${soulFn:formatCurrency(command.gameOrderStatistics['profit'])}</span>

</div>
<soul:pagination/>
<!--//endregion your codes 1-->