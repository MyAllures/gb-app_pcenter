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
        <div class="titleline pull-left"><h2>${views.fund_auto['电子支付']}</h2></div>
        <a href="/fund/recharge/company/electronicPayFirst.html" class="btn-gray btn btn-big pull-right"
           nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <h4>${views.fund_auto['请填写回执信息']}：</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤4']}<img src="${resRoot}/images/online-pay2.png"></span>
            <div class="control-group">
                <label class="control-label" style="width:130px;">${views.fund_auto['您的']}
                    <c:choose>
                        <c:when test="${payAccount.bankCode eq 'wechatpay'}">
                            ${dicts.common.bank_nickname[payAccount.bankCode]}：
                        </c:when>
                        <c:otherwise>
                            ${dicts.common.bankname[payAccount.bankCode]}${views.fund_auto['账号']}：
                        </c:otherwise>
                    </c:choose>
                </label>
                <div class="controls">
                    <input type="text" class="input" value="${payerBankcard}" name="result.payerBankcard"
                           autocomplete="off" placeholder="${views.fund_auto['昵称']}">
                    <c:if test="${payAccount.bankCode=='alipay'}">
                        <div class="controls">
                            <p style="color:#AAAAAA;">${views.fund_auto['支付宝转账到支付宝']}${views.fund_auto['请填写']}<span style="color:#FF7744;">${views.fund_auto['昵称']}</span>；</p>
                            <p style="color:#AAAAAA;">${views.fund_auto['支付宝转账到银行卡']}${views.fund_auto['请填写']}<span style="color:#FF7744;">${views.fund_auto['真实姓名']}</span>；</p>
                        </div>
                    </c:if>
                </div>

            </div>
            <div class="control-group">
                <label class="control-label" style="width:130px;">${views.fund_auto['金额']}：</label>
                <div class="controls">
                    <input type="text" class="input" name="result.rechargeAmount" autocomplete="off">
                    <span class="fee"></span>
                </div>
            </div>
            <%@include file="sale.jsp" %>
            <div class="control-group">
                <label class="control-label" style="width:130px;">${views.fund_auto['订单号（后5位）']}：</label>
                <div class="controls">
                    <input type="text" class="input" placeholder="${views.fund_auto['非必填']}" maxlength="5" name="result.bankOrder"
                           autocomplete="off">
                    <%-- <span class="tips line-hi30"><a href="#">如何查询后5位？</a></span>--%>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" style="width:130px;"></label>
                <div class="controls co-gray">
                    ${payAccount.bankCode=='alipay'? views.fund_auto['请填写订单号非商户订单号']:''}
                </div>
            </div>
            <%@include file="CaptchaCode.jsp" %>
            <div class=" control-group">
                <label class="control-label" style="width:130px;"></label>
                <soul:button target="commonRecharge.confirm" precall="validateForm" text="${views.fund_auto['提交申请']}" opType="function"
                             cssClass="btn-blue btn large-big disabled _submit"/>
            </div>
        </div>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <span class="deposit-info-title">${views.fund_auto['注意事项']}<img src="${resRoot}/images/online-pay3.png"></span>
            <ul class="attention-list">
                <li class="red">${views.fund_auto['扫码存款提醒1']}</li>
            </ul>
        </div>
    </div>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/ElectronicPaySecond', 'site/fund/recharge/CommonRecharge'], function (Page, CommonRecharge) {
        page = new Page();
        page.bindButtonEvents();
        page.commonRecharge = new CommonRecharge();
    });
</script>