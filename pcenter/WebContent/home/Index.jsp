<%--@elvariable id="playerApis" type="so.wwb.gamebox.model.master.player.vo.PlayerApiListVo"--%>
<%--@elvariable id="player" type="so.wwb.gamebox.model.master.player.vo.UserPlayerVo"--%>
<%--@elvariable id="sale" type="so.wwb.gamebox.model.master.operation.vo.VActivityMessageListVo"--%>
<%--@elvariable id="gameAnnouncement" type="so.wwb.gamebox.model.company.operator.vo.VSystemAnnouncementListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:set var="apiI18n" value="<%=Cache.getApiI18n()%>"/>
<div name="homeIndex">
    <div class="account">
       <%@include file="index.include/loading.jsp"%>
    </div>
    <div class="carousel">
        <%@include file="index.include/Carousel.jsp"%>
    </div>
    <div class="gameAnnouncement">
        <%@include file="index.include/GameAnnouncement.jsp"%>
    </div>
    <div class="activityMessage">
        <%@include file="index.include/ActivityMessage.jsp"%>
    </div>
    <%--<div class="gameAndSale">
        <%@include file="index.include/GameAndSale.jsp"%>
    </div>--%>
</div>
<soul:import res="site/home/Index"/>

