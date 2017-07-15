<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="personInfo">
        <div id="validateRule" style="display: none">${validateRule}</div>
        <div class="notice">
            <div class="notice-left"><em class="path"></em></div>
            <div class="path-right"><a class="cursor">${views.sysResource['个人资料']}</a></div>
        </div>
        <!--个人信息-->
        <div class="accout-infomation">
            <div class="control-group">
                <label class="control-label">${views.account['AccountSetting.personal.pic']}：</label>
                <div class="controls portrait position">
                    <a href="/personalInfo/toUploadHeadPortrait.html" nav-target="mainFrame">${views.account['AccountSetting.personal.updatePic']}</a>
                    <p class="edit-bg inline">
                        <img src="${soulFn:getImagePathWithDefault(domain, sysUserVo.result.avatarUrl,resRoot.concat('/images/default_portrait.png'))}" width="85" height="85">
                    </p>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">${views.account['AccountSetting.personal.realName']}：</label>
                <div class="controls">
                    <c:choose>
                        <c:when test="${empty sysUserVo.result.realName}">
                            <input type="text" class="input" value="${sysUserVo.result.realName}" name="result.realName" maxlength="30">
                            <span class="orange tips line-hi30"><i class="mark plaintsmall"></i>${views.account['AccountSetting.personal.message']}</span>
                            <input type="hidden" id="realNameStatus" value="0" name="realNameStatus"/>
                        </c:when>
                        <c:otherwise>
                            <span class="textop">${soulFn:overlayName(sysUserVo.result.realName)}</span>
                            <input type="hidden" name="result.realName" value="${sysUserVo.result.realName}"/>
                            <input type="hidden" id="realNameStatus" value="1" name="realNameStatus"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="control-group clearfix">
                <label class="control-label">${views.account['AccountSetting.personal.country']}：</label>
                <div class="controls">
                    <span class="input-group pull-left">
                        <gb:selectPure name="result.country"
                                       prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                       value="${sysUserVo.result.country}"
                                       listValue="remark"
                                       listKey="dictCode"
                                       relSelect="result.region"
                                       ajaxListPath="${root}/regions/site.html"/>
                    </span>
                    <span class="input-group pull-left">
                        <gb:selectPure name="result.region"
                                       prompt="${views.account['AccountSetting.personal.pleaseSelect']}"

                                       value="${sysUserVo.result.region}"
                                       listValue="remark"
                                       listKey="dictCode"
                                       relSelect="result.city"
                                       relSelectPath="${root}/regions/states/#result.country#.html"/>
                    </span>
                    <span class="input-group pull-left">
                        <gb:selectPure name="result.city"
                                       prompt="${views.account['AccountSetting.personal.pleaseSelect']}"
                                       value="${sysUserVo.result.city}"
                                       listValue="remark" listKey="dictCode"
                                       relSelectPath="${root}/regions/cities/#result.country#-#result.region#.html"/>
                    </span>
                </div>
            </div>

            <div class="control-group clearfix">
                <label class="control-label">${views.account['AccountSetting.personal.timeZone']}：</label>
                <div class="controls">
                    <c:choose>
                        <c:when test="${empty sysUserVo.result.defaultTimezone}">
                            <gb:selectPure name="result.defaultTimezone" list="${timeZoneEnum}" prompt="${views.account['AccountSetting.personal.pleaseSelect']}" value="${sysUserVo.result.defaultTimezone}"/>
                            <span class="orange tips line-hi30"><i class="mark plaintsmall"></i>${views.account['AccountSetting.personal.message']}</span>
                            <input type="hidden" id="timezoneStatus" value="0" name="timezoneStatus"/>
                        </c:when>
                        <c:otherwise>
                            <span class="textop">${dicts.common.time_zone[sysUserVo.result.defaultTimezone]}</span>
                            <input type="hidden" name="result.defaultTimezone" value="${sysUserVo.result.defaultTimezone}"/>
                            <input type="hidden" id="timezoneStatus" value="1" name="timezoneStatus"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="control-group clearfix">
                <label class="control-label">${views.account['AccountSetting.personal.language']}：</label>
                <div class="controls">
                    <span class="input-group pull-left">
                        <gb:selectPure name="result.defaultLocale" prompt="${views.account['AccountSetting.personal.pleaseSelect']}" value="${sysUserVo.result.defaultLocale}" ajaxListPath="${root}/personalInfo/getDefaultLocale.html" listKey="language"  listValue="tran"/>
                    </span>
                </div>
            </div>

            <div class="control-group clearfix">
                <label class="control-label">${views.account['AccountSetting.personal.currency']}：</label>
                <div class="controls">
                    <c:choose>
                        <c:when test="${empty sysUserVo.result.defaultCurrency}">
                            <span class="input-group pull-left">
                            <gb:selectPure name="result.defaultCurrency" prompt="${views.account['AccountSetting.personal.pleaseSelect']}" value="${sysUserVo.result.defaultCurrency}" ajaxListPath="${root}/personalInfo/getMainCurrency.html" listKey="code" listValue="tran"/>
                        </span>
                            <span class="orange tips line-hi30"><i class="mark plaintsmall"></i>${views.account['AccountSetting.personal.message']}</span>
                            <input type="hidden" id="currencyStatus" value="0" name="currencyStatus"/>
                        </c:when>
                        <c:otherwise>
                            <span class="textop">${dicts.common.currency[sysUserVo.result.defaultCurrency]}</span>
                            <input type="hidden" name="result.defaultCurrency" value="${sysUserVo.result.defaultCurrency}"/>
                            <input type="hidden" id="currencyStatus" value="1" name="currencyStatus"/>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            
            <%--<c:choose>
                <c:when test="${paramMap['nickName']=='1'}">
                    <div class="control-group">
                        <label class="control-label">${views.account['AccountSetting.personal.nickName']}：</label>
                        <div class="controls">
                            <input type="text" class="input" placeholder="" maxlength="15" value="${sysUserVo.result.nickname}" name="result.nickname">
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <input type="hidden" class="input" name="result.nickname" value="${sysUserVo.result.nickname}">
                </c:otherwise>
            </c:choose>--%>

            <c:choose>
                <c:when test="${paramMap['sex']=='1'}">
                    <div class="control-group">
                        <label class="control-label">${views.account['AccountSetting.personal.sex']}：</label>
                        <div class="controls m-t">
                            <span class="radio"><input name="result.sex" value="male" type="radio" ${sysUserVo.result.sex eq 'male'?'checked':''}></span>${views.account['AccountSetting.personal.sex.male']}
                            <span class="radio m-l"><input name="result.sex" value="female" type="radio" ${sysUserVo.result.sex eq 'female'?'checked':''}></span>${views.account['AccountSetting.personal.sex.female']}
                            <span class="radio m-l"><input name="result.sex" value="secret" type="radio" ${sysUserVo.result.sex eq 'secret'?'checked':''}></span>${views.account['AccountSetting.personal.sex.any']}
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <input type="hidden" name="result.sex" value="${sysUserVo.result.sex}"}>
                </c:otherwise>
            </c:choose>

            <div class="control-group">
                <label class="control-label">${views.account['AccountSetting.personal.birthday']}：</label>
                <div class="controls">
                    <gb:dateRange format="${DateFormat.DAY}" style="width:100px" inputStyle="width:80px" name="result.birthday"
                                  id="birthday" showDropdowns="true" callback="chooseConstellation"
                                  value="${sysUserVo.result.birthday}" maxDate="${dateQPicker.today}"></gb:dateRange>
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">${views.account['AccountSetting.personal.constellation']}：</label>
                <div class="controls"><span class="input-group pull-left">
                    <gb:selectPure name="result.constellation" list="${constellationEnum}" prompt="${views.account['AccountSetting.personal.pleaseSelect']}" value="${sysUserVo.result.constellation}"/></span>
                </div>
            </div>

            <c:choose>
                <c:when test="${paramMap['303']=='1'}">
                    <div class="control-group">
                        <label class="control-label">SKYPE：</label>
                        <div class="controls">
                            <input type="text" class="input" placeholder="" name="skype.contactValue" value="${noticeContactWays gt 0?noticContactWayMap["303"].contactValue:''}" maxlength="30">
                            <input type="hidden" value="${noticContactWayMap["303"].id}" name="skype.id">
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <input type="hidden" class="input" name="skype.contactValue" value="${noticeContactWays gt 0?noticContactWayMap["303"].contactValue:''}">
                    <input type="hidden" value="${noticContactWayMap["303"].id}" name="skype.id">
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${paramMap['302']=='1'}">
                    <div class="control-group">
                        <label class="control-label">MSN：</label>
                        <div class="controls">
                            <input type="text" class="input" placeholder="" name="msn.contactValue" value="${noticeContactWays gt 0?noticContactWayMap["302"].contactValue:''}" maxlength="30">
                            <input type="hidden" value="${noticContactWayMap["302"].id}" name="msn.id">
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <input type="hidden" class="input" name="msn.contactValue" value="${noticeContactWays gt 0?noticContactWayMap["302"].contactValue:''}">
                    <input type="hidden" value="${noticContactWayMap["302"].id}" name="msn.id">
                </c:otherwise>
            </c:choose>
            
            <c:choose>
                <c:when test="${paramMap['301']=='1'}">
                    <div class="control-group">
                        <label class="control-label">QQ：</label>
                        <div class="controls">
                            <input type="text" class="input" placeholder="" name="qq.contactValue" value="${noticeContactWays gt 0?noticContactWayMap["301"].contactValue:''}" maxlength="30">
                            <input type="hidden" value="${noticContactWayMap["301"].id}" name="qq.id">
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <input type="hidden" class="input" name="qq.contactValue" value="${noticeContactWays gt 0?noticContactWayMap["301"].contactValue:''}">
                    <input type="hidden" value="${noticContactWayMap["301"].id}" name="qq.id">
                </c:otherwise>
            </c:choose>

            <div class="control-group">
                    <soul:button cssClass="btn-blue btn large-big" text="${views.account['AccountSetting.personal.msg']}" opType="function" precall="updatePersonInfo" target="${root}/personalInfo/toPersonInfoSure.html?{xxx}" callback="updatePerson">${views.common['ok']}</soul:button>
                <a href="/personalInfo/view.html" nav-target="mainFrame" class="btn-gray btn large-big m-l">${views.common['cancel']}</a>
            </div>
        </div>
</form:form>
<!--//endregion your codes １-->
<!--//region your codes 3-->
<soul:import res="site/accountManagement/PersonalInfo"/>
<!--//endregion your codes 3-->
