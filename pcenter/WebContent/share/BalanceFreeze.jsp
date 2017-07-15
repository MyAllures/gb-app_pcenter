<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<html>
<head>
    <title>${views.share_auto['余额冻结']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form>
    <c:choose>
        <%--手动冻结用模板内容--%>
        <c:when test="${empty content}">
            <div class="modal-body">
                <div class="withdraw-not">
                    <h1><i class="tipbig fail"></i></h1>
                    <div class="tiptext" style="padding: 0px 35px;text-align: left;">
                        <p>${fn:replace(views.share_auto['密码输入错误冻结提醒内容'], "{0}",soulFn:formatDateTz(balanceFreezeEndTime, DateFormat.DAY_SECOND,timeZone))}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                    <%--<soul:button target="SecurityPwd" text="${views.share_auto['重置安全密码']}" cssClass="btn btn-filter" opType="function"/>--%>
                <soul:button target="closePage" text="${views.share_auto['好的']}" cssClass="btn btn-filter" opType="function"/>
                <a href="${customerService}" class="btn btn-filter" target="_blank">${views.share_auto['联系客服']}</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="modal-body">
                <div class="withdraw-not">
                    <h1><i class="tipbig fail"></i></h1>

                    <div class="tiptext" style="padding: 0px 35px;text-align: left;">
                        <p>${content}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button target="closePage" text="${views.share_auto['好的']}" cssClass="btn btn-filter" opType="function"/>
                <c:if test="${!empty customerService}">
                    <soul:button target="customerService" text="${views.share_auto['联系客服']}" url="${customerService}" opType="function" cssClass="btn btn-outline btn-filter"/>
                </c:if>
            </div>
        </c:otherwise>
    </c:choose>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/share/BalanceFreeze"/>
</html>
