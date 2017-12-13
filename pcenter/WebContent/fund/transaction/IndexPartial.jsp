<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-2
  Time: 上午10:03
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="chart-table">
    <table class="table table-striped table-hover dataTable" width="100%" border="0" cellpadding="0" cellspacing="0">
        <thead>
        <tr>
            <th width="20%">${views.fund['FundRecord.record.transactionNo']}</th>
            <th width="15%">${views.fund['FundRecord.record.createTime']}</th>
            <th width="24%" data-selector=".transactionType_type" data-name="search.transactionType">
                <gb:selectPure callback="query" name="" value="${command.search.transactionType}" list="${command.dictCommonTransactionType}" prompt="${views.fund['FundRecord.record.allType']}"></gb:selectPure>
            </th>
            <th width="12%">${views.fund['FundRecord.record.transactionMoney']}</th>
            <th width="13%">${views.fund['FundRecord.record.balance']}</th>
            <th width="9%" data-selector=".transactionType_status" data-name="search.status" style="padding-left: 0">
                <gb:selectPure callback="query" name="" value="${command.search.status}" list="${command.dictCommonStatus}" prompt="${views.fund['FundRecord.record.allStatus']}"></gb:selectPure>
            </th>
            <th width="8%">${views.fund['FundRecord.record.options']}</th>
        </tr>
        <thead>
        <tbody>
    <%--

              投注记录表:player_transaction 字段 transaction_data, 各个交易方式需要保存的数据

              存款:{"bankCode":"","realName":"player","favorable":"1","poundage":"","bankOrder":""}
              存款:{"银行代码":"","用户名":"","优惠":"","手续费":"","银行订单号":""}

              取款:{"bankCode":"","bankNo":"","withdrawStatus":""}
              取款:{"bankCode":"","银行卡号":"","稽核状态":""}


              transfers 转账(转入,转出): API id    {"API":2}

              backwater 返水:时间+期数; {"period":"1","date":"2015-05-09"}

              favorable 优惠:优惠活动名称; {'zh_CN':'','zh_TW':'','en_US':''...}  //存优惠属于活动的活动名称
              favorable 优惠:优惠活动名称; {"en_US":"存就送-层级15","zh_TW":"存就送-层级15","zh_CN":"存就送-层级15"}

              favorable 优惠:优惠活动名称; {"transaction_way":""} //transaction_way存不属于活动的优惠，取值大部分来自transaction_way 除了refund_fee(返手续费)取自fundType

              recommend 单次推荐: {"username":"","rewardType":""}
              username - 不论推荐奖励类型是什么 username存对方的username
              rewardType:  2-推荐奖励  3-被推荐奖励
              eg：
              catban (1001)推荐fly(1002)
              1001: {"username":"fly","rewardType":"2"}
              1002: {"username":"catban","rewardType":"3"}

              --银行代码为 字典 module = common and dict_type = bankname

          --%>
        <c:forEach items="${command.result}" var="pt">
            <c:set value="" var="_symbol"></c:set>
            <c:set value="" var="_desc"></c:set>
            <c:set value="${root}/fund/transaction/view.html?searchId=${command.getSearchId(pt.id)}" var="_viewUrl"></c:set>
            <c:choose>
                <c:when test="${pt.transactionType eq 'favorable'}">
                    <%--优惠--%>
                    <c:set value="+" var="_symbol"></c:set>
                    <%--为什么会有三种写法呢 这是因为它们是互补的 。优惠描述的来源不单一 --%>
                    <c:set value="${pt._describe[language]}${dicts.common.transaction_way[pt._describe['transaction_way']]}
                    ${dicts.common.fund_type[pt._describe['transaction_way']]}" var="_desc"></c:set>
                    <%-- 返手续费的弹窗 弹该笔反手续费对应的存款订单的详情窗--%>
                    <c:if test="${pt.fundType eq 'refund_fee'}">
                        <c:set value="${root}/fund/transaction/refundFeeView.html?searchId=${command.getSearchId(pt.id)}" var="_viewUrl"></c:set>
                    </c:if>
                </c:when>
                <c:when test="${pt.transactionType eq 'deposit'}">
                    <%--存款--%>
                    <c:set value="+" var="_symbol"></c:set>
                    <c:if test="${pt.fundType=='atm_counter'}">
                        <c:set value="${dicts.common.transaction_way[pt.transactionWay]}" var="_desc"></c:set>
                    </c:if>
                    <c:if test="${pt.fundType=='artificial_deposit'}">
                        <c:set value="${views.fund['FundRecord.view.tips']}" var="_desc"></c:set>
                    </c:if>
                    <c:if test="${pt.fundType!='atm_counter'&&pt.fundType!='artificial_deposit'}">
                        <c:set value="${dicts.common.fund_type[pt.fundType]}" var="_desc"></c:set>
                    </c:if>
                </c:when>
                <c:when test="${pt.transactionType eq 'withdrawals'}">
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
                    <c:choose>
                        <c:when test="${pt.fundType eq 'transfer_into'}">
                            <c:set value="+" var="_symbol"></c:set>
                            <c:set value="${gbFn:getSiteApiName(pt._describe['API'].toString())}${views.fund_auto['转入']}${views.fund['FundRecord.record.to']} ${views.fund['FundRecord.record.wallet']}" var="_desc"></c:set>
                            <%--转入--%>
                        </c:when>
                        <c:when test="${pt.fundType eq 'transfer_out'}">
                            <c:set value="${views.fund['FundRecord.record.wallet']}${views.fund_auto['转出']}${views.fund['FundRecord.record.to']} ${gbFn:getSiteApiName(pt._describe['API'].toString())}" var="_desc"></c:set>
                            <%--转出--%>
                        </c:when>
                    </c:choose>
                </c:when>
                <c:when test="${pt.transactionType eq 'backwater'}">
                    <%--返水--%>
                    <c:set value="+" var="_symbol"></c:set>
                    <c:set value="${pt._describe['period']}${views.fund['FundRecord.record.period']}" var="_desc"></c:set>
                </c:when>
                <c:when test="${pt.transactionType eq 'recommend'}">
                    <%--推荐--%>
                    <c:set value="+" var="_symbol"></c:set>

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

            <tr>
                <td>${pt.transactionNo}</td>
                <td>${soulFn:formatDateTz(pt.createTime, DateFormat.DAY_MINUTE, timeZone )}</td>
                <td>
                    ${dicts.common.transaction_type[pt.transactionType]}${pt.isFirstRecharge&&pt.fundType!='artificial_deposit'?'-'.concat(views.fund_auto['首存']):''}
                    <c:if test="${pt.transactionType eq 'recommend'}">${dicts.common.transaction_way[pt.transactionWay]}</c:if>
                    <c:if test="${_desc != ''}"><br>${_desc}</c:if>

                </td>
                <td>
                    <span class="${_symbol eq '+'?'green':'orange'}">${_symbol}${soulFn:formatCurrency(pt.transactionMoney)}</span>
                    <c:if test="${pt._describe['bitAmount']>0}">
                        </br>
                        <c:set var="digiccySymbol" value="${dicts.common.currency_symbol[_describe['bankCode']]}"/>
                       ${empty digiccySymbol?'Ƀ':digiccySymbol}<fmt:formatNumber value="${pt._describe['bitAmount']}" pattern="#.########"/>
                    </c:if>
                </td>
                <td>${soulFn:formatCurrency(pt.balance)}</td>
                <td style="padding-left: 0">
                    <c:choose>
                        <c:when test="${pt.status eq 'success'}">
                            <span class="green">${dicts.common.status[pt.status]}</span>
                        </c:when>
                        <c:when test="${pt.status eq 'failure'}">
                            <span class="gary">${dicts.common.status[pt.status]}</span>
                        </c:when>
                        <c:when test="${pt.status eq 'pending'}">
                            <span class="red">${dicts.common.status[pt.status]}</span>
                        </c:when>
                        <c:otherwise>
                            <span class="orange">${dicts.common.status[pt.status]}</span>
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${pt.transactionType eq 'transfers'}">
                            --
                        </c:when>
                        <c:otherwise>
                            <soul:button target="${_viewUrl}" text="${dicts.common.transaction_type[pt.transactionType]}${views.common['detail']}" opType="dialog" size="jp-open-dialog-700">
                                ${views.common['detail']}
                            </soul:button>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </c:forEach>
    </tbody>
    </table>
</div>
<soul:pagination cssClass="row bdtop3"/>
