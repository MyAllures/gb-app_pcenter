<%@ page import="so.wwb.gamebox.model.master.player.enums.UserBankcardTypeEnum" %>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.fund.vo.VPcenterWithdrawVo"--%>
<%--@elvariable id="bank" type="so.wwb.gamebox.model.master.player.po.UserBankcard"--%>
<%--@elvariable id="btc" type="so.wwb.gamebox.model.master.player.po.UserBankcard"--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<style type="text/css">
    .auditLogCss .modal-dialog{
        max-width:1000px;
        width: 100%;
    }
</style>
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right"><a class="cursor">${views.sysResource['取款专区']}</a></div>
</div>
<c:set var="bankType" value="<%=UserBankcardTypeEnum.TYPE_BANK%>"/>
<c:set var="btcType" value="<%=UserBankcardTypeEnum.TYPE_BTC%>"/>
<c:set var="totalBalance" value="${not empty player.walletBalance?player.walletBalance:0}"></c:set>
<c:if test="${not empty apiBalance}">
    <c:set var="totalBalance" value="${totalBalance + apiBalance}"></c:set>
</c:if>

<div class="main-wrap">
    <c:choose>
        <c:when test="${isDemo}">
            <%@include file="../../share/DemoNoPermit.jsp"%>
        </c:when>
        <c:when test="${hasOrder}">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext">
                    <p>${views.fund_auto['当前已有取款订单正在审核，']}</p>
                    <p>${views.fund_auto['请在该订单结束后再继续取款!']}&nbsp;</p>
                </div>
            </div>
        </c:when>
        <c:when test="${hasFreeze}">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext" style="padding: 0 80px">
                    <p>${empty player.balanceFreezeContent? views.fund_auto['您的账号余额已被冻结，请联系客服']:player.balanceFreezeContent}</p>
                </div>
            </div>
        </c:when>
        <c:when test="${not empty rank && (rank.withdrawMaxNum == null || rank.withdrawMinNum == null)}">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext">
                    <p>${views.fund_auto['暂时无法取款']}</p>
                </div>
            </div>
        </c:when>
        <c:when test="${(empty totalBalance) || (totalBalance < rank.withdrawMinNum || totalBalance <= 0)}">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext">
                    <p>${views.fund_auto['取款金额最少为']}${currencySign}${soulFn:formatCurrency(rank.withdrawMinNum)}</p>
                    <c:if test="${isLottery.paramValue=='false'}">
                        <p>${views.fund_auto['钱包余额不足提醒']}</p>
                    </c:if>
                    <c:if test="${!isLotterySite}">
                        <p>
                            <a class="btn-blue btn large-big gotoDespoit" href="javascript:void(0)">${views.fund_auto['转到钱包']}</a>
                        </p>
                    </c:if>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:if test="${totalBalance > 0 && totalBalance >= rank.withdrawMinNum}">
                <div class="hintotal float-not">
                    <form id="transferForm" class="location" method="post">
                        <div id="validateRule" style="display: none">${validate}</div>
                        <gb:token/>
                        <div class="control-group">
                            <label class="control-label line-hi42">${views.fund_auto['收款账号']}：</label>
                            <div class="controls">
                                <c:set var="bank" value="${bankcardMap.get(bankType)}"/>
                                <c:if test="${empty bank && isCash}">
                                    <c:forEach items="${bankcardMap}" var="i">
                                        <c:if test="${i.key == '' || i.value.type != btcType}">
                                            <c:set var="bank" value="${i.value}"/>
                                        </c:if>
                                    </c:forEach>
                                </c:if>
                                <c:set var="btc" value="${bankcardMap.get(btcType)}"/>
                                <c:choose>
                                    <%--两个收款帐号都有的、下拉--%>
                                    <c:when test="${isBit && isCash && !empty btc && !empty bank}">
                                        <div class="controls">
                                            <div class="controls">
                                                <div class="btn-group table-desc-right-t-dropdown bank-down-menu" id="bankcardMenu">
                                                    <input type="hidden" name="remittanceWay" value="1">
                                                    <button type="button" class="btn btn btn-default" data-toggle="dropdown" aria-expanded="false">
                                                        <c:set var="bankcardLen" value="${fn:length(bank.bankcardNumber)}"/>
                                                        <i class="pay-bank ${bank.bankName}"></i> 尾号:${fn:substring(bank.bankcardNumber, bankcardLen-4, bankcardLen)} <span>&nbsp;${soulFn:overlayName(bank.bankcardMasterName)}</span>
                                                        <span class="carat"></span>
                                                    </button>
                                                    <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                                                        <li role="presentation">
                                                            <a role="menuitem" tabindex="-1" href="javascript:void(0)" key="1"><i class="pay-bank ${bank.bankName}"></i> 尾号:${fn:substring(bank.bankcardNumber, bankcardLen-4, bankcardLen)}<span>&nbsp;${soulFn:overlayName(bank.bankcardMasterName)}</span><span><i class="arrow"></i></span></a>
                                                        </li>
                                                        <li role="presentation">
                                                            <c:set var="bankcardLen" value="${fn:length(btc.bankcardNumber)}"/>
                                                            <a role="menuitem" tabindex="-1" href="javascript:void(0)" key="2"><i class="pay-third ${btc.bankName}"></i> 尾号:${fn:substring(btc.bankcardNumber, bankcardLen-4, bankcardLen)}<span><i class="arrow"></i></span></a>
                                                        </li>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:when test="${isBit && !empty btc}">
                                        <div class="hintbank">
                                            <input type="hidden" name="remittanceWay" value="2">
                                            <i class="pay-third ${btc.bankName}"></i>
                                            ${views.fund_auto['尾号']}:${fn:substring(btc.bankcardNumber,fn:length(btc.bankcardNumber)-4, fn:length(btc.bankcardNumber))}
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="hintbank">
                                            <i class="pay-bank ${bank.bankName}"></i>
                                                ${views.fund_auto['尾号']}:${fn:substring(bank.bankcardNumber,fn:length(bank.bankcardNumber)-4, fn:length(bank.bankcardNumber))}
                                            <span>${soulFn:overlayName(bank.bankcardMasterName)}</span>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${isLottery.paramValue=='true'?views.home['index.account.totalAssets']:views.fund_auto['钱包余额']}：</label>
                            <div class="controls">
                                <span class="orange fontmiddle">
                                    <c:if test="${empty totalBalance}"><em>${currencySign}</em>0</c:if>
                                    <c:if test="${not empty totalBalance}">
                                        <em>${currencySign}</em>${soulFn:formatInteger(totalBalance)}${soulFn:formatDecimals(totalBalance)}
                                    </c:if>
                                </span>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label" for="withdrawAmount">${views.fund_auto['取款金额']}：</label>
                            <div class="controls">
                                <input type="hidden" name="walletBalance" value="${totalBalance}"/>
                                <input type="hidden" name="rankId" value="${rank.id}">
                                <input type="hidden" name="withdrawMaxNum" value="${rank.withdrawMaxNum}"/>
                                <input type="hidden" name="withdrawMinNum" value="${rank.withdrawMinNum}"/>
                                <input type="hidden" name="withdrawFee" id="withdrawFee" value="0"/>
                                <input type="hidden" name="balanceType" value="${player.balanceType}"/>
                                <input type="hidden" name="balanceFreeze" value="${player.balanceFreeze}"/>
                                <p class="character character-left">${currencySign}</p>
                                <input type="text" name="withdrawAmount" id="withdrawAmount" maxlength="10" class="input input-money m-20" showSuccMsg="false"
                                       style="height:35px;" placeholder="${rank.withdrawMinNum}-${rank.withdrawMaxNum}">
                            </div>
                            <div class="my-tips-div hide" style="padding-top: 8px">
                                <div class="controls my-tips">
                                </div>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${views.fund_auto['手续费']}：</label>
                            <div class="controls"><span class="line-hi30 counter-fee-css">
                                <c:if test="${auditMap.counterFee=='0'}">${views.fund_auto['免手续费']}</c:if>
                                <c:if test="${auditMap.counterFee!='0'}">
                                    <em>${currencySign}</em><span id="withdrawFee-span">${auditMap.counterFee}</span></span>
                                </c:if>

                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${views.fund_auto['行政费']}：</label>
                            <div class="controls">
                                <span class="line-hi30"><em>${currencySign}</em>${auditMap.administrativeFee>0?'-':''}
                                    ${soulFn:formatInteger(auditMap.administrativeFee)}${soulFn:formatDecimals(auditMap.administrativeFee)}
                                </span>
                                <c:if test="${auditMap.recordList}">
                                    <soul:button target="${root}/player/withdraw/showAuditLog.html" size="auditLogCss" cssClass="m-bigl btn btn-outline btn-filter" title="${views.fund_auto['稽核详细']}" text="${views.fund_auto['查看稽核详细']}" opType="dialog" />
                                </c:if>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${views.fund_auto['扣除优惠']}：</label>
                            <div class="controls">
                                <span class="line-hi30"><em>${currencySign}</em>${auditMap.deductFavorable>0?'-':''}
                                    ${soulFn:formatInteger(auditMap.deductFavorable)}${soulFn:formatDecimals(auditMap.deductFavorable)}
                                </span>
                            </div>
                        </div>
                        <div class="control-group withdrawing-result ">
                            <label class="control-label">${views.fund_auto['最终可取款']}：</label>
                            <div class="controls">
                                <span class="orange fontmiddle"><em>${currencySign}</em><span id="actualWithdraw-span">--</span></span>
                                <span class="orange" style="font-size: 18px;padding-left: 10px" id="actualWithdraw-tips-div">&nbsp;</span>
                            </div>

                            <input type="hidden" value="" name="actualWithdraw">
                        </div>
                        <div>
                            <soul:button precall="checkRate" target="saveWithdraw" text="${views.fund_auto['申请取款']}" opType="function" cssClass="btn-blue btn large-big lar-l withdraw-btn-css disable-gray ui-button-disable disabled">
                                ${views.fund_auto['申请取款']}
                            </soul:button>
                            <a style="display: none" name="returnView" nav-target="mainFrame" href="/player/withdraw/withdrawList.html"></a>
                            <a style="display: none" name="fundRecord" nav-target="mainFrame" href="/fund/transaction/chart.html"></a>
                        </div>
                    </form>
                </div>

                <div class="gamenotice" >
                    <div class="gamenotice-box">
                        <ul class="deposit-notice">
                            <li> ${fn:replace(fn:replace(views.fund_auto['取款提醒1'], "{0}",rank.withdrawNormalAudit ), "{1}", rank.withdrawAdminCost)}
                            </li>
                            <li> ${views.fund_auto['取款提醒2']}<br>
                                 ${views.fund_auto['注']}
                            </li>
                            <li class="bold"> ${views.fund_auto['声明']}</li>
                        </ul>
                    </div>
                </div>
            </c:if>
        </c:otherwise>
    </c:choose>
</div>
<soul:import res="site/fund/withdraw/PWithdraw"/>