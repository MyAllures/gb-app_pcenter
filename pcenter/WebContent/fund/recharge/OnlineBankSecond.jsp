<%--@elvariable id="payAccount" type="so.wwb.gamebox.model.master.content.po.PayAccount"--%>
<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%--@elvariable id="bankList" type="java.util.List<so.wwb.gamebox.model.company.po.Bank>"--%>
<%--@elvariable id="bank" type="so.wwb.gamebox.model.company.po.Bank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--网银存款步奏2-->
<form>
    <input type="hidden" name="result.payAccountId" value="${playerRechargeVo.result.payAccountId}"/>
    <input type="hidden" name="result.rechargeAmount" value="${playerRechargeVo.result.rechargeAmount}"/>
    <input type="hidden" name="activityId" value="${playerRechargeVo.activityId}"/>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="notice">
        <div class="notice-left"> <em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['网银存款']}</h2></div>
        <soul:button target="goToBack" cssClass="btn-gray btn btn-big pull-right" text="${views.fund_auto['返回上一级']}" opType="function"/>
    </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message clearfix">
            <h4>${views.fund_auto['请用存款至下方银行账户']}：</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay1.png"></span>
            <div class="bank-paidtotal">
                <ul>
                    <li>
                        <div class="bankinfo linbankinfo-m">
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
                    <pre style="margin: 20px;white-space: pre-wrap;word-wrap: break-word;">${payAccount.remark}</pre>
                </div>
            </c:if>
            <ul class="attention-list">
                <li>
                  <%--  <em class="orange">※ 请严格依照指定金额存款，包括小数点，否则将造成您的存款掉单！</em>--%>
                    <a href="javascript:;" class="openPage" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=9">${views.fund_auto['查看转账演示帮助']}？</a>
                </li>
            </ul>
            <div class=" control-group bank-menu">
                <c:set var="len" value="0"/>
                <c:if test="${!empty bank.website}">
                    <a href="${bank.website}" target="_blank" class="btn btn-outline btn-filter">${fn:replace(views.fund_auto['去转账'], "{0}",dicts.common.bankname[bank.bankName])}</a>
                    <c:set var="len" value="${len+1}"/>
                </c:if>
                <c:forEach items="${bankList}" var="i" varStatus="vs">
                    <c:if test="${i.bankName!=bank.bankName}">
                        <c:if test="${len==4}">
                            <div id="expendBanks" style="display:none">
                        </c:if>
                        <c:if test="${!empty i.website}">
                            <a href="${i.website}" type="button" target="_blank" class="btn btn-outline btn-filter">${fn:replace(views.fund_auto['去转账'], "{0}",dicts.common.bankname[i.bankName])}</a>
                            <c:set var="len" value="${len+1}"/>
                        </c:if>
                        <c:if test="${len>4&&vs.index+1==fn:length(bankList)}">
                            </div>
                        </c:if>
                    </c:if>
                </c:forEach>
                <c:if test="${len>4}">
                    <soul:button target="expendBanks" text="" cssClass="more-pull-down" opType="function"><span>${views.fund_auto['查看更多网上银行']}</span><i class="bank-arrico down"></i></soul:button>
                </c:if>
            </div>
          </div>
        </div>
    <div class="account-list account-info-warp">
        <div class="left-ico-message">
            <h4>${views.fund_auto['完成存款申请']}</h4>
            <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay3.png"></span>
            <div class="control-group">
                <label class="control-label" for="result.payerName">${views.fund_auto['存款人姓名']}：</label>
                <div class="controls">
                    <input type="text" id="result.payerName" name="result.payerName" placeholder="${views.fund_auto['您转账时使用的银行卡姓名']}" class="input" style="width:270px;">
                </div>
            </div>
            <ul class="attention-list">
                <li class="red">1、${views.fund_auto['存款提醒1']}</li>
                <li>2、${views.fund_auto['存款提醒2']} </li>
            </ul>
            <div class=" control-group">
                <soul:button target="commonRecharge.confirm" precall="validateForm" callback="back" text="${views.fund_auto['完成存款，提交申请']} " opType="function" cssClass="btn-blue btn large-big  m-l" tag="button"/>
            </div>
        </div>
    </div>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/OnlineBankSecond','site/fund/recharge/CommonRecharge'], function(Page, CommonRecharge) {
        page = new Page();
        page.bindButtonEvents();
        page.commonRecharge = new CommonRecharge();
    });
</script>
