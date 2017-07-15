<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form>
    <div class="notice"><div class="notice-left"><em class="path"></em></div>
        <div class="path-right"> <a class="cursor">${views.sysResource['个人资料']}</a></div>
    </div>
    <!--个人信息-->

    <div class="accout-infomation">
        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.pic']}：</label>
            <div class="controls  portrait position">
                <p class="edit-bg inline">
                    <img src="${soulFn:getImagePathWithDefault(domain, sysUserVo.result.avatarUrl,resRoot.concat('/images/default_portrait.png'))}" width="85" height="85">
                </p>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.realName']}：</label>
            <div class="controls">
                <span class="textop">${soulFn:overlayName(sysUserVo.result.realName)}</span>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.country']}：</label>
            <div class="controls">
                <span class="textop">
                        ${dicts.region.region[sysUserVo.result.country]}
                        <c:if test="${not empty sysUserVo.result.region}">-${dicts.state[sysUserVo.result.country][sysUserVo.result.region]}</c:if>
                        <c:if test="${not empty sysUserVo.result.city and not empty sysUserVo.result.region}">-${dicts.city[(sysUserVo.result.country).concat("_").concat(sysUserVo.result.region)][sysUserVo.result.city]}</c:if>
                </span>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.timeZone']}：</label>
            <div class="controls">
                <span class="textop">${dicts.common.time_zone[sysUserVo.result.defaultTimezone]}</span>
            </div>
        </div>

        <div class="control-group" id="defaultLocale" data-local="${sysUserVo.result.defaultLocale}">
            <label class="control-label">${views.account['AccountSetting.personal.language']}：</label>
            <div class="controls">
                <span class="textop">
                    ${dicts.common.local[sysUserVo.result.defaultLocale]}
                </span>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.currency']}：</label>
            <div class="controls">
                <span class="textop">${sysUserVo.result.defaultCurrency}${dicts.common.currency[sysUserVo.result.defaultCurrency]}</span>
            </div>
        </div>

        <%--<c:if test="${paramMap['nickName']=='1'}">
            <div class="control-group">
                <label class="control-label">${views.account['AccountSetting.personal.nickName']}：</label>
                <div class="controls">
                    <span class="textop">${sysUserVo.result.nickname}</span>
                </div>
            </div>
        </c:if>--%>

        <c:if test="${paramMap['sex']=='1'}">
            <div class="control-group">
                <label class="control-label">${views.account['AccountSetting.personal.sex']}：</label>
                <div class="controls">
                    <span class="textop">
                        <c:if test="${sysUserVo.result.sex eq 'male'}">
                            ${views.account['AccountSetting.personal.sex.male']}
                        </c:if>

                        <c:if test="${sysUserVo.result.sex eq 'female'}">
                            ${views.account['AccountSetting.personal.sex.female']}
                        </c:if>

                        <c:if test="${sysUserVo.result.sex eq 'secret'}">
                            ${views.account['AccountSetting.personal.sex.any']}
                        </c:if>
                    </span>
                </div>
            </div>
        </c:if>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.birthday']}：</label>
            <div class="controls">
                <span class="textop">${soulFn:formatDateTz(sysUserVo.result.birthday, DateFormat.DAY, timeZone)}</span>

            </div>
        </div>

        <div class="control-group">
            <label class="control-label">${views.account['AccountSetting.personal.constellation']}：</label>
            <div class="controls">
                <span class="textop">${dicts.common.constellation[sysUserVo.result.constellation]}</span>
            </div>
        </div>

        <c:if test="${paramMap['303']=='1'}">
            <div class="control-group">
                <label class="control-label">SKYPE：</label>
                <div class="controls">
                    <span class="textop">
                        <c:if test="${noticeContactWays gt 0}">
                            ${noticContactWayMap["303"].contactValue}
                        </c:if>
                    </span>
                </div>
            </div>
        </c:if>

        <c:if test="${paramMap['302']=='1'}">
            <div class="control-group">
                <label class="control-label">MSN：</label>
                <div class="controls">
                <span class="textop">
                    <c:if test="${noticeContactWays gt 0}">
                        ${noticContactWayMap["302"].contactValue}
                    </c:if>
                </span>
                </div>
            </div>
        </c:if>

        <c:if test="${paramMap['301']=='1'}">
            <div class="control-group">
                <label class="control-label">QQ：</label>
                <div class="controls">
                    <span class="textop">
                        <c:if test="${noticeContactWays gt 0}">
                            ${noticContactWayMap["301"].contactValue}
                        </c:if>
                    </span>
                </div>
            </div>
        </c:if>
        <div class="control-group">
            <soul:button target="toEdit" text="${views.common['edit']}" opType="function" cssClass="btn-blue btn large-big"/>
        </div>
    </div>
</form:form>
<!--//endregion your codes １-->
<!--//region your codes 3-->
<soul:import res="site/accountManagement/PersonalInfoView"/>
<!--//endregion your codes 3-->
