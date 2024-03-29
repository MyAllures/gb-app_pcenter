<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.PlayerGameOrderVo"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<form:form>
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right">
        <a class="cursor">${views.sysResource['投注记录']}</a></span>
    </div>
    <div class="return" style="margin-top: 1px">
        <%--<a href="/gameOrder/index.html"  nav-target="mainFrame" class="btn btn-gray btn-big">${views.gameOrder_auto['返回上一级']}</a>--%>
        <soul:button target="goToLastPage" text="${views.gameOrder_auto['返回上一级']}" opType="function" cssClass="btn btn-gray btn-big"/>
    </div>
</div>

<!--投注记录详细-->
<div class="rgeechar">
    <div class="record-detail">
        <c:set var="result" value="${command.result}"/>
        <table width="100%" border="0" cellspacing="0" cellpadding="0" class="">
            <tr>
                <td width="20%" class="datailname bold">${views.bet['History.view.playerAccount']}：</td>
                <td width="80%" class="arial"><%=SessionManager.getUserName()%></td>
            </tr>
            <tr>
                <td width="20%" class="datailname bold">${views.bet['History.view.betNo']}：</td>
                <td width="80%" class="arial">
                    ${result.betId}
                    <c:if test="${result.terminal eq '2'}">
                        &nbsp;
                        <span class="fa fa-mobile mobile" data-content="${views.gameOrder_auto['手机投注']}" data-placement="top" data-trigger="focus" data-toggle="popover" data-container="body" role="button" class="help-popover" tabindex="0">
                        </span>
                    </c:if>
                </td>
            </tr>
            <tr>
                <td height="34" class="datailname bold">${views.bet['History.view.apiProvide']}：</td>
                <td class="arial">${gbFn:getSiteApiName(result.apiId)}</td>
            </tr>
            <tr>
                <td class="datailname bold">${views.bet['History.view.gametype']}：</td>
                <td class="arial">
                    ${gbFn:getSiteApiName(result.apiId)}
                    <c:if test="${!empty gbFn:getGameTypeName(result.gameType)}">
                        >>${gbFn:getGameTypeName(result.gameType)}
                    </c:if>
                </td>
            </tr>
            <tr>
                <td class="datailname bold">${views.bet['History.view.betTime']}：</td>
                <td class="arial">${soulFn:formatDateTz(result.betTime,DateFormat.DAY_SECOND ,timeZone )}</td>
            </tr>
            <tr>
                <td class="datailname bold">${views.bet['History.view.transaction']}：</td>
                <td class="arial">
                    ${soulFn:formatCurrency(result.singleAmount)}
                </td>
            </tr>
            <tr>
                <td width="20%" class="datailname bold">${views.bet['History.view.payOutTime']}：</td>
                <td width="80%" class="arial">
                    <c:choose>
                        <c:when test="${result.orderState eq 'settle' && !empty result.payoutTime}">
                            ${soulFn:formatDateTz(result.payoutTime, DateFormat.DAY_SECOND,timeZone)}
                        </c:when>
                        <c:otherwise>--</c:otherwise>
                    </c:choose>
                </td>
            </tr>
            <tr>
                <td class="datailname bold">${views.bet['History.view.payOut']}：</td>
                <td class="arial">
                    <c:if test="${result.orderState=='settle'}">
                        <span class="orange">${soulFn:formatCurrency(result.profitAmount)}</span>
                    </c:if>
                    <c:if test="${result.orderState!='settle'}">--</c:if>
                </td>
            </tr>
            <c:if test="${result.winningAmount>0}">
                <tr>
                    <td class="datailname bold">${views.gameOrder_auto['彩池奖金']}：</td>
                    <td class="arial"><span class="orange">${soulFn:formatCurrency(result.winningAmount)}</span></td>
                </tr>
            </c:if>
            <tr>
                <td class="datailname bold">${views.bet['History.view.effectiveTransaction']}：</td>
                <td class="arial">
                    <c:if test="${result.orderState=='settle'}">
                        <span class="blue">${soulFn:formatCurrency(result.effectiveTradeAmount)}</span>
                    </c:if>
                    <c:if test="${result.orderState!='settle'}">--</c:if>
                </td>
            </tr>
            <tr>
                <td class="datailname bold">${views.bet['History.view.apiRecord']}：</td>
                <td>
                    <c:choose>
                        <%--体育投注--%>
                        <c:when test="${!empty result.betDetail && result.apiTypeId==3}">
                            <%@include file="SportsbookDetail.jsp"%>
                        </c:when>
                        <%--真人投注--%>
                        <c:when test="${!empty result.betDetail && result.apiTypeId==1}">
                            <%@include file="LiveDealerDetail.jsp"%>
                        </c:when>
                        <%--彩票投注--%>
                        <c:when test="${result.apiId==22}">
                            <%@include file="LotteryDetail.jsp"%>
                        </c:when>
                        <%--VR真人彩票--%>
                        <c:when test="${result.apiId==41}">
                            <%@include file="VRLotteryDetail.jsp"%>
                        </c:when>
                        <%--棋牌投注--%>
                        <c:when test="${!empty result.betDetail && result.apiTypeId==5}">
                            <%@include file="ChessPokerDetail.jsp"%>
                        </c:when>
                        <c:otherwise>
                            <c:forEach items="${resultArray}" var="array">
                                <table width="90%" border="0" cellspacing="0" cellpadding="0">
                                    <c:forEach items="${array}" var="json">
                                        <c:if test="${!empty views.gameOrder[json.key]||(result.apiId==3&&json.key=='type')||(result.apiId==1&&json.key=='ip')}">
                                            <tr>
                                                <td class="datailname datailback" style="width:30%">
                                                    <c:choose>
                                                        <%--DS ip--%>
                                                        <c:when test="${result.apiId==1&&json.key=='ip'}">
                                                            <c:set var="key" value="DS.${json.key}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--MG金额类型--%>
                                                        <c:when test="${json.key=='type'}">
                                                            ${views.gameOrder[json.value]}
                                                        </c:when>
                                                        <%--AG大厅类型--%>
                                                        <c:when test="${result.apiId==9&&json.key=='round'}">
                                                            <c:set var="key" value="AG.${json.key}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--SS 游戏类型--%>
                                                        <c:when test="${result.apiId==12&&json.key=='playType'}">
                                                            <c:set var="key" value="SS.${json.key}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--SA 玩家投注--%>
                                                        <c:when test="${result.apiId==17&&json.key=='betType'}">
                                                            <c:set var="key" value="SA.${json.key}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${views.gameOrder[json.key]}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="arial">
                                                    <c:choose>
                                                        <%--DS玩家投注--%>
                                                        <c:when test="${json.key=='liveMemberReportDetails'}">
                                                            <c:forEach items="${json.value}" var="v" varStatus="s">
                                                                <c:set var="value" value="${v['betType']}"/>
                                                                <c:set var="key" value="betType.${value}"/>
                                                                <c:if test="${!empty views.gameOrder[key]}">${views.gameOrder[key]}</c:if>
                                                                <c:if test="${empty views.gameOrder[key]}">
                                                                    <!--轮盘-->
                                                                    <c:if test="${fn:startsWith(value, 'RL')}">
                                                                        ${views.gameOrder['betTime.RL']}${fn:substringAfter(value, 'RL_')}
                                                                    </c:if>
                                                                    <c:if test="${!fn:startsWith(value, 'RL')}">
                                                                        ${v['betType']}
                                                                    </c:if>
                                                                </c:if>
                                                                <c:if test="${s.index<fn:length(json.value)-1}">
                                                                    ,
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--DS游戏结果--%>
                                                        <c:when test="${json.key=='resultList'}">
                                                            <!--百家乐、保险百家乐-->
                                                            <c:if test="${array['gameType']=='BACCARAT'||array['gameType']=='BACCARAT_INSURANCE'}">
                                                                <c:forEach var="value" items="${json.value}" varStatus="vs">
                                                                    <c:set var="key" value="BACCARAT${vs.index}.${value}"/>
                                                                    <c:if test="${vs.index!=3}">
                                                                        ${views.gameOrder[key]}&nbsp;
                                                                    </c:if>
                                                                    <c:if test="${vs.index==3}">
                                                                        ${views.gameOrder_auto['赢家点数']}：${value}
                                                                    </c:if>
                                                                </c:forEach>
                                                            </c:if>
                                                            <!--龙虎-->
                                                            <c:if test="${array['gameType']=='DRAGON_TIGER'}">
                                                                <c:set var="key" value="DRAGON_TIGER${json.value.get(0)}"/>
                                                                ${views.gameOrder[key]}
                                                            </c:if>
                                                            <!--骰宝-->
                                                            <c:if test="${array['gameType']=='SICBO'}">
                                                                (
                                                                <c:forEach var="value" items="${json.value}">
                                                                    <em class="gr gr-dice-${value} fs1"></em>
                                                                </c:forEach>
                                                                )
                                                            </c:if>
                                                            <!--轮盘-->
                                                            <c:if test="${array['gameType']=='ROULETTE'}">
                                                                ${json.value}
                                                            </c:if>
                                                            <!--色碟-->
                                                            <c:if test="${array['gameType']=='XOC_DIA'}">
                                                                <c:set var="key" value="resultList.${json.value}"/>
                                                                ${views.gameOrder[key]}
                                                            </c:if>
                                                            <!--牛牛-->
                                                            <c:if test="${array['gameType']=='BULL_BULL'}">
                                                                <c:set var="value" value="${json.value}"/>
                                                                <c:set var="key" value="BULL_BULL.${value[0]}"/>
                                                                ${views.gameOrder_auto['庄']}（${views.gameOrder_auto['点数']}【${views.gameOrder[key]}】，${views.gameOrder_auto['最大牌面']} 【
                                                                <c:set var="maxValue" value="${maxValue[1]}"/>
                                                                <c:set var="round" value="${maxValue%13==0?13:maxValue%13}"/>
                                                                <c:if test="${(maxValue/13).intValue()==0}">
                                                                    <em class="gr gr-spade-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${(maxValue/13).intValue()==1}">
                                                                    <em class="gr gr-heart-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${(maxValue/13).intValue()==2}">
                                                                    <em class="gr gr-club-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${(maxValue/13).intValue()==3||(maxValue/13).intValue()==4}">
                                                                    <em class="gr gr-diamond-${round} fs1"></em>
                                                                </c:if>
                                                                】）
                                                                <c:forEach var="i" begin="1" end="3" varStatus="v">
                                                                    </br>
                                                                    <c:set var="index" value="${3*(v.index-1)+2}"/>
                                                                    <c:set var="key" value="BULL_BULL.${value[index]}"/>
                                                                    ${views.gameOrder_auto['闲']}${v.index}(${views.gameOrder_auto['点数']}【${views.gameOrder[key]}】,
                                                                    ${views.gameOrder_auto['最大牌面']}【
                                                                    <c:set var="maxValue" value="${value[index+1]}"/>
                                                                    <c:set var="round" value="${maxValue%13==0?13:maxValue%13}"/>
                                                                    <c:if test="${(maxValue/13).intValue()==0}">
                                                                        <em class="gr gr-spade-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(maxValue/13).intValue()==1}">
                                                                        <em class="gr gr-heart-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(maxValue/13).intValue()==2}">
                                                                        <em class="gr gr-club-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(maxValue/13).intValue()==3||(maxValue/13).intValue()==4}">
                                                                        <em class="gr gr-diamond-${round} fs1"></em>
                                                                    </c:if>
                                                                    】,
                                                                    <c:set var="key" value="BULL_BULL.isWin.${value[index+2]}"/>
                                                                    ${views.gameOrder_auto['结果']}【${views.gameOrder[key]}】)
                                                                </c:forEach>
                                                            </c:if>
                                                        </c:when>
                                                        <%--DS结果牌--%>
                                                        <c:when test="${json.key=='pokerList'}">
                                                            <!--百家乐、保险百家乐-->
                                                            <c:if test="${array['gameType']=='BACCARAT'||array['gameType']=='BACCARAT_INSURANCE'}">
                                                                ${views.gameOrder_auto['庄']}：（
                                                                <c:forEach var="value" items="${json.value.get(1)}" varStatus="vs">
                                                                    <c:set var="round" value="${value%13==0?13:value%13}"/>
                                                                    <c:if test="${(value/13).intValue()==0}">
                                                                        <em class="gr gr-spade-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==1}">
                                                                        <em class="gr gr-heart-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==2}">
                                                                        <em class="gr gr-club-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==3||(value/13).intValue()==4}">
                                                                        <em class="gr gr-diamond-${round} fs1"></em>
                                                                    </c:if>
                                                                </c:forEach>
                                                                ）&nbsp;
                                                                ${views.gameOrder_auto['闲']}：（
                                                                <c:forEach var="value" items="${json.value.get(0)}" varStatus="vs">
                                                                    <c:set var="round" value="${value%13==0?13:value%13}"/>
                                                                    <c:if test="${(value/13).intValue()==0}">
                                                                        <em class="gr gr-spade-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==1}">
                                                                        <em class="gr gr-heart-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==2}">
                                                                        <em class="gr gr-club-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==3||(value/13).intValue()==4}">
                                                                        <em class="gr gr-diamond-${round} fs1"></em>
                                                                    </c:if>
                                                                </c:forEach>
                                                                ）
                                                            </c:if>
                                                            <!--龙虎-->
                                                            <c:if test="${array['gameType']=='DRAGON_TIGER'}">
                                                                <c:forEach var="value" items="${json.value}" varStatus="vs">
                                                                    <c:if test="${vs.index==0}">${views.gameOrder_auto['龙']}：</c:if>
                                                                    <c:if test="${vs.index==1}">${views.gameOrder_auto['虎']}：</c:if>
                                                                    <c:if test="${! empty value.get(0)}">
                                                                        <c:set var="value" value="${value.get(0)}"/>
                                                                    </c:if>
                                                                    <c:set var="round" value="${value%13==0?13:value%13}"/>
                                                                    <c:if test="${(value/13).intValue()==0}">
                                                                        <em class="gr gr-spade-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==1}">
                                                                        <em class="gr gr-heart-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==2}">
                                                                        <em class="gr gr-club-${round} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${(value/13).intValue()==3||(value/13).intValue()==4}">
                                                                        <em class="gr gr-diamond-${round} fs1"></em>
                                                                    </c:if>
                                                                    &nbsp;
                                                                </c:forEach>
                                                            </c:if>
                                                            <!--牛牛-->
                                                            <c:if test="${array['gameType']=='BULL_BULL'}">
                                                                ${views.gameOrder_auto['头牌']}：(
                                                                <c:set var="value" value="${json.value.get(0).get(0)}"/>
                                                                <c:set var="round" value="${value%13==0?13:value%13}"/>
                                                                <c:if test="${(value/13).intValue()==0}">
                                                                    <em class="gr gr-spade-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${(value/13).intValue()==1}">
                                                                    <em class="gr gr-heart-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${(value/13).intValue()==2}">
                                                                    <em class="gr gr-club-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${(value/13).intValue()==3||(value/13).intValue()==4}">
                                                                    <em class="gr gr-diamond-${round} fs1"></em>
                                                                </c:if>)
                                                                <c:forEach begin="1" end="4" varStatus="v">
                                                                    </br>
                                                                    <c:if test="${v.index==1}">${views.gameOrder_auto['庄']}&nbsp;（</c:if>
                                                                    <c:if test="${v.index!=1}">${views.gameOrder_auto['闲']}${v.index-1}（</c:if>
                                                                    <c:forEach var="value" items="${json.value.get(v.index)}">
                                                                        <c:set var="round" value="${value%13==0?13:value%13}"/>
                                                                        <c:if test="${(value/13).intValue()==0}">
                                                                            <em class="gr gr-spade-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${(value/13).intValue()==1}">
                                                                            <em class="gr gr-heart-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${(value/13).intValue()==2}">
                                                                            <em class="gr gr-club-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${(value/13).intValue()==3||(value/13).intValue()==4}">
                                                                            <em class="gr gr-diamond-${round} fs1"></em>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    )
                                                                </c:forEach>
                                                            </c:if>
                                                        </c:when>
                                                        <%--KG 玩家投注、投注详细--%>
                                                        <c:when test="${json.key=='BetType'||json.key=='BetSlip'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            <c:if test="${empty views.gameOrder[key]}">${json.value}</c:if>
                                                            <c:if test="${!empty views.gameOrder[key]}">${views.gameOrder[key]}</c:if>
                                                        </c:when>
                                                        <%--new MG金额类型--%>
                                                        <c:when test="${json.key=='type'}">
                                                            ${array['amount']}
                                                        </c:when>
                                                        <%---IM 玩家买的球队--%>
                                                        <c:when test="${json.key=='selection'}">
                                                            <%--H表示主队--%>
                                                            <c:if test="${json.value=='H'}">
                                                                ${array['homeTeam']}
                                                            </c:if>
                                                            <%--A表示客队--%>
                                                            <c:if test="${json.value=='A'}">
                                                                ${array['awayTeam']}
                                                            </c:if>
                                                        </c:when>
                                                        <%--IM、SS 盘口类型--%>
                                                        <c:when test="${json.key=='oddsType'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            <c:if test="${!empty views.gameOrder[key]}">
                                                                ${views.gameOrder[key]}
                                                            </c:if>
                                                            <c:if test="${empty views.gameOrder[key]}">${json.value}</c:if>
                                                        </c:when>
                                                        <%--GD游戏详细--%>
                                                        <c:when test="${json.key=='betArrays'}">
                                                            <c:if test="${! empty views.gameOrder['tableID']}">
                                                                ${views.gameOrder['tableID']}：${json.value.get(0)['tableID']}</br>
                                                            </c:if>
                                                            <c:if test="${! empty views.gameOrder['gameResult']}">
                                                                ${views.gameOrder['gameResult']}：
                                                                <c:set var="result" value="${fn:split(json.value.get(0)['gameResult'], ' ')}"/>
                                                                <%--GD百家乐--%>
                                                                <c:if test="${array['productID']=='Baccarat'}">
                                                                    <c:set var="result" value="${fn:split(json.value.get(0)['gameResult'], ' ')}"/>
                                                                    <c:forEach items="${result}" var="value" varStatus="vs">
                                                                        <c:if test="${value=='P'}">
                                                                            ${views.gameOrder_auto['闲']}：（
                                                                        </c:if>
                                                                        <c:if test="${value=='B'}">
                                                                            ) ${views.gameOrder_auto['庄']}：（
                                                                        </c:if>
                                                                        <c:set var="round" value="${result[vs.index+1]}"/>
                                                                        <c:if test="${round=='A'}">
                                                                            <c:set var="round" value="1"/>
                                                                        </c:if>
                                                                        <c:if test="${round=='J'}">
                                                                            <c:set var="round" value="11"/>
                                                                        </c:if>
                                                                        <c:if test="${round=='Q'}">
                                                                            <c:set var="round" value="12"/>
                                                                        </c:if>
                                                                        <c:if test="${round=='K'}">
                                                                            <c:set var="round" value="13"/>
                                                                        </c:if>
                                                                        <c:if test="${value=='SPADE'}">
                                                                            <em class="gr gr-spade-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${value=='HEART'}">
                                                                            <em class="gr gr-heart-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${value=='DIAMOND'}">
                                                                            <em class="gr gr-diamond-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${value=='CLUB'}">
                                                                            <em class="gr gr-club-${round} fs1"></em>
                                                                        </c:if>
                                                                        <c:if test="${vs.index==fn:length(result)-1}">
                                                                            ）
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </c:if>
                                                                <c:if test="${array['productID']!='Baccarat'}">
                                                                    ${json.value.get(0)['gameResult']}
                                                                </c:if>
                                                                </br>
                                                            </c:if>
                                                            <c:if test="${! empty views.gameOrder['winningBet']}">
                                                                ${views.gameOrder['winningBet']}：
                                                                <c:set var="result" value="${fn:split(json.value.get(0)['winningBet'], ',')}"/>
                                                                <%--GD百家乐--%>
                                                                <c:if test="${array['productID']=='Baccarat'}">
                                                                    <c:forEach items="${result}" var="value" varStatus="vs">
                                                                        <c:set var="v" value="winningBet.${fn:trim(value)}"/>
                                                                        ${views.gameOrder[v]}
                                                                        <c:if test="${vs.index!=fn:length(result)-1}">
                                                                            ,
                                                                        </c:if>
                                                                    </c:forEach>
                                                                </c:if>
                                                                <c:if test="${array['productID']!='Baccarat'}">
                                                                    ${json.value.get(0)['winningBet']}
                                                                </c:if>
                                                                </br>
                                                            </c:if>
                                                            <%--GD玩家投注--%>
                                                            <c:if test="${! empty views.gameOrder['subBetType']}">
                                                                ${views.gameOrder['subBetType']}：
                                                                <c:set var="key" value="subBetType.${json.value.get(0)['subBetType']}"/>
                                                                <%--玩家投注轮盘根据关键字来展示--%>
                                                                <c:if test="${empty views.gameOrder[key]&&!key.contains('Straight')&&!key.contains('Street')&&!key.contains('Split')&&!key.contains('Corner')&&!key.contains('Line')}">${json.value.get(0)['subBetType']}</c:if>
                                                                <c:if test="${key.contains('Straight')}">
                                                                    ${views.gameOrder['subBetType.Straight']}${fn:substringAfter(json.value.get(0)['subBetType'], "Straight")}
                                                                </c:if>
                                                                <c:if test="${key.contains('Street')||key.contains('Split')||key.contains('Corner')||key.contains('Line')}">
                                                                    ${views.gameOrder['subBetType.Street']}${fn:substringAfter(json.value.get(0)['subBetType'], "Street")}
                                                                </c:if>
                                                                <c:if test="${key.contains('Split')||key.contains('Corner')||key.contains('Line')}">
                                                                    ${views.gameOrder['Split']}${fn:substringAfter(json.value.get(0)['subBetType'], "Split")}
                                                                </c:if>
                                                                <c:if test="${key.contains('Corner')||key.contains('Line')}">
                                                                    ${views.gameOrder['Corner']}${fn:substringAfter(json.value.get(0)['subBetType'], "Corner")}
                                                                </c:if>
                                                                <c:if test="${key.contains('Line')}">
                                                                    ${views.gameOrder['Line']}${fn:substringAfter(json.value.get(0)['subBetType'], "Line")}
                                                                </c:if>
                                                                <c:if test="${!empty views.gameOrder[key]}">
                                                                    ${views.gameOrder[key]}
                                                                </c:if>
                                                            </c:if>
                                                        </c:when>
                                                        <%--OG投注区--%>
                                                        <c:when test="${json.key=='GameBettingContent'}">
                                                            <c:set value="${fn:split(json.value, '^')}" var="value"/>
                                                            ${value[0]}
                                                        </c:when>
                                                        <%--OG投注类型、玩家投注--%>
                                                        <c:when test="${json.key=='GameKind'||json.key=='GameBettingKind'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--SLC投注详细--%>
                                                        <c:when test="${json.key=='betDetail'}">
                                                            <c:set var="key" value="${json.key}.${fn:replace(json.value, ' ', '')}"/>
                                                            <c:set var="value" value="${views.gameOrder[key]}"/>
                                                            <c:if test="${!empty value}">${value}</c:if>
                                                            <c:if test="${empty value}">
                                                                <c:set var="len" value="${fn:length(fn:split(json.value, ','))}"/>
                                                                <c:forEach items="${fn:split(json.value, ',')}" var="i" varStatus="v">
                                                                    <c:set var="key" value="${json.key}.${fn:replace(i, ' ', '')}"/>
                                                                    <c:set var="value" value="${views.gameOrder[key]}"/>
                                                                    <c:if test="${!empty value}">${value}</c:if>
                                                                    <c:if test="${empty value}">
                                                                        <c:set var="len2" value="${fn:length(fn:split(i, ':'))}"/>
                                                                        <c:forEach items="${fn:split(i, ':')}" var="j" varStatus="v2">
                                                                            <c:set var="key" value="${json.key}.${fn:replace(j, ' ', '')}"/>
                                                                            <c:set var="value" value="${views.gameOrder[key]}"/>
                                                                            <c:if test="${!empty value}">${value}</c:if>
                                                                            <c:if test="${empty value}">
                                                                                <c:set var="len3" value="${fn:length(fn:split(j, ':'))}"/>
                                                                                <c:forEach items="${fn:split(j, '=')}" var="k" varStatus="v3">
                                                                                    <c:if test="${v3.index!=len3-1}">
                                                                                        =
                                                                                    </c:if>
                                                                                    <c:set var="key" value="${json.key}.${fn:replace(k, ' ', '')}"/>
                                                                                    <c:set var="value" value="${views.gameOrder[key]}"/>
                                                                                    <c:if test="${!empty value}">${value}</c:if>
                                                                                    <c:if test="${empty value}">${k}</c:if>
                                                                                </c:forEach>
                                                                            </c:if>
                                                                            <c:if test="${v2.index!=len2-1}">:</c:if>
                                                                        </c:forEach>
                                                                    </c:if>
                                                                    <c:if test="${v.index!=len-1}">,</c:if>
                                                                </c:forEach>
                                                            </c:if>
                                                        </c:when>
                                                        <%--AG游戏玩法--%>
                                                        <c:when test="${json.key=='playType'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--BB-玩家投注--%>
                                                        <c:when test="${json.key=='WagerDetail'}">
                                                            <c:forEach items="${fn:split(json.value, '*')}" var="i">
                                                                <c:set var="key" value="${json.key}.${array['GameType']}.${fn:split(i, ',')[0]}"/>
                                                                <c:if test="${!empty views.gameOrder[key]}">【${views.gameOrder[key]}】</c:if>
                                                                <c:if test="${empty views.gameOrder[key]}">【${fn:split(i, ',')[0]}】</c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--OG、BB游戏结果--%>
                                                        <c:when test="${json.key=='ResultType'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            <c:if test="${!empty views.gameOrder[key]}">
                                                                ${views.gameOrder[key]}
                                                            </c:if>
                                                            <c:if test="${empty views.gameOrder[key]}">
                                                                <c:if test="${command.result.orderState=='pending_settle'}">${views.gameOrder_auto['未结算']}</c:if>
                                                                <c:if test="${command.result.orderState=='cancel'}">${views.common_report['取消']}</c:if>
                                                                <c:if test="${command.result.orderState=='settle'&&command.result.profitAmount>0}">${views.gameOrder_auto['赢']}</c:if>
                                                                <c:if test="${command.result.orderState=='settle'&&command.result.profitAmount==0}">${views.gameOrder_auto['和']}</c:if>
                                                                <c:if test="${command.result.orderState=='settle'&&command.result.profitAmount<0}">${views.gameOrder_auto['输']}</c:if>
                                                            </c:if>
                                                        </c:when>
                                                        <c:when test="${json.key=='Result'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            <c:if test="${command.result.gameType=='Sportsbook'}">
                                                                <c:set var="key" value="${json.key}.Sportsbook.${json.value}"/>
                                                            </c:if>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--BB结果牌-百家乐--%>
                                                        <c:when test="${json.key=='Card'&&array['GameType']=='3001'}">
                                                            <c:forEach items="${fn:split(json.value, '*')}" var="value" varStatus="vs">
                                                                <c:if test="${vs.index==0}">
                                                                    ${views.gameOrder_auto['庄']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==1}">
                                                                    ${views.gameOrder_auto['闲']}：（
                                                                </c:if>
                                                                <c:forEach items="${fn:split(value, ',')}" var="i">
                                                                    <c:if test="${fn:contains(i, 'S')}">
                                                                        <em class="gr gr-spade-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'H')}">
                                                                        <em class="gr gr-heart-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'C')}">
                                                                        <em class="gr gr-club-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'D')}">
                                                                        <em class="gr gr-diamond-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                </c:forEach>
                                                                ）&nbsp;
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--BB结果牌-二八杠--%>
                                                        <c:when test="${json.key=='Card'&&array['GameType']=='3002'}">
                                                            ${json.value}
                                                        </c:when>
                                                        <%--BB结果牌-龙虎斗--%>
                                                        <c:when test="${json.key=='Card'&&array['GameType']=='3003'}">
                                                            <c:forEach items="${fn:split(json.value, '*')}" var="value" varStatus="vs">
                                                                <c:if test="${vs.index==0}">
                                                                    ${views.gameOrder_auto['龙']}：
                                                                </c:if>
                                                                <c:if test="${vs.index==1}">
                                                                    ${views.gameOrder_auto['虎']}：
                                                                </c:if>
                                                                <c:if test="${fn:contains(value, 'S')}">
                                                                    <em class="gr gr-spade-${fn:split(value, '.')[1]} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${fn:contains(value, 'H')}">
                                                                    <em class="gr gr-heart-${fn:split(value, '.')[1]} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${fn:contains(value, 'C')}">
                                                                    <em class="gr gr-club-${fn:split(value, '.')[1]} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${fn:contains(value, 'D')}">
                                                                    <em class="gr gr-diamond-${fn:split(value, '.')[1]} fs1"></em>
                                                                </c:if>
                                                                &nbsp;
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--BB结果牌-温州牌九--%>
                                                        <c:when test="${json.key=='Card'&&array['GameType']=='3006'}">
                                                            <c:forEach items="${fn:split(json.value, '*')}" var="value" varStatus="vs">
                                                                <c:if test="${vs.index==0}">
                                                                    ${views.gameOrder_auto['庄家']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==1}">
                                                                    ${views.gameOrder_auto['顺门']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==2}">
                                                                    ${views.gameOrder_auto['出门']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==3}">
                                                                    ${views.gameOrder_auto['到门']}：（
                                                                </c:if>
                                                                <c:forEach items="${fn:split(value, ',')}" var="i">
                                                                    <c:if test="${fn:contains(i, 'S')}">
                                                                        <em class="gr gr-spade-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'H')}">
                                                                        <em class="gr gr-heart-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'C')}">
                                                                        <em class="gr gr-club-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'D')}">
                                                                        <em class="gr gr-diamond-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                </c:forEach>
                                                                ）&nbsp;
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--BB结果牌-骰宝--%>
                                                        <c:when test="${json.key=='Card'&&array['GameType']=='3008'}">
                                                            (
                                                            <c:forEach var="value" items="${fn:split(json.value, ',')}">
                                                                <em class="gr gr-dice-${value} fs1"></em>
                                                            </c:forEach>
                                                            )
                                                        </c:when>
                                                        <%--BB结果牌-德州扑克--%>
                                                        <c:when test="${json.key=='Card'&&array['GameType']=='3010'}">
                                                            <c:forEach items="${fn:split(json.value, '*')}" var="value" varStatus="vs">
                                                                <c:if test="${vs.index==0}">
                                                                    ${views.gameOrder_auto['庄家']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==1}">
                                                                    ${views.gameOrder_auto['闲家']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==2}">
                                                                    ${views.gameOrder_auto['公牌']}：（
                                                                </c:if>
                                                                <c:forEach items="${fn:split(value, ',')}" var="i">
                                                                    <c:if test="${fn:contains(i, 'S')}">
                                                                        <em class="gr gr-spade-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'H')}">
                                                                        <em class="gr gr-heart-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'C')}">
                                                                        <em class="gr gr-club-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'D')}">
                                                                        <em class="gr gr-diamond-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                </c:forEach>
                                                                ）</br>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--BB结果牌-牛牛、三公--%>
                                                        <c:when test="${json.key=='Card'&&(array['GameType']=='3005'||array['GameType']=='3012')}">
                                                            <c:forEach items="${fn:split(json.value, '*')}" var="value" varStatus="vs">
                                                                <c:if test="${vs.index==0}">
                                                                    ${views.gameOrder_auto['庄']}&nbsp;&nbsp;：（
                                                                </c:if>
                                                                <c:if test="${vs.index==1}">
                                                                    ${views.gameOrder_auto['闲一']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==2}">
                                                                    ${views.gameOrder_auto['闲二']}：（
                                                                </c:if>
                                                                <c:if test="${vs.index==3}">
                                                                    ${views.gameOrder_auto['闲三']}：（
                                                                </c:if>
                                                                <c:forEach items="${fn:split(value, ',')}" var="i">
                                                                    <c:if test="${fn:contains(i, 'S')}">
                                                                        <em class="gr gr-spade-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'H')}">
                                                                        <em class="gr gr-heart-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'C')}">
                                                                        <em class="gr gr-club-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                    <c:if test="${fn:contains(i, 'D')}">
                                                                        <em class="gr gr-diamond-${fn:split(i, '.')[1]} fs1"></em>
                                                                    </c:if>
                                                                </c:forEach>
                                                                ）</br>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--PG奖金信息--%>
                                                        <c:when test="${json.key=='_bonusRewardItem'}">
                                                            <c:forEach items="${json.value.get(0)}" var="value">
                                                                ${value.key}${views.gameOrder[value.key]}：${value.value}</br>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--SS 游戏类型、赌注项目--%>
                                                        <c:when test="${json.key=='playType'||json.key=='betTypeCode'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--SS 会员赌注方式--%>
                                                        <c:when test="${json.key=='teamBetCode'}">
                                                            <c:set var="key" value="${json.key}.${array['betTypeCode']}.${json.value}"/>
                                                            <c:if test="${empty views.gameOrder[key]}">${json.value}</c:if>
                                                            <c:if test="${!empty views.gameOrder[key]}">${views.gameOrder[key]}</c:if>
                                                        </c:when>
                                                        <%--SS 联赛名称，球队名称--%>
                                                        <c:when test="${json.key=='leagueName'}">
                                                            ${json.value}
                                                            </br>
                                                            <%--homeAway":"H",表示A是主队--%>
                                                            <c:if test="${array['homeAway']=='H'}">${array['teamAname']}&nbsp;VS&nbsp; ${array['teamBname']}</c:if>
                                                            <c:if test="${array['homeAway']!='H'}">${array['teamBname']}&nbsp;VS&nbsp;${array['teamAname']}</c:if>
                                                        </c:when>
                                                        <%--ebet 玩家投注、开牌结果--%>
                                                        <c:when test="${json.key=='betMap'}">
                                                            <c:forEach items="${json.value}" var="i" varStatus="vs">
                                                                <c:set var="key" value="betMap.betType.${i['betType']}"/>
                                                                ${views.gameOrder[key]}
                                                                <c:if test="${!empty i['betNumber']}">
                                                                    【${i['betNumber']}】
                                                                </c:if>
                                                                <c:if test="${(fn:length(json.value)-1)!=vs.index}">,&nbsp;</c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--ebet 开牌结果--%>
                                                        <c:when test="${json.key=='judgeResult'}">
                                                            <c:forEach items="${json.value}" var="i" varStatus="vs">
                                                                <c:set var="key" value="betMap.betType.${i}"/>
                                                                ${views.gameOrder[key]}
                                                                <c:if test="${fn:length(json.value)-1!=vs.index}">,&nbsp;</c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--ebet 百家乐--%>
                                                        <c:when test="${array['gameType']=='1'&&(json.key=='bankerCards'||json.key=='playerCards')}">
                                                            <c:forEach items="${json.value}" var="i">
                                                                <c:set var="suit" value="${(i/13).intValue()}"/>
                                                                <c:set var="round" value="${i%13+2}"/>
                                                                <c:set var="round" value="${round>13?round-13:round}"/>
                                                                <c:if test="${suit==3}">
                                                                    <em class="gr gr-spade-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${suit==2}">
                                                                    <em class="gr gr-heart-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${suit==0}">
                                                                    <em class="gr gr-club-${round} fs1"></em>
                                                                </c:if>
                                                                <c:if test="${suit==1}">
                                                                    <em class="gr gr-diamond-${round} fs1"></em>
                                                                </c:if>
                                                            </c:forEach>
                                                        </c:when>
                                                        <%--SA 玩家投注--%>
                                                        <c:when test="${json.key=='betType'}">
                                                            <c:set var="key" value="${json.key}.${array['gameType']}.${json.value}"/>
                                                            <c:if test="${!empty views.gameOrder[key]}">
                                                                ${views.gameOrder[key]}
                                                            </c:if>
                                                            <c:if test="${empty views.gameOrder[key]}">
                                                                ${json.value}
                                                            </c:if>
                                                        </c:when>
                                                        <%--SA 投注客户端--%>
                                                        <c:when test="${json.key=='betSource'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            ${views.gameOrder[key]}
                                                        </c:when>
                                                        <%--沙巴货币--%>
                                                        <c:when test="${json.key=='currency'}">
                                                            <c:set var="key" value="${json.key}.${json.value}"/>
                                                            <c:if test="${empty views.gameOrder[key]}">
                                                                ${json.value}
                                                            </c:if>
                                                            <c:if test="${!empty views.gameOrder[key]}">
                                                                ${views.gameOrder[key]}
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${empty json.value&&json.value.toString() eq 'null'?'':json.value}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </table>
                                <br/>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </td>
            </tr>
        </table>
        <input type="hidden" id="betId"  value="${result.betId}"/>
        <input type="hidden" id="apiId" value="${result.apiId}">
        <c:if test="${result.apiId == 3}">
            <div class="row" style="margin-top: 20px;">
                <div style="text-align: center;">
                <soul:button target="gameDetail" size="size-large" precall=""
                        text="游戏详情" opType="function" cssClass="btn btn-outline btn-filter" />
                </div>
            </div>
        </c:if>
    </div>
</div>
</form:form>
<soul:import res="site/gameOrder/GameDetail"/>