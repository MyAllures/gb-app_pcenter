<%--@elvariable id="payAccountList" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--电子支付平台-->
<form>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['电子支付']}</h2></div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <c:if test="${fn:length(payAccountList)<=0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${fn:length(payAccountList)>0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['选择存款方式']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                            <label class="bank ${vs.index==0?'select':''}">
                                <span class="radio"><input name="result.payAccountId" value="${i.id}" type="radio" ${vs.index==0?'checked':''}></span>
                                <span class="radio-bank" title="${dicts.common.bankname[i.bankCode]}"><i class="pay-third ${i.bankCode}"></i></span>
                                <span class="bank-logo-name">${dicts.common.bankname[i.bankCode]}</span>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                <div class="left-ico-message clearfix accountMap" id="payAccount${i.id}" style="${vs.index==0?'':'display:none'}">
                    <h4>${fn:replace(views.fund_auto['请存款至以下账户'], "{0}",dicts.common.bankname[i.bankCode])}：</h4>
                    <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                    <div class="left-warp">
                        <div class="bank-paidtotal">
                            <ul>
                                <li>
                                    <div class="bankinfo bankinfo-m">
                                        <c:set var="flag" value="${empty i.customBankName||dicts.common.bankname[i.bankCode]==i.customBankName}"/>
                                        <h1><i class="${flag?'pay-third ':''} ${flag?i.bankCode:''}" style="font-size: small;">${flag?'':i.customBankName}</i></h1>
                                        <c:choose>
                                            <c:when test="${isHide}">
                                               <span class="orange select">
                                                    <i class="orange fontsbig">${views.fund_auto['账号代码']}：${i.code}</i>
                                                    <i class="m-bigl">
                                                        <soul:button target="customerService" text="${(empty hideContent.value) ? views.fund_auto['联系客服获取账号'] : hideContent.value}" url="${customerService}" opType="function"/>
                                                    </i>
                                               </span>
                                            </c:when>
                                            <c:otherwise>
                                              <span class="orange paidname select" data-clipboard-target="bankCard${i.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                                <em class="bank-number" id="bankCard${i.id}">${i.account}</em>
                                                <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                            </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="paidname select" data-clipboard-target="fullName${i.id}" data-clipboard-text="Default clipboard text from attribute" name="copy">
                                            <em class="gray">${views.fund_auto['姓名']}：</em>
                                            <em class="gathering-name" id="fullName${i.id}">${i.fullName}</em>
                                           <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                        </span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <c:if test="${!empty i.remark}">
                            <div>
                                <p style="margin: 15px 23px">${i.remark}</p>
                            </div>
                        </c:if>
                        <div class=" control-group">
                            <c:if test="${!empty banks[i.bankCode].website}">
                                <a href="${banks[i.bankCode].website}" target="_blank" type="button" class="btn btn-outline btn-filter m-l">${fn:replace(views.fund_auto['去转账'],"{0}", dicts.common.bankname[i.bankCode])}</a>
                            </c:if>
                            <c:if test="${!vs.last}">
                                <a href="javascript:;" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=62" class="m-l openPage">${fn:replace(views.fund_auto['是否查看转账演示'],"{0}", dicts.common.bankname[i.bankCode])}</a>
                            </c:if>
                        </div>
                    </div>
                    <c:if test="${! empty i.qrCodeUrl}">
                        <div class="pull-left">
                        <span class="two-dimension">
                            <img src="${soulFn:getThumbPath(domain,i.qrCodeUrl,176,176)}" style="width: 176px;height: 176px;"/>
                            <em><img src="${resRoot}/images/two-dimension-ico.png" class="pull-left">${dicts.common.bankname[i.bankCode]}${views.fund_auto['扫一扫付款']}</em>
                        </span>
                            <span><img src="${resRoot}/images/two-dimension123.png"></span>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay3.png"></span>
                <ul class="attention-list">
                    <li class="red">${views.fund_auto['扫码存款提醒']}</li>
                    <li>${fn:replace(fn:replace(fn:replace(views.fund_auto['扫码存款限额范围'], "{0}",siteCurrency ), "{1}", empty rank.onlinePayMin?'1.00':soulFn:formatCurrency(rank.onlinePayMin)),"{2}" , empty rank.onlinePayMax?'99,999,999.00':soulFn:formatCurrency(rank.onlinePayMax))}
                    </li>
                </ul>
                <div class=" control-group">
                    <soul:button target="submit" text="${views.fund_auto['已完成存款，下一步']}" opType="function" cssClass="btn-blue btn large-big  m-l"/>
                </div>
            </div>
        </div>
    </c:if>
</form>
<script type="text/javascript">
    curl(['site/fund/recharge/ElectronicPayFirst','site/fund/recharge/CommonRecharge'], function(Page, CommonRecharge) {
        page = new Page();
        page.bindButtonEvents();
        page.commonRecharge = new CommonRecharge();
    });
</script>