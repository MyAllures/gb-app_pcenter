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
<input type="hidden" value="${transactionNo}" name="search.transactionNo"/>
<c:choose>
    <c:when test="${resultCode==1}">
        <div class="modal-body">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext">
                    <p>
                        ${views.fund['Transfer.transfer.transferFail']}
                        <c:if test="${transferOut=='wallet'}">
                            ${views.fund['Transfer.transferResult.yourWallet']}
                        </c:if>
                        <c:if test="${transferOut!='wallet'}">
                            ${gbFn:getSiteApiName(transferOut)}
                        </c:if>
                    </p>
                    <p>${views.fund['Transfer.transfer.transferFailContent']}</p>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <soul:button target="reTransfer" text="${views.fund['Transfer.transfer.reTransfer']}" opType="function" cssClass="btn btn-filter btn-lg real-time-btn m-t-sm"/>
        </div>
    </c:when>
    <c:otherwise>
        <div class="modal-body">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext">
                    <p>${views.fund['Transfer.transfer.overTime']}</p>
                    <p>${views.fund['Transfer.transfer.transferOverTimeContent']}</p>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <soul:button target="reconnectTransfer" text="${views.fund['Transfer.transfer.again']}" opType="function" cssClass="btn btn-filter"/>
        </div>
    </c:otherwise>
</c:choose>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/transfers/TransfersResult"/>
</html>

