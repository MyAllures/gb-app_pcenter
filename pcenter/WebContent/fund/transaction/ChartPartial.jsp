<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-4
  Time: 上午9:55
--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.PlayerTransactionListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:if test="${fn:length(command.result)<=0}">
    <div style="text-align:center;"><i class="fa fa-exclamation-circle"></i> ${views.fund_auto['暂无内容']}</div>
</c:if>
<c:set var="preTime" value=""></c:set>
<c:forEach items="${command.result}" var="pt" varStatus="status">
    <%--颜色--%>
    <c:set value="" var="_style"></c:set>
    <%--描述--%>
    <c:set value="" var="_desc"></c:set>
    <%--方向--%>
    <c:set value="" var="_direction"></c:set>
    <%--存款，返水，优惠，推荐 放左侧； left
        取款，转账放右侧； right
    --%>
    <%--
        存款 blue ,取款 green，转账 gray ，其他 orange
    --%>
    <c:choose>

        <c:when test="${pt.transactionType eq 'favorable'}">
            <%--优惠--%>
            <c:set value="left" var="_direction"></c:set>
            <c:set value="orange" var="_style"></c:set>
            <%--为什么会有三种写法呢 这是因为它们是互补的 。优惠描述的来源不单一 --%>
                    <c:set value="${pt._describe[language]}${dicts.common.transaction_way[pt._describe['transaction_way']]}${dicts.common.fund_type[pt._describe['transaction_way']]}" var="_desc"></c:set>
        </c:when>

        <c:when test="${pt.transactionType eq 'deposit'}">
            <%--充值--%>
            <c:set value="left" var="_direction"></c:set>
            <c:set value="blue" var="_style"></c:set>
            <c:if test="${pt.fundType=='atm_counter'}">
                <c:set value="${dicts.common.transaction_way[pt.transactionWay]}" var="_desc"></c:set>
            </c:if>
            <c:if test="${pt.fundType=='artificial_deposit'}">
                <c:set value="${views.fund['FundRecord.view.tips']}" var="_desc"></c:set>
            </c:if>
            <c:if test="${pt.fundType!='atm_counter'&&pt.fundType!='artificial_deposit'}">
                <c:set value="${dicts.common.fund_type[pt.fundType]}" var="_desc"></c:set>
            </c:if>
            <%--<c:if test="${not empty pt.transactionWay && not empty dicts.common.transaction_way[pt.transactionWay]}">
                <c:set value="${dicts.common.fund_type[pt.fundType]}${'-'.concat(dicts.common.transaction_way[pt.transactionWay])}${empty pt._describe['bankCode']?'':'-'}${dicts.common.bankname[pt._describe['bankCode']]}" var="_desc"></c:set>
            </c:if>
            <c:if test="${empty pt.transactionWay || empty dicts.common.transaction_way[pt.transactionWay]}">
                <c:set value="${dicts.common.fund_type[pt.fundType]}${empty pt._describe['bankCode']?'':'-'}${dicts.common.bankname[pt._describe['bankCode']]}" var="_desc"></c:set>
            </c:if>--%>
        </c:when>

        <c:when test="${pt.transactionType eq 'withdrawals'}">
            <%--提现--%>
            <c:set value="right" var="_direction"></c:set>
            <c:set value="green" var="_style"></c:set>
            <%--取款--%>
            <c:if test="${pt.fundType=='artificial_withdraw'}">
                <c:set value="${views.fund['FundRecord.view.manualWithdraw']}" var="_desc"></c:set>
            </c:if>
            <c:if test="${pt.fundType!='artificial_withdraw'}">
                <c:set value="${dicts.common.bankname[pt._describe['bankCode']]} ${views.fund['FundRecord.record.bankNoAfter']}${fn:substring(pt._describe['bankNo'],pt._describe['bankNo'].length()-4,pt._describe['bankNo'].length())}" var="_desc"></c:set>
            </c:if>
        </c:when>

        <c:when test="${pt.transactionType eq 'transfers'}">
        <%--转账:转入 转出 相对于钱包来说--%>
            <c:set value="right" var="_direction"></c:set>
            <c:set value="gray" var="_style"></c:set>
            <c:choose>
                <c:when test="${pt.fundType eq 'transfer_into'}">
                    <c:set value="${gbFn:getSiteApiName(pt._describe['API'].toString())} ${dicts.common.transaction_type[pt.transactionType]}${views.fund['FundRecord.record.to']} ${views.fund['FundRecord.record.wallet']}" var="_desc"></c:set>
                    <%--转入--%>
                </c:when>
                <c:when test="${pt.fundType eq 'transfer_out'}">
                    <c:set value="${views.fund['FundRecord.record.wallet']} ${dicts.common.transaction_type[pt.transactionType]}${views.fund['FundRecord.record.to']} ${gbFn:getSiteApiName(pt._describe['API'].toString())}" var="_desc"></c:set>
                    <%--转出--%>
                </c:when>
            </c:choose>
        </c:when>

        <c:when test="${pt.transactionType eq 'backwater'}">
            <%--返水--%>
            <c:set value="left" var="_direction"></c:set>
            <c:set value="orange" var="_style"></c:set>
            <c:set value="${pt._describe['date']} ${pt._describe['period']}${views.fund['FundRecord.record.period']}" var="_desc"></c:set>
        </c:when>

        <c:when test="${pt.transactionType eq 'recommend'}">
            <%--推荐--%>
            <c:set value="left" var="_direction"></c:set>
            <c:set value="orange" var="_style"></c:set>
            <c:choose>
                <c:when test="${pt._describe['rewardType'] eq'2'}">
                    <c:set value="${views.fund['FundRecord.record.friend']} ${pt._describe['username']}" var="_desc"></c:set>
                </c:when>
                <c:when test="${pt._describe['rewardType'] eq '3'}">
                    <c:set value="${views.fund['FundRecord.record.recmTip1']}${views.fund['FundRecord.record.friend']} ${pt._describe['username']}${views.fund['FundRecord.record.recmTip2']}" var="_desc"></c:set>
                </c:when>
            </c:choose>
        </c:when>
    </c:choose>

    <c:set var="_StringCreateTime" value="${soulFn:formatDateTz(pt.createTime, DateFormat.DAY, timeZone )}"></c:set>

  <%--如果是第一次循环 或者是和上一次循环日期不一样 就开始--%>
    <c:if test="${empty preTime || preTime ne _StringCreateTime}">
        <div class="chart-box">
        <div class="time">${soulFn:formatDateTz(command.now, DateFormat.DAY, timeZone ) eq _StringCreateTime ? views.fund_auto['今天']:_StringCreateTime}</div>
    </c:if>
    <%--
        存款 blue ,取款 green，转账 gray ，其他 orange
    --%>
    <input type="hidden" value="${soulFn:formatDateTz(pt.createTime, DateFormat.DAY, timeZone )}" id="asd"/>
    <input type="hidden" value="${timeZone}" id="timeZone"/>
    <c:choose>
        <c:when test="${_style eq 'green'}">
            <div class="exhibition ${_direction}">
                <i class="point icoo"></i>
                <i class="point green"></i>
                <div class="content left boxgreen">
                    <soul:button target="${root}/fund/transaction/view.html?searchId=${command.getSearchId(pt.id)}" text="${dicts.common.transaction_type[pt.transactionType]}${views.common['detail']}" opType="dialog">
                        <div class="content-left">
                            <span class="money">${soulFn:formatCurrency(pt.transactionMoney)}</span>
                            <span class="text">${dicts.common.transaction_type[pt.transactionType]}&nbsp;${_desc}</span>
                            <span class="text">${views.fund['FundRecord.record.transactionNo']}：${pt.transactionNo}</span>
                        </div>
                        <div class="content-right">
                            <span class="timer">${soulFn:formatDateTz(pt.createTime, DateFormat.MINUTE, timeZone )}</span>
                            <span class="state">${dicts.common.status[pt.status]}</span>
                        </div>
                    </soul:button>
                </div>
            </div>
        </c:when>

        <c:when test="${_style eq 'orange'}">
            <div class="exhibition ${_direction}">
                <i class="point icoo"></i>
                <i class="point orange"></i>
                <div class="content left boxorange">
                    <soul:button target="${root}/fund/transaction/view.html?searchId=${command.getSearchId(pt.id)}" text="${dicts.common.transaction_type[pt.transactionType]}${views.common['detail']}" opType="dialog">
                        <div class="content-left">
                            <span class="money">${soulFn:formatCurrency(pt.transactionMoney)}</span>
                            <span class="text">${dicts.common.transaction_type[pt.transactionType]}&nbsp;${_desc}</span>
                            <span class="text">${views.fund['FundRecord.record.transactionNo']}：${pt.transactionNo}</span>
                        </div>
                        <div class="content-right">
                            <span class="timer">${soulFn:formatDateTz(pt.createTime, DateFormat.MINUTE, timeZone )}</span>
                            <span class="state">${dicts.common.status[pt.status]}</span>
                        </div>
                    </soul:button>
                </div>
            </div>
        </c:when>

        <c:when test="${_style eq 'gray'}">
            <div class="exhibition ${_direction}">
                <i class="point icoo"></i>
                <i class="point gray"></i>
                <div class="content left boxgray">
                    <soul:button size="size-wide"  target="${root}/fund/transaction/transfers/playerTransfersList.html?search.beginCreateTime=${soulFn:formatDateTz(pt.createTime, DateFormat.DAY, timeZone )}" text="${dicts.common.transaction_type['transfers']}${views.common['detail']}" opType="dialog" tag="a">
                        <div class="content-left">
                            <span class="money">${pt._count}<i class="moneytext">${views.fund['FundRecord.chart.transferNum']}</i></span>
                            <span class="text">${views.fund['FundRecord.chart.lastTransaction']}</span>
                            <span class="text">${soulFn:formatDateTz(pt.createTime, DateFormat.MINUTE, timeZone )}&nbsp;<%--15:00从我的钱包转到QQ钱包 --%>${_desc}</span>
                        </div>
                        <div class="content-right">
                            <span class="timer">${soulFn:formatDateTz(pt.createTime, DateFormat.MINUTE, timeZone )}</span>
                            <span class="state">${soulFn:formatCurrency(pt.transactionMoney)}</span>
                        </div>
                    </soul:button>
                </div>
            </div>
        </c:when>

        <c:when test="${_style eq 'blue'}">
            <div class="exhibition ${_direction}">
                <i class="point icoo"></i>
                <i class="point blue"></i>
                <div class="content left boxblue">
                    <soul:button target="${root}/fund/transaction/view.html?searchId=${command.getSearchId(pt.id)}" text="${dicts.common.transaction_type[pt.transactionType]}${views.common['detail']}" opType="dialog">
                        <div class="content-left">
                            <span class="money">${soulFn:formatCurrency(pt.transactionMoney)}</span>
                            <span class="text">
                                 ${dicts.common.transaction_type[pt.transactionType]}${pt.isFirstRecharge?'-'.concat(views.fund_auto['首存']):''}
                                <c:if test="${pt.transactionType eq 'recommend'}">${dicts.common.transaction_way[pt.transactionWay]}</c:if>
                                <c:if test="${_desc != ''}">-${_desc}</c:if>
                            <%--${dicts.common.transaction_type[pt.transactionType]}&nbsp;${_desc}--%>
                            </span>
                            <span class="text">${views.fund['FundRecord.record.transactionNo']}：${pt.transactionNo}</span>
                        </div>
                        <div class="content-right">
                            <span class="timer">${soulFn:formatDateTz(pt.createTime, DateFormat.MINUTE, timeZone )}</span>
                            <span class="state">${dicts.common.status[pt.status]}</span>
                        </div>
                    </soul:button>
                </div>
            </div>
        </c:when>
    </c:choose>



    <c:if test="${status.last}">
        <div class="exhibition">
          <div class="content left"></div>
        </div>
    </c:if>
    <c:set var="preTime" value="${_StringCreateTime}"></c:set>
    <%--如果是 最后一个 或者下一个 与当前日期不一样 就结束--%>
    <c:if test="${status.last || empty command.result.get(status.index+1) || soulFn:formatDateTz(command.result.get(status.index+1).createTime, DateFormat.DAY, timeZone ) ne preTime}">
        </div>
    </c:if>

</c:forEach>






