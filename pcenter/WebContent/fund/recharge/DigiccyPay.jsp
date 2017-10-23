<%--@elvariable id="userDigiccyList" type="java.util.List<so.wwb.gamebox.model.master.digiccy.po.UserDigiccy>"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form name="digiccyPayForm">
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <!--数字货币存款-->
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>${views.fund_auto['数字货币支付']}</h2></div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <c:forEach items="${userDigiccyList}" var="i">
        <div class="account-list account-info-warp sc-warp" name="account${i.currency}">
            <div class="sc-left-warp"><img src="${resRoot}/images/scqk-btb.png"></div>
            <div class="sc-right-warp">
                <div class="st-r-tit">
                    <span class="s-title">${dicts.digiccy.digiccy_currency[i.currency]}</span>
                    <span class="s-yue" style="${!empty i.address?'':'display:none'}">
                        <em>${views.fund_auto['余额']}:</em>
                        <i class="orange"><fmt:formatNumber value="${empty i.amount?0:i.amount}" pattern="#.########"/></i>
                        <soul:button target="refresh" text="" opType="function" cssClass="ico-ask refresh" currency="${i.currency}"/>
                        <input type="text" class="input" currency="${i.currency}" name="bitAmount" value=""/>
                        <soul:button target="exchange" currency="${i.currency}" text="${views.fund_auto['兑换金额']}" opType="function" cssClass="btn btn-filter btn-outline btn-lg ${i.amount>0?'':'hidebtn'}"/>
                    </span>
                </div>
                    <div class="st-r-gn" id="${i.currency}">
                    <c:if test="${!empty i.address}">
                        <div class="sao-ewm">
                            <span class="title">${views.fund_auto['二维码']}</span>
                            <span class="ewm-img"><img src="${i.addressQrcodeUrl}"/></span>
                        </div>
                        <div class="lzdz">
                            <span class="title">
                                ${views.fund_auto['地址']}
                                <button type="button" class="btn btn-filter btn-xs" data-clipboard-text="${i.address}" name="copy">${views.fund_auto['复制']}</button>
                            </span>
                            <textarea class="textarea" readonly>${i.address}</textarea>
                        </div>
                    </c:if>
                    <c:if test="${empty i.address}">
                        <div class="lzdz">
                            <span class="title">
                                ${views.fund_auto['还未生成地址']}
                                <soul:button target="newAddress" currency="${i.currency}" text="${views.fund_auto['生成地址']}" opType="function" cssClass="btn btn-filter btn-xs"/>
                            </span>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </c:forEach>
</form>
<script type="text/x-jsrender" id="addressRender">
    <div class="sao-ewm">
        <span class="title">${views.fund_auto['二维码']}</span>
        <span class="ewm-img"><img src="{{:data.addressQrcodeUrl}}"/></span>
    </div>
   <div class="lzdz">
        <span class="title">
            ${views.fund_auto['地址']}
            <button type="button" class="btn btn-filter btn-xs" data-clipboard-text="{{:data.address}}" name="copy">${views.fund_auto['复制']}</button>
        </span>
        <textarea class="textarea" readonly>{{:data.address}}</textarea>
    </div>
</script>
<soul:import res="site/fund/recharge/DigiccyPay"/>
