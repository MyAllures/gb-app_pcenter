<%@ page import="so.wwb.gamebox.model.master.fund.enums.RechargeStatusEnum" %>
<%--@elvariable id="playerRecharge" type="so.wwb.gamebox.model.master.fund.po.PlayerRecharge"--%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>选择优惠</title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<c:set var="success" value="<%=RechargeStatusEnum.ONLINE_SUCCESS.getCode()%>"/>
<form>
    <div class="modal-body">
        <div class="form-group clearfix line-hi34 m-t-sm">
            <c:if test="${playerRecharge.rechargeStatus eq success}">
                <label class="col-xs-3 al-right">兑换金额：</label>
                <div class="col-xs-8 p-x">
                     ${currencySign}<i class="orange">${soulFn:formatCurrency(playerRecharge.rechargeAmount)}</i>
                </div>
            </c:if>
            <c:if test="${playerRecharge.rechargeStatus != success}">
                <label class="col-xs-3 al-right">兑换处理中:</label>
                <div class="col-xs-8 p-x">
                    &nbsp;${playerRecharge.payerBank}&nbsp;<i class="orange"><fmt:formatNumber value="${playerRecharge.bitAmount}" pattern="#.########"/></i>
                </div>
            </c:if>
        </div>
        <div class="form-group clearfix line-hi34 m-t-sm">
            <label class="col-xs-3 al-right">选择优惠：</label>
            <div class="col-xs-8 p-x">
                <select name="activityId" class="selectwidth">
                    <option value="">不参与优惠</option>
                    <c:forEach items="${sales}" var="i">
                        <option value="${i.id}">${i.classifyKeyName}&nbsp;&nbsp;${i.activityName}</option>
                    </c:forEach>
                </select>
                <input type="hidden" value="${playerRecharge.transactionNo}" name="search.transactionNo"/>
            </div>
        </div>

    </div>
    <div class="modal-footer">
        <soul:button target="closePage" text="取消" opType="function" cssClass="btn btn-gray" tag="button"/>
        <soul:button target="${root}/fund/recharge/digiccy/saveSale.html" text="确认" callback="saveCallbak" opType="ajax" tag="button" cssClass="btn btn-filter" post="getCurrentFormData"/>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import type="edit"/>
</html>