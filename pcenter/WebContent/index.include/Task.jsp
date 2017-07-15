<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<dt>${views.index_auto['任务提醒']}</dt>
<%--没有最新消息--%>
<c:if test="${userTaskReminderList.size()<=0}">
    <dd class="infos-none"><i class="fa fa-exclamation-circle"></i></dd>
</c:if>
<%--任务--%>
<c:if test="${userTaskReminderList.size()>0}">
    <c:forEach items="${userTaskReminderList}" var="m">
        <dd>
            <c:choose>
                <%--判断是收款账号的任务提醒--%>
                <c:when test="${m.parentCode=='account'}">
                    <c:set value="${ fn:split(m.timeUnit, '@') }" var="timeUnit1"/>
                    <div class="clearfix">
                        <a href="javascript:void(0)">${fn:replace(views.taskReminder[m.dictCode],"?" ,m.taskNum)}</a>
                        <span>${timeUnit1[0]}${views.taskReminder[timeUnit1[1]]}</span>
                    </div>
                    <c:if test="${m.dictCode=='orange'}">
                        ${views.taskReminder['orangeMsg']}
                    </c:if>
                    <c:if test="${m.dictCode=='red'}">
                        ${views.taskReminder['redMsg']}
                    </c:if>
                    <c:if test="${m.dictCode=='frozen'}">
                        ${views.taskReminder['frozenMsg']}
                    </c:if>
                </c:when>
                <c:otherwise>
                    <c:set value="${ fn:split(m.timeUnit, '@') }" var="timeUnit"/>
                    <a href="javascript:void(0)">${fn:replace(views.taskReminder[m.dictCode],"?" ,m.taskNum)}</a><span>${timeUnit[0]}${views.taskReminder[timeUnit[1]]}</span>
                </c:otherwise>
            </c:choose>
        </dd>
    </c:forEach>
</c:if>
<dd class="more"><a href="javascript:void(0)">${views.message['view more news']}>></a></dd>
