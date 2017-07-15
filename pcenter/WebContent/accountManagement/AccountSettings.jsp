<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['个人资料']}</a></div>
    </div>

    <%--begin 个人信息--%>
    <div class="user-info">
        <div class="user-info-left portrait">
            <a href="javascript:void(0)" class="pInfo">${views.account['AccountSetting.personal.updatePic']}</a>
            <p class="edit-bg">
                <img src="${soulFn:getThumbPathWithDefault(domain, sysUserVo.result.avatarUrl,85,85, resRoot.concat('/images/default_portrait.png'))}" width="85px" height="85px">
            </p>
        </div>

        <div class="user-info-right">
            <p class="gray"><span id="_hourss"></span><span class="orange">${sysUserVo.result.nickname}</span>&nbsp;&nbsp;${views.account['AccountSetting.setting.message']}</p>
            <div>
                <span class="spacewidth">
                    <i class="gray">${views.account['AccountSetting.personal.realName']}：</i>
                    <c:choose>
                        <c:when test="${not empty sysUserVo.result.realName}">
                            ${soulFn:overlayName(sysUserVo.result.realName)}
                        </c:when>
                        <c:otherwise>
                            <form:form><soul:button target="${root}/accountSettings/toSettingRealName.html" text="${views.account['AccountSetting.setting.realName']}" opType="dialog">${views.account['AccountSetting.setting.realName']}</soul:button></form:form>
                        </c:otherwise>
                    </c:choose>
                </span>
                <i class="gray">${views.account['AccountSetting.setting.account']}</i>：${sysUserVo.result.username}${postfix}
            </div>
            <p><span class="spacewidth"><i class="gray">${views.account['AccountSetting.setting.registerTime']}：</i>${soulFn:formatDateTz(sysUserVo.result.createTime,DateFormat.DAY_SECOND ,timeZone )}</span><i class="gray">${views.account['AccountSetting.setting.lastLogin']}：</i>
                ${soulFn:formatDateTz(sysUserVo.result.lastLoginTime,DateFormat.DAY_SECOND , timeZone)}</p>
        </div>
    </div>
    <%--end 个人信息--%>

    <!-- begin 账号设置-->
    <div class="account-list">
        <div class="account-list-top">
            <c:set var="score" value="${accountSecurityLevel.score}"></c:set>
            <c:set var="grade" value="${accountSecurityLevel.grade}"></c:set>
            <dl>
                <dt>
                    <dd>${views.account['AccountSetting.setting.message1']}：<span class="orange fontbig">${score}</span>${views.account['AccountSetting.setting.score']}
                        <c:if test="${score>=0 and score<=59}">
                            <span class="spacefs orange fontsmall"><i class="mark plaint"></i>${views.account['AccountSetting.setting.message2']}</span>
                        </c:if>
                        <c:if test="${score>=60 and score<=79}">
                            <span class="spacefs orange fontsmall"><i class="mark plaint"></i>${views.account['AccountSetting.setting.message3']}</span>
                        </c:if>
                        <c:if test="${score>=80 and score<=100}">
                            <span class="spacefs orange fontsmall"><i class="mark plaint"></i>${views.account['AccountSetting.setting.message4']}</span>
                        </c:if>
                    </dd>
                    <dd>${views.account['AccountSetting.setting.accountLevel']}：<span class="auth-rate"> <span class="progress" style="width:${score}%"></span></span>
                        <span class="green">${views.common[grade]}</span>
                    </dd>
                </dt>
            </dl>
        </div>
        <div class="account-list-cen">
            <%--标记：玩家首页-左侧-个人信息-点击图标--%>
            <input type="hidden" name="isSign" value="${isSign}"/>
            <input type="hidden" name="typeName" value="${typeName}"/>

            <%--登录密码--%>
                <%@ include file="account.include/LoginPassword.jsp"%>
            <%--登录密码 --%>

            <%--安全密码 --%>
                <%@ include file="account.include/SecurityPassword.jsp"%>
            <%--安全密码 --%>

            <%--手机绑定 --%>
                <%@ include file="account.include/Phone.jsp"%>
            <%--手机绑定 --%>

            <%--邮箱绑定 --%>
                <%@include file="account.include/Email.jsp"%>
            <%--邮箱绑定 --%>

            <%--安全问题 --%>
                <%@ include file="account.include/SafeQuestions.jsp"%>
            <%--安全问题 --%>

            <%--银行卡信息 --%>
            <%@include file="account.include/Bank.jsp"%>
            <%--银行卡信息 --%>
        </div>
    </div>
<!-- end 账号设置-->
<!--//endregion your codes １-->
<!--//region your codes 3-->
<script>
    var _type = ${not empty type?type:"false"};
</script>
<soul:import res="site/accountManagement/AccountSettings"/>
<!--//endregion your codes 3-->
