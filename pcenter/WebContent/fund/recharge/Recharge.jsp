<%--@elvariable id="bankNotices" type="java.util.List<so.wwb.gamebox.model.master.content.po.CttAnnouncement>"--%>
<%--@elvariable id="map" type="java.util.Map<java.lang.string,java.lang.Long>"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form name="rechargeForm">
<div class="notice">
    <div class="notice-left"><em class="path"></em>
    </div>
    <div class="path-right">
        <a href="javascript:;">${views.sysResource['存款专区']}</a>
    </div>
</div>
<c:if test="${isDemo}">
    <%@include file="../../share/DemoNoPermit.jsp"%>
</c:if>
<c:if test="${!isDemo}">
    <!--存款-->
    <div class="account-info-warp">
        <div class="titleline"><h2>${views.fund_auto['请选择存款方式']}</h2></div>
    </div>
    <div class="deposit-select-wrap">
        <c:if test="${map['online']>0}">
            <div class="deposit-tab01">
                <a href="/fund/recharge/online/onlinePay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img1.png">
                    <span class="pay-title orange-t-bg"><em>${views.fund_auto['线上支付']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['company']>0}">
            <div class="deposit-tab01">
                <a href="/fund/recharge/company/onlineBankFirst.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img2.png"/>
                    <span class="pay-title blue-t-bg"><em>${views.fund_auto['网银存款']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['wechat']>0}">
            <div class="deposit-tab01">
                <a href="/fund/recharge/ScanElectronic/wechatpay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img3.png">
                    <span class="pay-title green-t-bg"><em>微信支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['alipay']>0}">
            <div class="deposit-tab01">
                <a href="online-pay3.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img4.png"/>
                    <span class="pay-title cyan-t-bg"><em>支付宝支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['qq']>0}">
            <div class="deposit-tab01">
                <a href="online-pay4.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img7.png">
                    <span class="pay-title sea-t-bg"><em>QQ支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['jd']>0}">
            <div class="deposit-tab01">
                <a href="online-pay5.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img5.png"/>
                    <span class="pay-title red-t-bg"><em>京东支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['bd']>0}">
            <div class="deposit-tab01">
                <a href="online-pay5.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img6.png"/>
                    <span class="pay-title pink-t-bg"><em>百度支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['unionpay']>0}">

        </c:if>
        <c:if test="${map['onecodepay']>0}">
            <div class="deposit-tab01">
                <a href="online-pay-sz.html" nav-Target="mainFrame">
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
    </div>
    <c:if test="${map['online']<=0&&map['company']<=0&&map['wechat']<=0&&map['alipay']<=0&&map['qq']<=0&&map['jd']<=0&&map['bd']<=0&&map['unionpay']<=0&&map['onecodepay']<=0&&map['bitcoin']<=0&&!isFastRecharge&&empty digiccyAccountInfo}">
        <div class="rgeechar">
            <div class="title deposit-hint">
            <span class="tips">
                <i class="mark plaintsmall"></i> ${views.fund_auto['支付系统升级中存款请联系客服']}
                <c:if test="${empty customerService}">
                    ${views.common['contactCustomerService']}
                </c:if>
                <c:if test="${!empty customerService}">
                    <soul:button target="customerService" text="${views.common['contactCustomerService']}" opType="function" url="${customerService}"/>
                </c:if>
            </span>
            </div>
        </div>
    </c:if>
    <!-- 注意事项 -->
    <div class="gamenotice">
        <div class="gamenotice-title">
            <h1>${views.fund_auto['注意事项']}</h1>
        </div>
        <div class="gamenotice-box">
            <ul class="attention-list">
                <li> ${views.fund_auto['扫码存款提醒']}</li>
                <li> ${views.fund_auto['存款提醒3']}</li>
                    <%-- <li class="red"> 请您务必依照网页上的存款金额进行存款。例如：200.18，方便系统加快您的入款速度。</li>--%>
            </ul>
        </div>
    </div>
    <div class="banknotice">
        <%@include file="BankNotice.jsp"%>
    </div>
    </form>
</c:if>

<soul:import res="site/fund/recharge/Recharge"/>


