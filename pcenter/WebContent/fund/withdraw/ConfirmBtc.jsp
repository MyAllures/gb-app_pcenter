<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body>
<!--确认绑定比特币-->
<form method="post" name="confirmBtc">
    <div class="modal-body">
        <div class="modal-body">
            <div id="validateRule" style="display: none">${validateRule}</div>
            <input type="hidden" name="result.bankcardNumber" value=""/>
            <h3 class="m-sm al-center">确认提交吗？</h3>
            <div class="form-group clearfix line-hi34 m-b-xxs al-center">
                <b>比特币钱包地址：</b>
            </div>
            <div class="rgeechar">
                <div class="title">
                    <span class="tips">
                        <i class="mark plaintsmall"></i>
                        <em class="orange">比特币钱包地址将直接影响您的正常收款，请务必再次确认！</em>
                    </span>
                </div>
            </div>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button target="closePage" text="" opType="function" cssClass="btn btn-filter btn-lg real-time-btn" tag="button">
            <span class="hd">${views.common['cancel']}</span>
        </soul:button>
        <soul:button target="next" text="" opType="ajax" cssClass="btn btn-filter btn-lg real-time-btn" tag="button" precall="validateForm">
            <span class="hd">${views.common['ok']}</span>
        </soul:button>
    </div>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import type="edit"/>