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
<c:if test="${fn:length(scan)<=0 && fn:length(electronic)<=0}">
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
            <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
        </div>
    </div>
</c:if>
<c:if test="${fn:length(scan)>0 || fn:length(electronic)>0}">
<div id="validateRule" style="display: none">${validateRule}</div>
<gb:token/>
<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>选择支付方式：</h4>
        <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
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
                        <c:otherwise>
                            <c:set var="key" value="recharge.scanElectronic.accountType.${accountType}"/>
                            <c:set var="name" value="${views.fund[key]}"/>
                        </c:otherwise>
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
                        <span class="radio"><input name="account" bankCode="${bankCode}" depositType="scan" showSuccMsg="false" isThird="false" rechargeType="${onlineType}" amountLimit="${accountLimit}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" type="radio" isAuthCode="${authCode}" randomAmount="${account.randomAmount}" ${index == 0?'checked':''} value="${command.getSearchId(account.id)}"></span>
                        <span class="radio-bank" title="${name}">
                            <i class="pay-third sm ${bankCode}"></i><font class="diy-pay-title"><c:out value="${name}"/></font>
                        </span>
                        <span class="bank-logo-name"><c:out value="${name}"/></span>
                    </label>
                    <c:set var="index" value="${index+1}"/>
                </c:forEach>
                <c:forEach items="${electronic}" var="account" varStatus="vs">
                    <c:if test="${vs.index == 0}">
                        <c:set var="thirdBankName" value="${dicts.common.bankname[account.bankCode]}"/>
                        <c:set var="thirdBankCode" value="${account.bankCode}"/>
                    </c:if>
                    <c:set var="name" value="  ${thirdBankName}"/>
                    <c:if test="${account.bankCode == 'other'}">
                        <c:set var="name" value="  ${account.customBankName}"/>
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
                        <c:set var="name" value="${account.aliasName}"/><%--accountRemark="${account.remark}"--%>
                        <span class="radio"><input name="account" depositType="electronic" accountInformation="${account.accountInformation}" accountPrompt="${account.accountPrompt}" type="radio" qrCodeUrl="${empty account.qrCodeUrl?'':soulFn:getThumbPath(domain,account.qrCodeUrl,176,176)}" showSuccMsg="false" ${index == 0?'checked':''} bankName="${thirdBankCode eq 'onecodepay'?'':account.fullName}" accountCode="${account.code}" bankNum="${account.account}" isThird="true" rechargeType="${companyType}" amountLimit="${accountLimit}" customBankName="${account.customBankName}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" accountId="${account.id}" value="${command.getSearchId(account.id)}"/></span>
                        <span class="radio-bank" title="${name}">
                            <i class="pay-third sm ${account.bankCode}"></i>
                            <font class="diy-pay-title">${name}</font>
                        </span>
                        <span class="bank-logo-name">${name}</span>
                        <font style="display: none" class="remark${account.id}"><c:out value="${account.remark}"/></font>
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
            <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
            <div class="left-warp">
                <div class="bank-paidtotal">
                    <ul>
                        <li>
                            <div class="bankinfo bankinfo-m">
                                <h1><i class="pay-third ${thirdBankCode}"></i><i id="customBankName"> <c:out value="${firstPayAccount.customBankName}"/></i></h1>
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
                                        <span class="orange paidname select" data-clipboard-text="${thirdBankCode eq 'onecodepay'?'不显示':firstPayAccount.account}" name="copy">
                                            <em class="bank-number" ${thirdBankCode != 'onecodepay'?'id="bankNum"':''}>${thirdBankCode eq 'onecodepay'?'不显示':firstPayAccount.account}</em>
                                            <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                                 <span class="paidname select" data-clipboard-text="${thirdBankCode eq 'onecodepay'?'不显示':firstPayAccount.fullName}" name="copy">
                                    <em class="gray">${views.fund_auto['姓名']}：</em>
                                    <em class="gathering-name" ${thirdBankCode != 'onecodepay'?'id="bankName"':''}>${thirdBankCode eq 'onecodepay'?'不显示':firstPayAccount.fullName}</em>
                                    <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                </span>
                            </div>
                        </li>
                    </ul>
                </div>
                <div class="control-group">
                    <div class="m-l" id="accountRemark">
                        <c:out value="${firstPayAccount.remark}"/>
                    </div>
                    <%--<c:if test="${!empty firstPayAccount.remark}">
                        <div id="">
                            <p style="margin: 15px 23px">${firstPayAccount.remark}</p>
                        </div>
                    </c:if>--%>
                    <c:if test="${firstPayAccount.bankCode eq 'alipay'}">
                        <a href="javascript:;" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=62" class="m-l openPage">${fn:replace(views.fund_auto['是否查看转账演示'],"{0}", thirdBankName)}</a>
                    </c:if>
                </div>
            </div>
            <c:if test="${!isHide}">
                <div id="qrCodeUrl" class="pull-left" style="${!empty firstPayAccount.qrCodeUrl?'':'display:none'}">
                    <span class="two-dimension">
                        <img src="${soulFn:getThumbPath(domain,firstPayAccount.qrCodeUrl,176,176)}" style="width: 176px;height: 176px;"/>
                        <em><img src="${resRoot}/images/two-dimension-ico.png" class="pull-left"/>${thirdBankName}${views.fund_auto['扫一扫付款']}</em>
                    </span>
                    <span><img src="${resRoot}/images/two-dimension123.png"></span>
                </div>
            </c:if>
        </div>
    </div>
</c:if>

<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>请填写存款金额：</h4>
        <span class="deposit-info-title">步骤<span id="step">${firstPayAccount.type eq '1'?'3':'2'}</span><img src="${resRoot}/images/online-pay2.png"></span>
        <div class="control-group" name="scanElement" style="${firstPayAccount.type eq '1'?'display:none':''}">
            <label class="control-label">${views.fund_auto['存款账号']}：</label>
            <div class="controls">${username}</div>
        </div>
        <c:if test="${thirdBankCode eq 'alipay'}">
            <div class="control-group" name="electronicElement">
                <label class="control-label" for="result.payerName">您的支付户名：</label>
                <div class="controls">
                    <input style="width: 200px" type="text" class="input" id="result.payerName" name="result.payerName" placeholder="请填写存款时使用的真实姓名">
                </div>
            </div>
        </c:if>
        <c:if test="${thirdBankCode != 'onecodepay'}">
            <div class="control-group" name="electronicElement" style="${firstPayAccount.type eq '1'?'':'display:none'}">
                <c:choose>
                    <c:when test="${thirdBankCode eq 'wechatpay'}">
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${thirdBankName}${views.fund_auto['账号']}"/>
                    </c:when>
                    <c:when test="${thirdBankCode eq 'qqwallet'}">
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}QQ号码"/>
                    </c:when>
                    <c:when test="${thirdBankCode eq 'other'}">
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${thirdBankName}${views.fund_auto['账号']}"/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="accountLabel" value="${views.fund_auto['您的']}${thirdBankName}${views.fund_auto['账号']}"/>
                    </c:otherwise>
                </c:choose>
                <input type="hidden" id="accountLabelId" prompt="${views.fund_auto['账号举例']}" value="${accountLabel}" />
                <label class="control-label" id="payerBankcardLabel" for="result.payerBankcard">${not empty electronic[0].accountInformation ? electronic[0].accountInformation : accountLabel}：</label>
                <div class="controls">
                    <input style="width: 200px" type="text" id="result.payerBankcard" name="result.payerBankcard" class="input" placeholder="${not empty electronic[0].accountPrompt ? electronic[0].accountPrompt : views.fund_auto['账号举例']}">
                </div>
            </div>
        </c:if>
        <div name="electronicElement" class="control-group" style="${firstPayAccount.type eq '1'?'':'display:none'}">
            <label class="control-label">${views.fund_auto['订单号（后5位）']}：</label>
            <div class="controls">
                <input style="width: 200px" type="text" class="input" placeholder="${views.fund_auto['请填写商户订单号']}" maxlength="5" name="result.bankOrder" autocomplete="off">
            </div>
        </div>
        <c:if test="${!empty thirdAccountType}">
            <div name="authCode" class="control-group" style="${isAuthCode?'':'display:none'}">
                <input type="hidden" name="isAuthCode" value="${isAuthCode}"/>
                <label class="control-label" for="payerBankcard">授权码：</label>
                <div class="controls" style="width: 525px">
                    <input  style="width: 200px" type="text" class="input" name="payerBankcard" id="payerBankcard" placeholder="获取授权码，参考下方教程" autocomplete="off"/>
                </div>
            </div>
        </c:if>
        <div class="control-group">
            <label class="control-label" for="result.rechargeAmount">存款金额：</label>
            <div class="controls">
                <input style="width: 200px" type="text" class="input" name="rechargeAmount" placeholder="${firstAccountLimit}">
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
            <soul:button target="sumFailureCount" precall="validateForm" text="立即存款" opType="function" cssClass="btn-blue btn large-big" tag="button"/>
        </div>
        <div class="applysale">
            <%--扫码--%>
            <ul id="scanDocument" class="transfer-tips" style="display: none">
                <li>温馨提示：</li>
                <li>单笔储值最低<span style="color:red">${currency}</span><span id="payMin" style="color:red"></span>，最高为<span style="color:red">${currency}</span><span id="payMax" style="color:red"></span>，如存款高于上限请分多笔支付。</li>
                <c:if test="${firstPayAccount.randomAmount}">
                    <li>为了提高对账速度及成功率，当前支付方式已开随机额度，请输入整数存款金额，将随机增加0.11~0.99元！</li>
                </c:if>
                <li>支付成功后，请等待几秒钟，提示<span style="color:red">「支付成功」</span>按确认键后再关闭支付窗口。</li>
                <li>建议您使用Internet Explorer 9以上、360浏览器、Firefox或Google Chrome等浏览器浏览。</li>
                <li>如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。
                    <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                </li>
            </ul>
            <%--电子支付--%>
            <ul id="electronicDocument" class="transfer-tips" style="display: none">
                <li>温馨提示：</li>
                <li>请先搜索账号或扫描二维码添加好友。</li>
                <li>单笔储值最低<span style="color:red">${siteCurrency}${onlinePayMin}</span>，最高为<span style="color:red">${siteCurrency}${onlinePayMax}</span>，如存款高于上限请分多笔支付。</li>
                <li>存款金额请加以小数点或尾数，以便区别。如充值200元，请输入201元或200.1之类小数。</li>
                <li>支付成功后，请等待几秒钟，提示<span style="color:red">「支付成功」</span>按确认键后再关闭支付窗口。</li>
                <li>建议您使用Internet Explorer 9以上、360浏览器、Firefox或Google Chrome等浏览器浏览。</li>
                <li>如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。
                    <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                </li>
            </ul>
            <%--易收付--%>
            <ul id="easyPayDocument" class="transfer-tips" style="display: none">
                <li style="color:red;font-size: large">温馨提示：</li>
                <li style="color:red;font-size: large">当前支付额度必须精确到小数点，请严格核对您的转账金额精确到分，如：100.51，否则无法提高对账速度及成功率，谢谢您的配合。</li>
            </ul>
        </div>
        <div name="authCode" class="fansao-wrap" style="${isAuthCode?'':'display:none'}">
            <div class="fansao-title">${thirdAccountType}教程</div>
            <div class="fansao-img"><img src="${resRoot}/images/${tutorialImg}.png"></div>
        </div>
    </div>
</div>
<%@include file="CompanyRechargeDialog.jsp"%>
</c:if>
</form>
<soul:import res="site/fund/recharge/ScanElectronic"/>