<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>

<div id="mainFrame" class="main-wrap">
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a class="cursor">修改密码</a>
        </div>
    </div>

    <div class="hintotal float-not change-password-wrap">
        <form class="location" method="post">
            <div id="validateRule" style="display: none">${validateRule}</div>
            <div class="change-link-wrap step-wrap">
                <div class="change-link step-btn">
                    <span class="step-btn-num">1</span>
                    选择校验方式
                </div>
                <div class="change-link step-btn">
                    <span class="step-btn-num">2</span>
                    身份认证
                </div>
                <div class="change-link step-btn active">
                    <span class="step-btn-num">3</span>
                    重置密码
                </div>
                <div class="change-link step-btn">
                    <span class="step-btn-num">4</span>
                    修改成功
                </div>
            </div>

            <div class="control-group">
                <label class="control-label">${views.personInfo_auto['新密码']}：</label>
                <div class="controls">
                    <input class="input input-money" placeholder="请输入6位数字" type="password" name="privilegePwd" maxlength="6">
                </div>
            </div>
            <div class="control-group">
                <label class="control-label">${views.personInfo_auto['确认密码']}：</label>
                <div class="controls">
                    <input class="input input-money" placeholder="请再次输入密码" type="password" name="privilegeRePwd" maxlength="6">
                </div>
            </div>
            <div class="change-btn">
                <soul:button target="updatePrivilegePwd" text="" opType="function" cssClass="btn-blue btn large-big">
                    ${views.account['AccountSetting.update']}
                </soul:button>

                <a href="/personInfo/password/goSuccess.html" nav-target="mainFrame" class="goSuccess btn-blue btn large-big" style="display: none">确定</a>
            </div>
        </form>
    </div>
</div>
<soul:import res="site/personInfo/ForgetPwd"/>


