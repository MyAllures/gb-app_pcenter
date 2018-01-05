<%--@elvariable id="payAccount" type="so.wwb.gamebox.model.master.content.po.PayAccount"--%>
<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--柜台转账步奏2-->
<form>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="result.rechargeType" value="${playerRechargeVo.result.rechargeType}"/>
    <input type="hidden" name="result.payAccountId" value="${playerRechargeVo.result.payAccountId}">
    <input type="hidden" name="result.rechargeAmount" value="${playerRechargeVo.result.rechargeAmount}"/>
    <input type="hidden" name="activityId" value="${playerRechargeVo.activityId}">
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${dicts.fund.recharge_type[playerRechargeVo.result.rechargeType]}</h2></div>
        <a href="/fund/recharge/company/atmCounterFirst.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message clearfix">
            <h4>${views.fund_auto['请用存款至下方银行账户']}：</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay1.png"></span>
            <div class="bank-paidtotal">
                <ul>
                    <li>
                        <div class="bankinfo  linbankinfo-m">
                            <h1>
                                <c:set var="isOther" value="${payAccount.bankCode=='other_bank'}"/>
                                <i class="${isOther?'':'pay-bank '} ${payAccount.bankCode}"></i>
                                <c:if test="${!isOther}">
                                    <em class="cardlabel debit"></em>
                                </c:if>
                                <c:if test="${isOther}">
                                    <i style="font-size: small;">${payAccount.customBankName}</i>
                                </c:if>
                             </h1>
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
                                        <span class="orange cardnumber select" data-clipboard-target="bankCard${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                            <em class="bank-number" id="bankCard${payAccount.id}">${soulFn:formatBankCard(payAccount.account)}</em>
                                            <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                        </span>
                                </c:otherwise>
                            </c:choose>
                            <span class="paidname select" data-clipboard-target="fullName${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                    <em class="gray">${views.fund_auto['银行用户名']}：</em>
                                    <em class="gathering-name" id="fullName${payAccount.id}">${payAccount.fullName}</em>
                                    <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                            </span>
                            <c:if test="${!empty payAccount.openAcountName}">
                                    <span class="paidname select" data-clipboard-target="openAcountName${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                        <em class="gray">${views.fund_auto['开户支行']}：</em>
                                        <em class="gathering-name" id="openAcountName${payAccount.id}">${payAccount.openAcountName}</em>
                                        <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                    </span>
                            </c:if>
                            <span class="paidname select" data-clipboard-target="rechargeAmount${payAccount.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                <em class="gray">${views.fund_auto['存款金额']}：</em>
                                <em class="gathering-name orange fontsbig" id="rechargeAmount${payAccount.id}">${soulFn:formatInteger(playerRechargeVo.result.rechargeAmount)}${soulFn:formatDecimals(playerRechargeVo.result.rechargeAmount)}</em>
                                <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                            </span>
                        </div>
                    </li>
                </ul>
            </div>
            <c:if test="${!empty payAccount.remark}">
                <div>
                    <pre style="margin: 20px">${payAccount.remark}</pre>
                </div>
            </c:if>
            <ul class="attention-list">
                <c:if test="${playerRechargeVo.result.rechargeType=='atm_money'}">
                    <li class="orange">※ ${views.fund_auto['汇款提醒']}</li>
                </c:if>
                <c:if test="${playerRechargeVo.result.rechargeType!='atm_money'}">
                   <%-- <li class="red">※ 请严格依照指定金额，包括小数点，否则将造成您的存款掉单！</li>--%>
                </c:if>
                <li><a href="javascript:;" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=63" class="openPage">${views.fund_auto['查看转账演示']}？</a></li>
            </ul>
        </div>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <h4>${views.fund_auto['完成存款后请填写以下信息']}</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤4']}<img src="${resRoot}/images/online-pay3.png"></span>
            <c:if test="${playerRechargeVo.result.rechargeType=='atm_money'}">
                <!--柜员机现金存款需填写回执信息-->
                <div class="control-group">
                    <label class="control-label" for="result.rechargeAddress">${views.fund_auto['交易地点']}：</label>
                    <div class="controls">
                        <input type="text" id="result.rechargeAddress" name="result.rechargeAddress" maxlength="50" class="input" placeholder="${views.fund_auto['请填写路名']}" style="width:270px;">
                    </div>
                </div>
            </c:if>
            <c:if test="${playerRechargeVo.result.rechargeType!='atm_money'}">
                <!--银行柜台、柜员机转帐需填写回执信息-->
                <div class="control-group">
                    <label class="control-label" for="result.payerName">${views.fund_auto['存款人姓名']}：</label>
                    <div class="controls">
                        <input type="text" name="result.payerName" id="result.payerName" placeholder="${views.fund_auto['您转账时使用的银行卡姓名']}" class="input" style="width:240px;">
                    </div>
                </div>
            </c:if>
            <ul class="attention-list">
                <li class="red">※ ${views.fund_auto['存款提醒1']}</li>
                <li>※ ${views.fund_auto['存款提醒2']}</li>

            </ul>
            <div class=" control-group">
                <soul:button target="confirm" precall="validateForm" text="${views.fund_auto['完成存款，提交申请']}" opType="function" cssClass="btn-blue btn large-big  m-l" tag="button"/>
            </div>
        </div>
    </div>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/AtmCounterSecond'], function(Page) {
        page = new Page();
        page.bindButtonEvents();
    });
</script>