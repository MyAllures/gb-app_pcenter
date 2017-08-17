<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-3
  Time: 下午3:29
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<html>
<head>
    <%@ include file="/include/include.head.jsp" %>
</head>
<style>
    .popalignr{
        width: 30%;
    }
</style>
<body>

<c:choose>
    <c:when test="${command.result.transactionType eq 'favorable' or command.result.transactionType eq 'backwater' or command.result.transactionType eq 'recommend'}">
        <%--优惠 返水 推荐 详情--%>
        <div class="theme-popcon">
        <div class="poptable">

                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                        <tr>
                            <td class="popalignr" style="width:29%;">${views.fund['FundRecord.record.transactionNo']}：</td>
                            <td >${command.result.transactionNo}</td>
                        </tr>
                        <tr>
                            <td class="popalignr">${views.fund['FundRecord.record.createTime']}：</td>
                            <td>${soulFn:formatDateTz(command.result.createTime, DateFormat.DAY_SECOND, timeZone )}</td>
                        </tr>
                        <c:choose>
                            <c:when test="${command.result.transactionType eq 'favorable'}">
                                <tr>
                                    <td class="popalignr">${views.fund['FundRecord.record.desc']}：</td>
                                    <td><span class="orange">
                                    <%--为什么会有三种写法呢 这是因为它们是互补的 。优惠描述的来源不单一 --%>
                                    ${command.result._describe['activityName']}${command.result._describe[language]}${dicts.common.transaction_way[command.result._describe['transaction_way']]}${dicts.common.fund_type[command.result._describe['transaction_way']]}</span></td>
                                </tr>
                            </c:when>
                            <c:when test="${command.result.transactionType eq 'backwater'}">
                                <tr>
                                    <td class="popalignr">${views.fund['FundRecord.record.desc']}：</td>
                                    <c:set value="${soulFn:formatDateTz(command.result._describe['date'],DateFormat.YEARMONTH,timeZone)}" var="date"></c:set>
                                    <td><span class="orange">${date.replace("-",views.common['year'])}${views.common['month']}&nbsp;${command.result._describe['period']}${views.fund['FundRecord.record.period']}</span></td>
                                </tr>
                            </c:when>
                            <c:when test="${command.result.transactionType eq 'recommend'}">
                                <tr>
                                    <td class="popalignr">${views.fund['FundRecord.record.desc']}：</td>
                                    <td><span class="orange">
                                        <%-- 红利-单次奖励 --%>
                                    <c:if test="${command.result.transactionWay eq 'single_reward'}">
                                        <c:if test="${command.result._describe['rewardType'] eq 2}">
                                            ${views.fund['FundRecord.record.friend']}&nbsp; ${command.result._describe['username']}
                                        </c:if>
                                        <c:if test="${command.result._describe['rewardType'] eq 3}">
                                            ${views.fund['FundRecord.record.recmTip1']}${views.fund['FundRecord.record.friend']}&nbsp;${command.result._describe['username']}&nbsp;${views.fund['FundRecord.record.recmTip2']}
                                        </c:if>
                                    </c:if>
                                    <%-- 天天返 --%>
                                    <c:if test="${command.result.transactionWay eq 'bonus_awards'}">
                                      ${views.fund['FundRecord.record.singleReward']}
                                    </c:if>
                                    </span></td>
                                </tr>
                            </c:when>
                        </c:choose>

                        <tr>
                            <td class="popalignr">${views.fund['FundRecord.record.transactionMoney']}： </td>
                            <td>${siteCurrencySign}&nbsp;<span class="orange fontmiddle">${soulFn:formatCurrency(command.result.transactionMoney)}</span></td>
                        </tr>
                        <tr>
                            <td class="popalignr">${views.fund['FundRecord.record.transactionStatus']}：</td>
                            <td><span class="${command.result.status eq 'failure' ? 'gray':'green'}">${dicts.common.status[command.result.status]}</span></td>
                        </tr>
                        </tbody>
                    </table>

        </div>
        </div>
    </c:when>
    <c:when test="${command.result.transactionType eq 'deposit' || command.result.transactionType eq 'withdrawals'}">
    <%--存款 取款 详情--%>
        <div class="theme-popcon">
            <div class="poptable">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tbody>
                    <tr>
                        <td class="popalignr" style="width:29%;">${views.fund['FundRecord.record.transactionNo']}：</td>
                        <td>${command.result.transactionNo}</td>
                    </tr>
                    <tr>
                        <td class="popalignr">${views.fund['FundRecord.record.createTime']}：</td>
                        <td>${soulFn:formatDateTz(command.result.createTime, DateFormat.DAY_SECOND, timeZone )}</td>
                    </tr>
                    <tr>
                        <td class="popalignr">${views.fund['FundRecord.record.desc']}：</td>
                        <td>
                            <span class="orange">
                                <c:choose>
                                    <c:when test="${command.result.transactionType eq 'deposit'}">
                                        <%--存款--%>
                                        <c:if test="${command.result.fundType=='atm_counter'}">
                                            ${dicts.common.transaction_way[command.result.transactionWay]}
                                        </c:if>
                                        <c:if test="${command.result.fundType=='artificial_deposit'}">
                                            ${views.fund['FundRecord.view.tips']}
                                        </c:if>
                                        <c:if test="${command.result.fundType!='atm_counter'&&command.result.fundType!='artificial_deposit'}">
                                            ${dicts.common.fund_type[command.result.fundType]}
                                        </c:if>
                                        <%--${command.result.fundType eq 'artificial_deposit' ? views.fund['FundRecord.view.admin']:''}
                                        ${command.result.fundType eq 'alipay_fast' || command.result.fundType eq 'wechatpay_fast' ? '电子支付':''}
                                        <c:if test="${command.result.fundType ne 'alipay_fast' && command.result.fundType ne 'wechatpay_fast' && command.result.fundType ne 'artificial_deposit'}">
                                            ${dicts.common.fund_type[command.result.fundType]}
                                        </c:if>

                                        <c:if test="${command.result.fundType ne 'online_deposit'}">
                                            -${dicts.common.transaction_way[command.result.transactionWay]}
                                        </c:if>--%>
                                        <%--<c:if test="${not empty command.result._describe['bankCode']}">
                                             -${dicts.common.bankname[command.result._describe['bankCode']]}
                                        </c:if>--%>
                                    </c:when>
                                    <c:otherwise>
                                        <%--取款--%>
                                        <c:if test="${command.result.fundType=='artificial_withdraw'}">
                                            ${views.fund['FundRecord.view.manualWithdraw']}
                                        </c:if>
                                        <c:if test="${command.result.fundType!='artificial_withdraw'}">
                                            ${dicts.common.bankname[command.result._describe['bankCode']]}&nbsp;${views.fund['FundRecord.record.bankNoAfter']}&nbsp;${fn:substring(command.result._describe['bankNo'],command.result._describe['bankNo'].length()-4,command.result._describe['bankNo'].length())}
                                        </c:if>
                                    </c:otherwise>
                                </c:choose>

                            </span>
                        </td>
                    </tr>
                    <c:if test="${not empty command.result._describe['auditStatus']}">
                        <tr>
                            <td class="popalignr">${views.fund['FundRecord.view.audit']}${views.fund['FundRecord.record.transactionStatus']}：</td>
                            <td><span>${dicts.fund.withdraw_status[command.result._describe['auditStatus']]}</span></td>
                        </tr>
                    </c:if>
                    <c:if test="${not empty command.result.failureReason && command.result.status eq 'failure'}">
                        <tr>
                            <td class="popalignr">${views.fund['FundRecord.view.failReason']}：</td>
                            <td><span>${command.result.failureReason}</span></td>
                        </tr>
                    </c:if>
                    <c:if test="${command.result.fundType eq 'bitcoin_fast'}">
                        <tr>
                            <td class="popalignr">txId：</td>
                            <td><span>${command.result._describe['bankOrder']}</span></td>
                        </tr>
                        <tr>
                            <td class="popalignr">${views.fund_auto['交易时间']}：</td>
                            <td><span>${soulFn:formatDateTz(command.result._describe['returnTime'], DateFormat.DAY_SECOND, timeZone )}</span></td>
                        </tr>
                        <tr>
                            <td class="popalignr">${views.fund_auto['比特币地址']}</td>
                            <td><span>${command.result._describe['payerBankcard']}</span></td>
                        </tr>
                    </c:if>
                    <c:if test="${command.result.fundType != 'bitcoin_fast'}">
                        <c:if test="${not empty command.result._describe['bankOrder']}">
                            <tr>
                                <td class="popalignr">${views.fund['FundRecord.view.orderNo']}：</td>
                                <td><span>${command.result._describe['bankOrder']}${views.fund_auto['后5位']}</span></td>
                            </tr>
                        </c:if>
                        <c:if test="${not empty command.result._describe['returnTime']}">
                            <tr>
                                <td class="popalignr">${views.fund['FundRecord.view.depositTime']}：</td>
                                <td><span>${soulFn:formatDateTz(command.result._describe['returnTime'], DateFormat.DAY_SECOND, timeZone )}</span></td>
                            </tr>
                        </c:if>
                    </c:if>
                    <c:if test="${not empty command.result.rechargeAddress}">
                        <tr>
                            <td class="popalignr">${views.fund_auto['交易地点']}：</td>
                            <td><span>${command.result.rechargeAddress}</span></td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
            <div class="moneydetail">
                <c:set var="bankCode" value="${command.result._describe['bankCode']}" />
                <c:choose>
                    <%--人工存提--%>
                    <c:when test="${command.result.fundType eq 'artificial_deposit'}">
                        <h3>${views.fund['FundRecord.view.tips']}</h3>
                    </c:when>
                    <%--扫码支付、电子支付--%>
                    <c:when test="${command.result.fundType eq 'alipay_scan'||command.result.fundType eq 'other_fast' || command.result.fundType eq 'wechatpay_scan'||command.result.fundType eq 'wechatpay_fast' || command.result.fundType eq 'alipay_fast' ||command.result.fundType eq 'bitcoin_fast'||command.result.fundType eq 'qqwallet_scan'}">
                        <h1>
                            <c:set var="scanCss" value="${bankCode}"/>
                            <c:if test="${command.result.fundType eq 'alipay_scan'||command.result.fundType eq 'alipay_fast'}">
                                <c:set var="scanCss" value="alipay"/>
                            </c:if>
                            <c:if test="${command.result.fundType eq 'wechatpay_scan'||command.result.fundType eq 'wechatpay_fast'}">
                                <c:set var="scanCss" value="wechatpay"/>
                            </c:if>
                            <c:if test="${command.result.fundType eq 'qqwallet_scan'}">
                                <c:set var="scanCss" value="qqwallet"/>
                            </c:if>
                            <c:set var="isOther" value="${bankCode eq 'other' && !empty command.result._describe['customBankName']}"/>
                            <i class="${isOther?'':'pay-third '}${scanCss}"></i>
                            <i style="font-size: medium">${isOther?command.result._describe['customBankName']:''}</i>
                        </h1>
                    </c:when>
                    <c:otherwise>
                        <h1>
                            <c:set var="isOther" value="${bankCode eq 'other_bank' && !empty command.result._describe['customBankName']}"/>
                            <i class="${isOther?'':'pay-bank '}${bankCode}"></i>
                            <i style="font-size: medium">${isOther?command.result._describe['customBankName']:''}</i>
                        </h1>
                    </c:otherwise>
                </c:choose>

                <div class="detailtable">
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tbody>
                            <c:if test="${bankCode eq 'alipay' || bankCode eq 'wechatpay'}">
                                <tr>
                                    <td class="popalignr">${bankCode eq 'alipay'? views.fund_auto['您的支付宝账号']:views.fund_auto['您的微信账号']}：</td>
                                    <td>${soulFn:overlayString(command.result.payerBankcard)}</td>
                                </tr>
                            </c:if>
                            <c:if test="${(bankCode ne 'alipay' && bankCode ne 'wechatpay') && not empty command.result._describe['realName']}">
                                <tr>
                                    <td class="popalignr"><span class="darkgray">${views.fund['FundRecord.view.name']}：</span></td>
                                    <td>${soulFn:overlayName(command.result._describe['realName'])}</td>
                                </tr>
                            </c:if>
                            <c:if test="${command.result.transactionType eq 'withdrawals'}">
                                <tr>
                                    <td class="popalignr"><span class="darkgray">${views.fund['FundRecord.view.name']}：</span></td>
                                    <td>${soulFn:overlayName(sysUserVo.result.realName)}</td>
                                </tr>
                                <!--withdrawVo-->
                                <tr>
                                    <td  class="popalignr"><span class="darkgray">${views.fund_auto['取款金额']}：</span></td>

                                    <td>
                                    <span class="orange">
                                        ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(command.result.transactionMoney)}
                                    </span>
                                    </td>
                                </tr>
                                <c:if test="${not empty withdrawVo.result.deductFavorable&&withdrawVo.result.deductFavorable>0}">
                                    <tr>
                                        <td  class="popalignr"><span class="darkgray">${views.fund_auto['扣除优惠']}：</span></td>
                                        <td>
                                            <span class="orange">
                                                    ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(withdrawVo.result.deductFavorable)}
                                            </span>
                                        </td>
                                    </tr>
                                </c:if>

                                <tr>
                                    <td  class="popalignr"><span class="darkgray">${views.fund_auto['手续费']}：</span></td>

                                    <td>
                                    <span class="orange">
                                        <c:if test="${not empty withdrawVo.result.counterFee && withdrawVo.result.counterFee>0}">
                                            ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(withdrawVo.result.counterFee)}
                                        </c:if>
                                        <c:if test="${empty withdrawVo.result.counterFee ||withdrawVo.result.counterFee==0}">${views.fund_auto['免手续费']}</c:if>
                                    </span>
                                    </td>
                                </tr>
                                <c:if test="${not empty withdrawVo.result.administrativeFee && withdrawVo.result.administrativeFee>0}">
                                    <tr>
                                        <td  class="popalignr"><span class="darkgray">${views.fund_auto['行政费']}：</span></td>
                                        <td>
                                            <span class="orange">
                                                    ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(withdrawVo.result.administrativeFee)}
                                            </span>
                                        </td>
                                    </tr>
                                </c:if>
                                <tr>
                                    <td  class="popalignr"><span class="darkgray">${views.fund_auto['实际金额']}：</span></td>

                                    <td>
                                    <span class="orange">
                                        ${siteCurrencySign}&nbsp;${withdrawVo.result.withdrawActualAmount>0?'-':''}${soulFn:formatCurrency(withdrawVo.result.withdrawActualAmount)}
                                    </span>
                                    </td>
                                </tr>
                            </c:if>
                            <c:if test="${command.result.transactionType ne 'withdrawals'}">
                                <c:if test="${command.result.fundType eq 'bitcoin_fast'}">
                                    <tr>
                                        <td  class="popalignr"><span class="darkgray">${views.fund_auto['比特币']}：</span></td>
                                        <td>
                                            <span class="orange">Ƀ<fmt:formatNumber value="${command.result._describe['bitAmount']}" pattern="#.########"/></span>
                                        </td>
                                    </tr>
                                    <c:if test="${command.result.rechargeAmount!=0}">
                                        <tr>
                                            <td  class="popalignr"><span class="darkgray">${views.fund['Deposit.deposit.rechargeAmount']}</span></td>
                                            <td>
                                                <span class="orange">
                                                    ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(command.result.rechargeAmount)}
                                                </span>
                                            </td>
                                        </tr>
                                    </c:if>
                                </c:if>
                                <c:if test="${command.result.fundType != 'bitcoin_fast'}">
                                    <tr>
                                        <td  class="popalignr"><span class="darkgray">${views.fund['Deposit.deposit.rechargeAmount']}</span></td>
                                        <td>
                                            <c:set var="fee" value="${empty command.result._describe['poundage']?0:command.result._describe['poundage']}"></c:set>
                                            <span class="orange">
                                                ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(command.result.rechargeAmount)}
                                            </span>
                                        </td>
                                    </tr>
                                    <c:if test="${not empty command.result._describe['poundage']}">
                                        <tr>
                                            <td class="popalignr"><span class="darkgray">${command.result._describe['poundage']-0 > 0 ?views.fund['FundRecord.view.rebackPoundage']:views.fund['FundRecord.view.poundage']}：</span></td>
                                            <td><span class="orange">${siteCurrencySign}&nbsp;${soulFn:formatCurrency(command.result._describe['poundage'])}</span></td>
                                        </tr>
                                    </c:if>
                                    <tr>
                                        <td class="popalignr"><span class="darkgray">${views.fund_auto['实际到账']}：</span></td>
                                        <td>
                                            <span class="orange">
                                               ${siteCurrencySign}&nbsp;${soulFn:formatCurrency(command.result.rechargeTotalAmount)}
                                            </span>
                                        </td>
                                    </tr>
                                </c:if>
                            </c:if>


                            <tr>
                                <td class="popalignr"><span class="darkgray">${views.fund['FundRecord.record.transactionStatus']}：</span></td>
                                <td><span class="${command.result.status eq 'failure' ? 'gray':'green'}">${dicts.common.status[command.result.status]}</span></td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </c:when>
</c:choose>
<%--优惠 详情 end--%>
</body>
<%@ include file="/include/include.js.jsp" %>
</html>
