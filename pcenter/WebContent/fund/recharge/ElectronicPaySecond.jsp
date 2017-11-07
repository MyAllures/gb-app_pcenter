<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%--@elvariable id="payAccount" type="so.wwb.gamebox.model.master.content.po.PayAccount""--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--电子支付平台-填写回执信息-->
<form>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="result.payAccountId" value="${playerRechargeVo.result.payAccountId}"/>
    <input type="hidden" name="result.rechargeType" value="${playerRechargeVo.result.rechargeType}">
    <input type="hidden" name="result.rechargeAmount" value="${playerRechargeVo.result.rechargeAmount}">
    <input type="hidden" name="result.payerBankcard" value="${playerRechargeVo.result.payerBankcard}">
    <input type="hidden" name="activityId" value="${playerRechargeVo.activityId}">

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
        <div class="left-ico-message clearfix">
            <h4>请用${dicts.common.bankname[payAccount.bankCode]}存款至以下帐号：</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay1.png"></span>
            <div class="left-warp">
                <div class="bank-paidtotal">
                    <ul>
                        <li>
                            <div class="bankinfo bankinfo-m">
                                <c:set var="flag" value="${empty payAccount.customBankName||dicts.common.bankname[payAccount.bankCode]==payAccount.customBankName}"/>
                                <h1><i class="${flag?'pay-third ':''} ${flag?payAccount.bankCode:''}" style="font-size: small;">${flag?'':payAccount.customBankName}</i></h1>
                                <c:choose>
                                    <c:when test="${isHide}">
                                       <span class="orange select">
                                            <i class="orange fontsbig">${views.fund_auto['账号代码']}：${payAccount.code}</i>
                                            <i class="m-bigl">
                                                <soul:button target="customerService" text="${(empty hideContent.value) ? views.fund_auto['联系客服获取账号'] : hideContent.value}" url="${customerService}" opType="function"/>
                                            </i>
                                       </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="orange paidname select" data-clipboard-text="${payAccount.account}" name="copy">
                                            <em class="bank-number">${payAccount.bankCode eq 'onecodepay'?'不显示':payAccount.account}</em>
                                            <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                <span class="paidname select" data-clipboard-text="${payAccount.fullName}" name="copy">
                                    <em class="gray">${views.fund_auto['姓名']}：</em>
                                    <em class="gathering-name">${payAccount.bankCode eq 'onecodepay'?'不显示':payAccount.fullName}</em>
                                   <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                </span>
                            </div>
                        </li>
                    </ul>
                </div>
                <c:if test="${!empty payAccount.remark}">
                    <div>
                        <p style="margin: 15px 23px">${payAccount.remark}</p>
                    </div>
                </c:if>
                <div class=" control-group">
                    <c:if test="${!empty banks[payAccount.bankCode].website}">
                        <a href="${banks[payAccount.bankCode].website}" target="_blank" type="button" class="btn btn-outline btn-filter m-l">${fn:replace(views.fund_auto['去转账'],"{0}", dicts.common.bankname[payAccount.bankCode])}</a>
                    </c:if>
                    <a href="javascript:;" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=62" class="m-l openPage">${fn:replace(views.fund_auto['是否查看转账演示'],"{0}", dicts.common.bankname[payAccount.bankCode])}</a>
                </div>
            </div>
            <c:if test="${! empty payAccount.qrCodeUrl}">
                <div class="pull-left">
                    <span class="two-dimension">
                        <img src="${soulFn:getThumbPath(domain,payAccount.qrCodeUrl,176,176)}" style="width: 176px;height: 176px;"/>
                        <em><img src="${resRoot}/images/two-dimension-ico.png" class="pull-left">${dicts.common.bankname[payAccount.bankCode]}${views.fund_auto['扫一扫付款']}</em>
                    </span>
                    <span><img src="${resRoot}/images/two-dimension123.png"></span>
                </div>
            </c:if>
        </div>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <h4>完成存款申请：</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤4']}<img src="${resRoot}/images/online-pay2.png"></span>
            <div class="control-group">
                <label class="control-label">${views.fund_auto['订单号（后5位）']}：</label>
                <div class="controls">
                    <input type="text" class="input" placeholder="${views.fund_auto['非必填']}" maxlength="5" name="result.bankOrder" autocomplete="off">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label"></label>
                <div class="controls co-gray">
                    ${payAccount.bankCode=='alipay'? views.fund_auto['请填写订单号非商户订单号']:''}
                </div>
            </div>
            <div class=" control-group">
                <label class="control-label"></label>
                <soul:button target="commonRecharge.confirm" precall="validateForm" text="${views.fund_auto['提交申请']}" opType="function"
                             cssClass="btn-blue btn large-big"/>
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