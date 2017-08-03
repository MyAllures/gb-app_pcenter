<%--
  Created by IntelliJ IDEA.
  User: orange
  Date: 15-10-20
  Time: 上午11:56
  To change this template use File | Settings | File Templates.
--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.fund.vo.VPcenterWithdrawVo"--%>
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
<div class="main-wrap">
    <c:choose>
        <c:when test="${playerWithdrawExist > 0}">
            <div class="withdraw-not">
                <h1><i class="tipbig fail"></i></h1>
                <div class="tiptext">
                    <p>${views.fund_auto['当前已有取款订单正在审核，']}</p>
                    <p>${views.fund_auto['请在该订单结束后再继续取款!']}&nbsp;</p>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <c:if test="${balanceFreezen}">
                <div class="withdraw-not">
                    <h1><i class="tipbig fail"></i></h1>
                    <div class="tiptext" style="padding: 0 80px">
                        <p>${empty player.balanceFreezeContent? views.fund_auto['您的账号余额已被冻结，请联系客服']:player.balanceFreezeContent}</p>
                    </div>
                </div>
            </c:if>
            <c:if test="${not empty rank && (rank.withdrawMaxNum == null || rank.withdrawMinNum == null)}">
                <div class="withdraw-not">
                    <h1><i class="tipbig fail"></i></h1>
                    <div class="tiptext">
                        <p>${views.fund_auto['暂时无法取款']}</p>
                    </div>
                </div>
            </c:if>
            <c:if test="${(empty player.walletBalance) || (player.walletBalance < rank.withdrawMinNum || player.walletBalance <= 0)}">
                <div class="withdraw-not">
                    <h1><i class="tipbig fail"></i></h1>
                    <div class="tiptext">
                        <p>${views.fund_auto['取款金额最少为']}<%--${currencySign}--%>${soulFn:formatCurrency(rank.withdrawMinNum)}${views.fund_auto['元']}</p>
                        <p>${views.fund_auto['钱包余额不足提醒']}</p>
                        <p>
                            <a class="btn-blue btn large-big gotoDespoit" href="javascript:void(0)">${views.fund_auto['转到钱包']}</a>
                        </p>
                    </div>
                </div>
            </c:if>
            <c:if test="${balanceFreezen==false&&(player.walletBalance > 0 && player.walletBalance >= rank.withdrawMinNum)}">
                <div class="hintotal float-not">
                    <form id="transferForm" class="location" method="post">
                        <div id="validateRule" style="display: none">${validate}</div>
                        <gb:token></gb:token>
                        <div class="control-group">
                            <label class="control-label line-hi42">${views.fund_auto['收款账号']}：</label>
                            <div class="controls">
                                <div class="hintbank">
                                    <i class="pay-bank ${command.result.bankName}"></i>
                                    ${views.fund_auto['尾号']}:${fn:substring(command.result.bankcardNumber,fn:length(command.result.bankcardNumber)-4, fn:length(command.result.bankcardNumber))}
                                    <span>${soulFn:overlayName(command.result.bankcardMasterName)}</span>
                                </div>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${isLottery.paramValue=='true'?views.home['index.account.totalAssets']:views.fund_auto['钱包余额']}：</label>
                            <div class="controls">
                                <span class="orange fontmiddle">

                                    <c:if test="${empty command.result.walletBalance}"><em>${siteCurrencySign}</em>0</c:if>
                                    <c:if test="${not empty command.result.walletBalance}">
                                        <em>${siteCurrencySign}</em>${soulFn:formatInteger(command.result.walletBalance)}${soulFn:formatDecimals(command.result.walletBalance)}
                                    </c:if>
                                </span>
                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${views.fund_auto['取款金额']}：</label>
                            <div class="controls">
                                <input type="hidden" name="walletBalance" value="${command.result.walletBalance}"/>
                                <input type="hidden" name="rankId" value="${rank.id}">
                                <input type="hidden" name="withdrawMaxNum" value="${rank.withdrawMaxNum}"/>
                                <input type="hidden" name="withdrawMinNum" value="${rank.withdrawMinNum}"/>
                                <input type="hidden" name="withdrawFee" id="withdrawFee" value="0"/>
                                <input type="hidden" name="balanceType" value="${player.balanceType}"/>
                                <input type="hidden" name="balanceFreeze" value="${player.balanceFreeze}"/><%--user.defaultCurrency--%>
                                <p class="character character-left">${siteCurrencySign}</p>
                                <input type="text" name="withdrawAmount" maxlength="10" class="input input-money m-20" showSuccMsg="false"
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
                                    <em>${siteCurrencySign}</em><span id="withdrawFee-span">${auditMap.counterFee}</span></span>
                                </c:if>

                            </div>
                        </div>
                        <div class="control-group">
                            <label class="control-label">${views.fund_auto['行政费']}：</label>
                            <div class="controls">
                                <span class="line-hi30"><em>${siteCurrencySign}</em>${auditMap.administrativeFee>0?'-':''}
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
                                <span class="line-hi30"><em>${siteCurrencySign}</em>${auditMap.deductFavorable>0?'-':''}
                                    ${soulFn:formatInteger(auditMap.deductFavorable)}${soulFn:formatDecimals(auditMap.deductFavorable)}
                                </span>
                            </div>
                        </div>
                        <div class="control-group withdrawing-result ">
                            <label class="control-label">${views.fund_auto['最终可取款']}：</label>
                            <div class="controls">
                                <span class="orange fontmiddle"><em>${siteCurrencySign}</em><span id="actualWithdraw-span">--</span></span>
                                <span class="orange" style="font-size: 18px;padding-left: 10px" id="actualWithdraw-tips-div">&nbsp;</span>
                            </div>

                            <input type="hidden" value="" name="actualWithdraw">
                        </div>
                        <div>
                            <soul:button precall="checkRate" target="${root}/player/withdraw/pleaseWithdraw.html" text="${views.fund_auto['申请取款']}" opType="ajax"
                                         post="getCurrentFormData" callback="saveCallBackWithdraw"
                                         cssClass="btn-blue btn large-big lar-l withdraw-btn-css disable-gray ui-button-disable disabled">
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