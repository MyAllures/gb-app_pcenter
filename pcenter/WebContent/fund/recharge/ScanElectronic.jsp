<%--@elvariable id="scan" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="electronic" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.content.vo.PayAccountVo"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right">
        <a href="javascript:;">${views.sysResource['存款专区']}</a>
    </div>
</div>
<form name="scanElectronicForm">
<%--渠道选择--%>
<%@include file="Channel.jsp"%>
<div id="validateRule" style="display: none">${validateRule}</div>
<gb:token/>
<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>选择支付方式：</h4>
        <span class="deposit-info-title">步骤1<img src="${resRoot}/images/online-pay1.png"></span>
        <div class="bank-deposit">
            <div class="bank-total">
                <c:set var="index" value="0"/>
                <c:forEach items="${scan}" var="i">
                    <c:set var="bankCode" value="${i.key}"/>
                    <c:set var="account" value="${i.value}"/>
                    <c:set var="name" value="${dicts.common.bankname[bankCode]}"/>
                    <c:set var="accountType" value="${account.accountType}"/>
                    <c:set var="authCode" value="${accountType eq '10' || accountType eq '11' || accountType eq '12'}"/>
                    <c:choose>
                        <c:when test="${accountType eq '10'}">
                            <c:set var="tutorialImg" value="wxzf-fs"/>
                            <c:set var="name" value="${dicts.content.account_type[accountType]}"/>
                            <c:set var="thirdAccountType" value="${name}"/>
                        </c:when>
                        <c:when test="${accountType eq '12'}">
                            <c:set var="tutorialImg" value="qqqb-fs"/>
                            <c:set var="name" value="${dicts.content.account_type[accountType]}"/>
                            <c:set var="thirdAccountType" value="${name}"/>
                        </c:when>
                        <c:when test="${accountType eq '11'}">
                            <c:set var="tutorialImg" value="zfb-fs"/>
                            <c:set var="name" value="${dicts.content.account_type[accountType]}"/>
                            <c:set var="thirdAccountType" value="${name}"/>
                        </c:when>
                    </c:choose>
                    <c:set var="onlinePayMax" value="${account.singleDepositMax}"/>
                    <c:set var="onlinePayMin" value="${account.singleDepositMin}"/>
                    <c:set var="onlinePayMin" value="${empty onlinePayMin || onlinePayMin<=0?0.01:soulFn:formatCurrency(onlinePayMin)}"/>
                    <c:set var="onlinePayMax" value="${empty onlinePayMax?'99,999,999':soulFn:formatCurrency(onlinePayMax)}"/>
                    <c:set var="accountLimit" value="* 范围:${onlinePayMin} ~ ${onlinePayMax}"/>
                    <c:if test="${index==0}">
                        <c:set var="firstPayAccount" value="${account}"/>
                        <c:set var="isAuthCode" value="${authCode}"/>
                        <c:set var="firstAccountLimit" value="${accountLimit}"/>
                    </c:if>
                    <label class="bank ${index == 0?'select':''}">
                        <span class="radio"><input name="account" showSuccMsg="false" isThird="false" rechargeType="${onlineType}" amountLimit="${accountLimit}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" type="radio" isAuthCode="${authCode}" randomAmount="${account.randomAmount}" ${index == 0?'checked':''} value="${command.getSearchId(account.id)}"></span>
                        <span class="radio-bank" title="${name}">
                            <i class="pay-third sm ${bankCode}"></i><font class="diy-pay-title">${name}</font>
                        </span>
                        <span class="bank-logo-name">${name}</span>
                    </label>
                    <c:set var="index" value="${index+1}"/>
                </c:forEach>
                <c:forEach items="${electronic}" var="account" varStatus="vs">
                    <c:if test="${vs.index == 0}">
                        <c:set var="thirdBankName" value="${dicts.common.bankname[account.bankCode]}"/>
                        <c:set var="thirdBankCode" value="${account.bankCode}"/>
                    </c:if>
                    <c:set var="onlinePayMax" value="${rank.onlinePayMax}"/>
                    <c:set var="onlinePayMin" value="${rank.onlinePayMin}"/>
                    <c:set var="onlinePayMin" value="${empty onlinePayMin || onlinePayMin<=0?0.01:soulFn:formatCurrency(onlinePayMin)}"/>
                    <c:set var="onlinePayMax" value="${empty onlinePayMax?'99,999,999':soulFn:formatCurrency(onlinePayMax)}"/>
                    <c:set var="accountLimit" value="* 范围:${onlinePayMin} ~ ${onlinePayMax}"/>
                    <c:if test="${index==0}">
                        <c:set var="firstPayAccount" value="${account}"/>
                        <c:set var="firstAccountLimit" value="${accountLimit}"/>
                    </c:if>
                    <label class="bank ${index == 0?'select':''}">
                        <c:set var="name" value="${account.aliasName}"/>
                        <span class="radio"><input name="account" type="radio" showSuccMsg="false" ${index == 0?'checked':''} bankName="${thirdBankCode eq 'onecodepay'?'':account.fullName}" accountCode="${account.code}" bankNum="${account.account}" isThird="true" rechargeType="${companyType}" amountLimit="${accountLimit}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" value="${command.getSearchId(account.id)}"/></span>
                        <span class="radio-bank" title="${name}">
                            <i class="pay-third sm ${account.bankCode}"></i>
                            <font class="diy-pay-title">${name}</font>
                        </span>
                        <span class="bank-logo-name">${name}</span>
                    </label>
                    <c:set var="index" value="${index+1}"/>
                </c:forEach>
            </div>
            <div class="clear"></div>
        </div>
    </div>
</div>
<%--只有电子支付展示收款账号信息--%>
<c:if test="${fn:length(electronic)>0}">
    <div name="electronicElement" class="account-list account-info-warp" style="${firstPayAccount.type eq '1'?'':'display:none'}">
        <div class="left-ico-message clearfix">
            <h4>请用${thirdBankName}存款至以下帐户：</h4>
            <span class="deposit-info-title">步骤2<img src="${resRoot}/images/online-pay2.png"></span>
            <div class="left-warp">
                <div class="bank-paidtotal">
                    <ul>
                        <li>
                            <div class="bankinfo bankinfo-m">
                                <h1><i class="pay-third ${thirdBankCode}"></i></h1>
                                <c:choose>
                                    <c:when test="${isHide}">
                                       <span class="orange select">
                                            <i class="orange fontsbig">${views.fund_auto['账号代码']}：<span id="accountCode">${firstPayAccount.code}</span></i>
                                            <i class="m-bigl">
                                                <soul:button target="customerService" text="${(empty hideContent.value) ? views.fund_auto['联系客服获取账号'] : hideContent.value}" url="${customerService}" opType="function"/>
                                            </i>
                                       </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="orange paidname select" data-clipboard-target="bankNum" data-clipboard-text="" name="copy">
                                            <em class="bank-number" ${thirdBankCode eq 'onecodepay'?'id="bankNum"':''}>${thirdBankCode eq 'onecodepay'?'不显示':firstPayAccount.account}</em>
                                            <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                 <span class="paidname select" data-clipboard-target="bankName" data-clipboard-text="" name="copy">
                                    <em class="gray">${views.fund_auto['姓名']}：</em>
                                    <em class="gathering-name" ${thirdBankCode eq 'onecodepay'?'id="bankName"':''}>${thirdBankCode eq 'onecodepay'?'不显示':firstPayAccount.fullName}</em>
                                    <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                </span>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="control-group">
                    <div class="m-l" id="accountRemark">
                        ${firstPayAccount.remark}
                    </div>
                    <c:if test="${firstPayAccount.bankCode eq 'alipay'}">
                        <a href="javascript:;" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=62" class="m-l openPage">${fn:replace(views.fund_auto['是否查看转账演示'],"{0}", thirdBankName)}</a>
                    </c:if>
                </div>
            </div>
            <div class="pull-left" style="${!empty firstPayAccount.qrCodeUrl?'':'display:none'}">
                <span class="two-dimension">
                    <img src="${soulFn:getThumbPath(domain,firstPayAccount.qrCodeUrl,176,176)}"/>
                    <em><img src="${resRoot}/images/two-dimension-ico.png" class="pull-left"/>${thirdBankName}${views.fund_auto['扫一扫付款']}</em>
                </span>
                <span><img src="${resRoot}/images/two-dimension123.png"></span>
            </div>
        </div>
    </div>
</c:if>

<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>请填写存款金额：</h4>
        <span class="deposit-info-title">步骤<span id="step">${firstPayAccount.type eq '1'?'3':'2'}</span><img src="${resRoot}/images/online-pay2.png"></span>
        <div class="control-group" name="scanElement" style="${firstPayAccount.type eq '1'?'display:none':''}">
            <label class="control-label">存款帐号：</label>
            <div class="controls">${username}</div>
        </div>
        <c:if test="${thirdBankCode eq 'alipay'}">
            <div class="control-group" name="electronicElement">
                <label class="control-label" for="result.payerName">您的支付户名：</label>
                <div class="controls">
                    <input type="text" class="input" id="result.payerName" name="result.payerName" placeholder="请填写存款时使用的真实姓名">
                </div>
            </div>
        </c:if>
        <c:if test="${thirdBankCode != 'onecodepay'}">
            <div class="control-group" name="electronicElement" style="${firstPayAccount.type eq '1'?'':'display:none'}">
                <c:choose>
                    <c:when test="${thirdBankCode eq 'wechatpay'}">
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${thirdBankName}${views.fund_auto['账号']}："/>
                    </c:when>
                    <c:when test="${thirdBankCode eq 'qqwallet'}">
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}QQ号码："/>
                    </c:when>
                    <c:when test="${thirdBankCode eq 'other'}">
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${thirdBankName}${views.fund_auto['账号']}："/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${thirdBankName}${views.fund_auto['账号']}："/>
                    </c:otherwise>
                </c:choose>
                <label class="control-label" for="result.payerBankcard">${accountLabel}</label>
                <div class="controls">
                    <input type="text" id="result.payerBankcard" name="result.payerBankcard" class="input" placeholder="* 如：陈XX">
                </div>
            </div>
        </c:if>
        <div name="electronicElement" class="control-group" style="${firstPayAccount.type eq '1'?'':'display:none'}">
            <label class="control-label">${views.fund_auto['订单号（后5位）']}：</label>
            <div class="controls">
                <input type="text" class="input" placeholder="${views.fund_auto['请填写订单号非商户订单号']}" maxlength="5" name="result.bankOrder" autocomplete="off">
            </div>
        </div>
        <c:if test="${!empty thirdAccountType}">
            <div name="authCode" class="control-group" style="${isAuthCode?'':'display:none'}">
                <input type="hidden" name="isAuthCode" value="${isAuthCode}"/>
                <label class="control-label" for="payerBankcard">授权码：</label>
                <div class="controls" style="width: 525px">
                    <input type="text" class="input" name="payerBankcard" id="payerBankcard" placeholder="获取授权码，参考下方教程" autocomplete="off"/>
                </div>
            </div>
        </c:if>
        <div class="control-group">
            <label class="control-label" for="result.rechargeAmount">存款金额：</label>
            <div class="controls">
                <input type="text" class="input" name="rechargeAmount" placeholder="${firstAccountLimit}">
                <input type="hidden" class="input" name="result.rechargeAmount" id="result.rechargeAmount">
                <input type="hidden" name="rechargeDecimals" value="${rechargeDecimals}"/>
                <span class="right-decimals" style="${firstPayAccount.randomAmount?'':'display:none'}" id="rechargeDecimals">.${rechargeDecimals}</span>
                <span tipsName="result.rechargeAmount-tips"></span>
                <span class="fee"></span>
            </div>
        </div>
        <!--优惠-->
        <%@include file="sale.jsp"%>
        <%--验证码--%>
        <%@include file="CaptchaCode.jsp"%>
        <div class=" control-group">
            <label class="control-label"></label>
            <input type="hidden" name="result.rechargeType" value="${firstPayAccount.type eq '1'?companyType:onlineType}"/>
            <soul:button target="submit" precall="validateForm" text="立即存款" opType="function" cssClass="btn-blue btn large-big" tag="button"/>
        </div>
        <div class="applysale">
            <ul class="transfer-tips">
                <li>支付成功后，请等待几秒钟，提示[<span class="red">支付成功</span>]后按确认件后再关闭支付窗口。</li>
                <li>
                    如充值后未到账，请联系在线客服。
                    <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                </li>
            </ul>
        </div>
        <div name="authCode" class="fansao-wrap" style="${isAuthCode?'':'display:none'}">
            <div class="fansao-title">${thirdAccountType}教程</div>
            <div class="fansao-img"><img src="${resRoot}/images/${tutorialImg}.png"></div>
        </div>
    </div>
</div>
<div class="modal-backdrop in" style="display: none" id="backdrop"></div>
<%--完成存款弹窗--%>
<div class="modal inmodal in" style="display: none" id="electronicDialog" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content animated bounceInRight family">
            <div class="modal-header">
                <span class="filter">完成存款，提交申请</span>
                <soul:button target="closeElectronicDialog" text="取消提交" opType="function" cssClass="close" tag="button">
                    <span aria-hidden="true">×</span>
                    <span class="sr-only">关闭</span>
                </soul:button>
            </div>
            <div class="modal-body">
                <div class="withdraw-not text-15p">
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['存款金额']}：</label>
                        <div class="col-xs-6 p-x f-size26" id="confirmRechargeAmount"></div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['手续费/返手续费']}：</label>
                        <div class="col-xs-6 p-x">
                            <%--green--%>
                            <em class="red f-size26" id="confirmFee"></em>
                        </div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs">
                        <label class="col-xs-5 al-right bold">实际到账：</label>
                        <div class="col-xs-6 p-x">
                            <em class="red f-size26" id="confirmRechargeTotal"></em>
                        </div>
                    </div>
                </div>
                <div class="clearfix bg-gray p-t-xs al-center">
                    <div class="clearfix line-hi25 p-sm caution-pop">
                        <em><i class="mark plaintsmall"></i> 系统审核通过后，您的钱包余额将增加相应的“实际到账”金额。</em>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button target="electronicSubmit" precall="validateForm" text="已存款，确认提交" opType="function" cssClass="btn btn-filter" tag="button"/>
                <soul:button target="closeElectronicDialog" text="取消提交" opType="function" cssClass="btn btn-outline btn-filter" tag="button"/>
            </div>
        </div>
    </div>
</div>
<%--失败弹窗--%>
<div class="modal inmodal in" style="display: none" id="electronicFailDialog" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content animated bounceInRight family">
            <div class="modal-header">
                <span class="filter">${views.fund['Deposit.deposit.depositFail']}</span>
                <soul:button target="closeElectronicDialog" text="取消提交" opType="function" cssClass="close" tag="button">
                    <span aria-hidden="true">×</span>
                    <span class="sr-only">关闭</span>
                </soul:button>
            </div>
            <div class="modal-body">
                <div class="theme-popcon">
                    <h3 class="popalign"><i class="tipbig fail"></i>${views.fund['Deposit.deposit.depositFail']}</h3>
                    <div class="text">
                        <p>${views.fund['Deposit.deposit.failureReason']}</p>
                        <p>${views.fund['Deposit.deposit.failOtherReason']}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button tag="button" target="back" text="${views.fund_auto['再存一次']}" opType="function" cssClass="btn btn-filter"/>
                <soul:button tag="button" target="customerService" text="${views.common['contactCustomerService']}" cssClass="btn btn-outline btn-filter" url="${customerService}" opType="function"/>
            </div>
        </div>
    </div>
</div>
<%--成功弹窗--%>
<div class="modal inmodal in" style="display: none" id="electronicSuccessDialog" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content animated bounceInRight family">
            <div class="modal-header">
                <span class="filter">${views.fund['Deposit.deposit.submitSuccess']}</span>
                <soul:button target="back" text="" opType="function" cssClass="close" tag="button">
                    <span aria-hidden="true">×</span>
                    <span class="sr-only">关闭</span>
                </soul:button>
            </div>
            <div class="modal-body">
                <div class="theme-popcon">
                    <h3 class="popalign"><i class="tipbig fail"></i>${views.fund['Deposit.deposit.submitSuccess']}</h3>
                    <div class="text">
                        <p>${views.fund['Deposit.deposit.submitSuccessTips']}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button tag="button" target="back" text="${views.fund_auto['再存一次']}" opType="function" cssClass="btn btn-filter"/>
                <soul:button tag="button" target="viewRecharge" text="${views.fund['Deposit.deposit.viewTrasaction']}" cssClass="btn btn-outline btn-filter" opType="function"/>
            </div>
        </div>
    </div>
</div>
</form>
<soul:import res="site/fund/recharge/ScanElectronic"/>