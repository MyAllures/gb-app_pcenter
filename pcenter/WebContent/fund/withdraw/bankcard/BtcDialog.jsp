<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.player.vo.UserBankcardVo"--%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${views.common['edit']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<form:form method="post" name="addBankForm">
    <gb:token/>
    <div class="modal-body" style="background: white">
        <div class="rgeechar">
            <div class="title">
                <span class="tips"><em class="orange">${views.fund_auto['取款前请先添加比特币钱包地址']}</em></span></div>
        </div>
        <div class="m-t-sm line-hi32">
            <div id="validateRule" style="display: none">${validate}</div>
            <div class="control-group">
                <label class="control-left">${views.fund_auto['比特币地址']}</label>
                <div class="controls">
                    <input type="text" name="result.bankcardNumber" class="input bn" style="width: 280px;"/>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer"  style="background: white">
        <soul:button precall="validateForm" cssClass="btn btn-filter" text="${views.common['ok']}" opType="function" target="saveBtc"/>
        <soul:button target="closePage" text="${views.common['cancel']}" cssClass="btn btn-outline btn-filter" opType="function"/>
    </div>
</form:form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/fund/withdraw/bankcard/BtcDialog"/>
</html>