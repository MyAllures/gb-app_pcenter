<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">${views.personInfo_auto['玩家中心']}<span class="arrow">></span>${views.sysResource['个人资料']}<span class="arrow">></span>${views.personInfo_auto['登录日志']}&nbsp;&nbsp;&nbsp;
            <soul:button target="goToLastPage" text="${views.personInfo_auto['返回']}" opType="function"/>
        </div>
    </div>
    <!--登录日志-->
    <div class="rgeechar">
        <div class="history">
            <span class="orange">${views.personInfo_auto['如果不确定是您本人登录，建议您']}</span></span>
            <%--<a href="javascript:void(0)" class="updatePwd">
                ${views.account['AccountSetting.log.message2']}
            </a>--%>
            <soul:button target="updatePwd" text="${views.account['AccountSetting.log.message2']}" opType="function"/>
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
                    <td>${soulFn:overlayIp(soulFn:formatIp(s.operateIp))}<span class="m-l gray">${gbFn:getIpRegion(s.operateIpDictCode)}</span></td>
                </tr>
            </c:forEach>
        </table>
    </div>
</form>
<soul:import res="site/personInfo/LoginLog" />
<!--//endregion your codes １-->
