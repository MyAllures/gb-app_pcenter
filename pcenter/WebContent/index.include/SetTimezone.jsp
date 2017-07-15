<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 16-1-5
  Time: 下午8:55
--%>
<%@page import="so.wwb.gamebox.web.SessionManagerCommon" %>
<%@ page import="java.util.Date" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<html>
<head>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form>
    <div class="modal-body">
        <h3 class="m-sm  al-center">${views.index_auto['请设置您的时区']}</h3>
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right">${views.index_auto['您的时区']}：</label>
            <div class="col-xs-8 p-x">
                <c:set value="<%= SessionManagerCommon.getTimeZone().getDisplayName() %>" var="timezonVal"/>
                <gb:selectPure name="result.defaultTimezone" value="${timezonVal}" list="${command}" cssClass="selectwidth m-bigr"></gb:selectPure>
                <c:set var="current" value="<%= new Date()%>"/>
                <div class="co-grayc2 _showDateByTimezone"><%= SessionManagerCommon.getTimeZone().getDisplayName() %>&nbsp;&nbsp;${soulFn:formatDateTz(current,DateFormat.DAY_SECOND, timeZone)}</div>
            </div>
        </div>
        <div class="clearfix m-b bg-gray p-t-xs">
            <div class="line-hi25 p-sm">${views.index_auto['您的系统信息将以该时区显示']}<span class="co-orange">${views.index_auto['一旦设置不可修改']}</span></div>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button target="${root}/index/setTimezone.html" post="getCurrentFormData" text="" callback="closePage" opType="ajax" cssClass="btn btn-filter">${views.index_auto['使用该时区']}</soul:button>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<script>
    curl(['gb/home/TopPage','site/home/SetTimezone'], function(TopPage,SetTimezone) {
        setTimezone= new SetTimezone();
        setTimezone.bindButtonEvents();
    });
</script>
</html>
