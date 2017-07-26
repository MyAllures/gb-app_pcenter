<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="main-wrap">
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['取款专区']}</a></div>
    </div>
    <form name="bindBankcardForm">
    <c:set var="load" value="bankcard"/>
    <gb:token/>
    <c:choose>
        <%--比特币、银行卡都支持--%>
        <c:when test="${isCash && isBit}">
            <div class="tabmenu bankTab">
                <ul class="tab">
                    <li><a class="current">银行卡账户</a></li>
                    <li><a>比特币钱包</a></li>
                </ul>
            </div>
        </c:when>
        <%--银行卡不支持、比特币支持--%>
        <c:when test="${isBit}">
            <c:set var="load" value="btc"/>
        </c:when>
        <%--默认支持银行卡--%>
        <c:otherwise>
        </c:otherwise>
    </c:choose>
    <div class="user-info">
        <c:if test="${load eq 'bankcard'}">
            <%@include file="Bankcard.jsp"%>
        </c:if>
        <c:if test="${load eq 'btc'}">
            <%@include file="Btc.jsp"%>
        </c:if>
    </div>
    </form>
</div>
<soul:import res="site/fund/withdraw/bankcard/BindBankcard"/>