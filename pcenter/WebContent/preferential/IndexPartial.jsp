<%@ page import="so.wwb.gamebox.model.SiteParamEnum" %><%--@elvariable id="command" type="so.wwb.gamebox.model.master.operation.vo.VPreferentialRecodeListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--//region your codes １-->
<c:set var="activityHallSwitch" value="<%=ParamTool.getSysParam(SiteParamEnum.ACTIVITY_HALL_SWITCH)%>"></c:set><!-- 活动大厅开关 -->
<div class="chart-table info-notice">
    <table border="0" cellpadding="0" cellspacing="0" class="table dataTable">
        <thead>
            <tr>
                <th>${views.preferential_auto['申请时间']}</th>
                <c:if test="${activityHallSwitch.paramValue eq 'true'}">
                    <th>${views.preferential_auto['申请单号']}</th>
                </c:if>
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
                    <c:if test="${activityHallSwitch.paramValue eq 'true'}">
                        <td>${p.transactionNo}</td>
                    </c:if>
                    <td class="save-title" data-toggle="tooltip" data-placement="left" >
                        <div class="elli" style="height: 14px" title="${empty p.activityName? views.preferential_auto['系统优惠']:p.activityName}">${empty p.activityName? views.preferential_auto['系统优惠']:p.activityName}
                            <c:if test="${activityHallSwitch.paramValue eq 'true'}">
                                (${p.rechargeTransactionNo})<%--需求增加存款订单号--%>
                            </c:if>
                        </div>
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
                            <c:when test="${p.checkState eq '4'}">
                                ${views.preferential_auto['未达到条件']}
                            </c:when>
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


