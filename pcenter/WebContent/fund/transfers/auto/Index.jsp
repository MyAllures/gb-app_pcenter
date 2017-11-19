<%--@elvariable id="playerApiListVo" type="so.wwb.gamebox.model.master.player.vo.PlayerApiListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<%--免转页面--%>
<form name="transferForm">
    <input type="hidden" value="${isRefresh}" name="isRefresh"/>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a class="cursor">${views.sysResource['额度转换']}</a>
        </div>
    </div>
    <!--资产-->
    <div class="account s2">
        <%@include file="Assets.jsp" %>
    </div>
    <div class="gameAnnouncement">
        <%@include file="../../../home/index.include/GameAnnouncement.jsp" %>
    </div>
</form>
<soul:import res="site/fund/transfers/auto/Index"/>
</script>