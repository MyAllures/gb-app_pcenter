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
    <div class="modal-body">
        <div class="rgeechar">
            <div class="title">
                <span class="tips"><em class="orange">取款前请先添加比特币钱包地址,成功取款后,我们会将款项打至您填写的钱包账户!</em></span></div>
        </div>
        <div class="m-t-sm line-hi32">
            <div id="validateRule" style="display: none">${validate}</div>
            <div class="control-grouptwo">
                <label class="control-left">比特币钱包地址：</label>
                <div class="controls">
                    <input type="text" name="result.bankcardNumber" class="input bn" style="width: 280px;"/>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button precall="validateForm" cssClass="btn btn-filter" callback="saveCallbak" text="${views.common['ok']}" opType="ajax" dataType="json" target="${root}/fund/userBankcard/submitBtc.html" post="getCurrentFormData"/>
        <soul:button target="closePage" text="${views.common['cancel']}" cssClass="btn btn-outline btn-filter" opType="function"/>
    </div>
</form:form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import type="edit"/>
</html>