<%--@elvariable id="command" type="so.wwb.gamebox.model.master.operation.vo.VPreferentialRecodeListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--//region your codes １-->
<div class="chart-table info-notice">
    <table border="0" cellpadding="0" cellspacing="0" class="table dataTable">
        <thead>
            <tr>
                <th>${views.preferential_auto['申请时间']}</th>
                <th>${views.preferential_auto['申请单号']}</th>
                <th style="width: 400px">${views.preferential_auto['活动名称']}</th>
                <th>${views.preferential_auto['申请金额']}</th>
                <th>${views.preferential_auto['优惠金状态']}</th>
                <th>${views.preferential_auto['优惠稽核']}</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach items="${command.result}" var="p">
                <tr>
                    <td>${soulFn:formatDateTz(p.applyTime,DateFormat.DAY_SECOND,timeZone)}</td>
                    <td>${p.transactionNo}</td>
                    <td class="save-title" data-toggle="tooltip" data-placement="left" >
                        <div class="elli" style="height: 14px" title="${empty p.activityName? views.preferential_auto['系统优惠']:p.activityName}">${empty p.activityName? views.preferential_auto['系统优惠']:p.activityName}</div>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.checkState eq 'success'||p.checkState eq '2'}">
                                ${siteCurrencySign}${soulFn:formatCurrency(p.preferentialValue)}
                            </c:when>
                            <c:otherwise>
                                ---
                            </c:otherwise>
                        </c:choose>

                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.checkState eq 'success'||p.checkState eq '2' || p.checkState eq '4'}">
                                ${views.preferential_auto['已到账']}
                            </c:when>
                            <c:when test="${p.checkState eq '1'}">
                                ${views.preferential_auto['待审核']}
                            </c:when>
                            <c:when test="${p.checkState eq '0'}">
                                ${views.preferential_auto['进行中']}
                            </c:when>
                            <c:otherwise>
                                ${views.preferential_auto['已拒绝']}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${p.checkState eq 'success'||p.checkState eq '2'}">
                                ${p.preferentialAudit}${views.preferential_auto['倍']}
                            </c:when>
                            <c:otherwise>
                                ---
                            </c:otherwise>
                        </c:choose>

                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<soul:pagination/>
<!--//endregion your codes １-->


