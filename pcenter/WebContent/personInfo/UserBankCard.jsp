<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<html lang="zh-CN">
<head>
    <title>${views.personInfo_auto['添加银行卡']}</title>
    <%@ include file="/include/include.head.jsp" %>
</head>

<body class="body-b-none">
<form:form id="editForm" action="" method="post">
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="modal-body">
        <div class="control-grouptwo line-hi34">
            <label class="control-left">${views.personInfo_auto['真实姓名']}：</label>
            <div class="controls">
                <c:choose>
                    <c:when test="${user.realName != null && user.realName != ''}">
                        <input type="text" readonly="readonly" name="realName" value="${soulFn:overlayName(user.realName)}" class="input bn" maxlength="30" showSuccMsg="false">
                    </c:when>
                    <c:otherwise>
                        <input type="hidden" name="realName">
                        <div class="real-name"><soul:button target="setRealName" text="${views.personInfo_auto['添加真实姓名']}" opType="function" /></div>
                    </c:otherwise>
                </c:choose>
            </div>
            <p class="tipsgray">${views.personInfo_auto['银行卡户名与真实姓名一致才能取款成功']}</p>
        </div>

        <div class="control-grouptwo clearfix ud-select" style="margin-top: 0;">
            <label class="control-left">${views.personInfo_auto['银行']}：</label>

            <div class="bank-deposit" style="margin-bottom: 0">
                <div class="bank-total">
                    <c:forEach items="${bankListVo.result}" var="bank" varStatus="vs" end="14">
                        <label class="bank ${vs.index==0?' select':''}" bankcode="${bank.bankName}">
                        <span class="radio">
                            <input name="result.bankName" type="radio" value="${bank.bankName}" ${vs.index==0?'checked':''} class="ignore"/>
                        </span>
                        <span class="radio-bank" title="${dicts.common.bankname[bank.bankName]}">
                            <i class="pay-bank ${bank.bankName}"></i>
                        </span>
                            <span class="bank-logo-name">${dicts.common.bankname[bank.bankName]}</span>
                        </label>
                    </c:forEach>
                </div>

                <div name="hideBank" style="display: none;">
                    <c:forEach items="${bankListVo.result}" var="bank" varStatus="vs" begin="15">
                        <label class="bank ${vs.index==0?' select':''}" bankcode="${bank.bankName}">
                        <span class="radio">
                            <input name="result.bankName" type="radio" value="${bank.bankName}" ${vs.index==0?'checked':''} class="ignore"/>
                        </span>
                        <span class="radio-bank" title="${dicts.common.bankname[bank.bankName]}">
                            <i class="pay-bank ${bank.bankName}"></i>
                        </span>
                            <span class="bank-logo-name">${dicts.common.bankname[bank.bankName]}</span>
                        </label>
                    </c:forEach>
                </div>
                <div class="clear"></div>
            </div>
            <c:if test="${fn:length(bankListVo.result)>15}">
                <div class="bank-spreadout set" style="margin-right: 108px; margin-bottom: 0;">
                <span name="extendBank">
                    <soul:button target="showMoreBank" text="${views.fund['Deposit.deposit.expendBank']}" opType="function"/>
                    <i class="bank-arrico down"></i>
                </span>
                <span style="display: none" name="collapseBank">
                    <soul:button target="showMoreBank" text="${views.fund['Deposit.deposit.shrinkBank']}" opType="function"/>
                    <i class="bank-arrico up"></i>
                </span>
                </div>
            </c:if>

        </div>

        <div class="control-grouptwo">
            <label class="control-left">${views.personInfo_auto['银行卡号']}：</label>
            <div class="controls">
                <input type="text" class="input bn ignore" placeholder="" maxlength="24" name="bankcardNumber2" tipsName="result.bankcardNumber-tips" autocomplete="off">
                <input type="hidden" class="input" placeholder="" name="result.bankcardNumber" >
            </div>
        </div>

        <div class="control-grouptwo">
            <label class="control-left">${views.personInfo_auto['开户行']}：</label>
            <div class="controls">
                <input type="text" autocomplete="off" class="input bn result-bankDeposit" name="result.bankDeposit">
            </div>
            <p class="tipsgray">${views.personInfo_auto['如']}</p>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button precall="validateForm" target="${root}/personInfo/password/updatePassword.html"
                     text="${views.account['AccountSetting.update']}" opType="ajax"
                     cssClass="btn btn-outline btn-filter" dataType="json" post="getCurrentFormData"
                     callback="saveCallbak">${views.common['AccountSetting.update']}
        </soul:button>
        <soul:button target="closePage" text="${views.common['cancel']}" opType="function"
                     cssClass="btn-gray btn btn-big">${views.common['cancel']}
        </soul:button>
    </div>
</form:form>

</body>
<%@ include file="/include/include.js.jsp" %>
<!--//region your codes 4-->
<soul:import res="site/personInfo/UpdateBank"/>
<!--//endregion your codes 4-->
</html>
<!--//endregion your codes １-->
