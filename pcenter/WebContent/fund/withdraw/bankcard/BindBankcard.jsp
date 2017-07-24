<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="main-wrap">
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['取款专区']}</a></div>
    </div>
    <form name="bindBankcardForm">
    <c:choose>
        <%--比特币、银行卡都支持--%>
        <c:when test="${isCash && isBit}">
            <div class="tabmenu bankTab">
                <ul class="tab">
                    <li><a class="current">银行卡账户</a></li>
                    <li><a>比特币钱包</a></li>
                </ul>
            </div>
            <div class="user-info">
                <%@include file="Bankcard.jsp" %>
            </div>
        </c:when>
        <%--银行卡不支持、比特币支持--%>
        <c:when test="${isBit}">
            <div class="user-info">
                <%@include file="Btc.jsp" %>
            </div>
        </c:when>
        <%--默认支持银行卡--%>
        <c:otherwise>
            <div class="user-info">
                <%@include file="Bankcard.jsp" %>
            </div>
        </c:otherwise>
    </c:choose>
    </form>
</div>
<soul:import res="site/fund/withdraw/bankcard/"/>