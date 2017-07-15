<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
            <ul>
                <li>
                    <div class="menu">
                        <a class="menu-hd" href="javascript:;">
                                    <span class="orange" id="ofullname">
                                    <c:choose>
                                        <c:when test="${sysUserVo.result.nickname !='' && sysUserVo.result.nickname !=null}">${sysUserVo.result.nickname}</c:when>
                                        <c:otherwise>${sysUserVo.result.username}</c:otherwise>
                                    </c:choose>

                                    </span>
                            <b></b>
                        </a>
                        <div class="menu-bd box">
                            <div class="global-account-head">
                                <a href="javaScript:;" class="global-account-img">
                                    <img src="${soulFn:getThumbPathWithDefault(domain, sysUserVo.result.avatarUrl, 39,39,resRoot.concat('/images/default_portrait.png'))}" width="39" height="39">
                                </a>

                                <p class="global-account-name" title="name">
                                    <span  class="_hours"></span>
                                    <c:if test="${sysUserVo.result.nickname !='' && sysUserVo.result.nickname !=null}">${sysUserVo.result.nickname}</c:if>
                                </p>
                                <a class="accountSet" href="javascript:;">${views.home['index.personInfo']}</a>
                                <span class="global-top-seperator">|</span>
                                <a class="transactionRecords" href="javascript:;">${views.home['index.betOrder']}</a>
                            </div>

                            <div class="global-account-money">
                                ${views.home['index.account.totalAssets']}:
                                <a href="javascript:;" class="show-remaining btn btn-filter btn-xs real-time-btn show-remaining">${views.home['index.showBalance']}</a>
                                        <span class="hide-astrict">
                                            <em class="total-money astrict">
                                                <%--${soulFn:formatCurrency(userPlayerVo.result.walletBalance==null?0:userPlayerVo.result.walletBalance)}--%>
                                                    ${soulFn:formatCurrency(totalAssets)}
                                            </em>
                                            <i class="ico-ask showsmall refresh"></i>
                                        </span>
                                <p class="dottline space"></p>
                                <div class="total">
                                    <c:if test="${!isAutoPay}">
                                        <a name="transfer" href="javascript:;">${views.home['index.transfer']}</a>
                                        <span class="global-top-seperator">|</span>
                                    </c:if>
                                    <a name="recharge" href="javascript:;">${views.home['index.despoit']}</a>
                                    <span class="global-top-seperator">|</span>
                                    <a name="withdraws" href="javascript:;">${views.home['index.withdraw']}</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </li>
            </ul>