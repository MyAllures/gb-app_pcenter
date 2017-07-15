<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-10-28
  Time: 下午5:51
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
<div class="theme-popcon">
  <h3 class="popalign"><i class="tipbig fail"></i>${views.fund_auto['您今日已达到取款次数上限']}</h3>
  <form class="popbutton">
    <soul:button target="closePage" text="${views.common['ok']}" cssClass="btn btn-blue middle-big" opType="function"/>
  </form>
</div>

</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/PWithdraw"/>
</html>
