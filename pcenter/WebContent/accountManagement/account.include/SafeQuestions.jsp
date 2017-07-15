<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form id="safeQuestion">
    <input type="hidden" value="${sysUserProtection.id}" name="sysUserProtectionId">
    <div id="validateRule" style="display: none">${safeQuestionRule}</div>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr>
            <td><i class="mark ${not empty sysUserProtection?'success':'plaint'}"></i>${views.account['AccountSetting.setting.question.securityQuestion']}</td>
            <td class="gray">${not empty sysUserProtection?views.account['AccountSetting.setting.question.message4']:views.account['AccountSetting.setting.question.message5']}</td>
            <td width="14%">
                <soul:button target="SetAndHide" text="" opType="function" cssClass="btn btn-blue btn-small classtitle" tag="button">
                    <span class="set">${views.account['AccountSetting.set']}</span>
                    <span class="shrink">${views.account['AccountSetting.shrink']}</span>
                </soul:button>
            </td>
        </tr>
        <tr class="bottomline" style="display:none;">
            <td colspan="3" id="question">
                <c:choose>
                    <c:when test="${not empty sysUserProtection}">
                        <%--修改安全问题--%>
                        <div class="accout-retract" id="modifySafeQuestion">
                            <h2>${views.account['AccountSetting.setting.question.message6']}</h2>
                            <div class="orange spaces modifypassword">
                                ${views.account['AccountSetting.setting.question.message7']}
                            </div>
                            <div class="controls spaces">
                                <soul:button target="modifySecretSecurity" text="${views.account['AccountSetting.setting.question.updatePwd']}" cssClass="btn-gray btn btn-big ${sysUserProtection.errorTimes>=6?'disable-gray ui-button-disable':''}" opType="function">${views.account['AccountSetting.setting.question.updatePwd']}</soul:button>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <%--设置安全问题--%>
                        <div class="accout-retract">
                            <h2>${views.account['AccountSetting.setting.question.message5']}</h2>
                            <%--<div class="warm-tips">--%>
                                <%--<h3 class="orange">${views.account['AccountSetting.setting.question.tips']}：</h3>--%>
                                <%--<p>${views.account['AccountSetting.setting.question.message1']}</p></div>--%>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.question.question1']}：</label>
                                <div class="controls">
                                    <gb:selectPure name="question1" list="${questions1}" cssClass="selectwidth" prompt="${views.account['AccountSetting.please']}" listValue="value" listKey="key"/>
                                </div>
                            </div>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
                                <div class="controls">
                                    <input type="text" placeholder="" class="input" name="answer1">
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.question.question2']}：</label>
                                <div class="controls">
                                    <gb:selectPure name="question2" list="${questions2}" cssClass="selectwidth" prompt="${views.account['AccountSetting.please']}" listValue="value" listKey="key"/>
                                </div>
                            </div>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
                                <div class="controls">
                                    <input type="text" placeholder="" class="input" name="answer2">
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.question.question3']}：</label>
                                <div class="controls">
                                    <gb:selectPure name="question3" list="${questions3}" cssClass="selectwidth" prompt="${views.account['AccountSetting.please']}" listValue="value" listKey="key"/>
                                </div>
                            </div>
                            <div class="control-grouptwo">
                                <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
                                <div class="controls">
                                    <input type="text" placeholder="" class="input" name="answer3">
                                </div>
                            </div>

                            <div class="control-grouptwo">
                                <label class="control-label"></label>
                                <div class="controls">
                                    <soul:button target="confirmQuestions" text="${views.common['next']}" cssClass="btn btn-filter" precall="validateForm" opType="function" post="getCurrentFormData">${views.common['next']}</soul:button>
                                </div>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </td>
        </tr>
    </table>
</form:form>
<!--//endregion your codes １-->
