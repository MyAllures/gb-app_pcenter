<%--@elvariable id="gameAnnouncement" type="so.wwb.gamebox.model.company.operator.vo.SystemAnnouncementListVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:if test="${fn:length(gameAnnouncement.result)>0}">
    <div class="gamenotice">
        <div class="gamenotice-title">
            <h1>${views.fund['Transfer.transfer.gameNotice']}</h1>
            <span class="more gameMore" style="width: 67px">
                <soul:button target="moreGameAnnouncement" text="${views.common['more']}&gt;" opType="function"/>
            </span>
        </div>
        <div class="gamenotice-box">
            <dl>
                <c:forEach items="${gameAnnouncement.result}" var="s" varStatus="vs">
                    <c:forEach items="${apiMap}" var="apis">
                        <c:if test="${apis.value.apiId==s.apiId}">
                            <dd class="clearfix">
                                <div class="item">
                                    <h2 class="orange">${gbFn:getApiName((s.apiId).toString())}<c:if test="${s.gameId!=null}">——${gbFn:getGameName((s.gameId).toString())}</c:if></h2>
                                    <p>
                                            <a href="/operation/pAnnouncementMessage/gameNoticeDetail.html?searchId=${gameAnnouncement.getSearchId(s.id)}"
                                               nav-target="mainFrame">${s.shortContentText80}"></a>
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