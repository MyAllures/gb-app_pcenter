<%--@elvariable id="player" type="so.wwb.gamebox.model.master.player.po.UserPlayer"--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.setting.vo.SiteConfineIpVo"--%>
<%--@elvariable id="rule" type="so.wwb.gamebox.model.company.site.po.SiteI18n"--%>
<%--@elvariable id="map" type="java.util.Map"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">${views.sysResource['推荐好友']}</div>
    </div>
    <div class="tabmenu">
        <ul class="tab">
            <li id="tab1"><soul:button target="recommend" cssClass="${type!='record'?'current':''}" text="${views.recommend_auto['推荐好友']}" opType="function"/></li>
            <li id="tab2"><soul:button target="recommend" cssClass="${type!='record'?'':'current'}" type="record" text="${views.recommend_auto['推荐记录']}" opType="function"/></li>
        </ul>
    </div>
    <div id="recommend" style="${type!='record'?'':'display:none'}">
        <c:if test="${type!='record'}">
            <%@include file="RecommendPartial.jsp" %>
        </c:if>
    </div>
    <div id="recommendRecord" style="${type=='record'?'':'display:none'}">
        <c:if test="${type=='record'}">
            <%@include file="RecommendRecord.jsp" %>
        </c:if>
    </div>
</form>
<soul:import res="site/recommend/Recommend"/>

