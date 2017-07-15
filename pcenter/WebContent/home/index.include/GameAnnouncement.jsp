<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:if test="${fn:length(gameAnnouncement.result)>0}">
    <div class="gamenotice">
        <div class="gamenotice-title">
            <h1>${views.fund['Transfer.transfer.gameNotice']}</h1>
            <span class="more gameMore">
                <soul:button target="moreGameAnnouncement" text="${views.common['more']}&gt;" opType="function"/>
            </span>
        </div>
        <div class="gamenotice-box">
            <dl>
                <c:forEach items="${gameAnnouncement.result}" var="s" varStatus="vs">
                    <c:forEach items="${apiMap}" var="apis">
                        <c:if test="${apis.value.apiId==s.apiId}">
                            <dd class="clearfix">
                                    <%--<soul:button target="gameDetail" url="${root}/operation/pAnnouncementMessage/gameNoticeDetail.html?searchId=${gameAnnouncement.getSearchId(s.id)}" text="" opType="function">
                                        <img src="${soulFn:getThumbPath(domain, apis.value.cover,66,24)}">
                                    </soul:button>--%>
                                <div class="item">
                                    <h2 class="orange">${gbFn:getApiName((s.apiId).toString())}<c:if test="${s.gameId!=null}">——${gbFn:getGameName((s.gameId).toString())}</c:if></h2>
                                    <p>
                                        <%--<soul:button target="gameDetail" text=""
                                                     url="${root}/operation/pAnnouncementMessage/gameNoticeDetail.html?searchId=${gameAnnouncement.getSearchId(s.id)}"
                                                     opType="function">${fn:substring(s.content,0,50)}<c:if test="${fn:length(s.content)>50}">...</c:if></soul:button>--%>
                                            <a href="/operation/pAnnouncementMessage/gameNoticeDetail.html?searchId=${gameAnnouncement.getSearchId(s.id)}"
                                               nav-target="mainFrame">${fn:substring(s.content,0,80)}<c:if test="${fn:length(s.content)>80}">...</c:if></a>
                                            <i class="date clock"></i>
                                        <span class="date">${soulFn:formatDateTz(s.publishTime, DateFormat.DAY_SECOND,timeZone)}</span>

                                    </p>
                                </div>
                            </dd>
                        </c:if>
                    </c:forEach>
                </c:forEach>
            </dl>
        </div>
    </div>
</c:if>