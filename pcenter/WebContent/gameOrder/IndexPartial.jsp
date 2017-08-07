<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.PlayerGameOrderListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<textarea style="display: none" name="search.gameTypeList">${command.search.gameTypeList}</textarea>
<input type="hidden" name="search.beginWinningAmount" value="${command.search.beginWinningAmount}"/>
<div class="chart-table">
    <table  width="100%" border="0" cellpadding="0" cellspacing="0" class="game-record-table1">
        <tbody>
            <tr>
                <c:if test="${isLottery.paramValue!='true'}">
                    <th>${views.gameOrder_auto['游戏类型']}</th>
                </c:if>
                <th>${views.gameOrder_auto['游戏名称']}</th>
                <th width="20%">${views.gameOrder_auto['注单号']}</th>
                <th>${views.gameOrder_auto['投注时间']}</th>
                <th>${views.gameOrder_auto['派彩时间']}</th>
                <th>${views.gameOrder_auto['投注额']}</th>
                <th>${views.gameOrder_auto['有效投注额']}</th>
                <th>${views.gameOrder_auto['派彩']}</th>
                <th>
                    <gb:selectPure name="search.orderState" callback="query" cssClass="chosen-select-no-single" value="${command.search.orderState}" prompt="${views.gameOrder_auto['全部']}" listKey="key" listValue="${dicts.game.order_state[key]}" list="${orderState}"/>
                </th>
            </tr>
            <c:if test="${fn:length(command.result)<=0}">
                <tr>
                    <td class="no-content_wrap" colspan="8" style="text-align: center"><i class="fa fa-exclamation-circle"></i> ${views.bet['History.norecord']}</td>
                </tr>
            </c:if>
            <c:if test="${fn:length(command.result)>0}">
                <tr style="background: #ededed;">
                    <td colspan="5">
                        <span class="red m-r-sm al-bold">${fn:replace(views.gameOrder_auto['总共笔数'],"{0}" , command.paging.totalCount)}</span>
                        <span class="al-bold">
                            ${views.gameOrder_auto['彩池奖金']}：
                             <c:if test="${winningAmount>0}">
                                 <soul:button target="queryWinning" text="${siteCurrencySign}${soulFn:formatCurrency(winningAmount)}" opType="function"/>
                             </c:if>
                            <c:if test="${winningAmount<=0}">${siteCurrencySign}${soulFn:formatCurrency(winningAmount)}</c:if>
                        </span>
                    </td>
                    <td class="red">${soulFn:formatCurrency(singleAmount)}</td>
                    <td class="red">${soulFn:formatCurrency(effectAmount)}</td>
                    <td class="red">${siteCurrencySign}${soulFn:formatCurrency(profitAmount)}</td>
                    <td></td>
                </tr>
                <c:forEach items="${command.result}" var="i" varStatus="vs">
                    <tr style="${vs.index%2==0?'background: #f9f9f9;':''}">
                        <c:if test="${isLottery.paramValue!='true'}">
                        <td>${gbFn:getApiName(i.apiId.toString())}&nbsp;&nbsp;${gbFn:getGameTypeName(i.gameType)}</td>
                        </c:if>
                        <td>${gbFn:getGameName(i.gameId.toString())}</td>
                        <td>
                            <c:choose>
                                <c:when test="${i.terminal eq '2'}">
                                    <span class="fa fa-mobile mobile" data-content="${views.gameOrder_auto['手机投注']}" data-placement="top" data-trigger="focus" data-toggle="popover" data-container="body" role="button" class="help-popover" tabindex="0">
                                    </span>
                                </c:when>
                            </c:choose>
                            <a href="/gameOrder/gameRecordDetail.html?searchId=${command.getSearchId(i.id)}" nav-target="mainFrame">${i.betId}</a>
                        </td>
                        <td>
                            ${soulFn:formatDateTz(i.betTime, DateFormat.DAY, timeZone)}
                            </br>
                            ${soulFn:formatDateTz(i.betTime, DateFormat.SECOND, timeZone)}
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${i.orderState=='settle'&&!empty i.payoutTime}">
                                    ${soulFn:formatDateTz(i.payoutTime, DateFormat.DAY, timeZone)}
                                    </br>
                                    ${soulFn:formatDateTz(i.payoutTime, DateFormat.SECOND, timeZone)}
                                </c:when>
                                <c:otherwise>
                                    --
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>${soulFn:formatCurrency(i.singleAmount)}</td>
                        <td>
                            ${i.orderState!='settle'?'--':soulFn:formatCurrency(i.effectiveTradeAmount)}
                        </td>
                        <td>
                            ${i.orderState!='settle'?'--':soulFn:formatCurrency(i.profitAmount)}
                        </td>
                        <td><a href="/gameOrder/gameRecordDetail.html?searchId=${command.getSearchId(i.id)}" nav-target="mainFrame">${dicts.game.order_state[i.orderState]}</a></td>
                    </tr>
                </c:forEach>
            </c:if>
        </tbody>
    </table>
</div>
<soul:pagination/>