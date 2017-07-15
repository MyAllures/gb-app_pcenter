<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-12-2
  Time: 下午8:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<html>
<head>
    <title></title>
  <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form>
  <div class="modal-body">
      <pre style="white-space: pre-wrap;word-wrap: break-word;border: 0px;text-indent: -70px;">
          ${fn:substring(vSystemAnnouncementListVo.result.get(0).content,0,100)}<c:if test="${fn:length(vSystemAnnouncementListVo.result.get(0).content)>100}">...</c:if>
      </pre>
  </div>
  <div class="modal-footer" apiId="${vSystemAnnouncementListVo.result.get(0).apiId}">
    <soul:button target="systemNoticeDetail" text="${views.operation_auto['查看详细']}" opType="function" cssClass="btn btn-filter"/>
  </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/operation/message/SystemNoticeDetail"/>
</html>
