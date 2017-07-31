<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<h3>${views.fund_auto['绑定比特币钱包']}</h3>
<div class="rgeechar">
    <div class="title">
        <span class="tips"><em class="orange">${views.fund_auto['取款前请先添加比特币钱包地址']}</em></span></div>
</div>
<div class="m-t-sm line-hi32">
    <div id="validateRule" style="display: none">${validate}</div>
    <div class="control-grouptwo">
        <label class="control-left">${views.fund_auto['比特币地址']}</label>
        <div class="controls">
            <input type="text" name="result.bankcardNumber" class="input bn" style="width: 280px;"/>
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-label" style="width:132px;"></label>
        <div class="controls" id="submitInfo">
            <soul:button target="resetBtc" text="${views.fund_auto['重置']}" opType="function" cssClass="btn btn-gray middle-big"/>
            <soul:button target="${root}/fund/userBankcard/submitBtc.html" post="getCurrentFormData" dataType="json" callback="saveBankcardCallback" text="${views.fund_auto['确认']}" opType="ajax" precall="validateForm" cssClass="btn btn-blue middle-big btn-bank"/>
        </div>
    </div>
</div>