<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerGameOrderVo"--%>
<%--@elvariable id="resultVo" type="so.wwb.gamebox.model.api.vo.ApiLotteryResultVo"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<%--真人投注详细--%>
<c:set var="p" value="${command.result}"/>
<c:set var="resultVo" value="${p.resultVo}"/>
<table width="90%" border="0" cellspacing="0" cellpadding="0">
    <c:if test="${!empty resultVo}">
        <tr>
            <td class="datailname datailback" style="width:30%">
                ${views.gameOrder_auto['彩种']}：
            </td>
            <td class="arial">
                ${dicts.lottery.lottery[resultVo.code]}
            </td>
        </tr>
        <tr>
            <td class="datailname datailback" style="width:30%">
                ${views.gameOrder_auto['期号']}：
            </td>
            <td class="arial">
                ${resultVo.expect}
            </td>
        </tr>
        <tr>
            <td class="datailname datailback" style="width:30%">
                ${views.gameOrder_auto['赔率']}：
            </td>
            <td class="arial">
                ${resultVo.odd}
            </td>
        </tr>
        <tr>
            <td class="datailname datailback" style="width:30%">
                ${views.gameOrder_auto['下注内容']}：
            </td>
            <td class="arial">
                ${dicts.lottery.lottery_betting[resultVo.betCode]}-${resultVo.betNum}
            </td>
        </tr>
    </c:if>
    <c:if test="${empty resultVo && !empty resultArray}">
        <c:forEach items="${resultArray}" var="array">
            <tr>
                <td class="datailname datailback" style="width:30%">
                    ${views.gameOrder_auto['彩种']}：
                </td>
                <td class="arial">
                    ${dicts.lottery.lottery[array['code']]}
                </td>
            </tr>
            <tr>
                <td class="datailname datailback" style="width:30%">
                    ${views.gameOrder_auto['期号']}：
                </td>
                <td class="arial">
                    ${array['expect']}
                </td>
            </tr>
            <tr>
                <td class="datailname datailback" style="width:30%">
                    ${views.gameOrder_auto['赔率']}：
                </td>
                <td class="arial">
                    ${array['odd']}
                </td>
            </tr>
            <tr>
                <td class="datailname datailback" style="width:30%">
                    ${views.gameOrder_auto['下注内容']}：
                </td>
                <td class="arial">
                    ${dicts.lottery.lottery_betting[array['bet_code']]}-${array['bet_num']}
                </td>
            </tr>
        </c:forEach>
    </c:if>
</table>