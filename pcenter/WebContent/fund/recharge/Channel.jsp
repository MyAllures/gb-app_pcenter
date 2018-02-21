<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<%--支付渠道---%>
<div class="deposit-info-warp  clearfix">
    <c:set var="channelMap" value="<%=SessionManager.getRechargeChannel()%>"/>
    <div class="titleline pull-left">
        <div class="btn-group table-desc-right-t-dropdown bank-down-menu">
            <button type="button" class="btn btn btn-default" data-toggle="dropdown" aria-expanded="false">
                <i class="pay-third wechatpay"></i> <span class="carat"></span>
            </button>
            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                <c:set var="map" value="${channelMap['channel']}"/>
                <c:if test="${map['online']>0}">
                    <li role="presentation">
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/online/onlinePay.html" key="10" nav-Target="mainFrame"><i class="pay-third unionpay"></i></a>
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
                        <a role="menuitem" tabindex="-1" href="/fund/recharge/ScanElectronic/alipay.html" nav-Target="mainFrame" key="30"><i class="pay-third wechatpay"></i></a>
                    </li>
                </c:if>
                <c:if test="${map['qq']>0}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/ScanElectronic/qq.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img7.png">
                            <span class="pay-title sea-t-bg"><em>QQ支付</em></span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${map['jd']>0}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/ScanElectronic/jd.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img5.png"/>
                            <span class="pay-title red-t-bg"><em>京东支付</em></span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${map['bd']>0}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/ScanElectronic/bd.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img6.png"/>
                            <span class="pay-title pink-t-bg"><em>百度支付</em></span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${map['unionpay']>0}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/ScanElectronic/union.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img6.png"/>
                            <span class="pay-title pink-t-bg"><em>银联支付</em></span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${map['onecodepay']>0}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/ScanElectronic/onecodepay.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img9.png"/>
                            <span class="pay-title prasinous-t-bg"><em>一码付</em></span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${isFastRecharge}">
                    <div class="deposit-tab01">
                        <c:set var="url" value="${rechargeUrlParam.paramValue}"/>
                        <c:if test="${!fn:startsWith(url, 'http')}">
                            <c:set var="url" value="http://${rechargeUrlParam.paramValue}"/>
                        </c:if>
                        <a href="<c:out value='${url}'/>" target="_blank">
                            <img src="${resRoot}/images/deposit-tab-img10.png">
                   <span class="pay-title">
                       <em data-href="/fund/recharge/online/onlinePay.html" class="showPage" style="cursor: pointer;">${views.fund_auto['充值中心']}</em>
                       <i data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=8" class="pay-title-tips" style="cursor: pointer;">${views.fund_auto['范例']}</i>
                   </span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${map['bitcoin']>0}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/company/bitCoinFirst.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img8.png">
                            <span class="pay-title yellow-t-bg"><em>${views.fund_auto['比特币支付']}</em></span>
                        </a>
                    </div>
                </c:if>
                <c:if test="${!empty digiccyAccountInfo}">
                    <div class="deposit-tab01">
                        <a href="/fund/recharge/digiccy/digiccyPay.html" nav-Target="mainFrame">
                            <img src="${resRoot}/images/deposit-tab-img12.png">
                            <span class="pay-title dark-green-t-bg"><em>${views.fund_auto['数字货币支付']}</em></span>
                        </a>
                    </div>
                </c:if>
            </ul>
        </div>
    </div>
    <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
</div>
