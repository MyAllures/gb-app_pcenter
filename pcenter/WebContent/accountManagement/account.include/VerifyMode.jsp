<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract">

    <h2>${views.account['AccountSetting.setting.verifyMode']}</h2>

    <div class="clearfix">
        
        <c:choose>
            <c:when test="${not empty permissionPwd || not empty sysUserProtectionVo.result}">
                <c:if test="${not empty permissionPwd}">
                    <div class="verify-way">
                        <dl>
                            <dd class="title-a"><i class="navico recommend"></i>${views.account['AccountSetting.setting.message5']}</dd>
                            <dd class="title-b">${views.account['AccountSetting.setting.message6']}</dd>
                            <dd class="title-c">
                                <soul:button target="toSecurityPwd" text="${views.account['AccountSetting.setting.message11']}" opType="function" cssClass="btn btn-outline btn-filter btn-lg real-time-btn" contactWayType="${type}" isSet="${not empty sysUserProtectionVo.result}"><span class="">${views.account['AccountSetting.setting.message11']}</span></soul:button>
                            </dd>
                        </dl>
                    </div>
                </c:if>

                <c:if test="${not empty sysUserProtectionVo.result}">
                    <div class="verify-way">
                        <dl>
                            <dd class="title-a"><i class="navico security"></i>${views.account['AccountSetting.setting.question.message9']}</dd>
                            <dd class="title-b">${views.account['AccountSetting.setting.message7']}</dd>
                            <dd class="title-c">
                                <soul:button target="toConfirmAnswers" text="${views.account['AccountSetting.setting.message8']}" opType="function" cssClass="btn btn-outline btn-filter btn-lg real-time-btn" contactWayType="${type}" isSet="${not empty permissionPwd}"><span class="">${views.account['AccountSetting.setting.message8']}</span></soul:button>
                            </dd>
                        </dl>
                    </div>
                </c:if>
            </c:when>
            <c:otherwise>
                <div class="verify-way">
                    <dl>
                        <dd class="title-a"><i class="navico recommend"></i>${views.account['AccountSetting.setting.message9']}</dd>
                        <dd class="title-b">${views.account['AccountSetting.setting.message10']}</dd>
                        <dd class="title-c">
                            <soul:button target="customerService" text="" url="<%=CacheBase.getDefaultCustomerService().getParameter()%>" opType="function" cssClass="btn  btn-outline btn-filter btn-lg real-time-btn">
                                <span class="">${views.account['AccountSetting.setting.message12']}</span>
                            </soul:button>
                        </dd>
                    </dl>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div>
<!--//endregion your codes １-->
