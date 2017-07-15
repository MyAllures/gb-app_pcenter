<%--@elvariable id="carouselList" type="java.util.List<java.util.Map>"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:set var="apis" value="<%=Cache.getApi()%>"/>
<c:set var="siteApis" value="<%=Cache.getSiteApi() %>"/>
<div class="clearfix game-n-w">
    <c:forEach var="item" items="${carouselList}" varStatus="status">
        <c:if test="${item.apiId=='link'}">
            <c:set var="linkUrl" value="${item.url}"></c:set>
        </c:if>
        <c:if test="${item.apiId!='link'}">
            <c:if test="${item.apiId==3&&item.apiTypeId==2}">
                <c:set var="linkUrl" value="/casino.html?apiType=${item.apiTypeId}&apiId=${item.apiId}&gameTag=hot_game"></c:set>
            </c:if>
            <c:if test="${item.apiId==6&&item.apiTypeId==2}">
                <c:set var="linkUrl" value="/casino.html?apiType=${item.apiTypeId}&gameTag=hot_game&apiId=${item.apiId}"></c:set>
            </c:if>
            <c:if test="${item.apiId!=3&&item.apiId!=6}">
                <c:set var="linkUrl" value="/commonPage/gamePage/loading.html?apiId=${item.apiId}&apiTypeId=${item.apiTypeId}&gameCode="></c:set>
            </c:if>
        </c:if>

        <soul:button target="linkApiUrl" url="${linkUrl}" mtstart="${item.maintainStart}" mtend="${item.maintainEnd}" cssClass="game-nav" text="" opType="function" status="${apis[item.apiId.toString()].systemStatus=='maintain'||siteApis[item.apiId.toString()].systemStatus eq 'maintain'}">
            <img src="${soulFn:getThumbPath(domain,item.cover,220,85)}" style="width: 220px;height: 85px;">
            <em>${item.name}</em>
        </soul:button>
       <%-- <a href="${empty linkUrl?'#':linkUrl}" target="_blank" class="game-nav">
            <img src="${soulFn:getThumbPath(domain,item.cover,220,85)}" style="width: 220px;height: 85px;">
            <em>${item.name}</em>
        </a>--%>
    </c:forEach>
</div>
