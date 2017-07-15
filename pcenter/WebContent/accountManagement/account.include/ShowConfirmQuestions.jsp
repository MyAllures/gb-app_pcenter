<%@ page import="so.wwb.gamebox.model.CacheBase" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<div class="accout-retract" id="showSafeQuestionRe">
    <div id="validateRule" style="display: none">${safeQuestionRule}</div>
    <h2>${views.account['AccountSetting.setting.question.message10']}</h2>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.question1']}：</label>
        <div class="controls">${dicts.setting.master_question1[sysUserProtectionVo.result.question1]}</div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
        <div class="controls">
            <input type="text" placeholder="" name="answer1"  class="input" showSuccMsg="false">
        </div>
    </div>

    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.question2']}：</label>
        <div class="controls">
            ${dicts.setting.master_question2[sysUserProtectionVo.result.question2]}
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
        <div class="controls">
            <input type="text" placeholder="" name="answer2"  class="input" showSuccMsg="false">
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.question3']}：</label>
        <div class="controls">
            ${dicts.setting.master_question3[sysUserProtectionVo.result.question3]}
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-left">${views.account['AccountSetting.setting.question.answer']}：</label>
        <div class="controls">
            <input type="text" placeholder="" name="answer3" class="input" showSuccMsg="false">
        </div>
    </div>
    <div class="control-grouptwo">
        <label class="control-label"></label>
        <div class="controls">
            <soul:button target="showQuestions2" text="${views.common['next']}" cssClass="btn-blue btn btn-big" precall="validateForm" opType="function">${views.common['next']}</soul:button>
            &nbsp;&nbsp;${views.account['AccountSetting.setting.question.forgetAnswer']}
            <soul:button target="customerService" text="" url="<%=CacheBase.getDefaultCustomerService().getParameter()%>" opType="function" cssClass="">
                <span class="">${views.account['AccountSetting.setting.contactOnlineCustomer']}</span>
            </soul:button>
        </div>
    </div>
</div>

<!--//endregion your codes １-->