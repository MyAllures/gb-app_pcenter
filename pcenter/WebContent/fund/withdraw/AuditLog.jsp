<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-10-28
  Time: 下午3:00
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body style="background-color: #ffffff">
<form class="">
    <div class="modal-body theme-popcon">
        <div class="table-responsive tab-border-1 modal-full-screen">
            <table class="table table-full-screen" width="100%" border="0" cellspacing="0" cellpadding="0">
                <thead>
                <tr>
                    <th>${views.fund['withdraw.edit.playerWithdraw.despoitTime']}</th>
                    <%--<th>${views.fund['withdraw.edit.playerWithdraw.effectiveTransation']}</th>--%>
                    <th>${views.fund['withdraw.edit.playerWithdraw.despoitAmount']}</th>
                    <%--<th>${views.fund['withdraw.edit.playerWithdraw.relaxedAmounts']}</th>--%>

                    <th>${views.fund['withdraw.edit.playerWithdraw.despoitAudit']}</th>
                    <th>${views.fund['withdraw.check.playerWithdraw.forAdministrationCost']}</th>

                    <th>${views.fund['withdraw.edit.playerWithdraw.favourableAmount']}</th>
                    <th>${views.fund['withdraw.edit.playerWithdraw.favourableAudit']}</th>
                    <th>${views.fund['withdraw.edit.playerWithdraw.favourableDeduction']}</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${list}" var="s" varStatus="vs">
                    <tr>
                        <td>
                                ${soulFn:formatDateTz(s.completionTime, DateFormat.DAY_SECOND,timeZone)}
                            <input type="hidden" name="feeList[${vs.index}].id" value="${s.id}" >
                        </td>
                        <%--<td>${empty s.effectiveTransaction?0:s.effectiveTransaction}</td>--%>
                        <td>
                            <c:if test="${s.transactionType!='deposit'}">--</c:if>
                            <c:if test="${s.transactionType=='deposit'}">
                                <c:if test="${s.transactionMoney eq null}">--</c:if>
                                <c:if test="${s.transactionMoney != null}">${dicts.common.currency_symbol[user.defaultCurrency]}${soulFn:formatInteger(s.transactionMoney)}${soulFn:formatDecimals(s.transactionMoney)}</c:if>
                            </c:if>
                        </td>
                        <%--<td>${soulFn:formatInteger(s.relaxingQuota)}${soulFn:formatDecimals(s.relaxingQuota)}</td>--%>

                        <td>
                            <c:if test="${s.rechargeAuditPoints eq null}">
                                --
                            </c:if>
                            <c:if test="${s.rechargeAuditPoints != null}">
                                <c:if test="${empty s.effectiveTransaction}">
                                    <c:set var="sub" value="${s.remainderEffectiveTransaction+s.relaxingQuota}"></c:set>
                                </c:if>
                                <c:if test="${not empty s.effectiveTransaction}">
                                    <c:set var="sub" value="${s.effectiveTransaction+s.remainderEffectiveTransaction+s.relaxingQuota}"></c:set>
                                </c:if>

                                <c:set var="parent" value="${s.rechargeAuditPoints<0?0:s.rechargeAuditPoints}"></c:set>
                                ${soulFn:formatInteger(sub)}${soulFn:formatDecimals(sub)}
                                /
                                ${soulFn:formatInteger(parent)}${soulFn:formatDecimals(parent)}
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${s.administrativeFee eq null}">
                                --
                            </c:if>
                            <c:if test="${s.administrativeFee==0}">
                                <li class="green">${views.fund['withdraw.edit.playerWithdraw.passThrough']}</li>
                            </c:if>
                            <c:if test="${s.administrativeFee>0}">
                                <li class="co-red3">
                                    ${dicts.common.currency_symbol[user.defaultCurrency]}
                                    -${soulFn:formatInteger(s.administrativeFee)}${soulFn:formatDecimals(s.administrativeFee)}
                                </li>
                            </c:if>
                        </td>

                        <td>
                            <c:if test="${s.transactionType!='deposit'}">
                                <c:if test="${s.transactionMoney eq null}">--</c:if>
                                <c:if test="${s.transactionMoney != null}">${dicts.common.currency_symbol[user.defaultCurrency]}${soulFn:formatInteger(s.transactionMoney)}${soulFn:formatDecimals(s.transactionMoney)}</c:if>
                            </c:if>
                            <c:if test="${s.transactionType=='deposit'}">
                            --
                            </c:if>

                        </td>
                        <td>
                            <c:if test="${s.favorableAuditPoints eq null}">--</c:if>
                            <c:if test="${s.favorableAuditPoints != null}">

                                <c:if test="${empty s.effectiveTransaction}">
                                    <c:set var="sub" value="${s.favorableRemainderEffectiveTransaction}"></c:set>
                                </c:if>
                                <c:if test="${not empty s.effectiveTransaction}">
                                    <c:set var="sub" value="${s.effectiveTransaction+s.favorableRemainderEffectiveTransaction}"></c:set>
                                </c:if>

                                <c:set var="parent" value="${s.favorableAuditPoints-s.relaxingQuota<0?0:s.favorableAuditPoints}"></c:set>
                                ${soulFn:formatInteger(sub)}${soulFn:formatDecimals(sub)}
                                /
                                ${soulFn:formatInteger(parent)}${soulFn:formatDecimals(parent)}


                                <%--${soulFn:formatInteger(s.favorableAuditPoints)}${soulFn:formatDecimals(s.favorableAuditPoints)}--%>
                            </c:if>
                        </td>
                        <td>
                            <c:if test="${s.deductFavorable eq null}">
                                --
                            </c:if>
                            <c:if test="${s.deductFavorable==0}">
                                <li class="green">${views.fund['withdraw.edit.playerWithdraw.passThrough']}</li>
                            </c:if>
                            <c:if test="${s.deductFavorable>0}">
                                <li class="co-red3">
                                    ${dicts.common.currency_symbol[user.defaultCurrency]}
                                    -${soulFn:formatInteger(s.deductFavorable)}${soulFn:formatDecimals(s.deductFavorable)}
                                </li>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>

            </table>
        </div>

    </div>
    <div class="modal-footer">
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/ShowAuditLog"/>
</html>
