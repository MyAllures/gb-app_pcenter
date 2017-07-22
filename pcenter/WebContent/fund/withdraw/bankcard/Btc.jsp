<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<h3>绑定比特币钱包</h3>
<div class="rgeechar">
    <div class="title">
        <span class="tips"><em class="orange">取款前请先添加比特币钱包地址,成功取款后,我们会将款项打至您填写的钱包账户!</em></span></div>
</div>
<div class="m-t-sm line-hi32">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="control-grouptwo">
        <label class="control-left">比特币钱包地址：</label>
        <div class="controls">
            <input type="text" name="result.bankcardNumber" class="input bn" style="width: 280px;"/>
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-label" style="width:132px;"></label>
        <div class="controls" id="submitInfo">
            <soul:button target="resetBtc" text="重置" opType="function" cssClass="btn btn-gray middle-big"/>
            <a title="重置" class="btn btn-gray middle-big">
                重置
            </a>
            <soul:button target="${root}" post="getCurrentFormData" dataType="json" callback="saveBankcardCallback" text="确认" opType="dialog" cssClass="btn btn-blue middle-big btn-bank"/>
        </div>
    </div>
</div>