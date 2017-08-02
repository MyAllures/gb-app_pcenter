<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="main-wrap">
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['个人资料']}</a></div>
    </div>
    <form name="bindBankcardForm">
        <gb:token/>
        <div class="user-info">
            <%@include file="Bankcard.jsp"%>
        </div>
    </form>
</div>
<soul:import res="site/fund/withdraw/bankcard/IntoBankcard"/>