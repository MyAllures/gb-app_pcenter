<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<form>
<div class="wrap">
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['消息公告']}</a><span class="arrow">></span>${views.operation_auto['系统公告']}</div>
    </div>
    <div class="return">
        <a href="/operation/pAnnouncementMessage/systemNoticeHistory.html" nav-target="mainFrame" class="btn btn-gray btn-big">${views.operation_auto['返回上一级']}</a>
    </div>
    <!--选项卡-->
    <div class="tabmenu">
        <ul class="tab">
            <li><a href="/operation/pAnnouncementMessage/gameNotice.html" class="gameAnn" nav-target="mainFrame">${views.operation_auto['游戏公告']}</a></li>
            <li><a href="/operation/pAnnouncementMessage/advisoryMessage.html" class="current systemAnn" nav-target="mainFrame">${views.operation_auto['系统公告']}</a></li>
            <li><a href="/operation/pAnnouncementMessage/messageList.html" class="siteMessage" nav-target="mainFrame">${views.operation_auto['站点消息']}</a></li>
        </ul>
    </div>

    <!--消息详情页-->
    <div class="salemore">
        <div class="al-right pull-right">
            &lt;
            <c:if test="${vSystemAnnouncementListVo.paging.pageNumber != 1}">
                <a href="/operation/pAnnouncementMessage/systemNoticeHistory.html?&isDetail=1&search.startTime=${soulFn:formatDateTz(command.search.startTime, DateFormat.DAY_SECOND,timeZone)}&search.endTime=${soulFn:formatDateTz(command.search.endTime, DateFormat.DAY_SECOND,timeZone)}&paging.pageNumber=${command.paging.pageNumber-1}"  nav-target="mainFrame" class="co-gray6">上一条</a>
            </c:if>
            &nbsp;
            <c:if test="${vSystemAnnouncementListVo.paging.pageNumber != vSystemAnnouncementListVo.paging.totalCount}">
                <a href="/operation/pAnnouncementMessage/systemNoticeHistory.html?&isDetail=1&search.startTime=${soulFn:formatDateTz(command.search.startTime, DateFormat.DAY_SECOND,timeZone)}&search.endTime=${soulFn:formatDateTz(command.search.endTime, DateFormat.DAY_SECOND,timeZone)}&paging.pageNumber=${command.paging.pageNumber+1}"  nav-target="mainFrame" class="co-gray6">下一条</a>
            </c:if>

            &gt;&nbsp;&nbsp;&nbsp;
        </div>

        <h2><span class="name">${vSystemAnnouncementListVo.result.get(0).title}</span><br/>
            <div class="datetime"><i class="clock"/>${soulFn:formatDateTz(vSystemAnnouncementListVo.result.get(0).publishTime, DateFormat.DAY_SECOND,timeZone)}</div></h2>

        <div class="salemore-con">
            <pre style="white-space: pre-wrap;word-wrap: break-word;border: 0px;">${vSystemAnnouncementListVo.result.get(0).content}</pre>
        </div>
    </div>
</div>
</form>
<soul:import res="site/operation/message/SystemNoticeDetail"/>
