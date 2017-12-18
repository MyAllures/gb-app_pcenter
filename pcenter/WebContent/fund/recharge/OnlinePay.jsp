<%--@elvariable id="payAccountMap" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--在线支付-->
<form name="onlineForm">
    <gb:token/>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <input type="hidden" name="realNameDialog" value="${realNameDialog}">
    <input type="hidden" name="displayFee" value="${rank.isFee || rank.isReturnFee}"/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['在线支付']}</h2></div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <c:if test="${fn:length(payAccountMap)<=0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${fn:length(payAccountMap)>0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['选择您将使用的银行']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountMap}" var="i" varStatus="vs">
                            <c:if test="${vs.index==0}">
                                <c:set var="onlinePayMax" value="${i.value.singleDepositMax}"/>
                                <input type="hidden" id="randomAmount" value="${i.value.randomAmount}"/>
                                <c:choose>
                                    <c:when test="${empty i.value.singleDepositMin}">
                                        <c:set var="onlinePayMin" value='1.00'/>
                                    </c:when>
                                    <c:when test="${i.value.singleDepositMin==0}">
                                        <c:set var="onlinePayMin" value='0.01'/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="onlinePayMin" value="${soulFn:formatCurrency(i.value.singleDepositMin)}"/>
                                    </c:otherwise>
                                </c:choose>

                            </c:if>
                            <c:if test="${vs.index==16}"><div name="hideBank" style="display: none"></c:if>
                            <label class="bank ${vs.index==0?'select':''}">
                                <span class="radio"><input name="result.payerBank" value="${i.key}" type="radio" ${vs.index==0?'checked':''}></span>
                                <span class="radio-bank" title="${dicts.common.bankname[i.key]}"><i class="pay-bank ${i.key}"></i></span>
                                <span class="bank-logo-name">${dicts.common.bankname[i.key]}</span>
                                <input type="hidden" class="onlinePayMax" value="${empty i.value.singleDepositMax?'99,999,999.00':soulFn:formatCurrency(i.value.singleDepositMax)}"/>
                                <input type="hidden" class="onlinePayMin" value="${empty i.value.singleDepositMin?'0.01':soulFn:formatCurrency(i.value.singleDepositMin)}"/>
                            </label>
                            <c:if test="${fn:length(payAccountMap)>16&&vs.index==(fn:length(payAccountMap)-1)}"></div></c:if>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
                <c:if test="${fn:length(payAccountMap)>16}">
                    <div class="bank-spreadout set">
                        <soul:button target="expendBank" text="" opType="function">
                            <span>${views.fund_auto['展开更多银行']}</span>  <i class="bank-arrico down"></i>
                        </soul:button>
                    </div>
                </c:if>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请填写存款金额']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                <form>
                    <div class="control-group">
                        <label class="control-label">${views.fund_auto['存款账号']}：</label>
                        <div class="controls">${username}</div>
                    </div>
                    <div class="control-group">
                        <label class="control-label" for="result.rechargeAmount" autocomplete="off">${views.fund_auto['存款金额']}：</label>
                        <div class="controls" style="width: 480px">
                            <input type="text" class="input" name="result.rechargeAmount" id="result.rechargeAmount" autocomplete="off">
                            <span class="fee"></span>
                        </div>
                    </div>

                    <%@include file="sale.jsp"%>
                    <%@include file="CaptchaCode.jsp"%>
                    <div class=" control-group">
                        <label class="control-label"></label>
                        <soul:button target="submit" precall="validateForm" text="${views.fund_auto['立即存款']}" callback="back" opType="function" cssClass="btn-blue btn large-big disabled _submit"/>
                    </div>
                    <div>
                    </div>
                </form>
            </div>
        </div>

        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <span class="deposit-info-title">${views.fund_auto['注意事项']}<img src="${resRoot}/images/online-pay3.png"></span>
                <ul class="attention-list">
                    <li>1.${fn:replace(fn:replace(fn:replace(views.fund_auto['在线快速存储单笔限额范围'], "{0}",siteCurrency ), "{1}", onlinePayMin),"{2}" , empty onlinePayMax?'99,999,999.00':soulFn:formatCurrency(onlinePayMax))}
                    </li>
                    <!--随机额度提示-->
                    <div name="randomAmountMsg">
                    <li>2.${views.fund_auto['随机额度提示信息']}</li>
                    </div>
                </ul>
            </div>
        </div>
    </c:if>

</form>
<soul:import res="site/fund/recharge/OnlinePay"/>