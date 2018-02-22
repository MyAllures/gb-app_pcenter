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
            <div class="deposit-tab01 zxzf-bg">
                <a href="/fund/recharge/online/onlinePay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img1.png">
                    <span class="pay-title"><em>${views.fund_auto['线上支付']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['company']>0}">
            <div class="deposit-tab01 wyck-bg">
                <a href="/fund/recharge/company/onlineBankFirst.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img2.png"/>
                    <span class="pay-title blue-t-bg"><em>${views.fund_auto['网银存款']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['wechat']>0}">
            <div class="deposit-tab01 wxzf-bg">
                <a href="/fund/recharge/ScanElectronic/wechatpay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img3.png">
                    <span class="pay-title green-t-bg"><em>微信支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['alipay']>0}">
            <div class="deposit-tab01 zfb-bg">
                <a href="/fund/recharge/ScanElectronic/alipay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img4.png"/>
                    <span class="pay-title"><em>支付宝支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['qq']>0}">
            <div class="deposit-tab01 qqzf-bg">
                <a href="/fund/ronlinebecharge/ScanElectronic/qq.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img7.png">
                    <span class="pay-title"><em>QQ支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['jd']>0}">
            <div class="deposit-tab01 jdzf-bg">
                <a href="/fund/recharge/ScanElectronic/jd.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img5.png"/>
                    <span class="pay-title"><em>京东支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['bd']>0}">
            <div class="deposit-tab01 bdzf-bg">
                <a href="/fund/recharge/ScanElectronic/bd.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img6.png"/>
                    <span class="pay-title"><em>百度支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['unionpay']>0}">
            <div class="deposit-tab01 ylzf-bg">
                <a href="/fund/recharge/ScanElectronic/union.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img13.png"/>
                    <span class="pay-title"><em>银联支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['onecodepay']>0}">
            <div class="deposit-tab01 ymf-bg">
                <a href="/fund/recharge/ScanElectronic/onecodepay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img9.png"/>
                    <span class="pay-title prasinous-t-bg"><em>一码付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['counter']>0}">
            <div class="deposit-tab01 gtck-bg">
                <a href="/fund/recharge/company/atmCounterFirst.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img11.png"/>
                    <span class="pay-title prasinous-t-bg"><em>${views.fund_auto['柜员机/柜台存款']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['other']>0}">
            <div class="deposit-tab01 qtzf-bg">
                <a href="/fund/recharge/ScanElectronic/other.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img14.png"/>
                    <span class="pay-title prasinous-t-bg"><em>其他支付</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${isFastRecharge}">
            <c:set var="url" value="${rechargeUrlParam.paramValue}"/>
            <c:if test="${!fn:startsWith(url, 'http')}">
                <c:set var="url" value="http://${rechargeUrlParam.paramValue}"/>
            </c:if>
            <div class="deposit-tab01 czzx-bg">
                <a href="<c:out value='${url}'/>" target="_blank">
                    <img src="${resRoot}/images/deposit-tab-img10.png"/>
                    <span class="pay-title prasinous-t-bg"><em>${views.fund_auto['充值中心']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${map['bitcoin']>0}">
            <div class="deposit-tab01 btb-bg">
                <a href="/fund/recharge/company/bitCoinFirst.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img8.png">
                    <span class="pay-title yellow-t-bg"><em>${views.fund_auto['比特币支付']}</em></span>
                </a>
            </div>
        </c:if>
        <c:if test="${!empty digiccyAccountInfo}">
            <div class="deposit-tab01 szhb-bg">
                <a href="/fund/recharge/digiccy/digiccyPay.html" nav-Target="mainFrame">
                    <img src="${resRoot}/images/deposit-tab-img15.png">
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


