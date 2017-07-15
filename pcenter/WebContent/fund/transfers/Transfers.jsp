<%--@elvariable id="playerApiListVo" type="so.wwb.gamebox.model.master.player.vo.PlayerApiListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form name="transferForm">
    <input type="hidden" value="${isRefresh}" name="isRefresh"/>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a class="cursor">${views.sysResource['额度转换']}</a>
        </div>
    </div>
    <!--资产-->
    <div class="account">
        <%@include file="transfers.include/loading.jsp" %>
    </div>
    <!--转账-->
    <div class="clearfix">
        <div class="asset left-asset">
            <%@include file="transfers.include/TransfersPartial.jsp" %>
        </div>
        <div class="asset right-asset clearfix">
            <%@include file="../../home/index.include/Carousel.jsp"%>
        </div>
    </div>
    <div class="gameAnnouncement">
        <%@include file="../../home/index.include/GameAnnouncement.jsp"%>
    </div>
</form>
<soul:import res="site/fund/transfers/Transfers"/>

