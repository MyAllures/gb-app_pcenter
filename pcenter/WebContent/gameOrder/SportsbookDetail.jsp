<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerGameOrderVo"--%>
<%--@elvariable id="resultVo" type="so.wwb.gamebox.model.api.vo.ApiSportResultVo"--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="soulFn" uri="http://soul/fnTag" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<%--体育类投注详细--%>
<c:set var="p" value="${command.result}"/>
<c:set var="resultVo" value="${p.resultVo}"/>
<c:set var="len" value="${fn:length(resultVo.apiSportResultVoList)}"/>
<table width="90%" border="0" cellspacing="0" cellpadding="0">
    <tr>
        <td class="datailname datailback" style="width:30%">
            ${views.gameOrder_auto['方式']}：
        </td>
        <td class="arial">
            <c:choose>
                <%--<c:when test="${p.apiId==19}">
                    --
                </c:when>--%>
                <c:when test="${!empty p.betDetail}">
                    <gb:sportType apiId="${p.apiId}" betType="${resultVo.betType}" oddsType="${resultVo.oddsType}"/>
                </c:when>
                <c:when test="${empty p.betDetail && p.apiId==10}">
                    ${views.gameOrder_auto['游戏方未提供']}
                </c:when>
            </c:choose>
        </td>
    </tr>
    <tr>
        <td class="datailname datailback" style="width:30%">
            ${views.gameOrder_auto['详情']}：
        </td>
        <td class="al-left">
            <c:choose>
                <%--<c:when test="${p.apiId==19}">
                    --
                </c:when>--%>
                <c:when test="${!empty p.betDetail}">
                    <c:if test="${len>=1}">
                        <c:forEach items="${resultVo.apiSportResultVoList}" var="i" varStatus="vs">
                            <gb:sportView apiId="${p.apiId}" leagueName="${i.leagueName}" homeTeam="${i.homeTeam}" homeTeamId="${i.homeTeamId}" awayTeam="${i.awayTeam}" awayTeamId="${i.awayTeamId}" betScore="${i.betScore}" ftScore="${i.ftScore}" handicap="${i.handicap}" htScore="${i.htScore}" odds="${i.odds}" selection="${i.selection}" betType="${i.betType}" matchTime="${i.matchTime}" betTeamName="${i.betTeamName}"/>
                            <c:if test="${vs.index<len-1}">
                                <br/>
                                <br/>
                            </c:if>
                        </c:forEach>
                    </c:if>
                    <c:if test="${len<1}">
                        <gb:sportView apiId="${p.apiId}" leagueName="${resultVo.leagueName}" homeTeam="${resultVo.homeTeam}" homeTeamId="${resultVo.homeTeamId}" awayTeam="${resultVo.awayTeam}" awayTeamId="${resultVo.awayTeamId}" betScore="${resultVo.betScore}" ftScore="${resultVo.ftScore}" handicap="${resultVo.handicap}" htScore="${resultVo.htScore}" odds="${resultVo.odds}" betType="${resultVo.betType}" matchTime="${resultVo.matchTime}" selection="${resultVo.selection}" betTeamName="${resultVo.betTeamName}"/>
                    </c:if>
                </c:when>
                <c:when test="${empty p.betDetail && p.apiId==10}">
                    ${views.gameOrder_auto['游戏方未提供']}
                </c:when>
            </c:choose>
        </td>
    </tr>
</table>