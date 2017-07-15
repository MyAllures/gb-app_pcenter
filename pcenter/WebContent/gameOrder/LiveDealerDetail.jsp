<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerGameOrderVo"--%>
<%--@elvariable id="resultVo" type="so.wwb.gamebox.model.api.vo.ApiLiveResultVo"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<%--真人投注详细--%>
<c:set var="p" value="${command.result}"/>
<c:set var="resultVo" value="${p.resultVo}"/>
<table width="90%" border="0" cellspacing="0" cellpadding="0">
    <c:if test="${! empty resultVo.tableInfo && resultVo.tableInfo !='null'}">
    <tr>
        <td class="datailname datailback" style="width:30%">
            ${views.gameOrder_auto['场次']}：
        </td>
        <td class="arial">
           ${resultVo.tableInfo eq 'null'?'':resultVo.tableInfo}
        </td>
    </tr></c:if>
    <tr>
        <td class="datailname datailback" style="width:30%">
            ${views.gameOrder_auto['玩家下注']}：
        </td>
        <td class="arial">
            <gb:liveDealerSelection apiId="${p.apiId}" selectionVoSet="${resultVo.selectionVoSet}" betType="${resultVo.betType}"/>
        </td>
    </tr>
    <tr>
        <td class="datailname datailback" style="width:30%">
            ${views.gameOrder_auto['游戏详细']}：
        </td>
        <td class="arial">
            <%@include file="/report/betting/LiveDealerResult.jsp"%>
        </td>
    </tr>
</table>