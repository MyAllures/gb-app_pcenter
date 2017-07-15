<%--@elvariable id="playerApiListVo" type="so.wwb.gamebox.model.master.player.vo.PlayerApiListVo"--%>
<%--@elvariable id="player" type="so.wwb.gamebox.model.master.player.vo.UserPlayerVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:set var="apis" value="<%=Cache.getApi() %>"/>
<c:set var="siteApis" value="<%=Cache.getSiteApi() %>"/>
<div class="loading-a">
    <div class="spiner-example">
        <img src="${resRoot}/images/022b.gif">
    </div>
</div>

<div class="property">
    <div class="property-left">
        ${views.home['index.account.totalAssets']}
        <em class="total-money">${soulFn:formatCurrency(playerApiListVo.totalAssets)}</em>
        <div class="m-loading-icon-x" style="display: none"><img src="${resRoot}/images/022b.gif"></div>
        <soul:button target="getAllApiBalance" cssClass="ico-ask refresh" text="" title="${views.fund_auto['刷新总资产']}" opType="function"/>
    </div>
    <soul:button target="${root}/transfer/auto/changeAutoPay.html" text="${views.fund_auto['切换至手动额度转换']}" opType="ajax" callback="changeAutoPayCallback" cssClass="btn btn-gray btn-big btn-edzh" tag="button"/>
    <soul:button target="recoveryApi" text="" opType="function" cssClass="btn btn-blue btn-big btn-money-back" tag="button">
        <i class="btn-money-back-white"></i>
        ${views.fund_auto['资金回收']}
    </soul:button>
</div>
<div>
    <div class="balance">
        <div class="wallet">
            <dl>
                <dt>
                    ${views.home['index.balance']}
                </dt>
                <dd class="orange wallet-money">
                    ${soulFn:formatCurrency(player.walletBalance)}
                </dd>
                <div class="m-loading-icon-x" style="display: none"><img src="${resRoot}/images/022b.gif"></div>
                <c:if test="${withdraw > 0}">
                    <dd class="co-gray hint-1">
                        ${views.home['index.account.withdrawing']}:
                        <span class="orange">${soulFn:formatCurrency(withdraw)}</span>
                        <a href="javascript:;" class="ToolTips ToolTipCol" data-html="true" data-text="${views.home['index.account.withdrawMessage']}">
                            <i class="ico-ask ask"></i>
                        </a>
                    </dd>
                </c:if>
                <c:if test="${transfer > 0}">
                    <dd class="co-gray hint-2">
                        ${views.home['index.transferProcess']}:
                        <span class="orange">${soulFn:formatCurrency(transfer)}</span>
                        <a href="javascript:;" class="ToolTips ToolTipCol" data-html="true" data-text="${views.home['index.account.transferProcessTips']}">
                            <i class="ico-ask ask"></i>
                        </a>
                    </dd>
                </c:if>
            </dl>
        </div>
        <div class="balance-right pull-left">
            <c:forEach items="${playerApiListVo.result}" var="i">
                <div class="game onmouse api-info api-${i.apiId}" type="button" data-toggle="tooltip" data-placement="bottom" <c:if test="${i.synchronizationStatus=='abnormal'}">title="${fn:replace(views.home['index.assets.abnormalTips'], '{0}', i.abnormalReason)}"</c:if>>
                    <c:if test="${!empty i.id}">
                        <soul:button cssClass="title-ref" title="${views.fund_auto['回收']}" text="" api="${i.apiId}" opType="function" target="recoveryApi">
                            <i class="btn-money-back-blue"></i>
                        </soul:button>
                    </c:if>
                    <p class="game-left api-logo-box ${empty i.id?'':'active'}">
                        <i class="api-logo-${i.apiId}"></i>
                    </p>
                    <p class="game-right">
                        <span class="title">${gbFn:getApiName(i.apiId.toString())}</span>
                        <c:set var="apiStatus" value="${apis[i.apiId.toString()].systemStatus}"/>
                        <c:set var="siteApiStatus" value="${siteApis[i.apiId.toString()].systemStatus}"/>
                        <c:set var="money" value="${empty i.money?0:i.money}"/>
                        <c:choose>
                            <c:when test="${apiStatus == 'maintain' || siteApiStatus == 'maintain'}">
                                <span class="blue"><em class="api-money" id="api-money-${i.apiId}">${soulFn:formatCurrency(money)}</em>${views.home['index.account.maintain']}</span>
                            </c:when>
                            <c:when test="${i.synchronizationStatus=='abnormal'}">
                                <span class="blue api-money" id="api-money-${i.apiId}"><img src="${resRoot}/images/loadingimg2.gif"></span>
                            </c:when>
                            <c:otherwise>
                                <span class="blue api-money" id="api-money-${i.apiId}">${soulFn:formatCurrency(i.money)}</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="game onmouse loading-api loading-${i.apiId}" style="display: none;">
                    <div class="g-loading-icon"><img src="${resRoot}/images/022b.gif"></div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

