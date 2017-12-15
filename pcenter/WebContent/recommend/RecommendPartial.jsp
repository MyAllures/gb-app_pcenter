<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--推荐好友-->
<div class="recode">${views.recommend['recommend.Recommend.registerCode']}<i class="blue fontlarge">${invitationCode}</i>
<span class="respace">${views.recommend['recommend.Recommend.recommendFriend']}
    <c:if test="${map['count']>0}">
        <a href="/playerRecommendAward/recommendRecord.html" nav-target="mainFrame">
            <i class="green fontlarge">${soulFn:formatNumber(map.get("count"))}</i>
        </a>
    </c:if>
   <c:if test="${map['count']<=0}">
       <i class="green fontlarge">${soulFn:formatNumber(map.get("count"))}</i>
   </c:if>
</span>
    <span class="respace">${views.recommend['recommend.Recommend.obtain']}<i class="orange fontlarge">&nbsp;${soulFn:formatCurrency(map.get("amount"))}&nbsp;</i>${views.fund['recommend.Recommend.recommendAward']}</span>
</div>

<!--邀请方式-->
<div class="invite-way">
    <div class="titleline"><h2>${views.recommend['recommend.Recommend.invitationType']}</h2></div>
    <div class="invite-box">
        <h3>${views.recommend['recommend.Recommend.registerCodeTips']}</h3>
        <div class="invite-copy">
            <div class="invite-copyleft">
                <textarea class="textarea" id="recommendUrl"><%=request.getServerName()%>/register.html?c=${invitationCode}</textarea>
                <p class="gray">${views.recommend['recommend.Recommend.copyRecommendUrl']}</p>
            </div>
            <div class="invite-button">
                <button class="btn-blue btn large-big lar-l" type="button" data-clipboard-target="recommendUrl" data-clipboard-text="Default clipboard text from attribute" name="copy">${views.common['copy']}</button>
            </div>
        </div>
    </div>
</div>

<!--推荐奖励-->
<c:if test="${!empty command.rewardTheWay.paramValue}">
    <div class="invite-total">
        <div class="titleline"><h2>${views.recommend['recommend.Recommend.recommendAward']}</h2></div>
        <div class="invite-con">
            <i class="relink bonus"></i>
                ${views.recommend['recommend.Recommend.recommendFriendAndRecharge']}<span class="orange">${views.recommend['recommend.Recommend.fullMoney']}${siteCurrencySign}${command.rewardTheWay.paramValue}</span>，
            <c:choose>
                <c:when test="${command.isReward.paramValue=='1'}">
                    ${views.recommend['recommend.Recommend.earchReceived']}
                </c:when>
                <c:when test="${command.isReward.paramValue=='2'}">
                    ${views.recommend['recommend.Recommend.youWillGet']}
                </c:when>
                <c:otherwise>
                    ${views.recommend['recommend.Recommend.yourFriendWillGet']}
                </c:otherwise>
            </c:choose>
            <span class="orange">${siteCurrencySign}${command.rewardMoney.paramValue}</span>${views.recommend['recommend.Recommend.rewardEnd']}
        </div>
    </div>
</c:if>

<!--推荐红利-->
<c:if test="${fn:length(command.gradientTempList)>0&&command.bonus.active}">
    <div class="invite-total">
        <div class="titleline"><h2>${views.recommend['recommend.Recommend.recommendedDividend']}</h2></div>
        <div class="recommended-bonus">
            <table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <th>${views.recommend['recommend.Recommend.recommendNumberOfPlayer']}</th>
                    <th>${views.recommend['recommend.Recommend.recommendedDividendRatio']}
                        <a href="javascript:void(0);">
                            <span tabindex="0" class="m-l-sm help-popover" role="button" data-container="body"
                                        data-toggle="popover" data-trigger="focus" data-placement="top"
                                        data-content="${views.recommend['recommend.Recommend.recommendedDividendRatioTips']}" data-original-title="" title="">
                                <i class="ico-ask ask fa"></i>
                            </span>
                        </a>
                    </th>
                </tr>
                <c:forEach items="${command.gradientTempList}" var="i">
                    <tr>
                        <td>${i.playerNum}&nbsp;${views.recommend['recommend.Recommend.overThan']}</td>
                        <td><span class="orange">${i.proportion}%</span></td>
                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>
</c:if>

<!--活动规则-->
<c:if test="${! empty rule.value}">
    <div class="invite-total" style="margin-bottom: 100px">
        <div class="titleline"><h2>${views.recommend['recommend.Recommend.recommendRule']}</h2></div>
        <div class="active-rule" style="padding: 0 80px 0 0">
            <pre style="white-space: pre-wrap;word-wrap: break-word;">${rule.value}</pre>
        </div>
    </div>
</c:if>
