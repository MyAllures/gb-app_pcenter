<%@ page import="static so.wwb.gamebox.model.ParamTool.*" %>
<%--@elvariable id="playerApiListVo" type="so.wwb.gamebox.model.master.player.vo.PlayerApiListVo"--%>
<%--@elvariable id="player" type="so.wwb.gamebox.model.master.player.vo.UserPlayerVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:set var="apis" value="<%=Cache.getApi() %>"/>
<c:set var="siteApis" value="<%=Cache.getSiteApi() %>"/>
<!--资产-->
<div class="property">
    <div class="property-left">
        <span style="display: inline-block; line-height: 55px;">
            ${views.home['index.account.totalAssets']}
        </span>
        <div class="m-loading-icon-x"><img src="${resRoot}/images/022b.gif"></div>
        <em class="total-money assets-money" style="display: none">${soulFn:formatCurrency(playerApiListVo.totalAssets)}</em>
        <span class="hide-assets" style="display: none">--</span>
        <span style="display:none;" name="totalRefresh">
             <soul:button target="refresh" cssClass="totalRefresh" text="" opType="function" type="all">
                 <i class="ico-ask refresh"></i>
             </soul:button>
            ${views.home['index.account.synTime']}：${soulFn:formatDateTz(player.synchronizationTime, DateFormat.DAY_SECOND, timeZone)}
        </span>
    </div>
    <div class="moneyhide">
        <span class="title">${views.home['index.account.hiddenBalance']}</span>
        <i class="ico-ask show"></i>
        <input type="hidden" name="isHide" value="0" />
    </div>
</div>
<div class="balance">
    <div class="wallet">
        <dl>
            <dt name="walletRefresh">
                ${views.home['index.balance']}
            </dt>
            <dd class="orange" style="height: 40px;">
                <div class="m-loading-icon" style="${playerApiListVo.type=='api'?'display: none;':''}"><img src="${resRoot}/images/022b.gif"></div>
                <span class="home-money assets-money wallet-money" style="${playerApiListVo.type=='api'?'':'display: none;'}">${soulFn:formatCurrency(player.walletBalance)}</span>
                <span class="hide-assets" style="display: none">--</span>
                <i class="arr-right" name="wallet-right" style="display: none"></i>
                <i class="arr-left" name="wallet-left" style="display: none"></i>
            </dd>
            <c:set var="autoPayParam" value="<%=getSysParam(SiteParamEnum.SITE_API_AUTO_PAY)%>"/>
            <c:if test="${!empty autoPayParam && autoPayParam.paramValue=='true'}">
                <p class="btntotal"></p>
                <soul:button target="${root}/transfer/auto/changeAutoPay.html" text="${views.fund_auto['切换至自动额度转换']}" opType="ajax" callback="changeAutoPayCallback" cssClass="btn btn-gray btn-big" tag="button"/>
            </c:if>
            <p class="btntotal"></p>
            <c:if test="${withdraw>0}">
                <dd class="co-gray hint-1">
                        ${views.home['index.account.withdrawing']}
                    <div class="g-loading-icon-x" style="${playerApiListVo.type=='api'?'display: none;':''}">
                        <img src="${resRoot}/images/022b.gif">
                    </div>
                    <span class="orange withdraw-money assets-money" style="${playerApiListVo.type=='api'?'':'display: none;'}">${soulFn:formatCurrency(withdraw)}</span>
                    <span class="orange hide-assets" style="display: none">--</span>
                    <a href="javascript:;" class="ToolTips ToolTipCol" data-html="true" data-text="${views.home['index.account.withdrawMessage']}">
                        <i class="ico-ask ask"></i>
                    </a>
                </dd>
            </c:if>
           <c:if test="${transfer>0}">
               <dd class="co-gray hint-1">
                       ${views.home['index.transferProcess']}
                   <div class="g-loading-icon-x transfer-loading" style="${playerApiListVo.type=='api'?'display: none;':''}">
                       <img src="${resRoot}/images/022b.gif">
                   </div>
                   <span class="orange assets-money transfer-money" style="${playerApiListVo.type=='api'?'':'display: none;'}">${soulFn:formatCurrency(transfer)}</span>
                   <span class="orange hide-assets" style="display: none">--</span>
                   <a href="javascript:;" class="ToolTips ToolTipCol" data-html="true" data-text="${views.home['index.account.transferProcessTips']}">
                       <i class="ico-ask ask"></i>
                   </a>
               </dd>
           </c:if>
        </dl>
    </div>
    <div class="balance-right pull-left">
        <c:forEach items="${playerApiListVo.result}" var="i">
            <div class="game onmouse loading-api" style="${!empty playerApiListVo.search.id&&i.id!=playerApiListVo.search.id?'display: none;':''}">
                <div class="g-loading-icon"><img src="${resRoot}/images/022b.gif"></div>
            </div>

            <div id="api-game-${i.apiId}" class="game onmouse" style="${!empty playerApiListVo.search.id&&i.id!=playerApiListVo.search.id?'':'display: none;'}" <c:if test="${i.synchronizationStatus=='abnormal'}">title="${fn:replace(views.home['index.assets.abnormalTips'], '{0}', i.abnormalReason)}"</c:if>>
                <c:if test="${!empty i.id}">
                    <soul:button target="refreshApi" cssClass="title-ref refreshApi" text="" opType="function" type="api" state="${apis[i.apiId.toString()].systemStatus=='maintain'}" apiId="${i.apiId}" title="${soulFn:formatDateTz(i.synchronizationTime, DateFormat.DAY_SECOND, timeZone)}">
                        <i class="ico-ask refresh"></i>
                    </soul:button>
                </c:if>
                <c:if test="${empty i.id}">
                    <a data-rel='{"precall":"","callback":"",post:"",opType:"function",dataType:"",target:"refreshApi",confirm:"",text:"",size:"","type":"api","apiId":"${i.apiId}" }'></a>
                </c:if>
                <p class="game-left api-logo-box ${empty i.id?'':'active'}">
                    <i class="api-logo-${i.apiId}"></i>
                </p>
                <p class="game-right">
                    <i class="arr-down" style="display: none" name="${i.apiId}down"></i>
                    <i class="arr-up" style="display: none" name="${i.apiId}up"></i>
                    <span class="title">
                         <a> ${gbFn:getApiName(i.apiId.toString())}</a>
                    </span>
                    <c:choose>
                        <c:when test="${apis[i.apiId.toString()].systemStatus eq 'disable'||siteApis[i.apiId.toString()].systemStatus eq 'disable'}">
                            <span class="gray assets-money api-money">${views.fund_auto['停用中']}</span>
                        </c:when>
                        <c:when test="${apis[i.apiId.toString()].systemStatus=='maintain'||siteApis[i.apiId.toString()].systemStatus eq 'maintain'}">
                            <span class="gray assets-money"><em class="api-money">${empty i.money||i.money==0?'0.00':soulFn:formatCurrency(i.money)}</em>&nbsp;${views.home['index.account.maintain']}</span>
                        </c:when>
                        <c:when test="${empty i.id}">
                            <span class="gray assets-money api-money ">0.00</span>
                        </c:when>
                        <c:when test="${i.synchronizationStatus=='abnormal'}">
                            <span class="co-gray api-money assets-money"><img src="${resRoot}/images/loadingimg2.gif"></span>
                            <%--<span class="gray assets-money">${views.home['index.account.dataException']}</span>--%>
                        </c:when>
                        <c:when test="${empty i.money||i.money==0}">
                            <span class="gray api-money assets-money">0.00</span>
                        </c:when>
                        <c:otherwise>
                            <span class="blue api-money assets-money">${soulFn:formatCurrency(i.money)}</span>
                        </c:otherwise>
                    </c:choose>
                    <span class="hide-assets" style="display: none">--</span>
                </p>
            </div>
        </c:forEach>
    </div>
</div>
<script>
    $(function() {
        Util.ToolTip.init();
    });
</script>