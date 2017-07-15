<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
    <div class="accout-retract"><div id="validateRule" style="display: none">${safeQuestionRule}</div>
    <input type="hidden" name="question1" value="${safeQuestionVo.question1}">
    <input type="hidden" name="question2" value="${safeQuestionVo.question2}">
    <input type="hidden" name="question3" value="${safeQuestionVo.question3}">
    <input type="hidden" name="a1" value="${safeQuestionVo.answer1}">
    <input type="hidden" name="a2" value="${safeQuestionVo.answer2}">
    <input type="hidden" name="a3" value="${safeQuestionVo.answer3}">
    <h2>${views.account['AccountSetting.setting.question.message']}</h2>
    <%--<div class="warm-tips">
        <h3 class="orange">${views.account['AccountSetting.setting.question.tips']}：</h3>
        <p>${views.account['AccountSetting.setting.question.message1']}</p></div>--%>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.question1']}：</label>
        <div class="controls">${dicts.setting.master_question1[safeQuestionVo.question1]}</div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
        <div class="controls">
            <input type="text" tt="a1" placeholder="" class="input answer" name="answer1" autocomplete="off">
        </div>
    </div>

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.question2']}：</label>
        <div class="controls">
            ${dicts.setting.master_question2[safeQuestionVo.question2]}
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
        <div class="controls">
            <input type="text" tt="a2" placeholder="" class="input answer" name="answer2" autocomplete="off">
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.question3']}：</label>
        <div class="controls">
            ${dicts.setting.master_question3[safeQuestionVo.question3]}
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
        <div class="controls">
            <input type="text" tt="a3" placeholder="" class="input answer" name="answer3" autocomplete="off"/>
        </div>
    </div>
    <%--<div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.password.loginPwd']}：</label>
        <div class="controls">
            <input type="password" placeholder="" class="input" name="loginPassword" />
            <p class="m-tt"><a>${views.account['AccountSetting.setting.question.message2']}</a></p>
        </div>
    </div>--%>

    <div class="control-grouptwo">
        <label class="control-label"></label>
        <div class="controls">
            <soul:button target="${root}/accountSettings/saveQuestions.html" text="${views.common['submit']}" cssClass="btn-blue btn btn-big disabled answers" precall="validateForm" opType="ajax" post="getCurrentFormData" callback="mySaveCallBack">${views.common['submit']}</soul:button>
            <soul:button target="showQuestions" text="${views.account['AccountSetting.setting.question.message3']}" cssClass="btn-gray btn btn-big" opType="function" post="getCurrentFormData">${views.account['AccountSetting.setting.question.message3']}</soul:button>
        </div>
    </div>
</div>

<!--//endregion your codes １-->
