<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>

<div class="chart-table info-notice">
    <table  border="0" cellpadding="0" cellspacing="0" class="table">
        <tbody>
            <c:choose>
                <c:when test="${fn:length(command.result)>0}">
                    <c:forEach items="${command.result}" var="s" varStatus="dex">
                        <tr class="${(dex.index % 2)==0 ? '':'gameback'}">
                            <td class="al-left">
                                <a href="/operation/pAnnouncementMessage/systemNoticeDetail.html?searchId=${command.getSearchId(s.id)}"
                                   nav-target="mainFrame">${fn:substring(s.content,0,50)}<c:if test="${fn:length(s.content)>50}">...</c:if></a>
                            </td>
                            <td><span class="datemessage"><i class="clock"></i>${soulFn:formatDateTz(s.publishTime, DateFormat.DAY_SECOND,timeZone)}</span></td>
                        </tr>
                    </c:forEach>
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
</div>
<soul:pagination/>