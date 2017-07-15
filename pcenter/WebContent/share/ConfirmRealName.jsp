<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form method="post">
<div id="validateRule" style="display: none">${validateRule}</div>
<input type="hidden" name="sysUser.username" value="<%=SessionManager.getUserName()%>"/>
<div class="modal-body">
    <div class="modal-body">
        <h3 class="m-sm al-center"></h3>
        <div class="form-group clearfix line-hi34 m-b-xxs">
            <label class="col-xs-3 al-right" for="confirmRealName">${views.share['realName.fillRealName']}</label>
            <div class="col-xs-8 p-x">
                <input type="text" id="confirmRealName" name="confirmRealName" class="input"/>
            </div>
        </div>
        <div class="clearfix m-b bg-gray p-t-xs">
            <div class="line-hi25 p-sm">${views.share['realName.confirmRealNameTips']}</div>
        </div>
    </div>
</div>
<div class="modal-footer">
    <a class="btn btn-outline btn-filter btn-lg real-time-btn" href="${root}/share/realName.html">
        <span class="hd">${views.share['realName.back']}</span>
    </a>
    <soul:button precall="validateForm" target="${root}/share/saveRealName.html" text="" opType="ajax" callback="saveCallbak" post="getCurrentFormData" cssClass="btn btn-filter btn-lg real-time-btn">
        <span class="hd">${views.common['submit']}</span>
    </soul:button>
</div>
</form>
<soul:import type="edit"/>