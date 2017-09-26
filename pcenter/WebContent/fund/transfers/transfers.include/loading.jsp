<%@ page import="static so.wwb.gamebox.model.ParamTool.*" %>
<%@ page import="so.wwb.gamebox.model.SiteParamEnum" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="property">
    <div class="property-left">
        <span style="display: inline-block; line-height: 55px;">
            ${views.home['index.account.totalAssets']}
        </span>
        <div class="m-loading-icon-x"><img src="${resRoot}/images/022b.gif"></div>
    </div>
    <div class="moneyhide">${views.home['index.account.hiddenBalance']}<i class="ico-ask show"></i></div>
</div>
<div>
    <div class="balance">
        <div class="wallet">
            <dl>
                <dt>${views.home['index.balance']}</dt>
                <dd class="orange wallet-money" style="height: 40px;">
                    <div class="m-loading-icon"><img src="${resRoot}/images/022b.gif"></div>
                </dd>
                <c:set var="autoPayParam" value="<%=getSysParam(SiteParamEnum.SITE_API_AUTO_PAY)%>"/>
                <c:if test="${!empty autoPayParam && autoPayParam.paramValue=='true'}">
                    <p class="btntotal"></p>
                    <soul:button target="${root}/transfer/auto/changeAutoPay.html" text="${views.fund_auto['切换至自动额度转换']}" opType="ajax" callback="changeAutoPayCallback" cssClass="btn btn-gray btn-big" tag="button"/>
                </c:if>
                <p class="btntotal"></p>
                <dd class="co-gray hint-1">
                    ${views.home['index.account.withdrawing']}
                    <div class="g-loading-icon-x">
                        <img src="${resRoot}/images/022b.gif">
                    </div>
                    <a href="javascript:;" class="ToolTips ToolTipCol" data-html="true" data-text="${views.home['index.account.withdrawMessage']}">
                        <i class="ico-ask ask"></i>
                    </a>
                </dd>
                <dd class="co-gray hint-1">
                    ${views.home['index.transferProcess']}
                    <div class="g-loading-icon-x transfer-loading">
                        <img src="${resRoot}/images/022b.gif">
                    </div>
                    <a href="javascript:;" class="ToolTips ToolTipCol" data-html="true" data-text="${views.home['index.account.transferProcessTips']}">
                        <i class="ico-ask ask"></i>
                    </a>
                </dd>
            </dl>
        </div>
        <div class="balance-right pull-left">
            <c:forEach begin="1" end="${fn:length(apiList)}">
                <div class="game onmouse" type="button" data-toggle="tooltip" data-placement="bottom" title="" data-original-title="">
                    <div class="g-loading-icon"><img src="${resRoot}/images/022b.gif"></div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>
