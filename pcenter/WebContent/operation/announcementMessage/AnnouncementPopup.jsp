<%--@elvariable id="vSystemAnnouncementListVo" type="so.wwb.gamebox.model.company.operator.vo.SystemAnnouncementListVo"--%>
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
          ${vSystemAnnouncementListVo.result.get(0).shortContentText100}
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
