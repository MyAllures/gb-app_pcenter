<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%--@elvariable id="payAccount" type="so.wwb.gamebox.model.master.content.po.PayAccount""--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--电子支付平台-填写回执信息-->
<form>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="result.payAccountId" value="${playerRechargeVo.result.payAccountId}"/>
    <input type="hidden" name="onlinePayMin" value="${soulFn:formatCurrency(rank.onlinePayMin)}"/>
    <input type="hidden" name="onlinePayMax" value="${soulFn:formatCurrency(rank.onlinePayMax)}"/>
    <input type="hidden" name="result.rechargeType" value="${playerRechargeVo.result.rechargeType}">
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['比特币支付']}</h2></div>
        <a href="/fund/recharge/company/electronicPayFirst.html" class="btn-gray btn btn-big pull-right"
           nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <h4>${views.fund_auto['请填写回执信息']}：</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤4']}<img src="${resRoot}/images/online-pay2.png"></span>
            <div class="control-group">
                <label class="control-label" for="result.bitAmount">${views.fund_auto['比特币']}：</label>
                <div class="controls">
                    <input type="text" class="input" id="result.bitAmount" name="result.bitAmount" autocomplete="off">
                    <span class="fee"></span>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="result.payerBankcard">${views.fund_auto['您的比特币地址']}：</label>
                <div class="controls">
                    <input type="text" class="input" style="width:60%" id="result.payerBankcard" name="result.payerBankcard" autocomplete="off">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="result.bankOrder">txId：</label>
                <div class="controls">
                    <input type="text" class="input" style="width:60%" id="result.bankOrder" name="result.bankOrder" autocomplete="off">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">${views.fund_auto['交易时间']}：</label>
                <div class="controls">
                    <gb:dateRange name="result.returnTime" style="width:45%" format="${DateFormat.DAY_SECOND}"/>
                </div>
            </div>
            <%@include file="sale.jsp" %>
            <%@include file="CaptchaCode.jsp" %>
            <div class=" control-group">
                <label class="control-label"></label>
                <soul:button target="confirm" precall="validateForm" text="${views.fund_auto['提交申请']}" opType="function"
                             cssClass="btn-blue btn large-big _submit"/>
            </div>
        </div>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <span class="deposit-info-title">${views.fund_auto['注意事项']}<img src="${resRoot}/images/online-pay3.png"></span>
            <ul class="attention-list">
                <li class="red">${views.fund_auto['为了方便系统快速完成转账']}</li>
            </ul>
        </div>
    </div>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/BitCoinSecond'], function (Page) {
        page = new Page();
        page.bindButtonEvents();
    });
</script>