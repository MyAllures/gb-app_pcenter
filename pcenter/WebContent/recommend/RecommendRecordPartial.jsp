<%--@elvariable id="command" type="so.wwb.gamebox.model.master.report.vo.PlayerRecommendAwardListVo"--%>
<%--@elvariable id="map" type="java.util.Map"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="chart-table info-notice">
    <table width="100%" border="0" cellpadding="0" cellspacing="0" class="table">
        <tr>
            <th width="18%">${views.recommend['recommend.Record.friendAccount']}</th>
            <th width="18%">${views.recommend['recommend.Record.registerTime']}</th>
            <th width="17%">${views.recommend['recommend.Record.status']}</th>
            <th width="13%">${views.recommend['recommend.Record.recommendSingelAward']}</th>
        </tr>
        <c:choose>
            <c:when test="${empty command.recommendAwardRecords && fn:length(command.recommendAwardRecords)<=0}">
                <tr>
                    <td class="no-content_wrap" colspan="5">
                        <div>
                            <i class="fa fa-exclamation-circle"></i> ${views.recommend['recommend.Record.noContents']}
                        </div>
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <c:forEach items="${command.recommendAwardRecords}" var="i">
                    <tr>
                        <td>${soulFn:overlayString(i.recommendUserName)}</td>
                        <td>${soulFn:formatDateTz(i.createTime, DateFormat.DAY_SECOND, timeZone)}</td>
                        <td>${dicts.player.user_status[i.status]}</td>
                        <td>
                            <c:choose>
                                <c:when test="${i.singleCount>0}">
                                    ${views.recommend['recommend.Record.obtained']}
                                </c:when>
                                <c:when test="${! empty rewardTheway.paramValue}">
                                    <span class="orange">${views.recommend[recommend.Record.notMeetTheConditions]}</span>
                                </c:when>
                                <c:otherwise>
                                    --
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </table>
</div>
<soul:pagination/>

