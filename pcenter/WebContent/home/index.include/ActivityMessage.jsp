<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<c:if test="${fn:length(sale.result) > 0}">
    <div class="saleactive">
        <div class="saleactive-title">
            <h1>${views.sysResource['优惠活动']}</h1>
            <span class="more favourableMore"> <a href="javascript:void(0)">${views.common['more']}&gt;</a></span>
        </div>
        <div class="item">
            <ul>
                <c:forEach items="${sale.result}" var="i" begin="0" end="7">
                    <li>
                            <span class="item-img">
                                <%--<a href="${root}/preferential/detail.html?searchId=${sale.getSearchId(i.id)}&code=${i.code}" target="_blank"><img src="${soulFn:getThumbPath(domain,i.activityCover,0,0)}"></a>--%>
                                <soul:button target="openActivity" text="${views.activity['Activity.list.activityDetails']}" opType="function" url="${root}/preferential/detail.html?searchIds=${i.searchId}&code=${i.code}"><img src="${soulFn:getThumbPath(domain,i.activityCover,0,0)}"></soul:button>
                            </span>
                        <h4>
                            <i
                                    <c:if test="${i.code eq 'first_deposit'}">class="item-title-ico goryorange"</c:if>
                                    <c:if test="${i.code eq 'back_water'}">class="item-title-ico gorylightgreen"</c:if>
                                    <c:if test="${i.code eq 'regist_send'}">class="item-title-ico goryred"</c:if>
                                    <c:if test="${i.code eq 'relief_fund'}">class="item-title-ico gorylightblue"</c:if>
                                    <c:if test="${i.code eq 'effective_transaction'}">class="item-title-ico gorygreen"</c:if>
                                    <c:if test="${i.code eq 'profit_loss'}">class="item-title-ico goryblue"</c:if>
                                    <c:if test="${i.code eq 'deposit_send'}">class="item-title-ico goryblue2"</c:if>
                                    <c:if test="${i.code eq 'content'}">class="item-title-ico gorylightgray"</c:if>
                            >${siteI18nMap[i.activityClassifyKey].value}</i>
                                <%--<a href="${root}/preferential/detail.html?searchId=${sale.getSearchId(i.id)}&code=${i.code}" target="_blank" class="act-title-c">${i.activityName}</a>--%>
                            <soul:button target="openActivity" text="${views.activity['Activity.list.activityDetails']}" opType="function" url="${root}/preferential/detail.html?searchIds=${i.searchId}&code=${i.code}" cssClass="act-title-c">${i.activityName}</soul:button>
                        </h4>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</c:if>