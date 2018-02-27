<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<%--支付渠道---%>
<div class="deposit-info-warp  clearfix">
    <c:set var="channelMap" value="<%=SessionManager.getRechargeChannel()%>"/>
    <div class="titleline pull-left">
        <div class="btn-group table-desc-right-t-dropdown bank-down-menu">
            <button type="button" class="btn btn btn-default" data-toggle="dropdown" aria-expanded="false">
                <i class="pay-third ${bankCode}"></i>
                <span class="carat"></span>
            </button>
            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                <c:set var="map" value="${channelMap['channel']}"/>
                <c:if test="${map['online']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/online/onlinePay.html" key="10" nav-Target="mainFrame"><i class="pay-third onlinepay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['company']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/company/onlineBankFirst.html" key="20" nav-Target="mainFrame"><i class="pay-third ebankpay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['wechat']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/wechatpay.html" nav-Target="mainFrame" key="30"><i class="pay-third wechatpay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['alipay']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/alipay.html" nav-Target="mainFrame" key="30"><i class="pay-third alipay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['qq']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/qq.html" nav-Target="mainFrame" key="30"><i class="pay-third qqwallet"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['jd']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/jd.html" nav-Target="mainFrame" key="30"><i class="pay-third jdwallet"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['bd']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/bd.html" nav-Target="mainFrame" key="30"><i class="pay-third bdwallet"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['unionpay']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/union.html" nav-Target="mainFrame" key="30"><i class="pay-third unionpay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['onecodepay']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/onecodepay.html" nav-Target="mainFrame" key="30"><i class="pay-third onecodepay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['counter']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/company/atmCounterFirst.html" nav-Target="mainFrame" key="30"><i class="pay-third gyjgt"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['other']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/other.html" nav-Target="mainFrame" key="30"><i class="pay-third else"></i></a>
                    </li>
                </c:if>
                <c:if test="${channelMap['isFastRecharge']}">
                    <c:set var="rechargeUrlParam" value="${channelMap['rechargeUrlParam']}"/>
                    <c:set var="url" value="${rechargeUrlParam.paramValue}"/>
                    <c:if test="${!fn:startsWith(url, 'http')}">
                        <c:set var="url" value="http://${rechargeUrlParam.paramValue}"/>
                    </c:if>
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1"  href="<c:out value='${url}'/>" target="_blank" key="30"><i class="pay-third quickpay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['bitcoin']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/company/bitCoinFirst.html" nav-Target="mainFrame" key="30"><i class="pay-third bitcoin"></i></a>
                    </li>
                </c:if>
                <c:if test="${!empty channelMap['digiccyAccountInfo']}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/digiccy/digiccyPay.html" nav-Target="mainFrame" key="30"><i class="pay-third szhb"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['easy']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/easyPay.html" nav-Target="mainFrame" key="30"><i class="pay-third ysfpay"></i></a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
    <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
</div>
