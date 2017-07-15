<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>

<c:if test="${fn:length(command.result) le 0}">
    <div class="chart-table info-notice">
</c:if>
    <table  border="0" cellpadding="0" cellspacing="0" class="table">
        <tbody>
        <c:choose>
            <c:when test="${fn:length(command.result)>0}">
                <div class="gamenotice">
                    <div class="gamenotice-box">
                        <dl>


                            <c:forEach items="${command.result}" var="s" varStatus="dex">
                                <i class="date clock"></i>
                                <span class="date">${soulFn:formatDateTz(s.publishTime, DateFormat.DAY_SECOND,timeZone)}</span>
                                <c:forEach items="${apiMap}" var="apis">
                                    <c:if test="${apis.value.apiId==s.apiId}">
                                        <dd class="clearfix ${(dex.index % 2)==0 ? '':'gameback'}" >
                                            <div class="item">
                                                <h2 class="orange">${gbFn:getApiName((s.apiId).toString())}<c:if test="${s.gameId!=null}">——${gbFn:getGameName((s.gameId).toString())}</c:if></h2>
                                                <p>
                                                    <span class="title">
                                                        ${fn:substring(s.title,0,50)}<c:if test="${fn:length(s.title)>50}">...</c:if>
                                                    </span>
                                                    <a href="/operation/pAnnouncementMessage/gameNoticeDetail.html?searchId=${command.getSearchId(s.id)}"
                                                       nav-target="mainFrame">${fn:substring(s.content,0,80)}<c:if test="${fn:length(s.content)>80}">...</c:if></a>

                                                </p>
                                            </div>
                                        </dd>
                                        <p class="dottline"></p>
                                    </c:if>
                                </c:forEach>
                            </c:forEach>
                        </dl>
                    </div>
                </div>
            </c:when>
            <c:otherwise>
                <tr>
                    <td class="no-content_wrap" style="border-bottom: 0px;">
                        <div>
                            <i class="fa fa-exclamation-circle"></i> ${views.operation_auto['暂无内容!']}
                        </div>
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
        </tbody>
    </table>

<c:if test="${fn:length(command.result) le 0}">
</div>
</c:if>
<soul:pagination/>
