<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right"><a class="cursor">${views.sysResource['账号管理']}</a><span class="arrow">></span>${views.sysResource['登录日志']}</div>
</div>
<!--登录日志-->
<div class="rgeechar">
    <div class="history">
        <%--${views.account['AccountSetting.log.message']}<br/>--%>
        <span class="orange">${views.account['AccountSetting.log.message1']}</span>
        <a href="javascript:void(0)" class="updatePwd" nav-target="mainFrame">${views.account['AccountSetting.log.message2']}</a>
    </div>
</div>
<div class="chart-table">
    <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr>
            <th width="18%">${views.account['AccountSetting.log.loginTime']}</th>
            <th width="18%">IP</th>
        </tr>
        <c:forEach items="${sysAuditLogs}" var="s">
            <tr>
                <td>${soulFn:formatDateTz(s.operateTime,DateFormat.DAY_SECOND ,timeZone )}</td>
                <td>${soulFn:overlayIp(soulFn:formatIp(s.operateIp))}<span class="m-l  gray">${gbFn:getIpRegion(s.operateIpDictCode)}</span></td>
            </tr>
        </c:forEach>
    </table>
</div>
<soul:import res="site/accountManagement/AccountLoginLog" />
<!--//endregion your codes １-->
