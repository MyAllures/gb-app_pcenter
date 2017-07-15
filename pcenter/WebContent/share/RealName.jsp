<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<!--填写真实姓名-->
<form method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="modal-body">
        <div class="modal-body">
            <h3 class="m-sm al-center"></h3>
            <div class="form-group clearfix line-hi34 m-b-xxs">
                <label class="col-xs-3 al-right" for="realName">${views.share['realName.fillRealName']}</label>
                <div class="col-xs-8 p-x">
                    <input type="text" id="realName" name="realName" class="input"/>
                </div>
            </div>
            <div class="clearfix m-b bg-gray p-t-xs">
                <div class="line-hi25 p-sm">${views.share['realName.realNameTips']}</div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button target="next" text="" opType="function" cssClass="btn btn-filter btn-lg real-time-btn" tag="button" precall="validateForm">
            <span class="hd">${views.common['next']}</span>
        </soul:button>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/share/RealName"/>