<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract">
    <div id="validateRule" style="display: none">${safeQuestionRule}</div>
    <h2>${views.account['AccountSetting.setting.question.message12']}</h2>
    <div class="warm-tips">
        <h3 class="orange">${views.account['AccountSetting.setting.question.tips']}：</h3>
        <p>${views.account['AccountSetting.setting.question.message1']}</p></div>
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

<!--//endregion your codes １-->
