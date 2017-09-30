<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right">${views.personInfo_auto['玩家中心']}<span class="arrow">></span>${views.personInfo_auto['个人资料']}</div>
</div>
<c:choose>
    <c:when test="${isDemo}">
        <%@include file="../share/DemoNoPermit.jsp"%>
    </c:when>
    <c:otherwise>
        <!--账号设置-->
        <form:form id="personInfo">
            <div id="validateRule" style="display: none">${validateRule}</div>
            <gb:token/>
            <div class="user-info">
                <div class="user-info-left portrait">
                    <a href="/personInfo/toUploadHeadPortrait.html" nav-target="mainFrame"
                       class="pInfo">${views.account['AccountSetting.personal.updatePic']}</a>
                    <p class="edit-bg">
                        <img src="${soulFn:getThumbPathWithDefault(domain, sysUser.avatarUrl,85,85, resRoot.concat('/images/default_portrait.png'))}"
                             width="85px" height="85px">
                    </p>
                </div>
                <div class="user-info-right">
                    <p class="gray">
                        <span>${views.personInfo_auto['欢迎游戏']}</span> <span class="orange">${sysUser.username}</span>
                        &nbsp;&nbsp;${views.personInfo_auto['再忙也要起来走一走']}
                    </p>
                    <p>
                <span class="spacewidth">
                  <i class="gray">${views.personInfo_auto['主货币']}：</i>
                  ${sysUser.defaultCurrency}${dicts.common.currency[sysUser.defaultCurrency]}
                </span>
                    </p>
                    <p>
              <span class="spacewidth">
                <i class="gray">${views.personInfo_auto['上次登录时间']}：</i>
                ${soulFn:formatDateTz(sysUser.lastLoginTime,DateFormat.DAY_SECOND,timeZone)}
              </span>
                    </p>
                </div>
                <div class="user-btn-right">
                    <soul:button target="${root}/personInfo/password/editPassword.html" text="${views.personInfo_auto['修改登录密码']}" opType="dialog"
                                 cssClass="btn btn-outline btn-filter editPassword" tag="button"/>
                        <%--<c:choose>
                            <c:when test="${empty sysUser.permissionPwd}">
                                <soul:button target="${root}/personInfo/password/toSecurityPassword.html" text="${views.personInfo_auto['设置安全密码']}"
                                             opType="dialog"
                                             cssClass="btn btn-outline btn-filter" tag="button"/>
                            </c:when>
                            <c:otherwise>
                                <soul:button target="${root}/personInfo/password/toUpdateSecurityPassword.html" text="${views.personInfo_auto['修改安全密码']}"
                                             opType="dialog"
                                             cssClass="btn btn-outline btn-filter" tag="button"/>
                            </c:otherwise>
                        </c:choose>--%>

                    <soul:button target="${root}/personInfo/password/toUpdateSecurityPassword.html" text="${views.personInfo_auto['修改安全密码']}"
                                 opType="dialog"
                                 cssClass="btn btn-outline btn-filter" tag="button"/>
                </div>
            </div>

            <%@include file="AccountInfo.jsp"%>

        </form:form>
    </c:otherwise>
</c:choose>

<!--//endregion your codes １-->
<!--//region your codes 3-->
<soul:import res="site/personInfo/PersonInfo"/>
<!--//endregion your codes 3-->
