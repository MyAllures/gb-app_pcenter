<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.VPlayerApiListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form>
    <div class="theme-popcon">
        <div class="text"></div>
        <p>
            ${views.fund['Transfer.recoveryMoney.recoveryAllGame']}&nbsp;&nbsp;
            <soul:button target="${root}/fund/playerTransfer/recovery.html" text="${views.fund['Transfer.recoveryMoney.recoveryAll']}" opType="ajax" tag="button" cssClass="btn btn-gray middle-big" confirm="${views.fund['Transfer.recoveryMoney.recoveryTips']}" callback="refresh"/>
        </p>
        <div class="poptable">
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tbody>
                    <c:forEach items="${command.result}" var="i">
                        <tr>
                            <td>${gbFn:getSiteApiName(i.apiId.toString())}</td>
                            <td>${soulFn:formatCurrency(i.money)}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${(i.money>0&&i.transferState=='pending_confirm')||i.taskStatus}">
                                        <span>${views.fund['Transfer.recoveryMoney.recoveryProcess']}</span>
                                    </c:when>
                                    <c:when test="${i.money>0}">
                                        <soul:button target="${root}/fund/playerTransfer/recovery.html?type=singlePlayerApi&searchId=${command.getSearchId(i.id)}" text="${views.fund_auto['回收资金']}" opType="ajax" confirm="${fn:replace(views.fund['Transfer.recoveryMoney.confirmRecoveryApiMoney'], '{0}', gbFn:getSiteApiName(i.apiId.toString()))}" callback="refresh"/>
                                    </c:when>
                                    <c:otherwise>
                                        <span>${views.fund['Transfer.recoveryMoney.recoveryMoney']}</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/transfers/RecoveryMoney"/>
</html>

