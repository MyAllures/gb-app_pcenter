<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<style>
    .change-password-wrap .control-group .controls .tips{width: 100%}
</style>
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
                <div class="change-link step-btn active">
                    <span class="step-btn-num">2</span>
                    身份认证
                </div>
                <div class="change-link step-btn">
                    <span class="step-btn-num">3</span>
                    重置密码
                </div>
                <div class="change-link step-btn">
                    <span class="step-btn-num">4</span>
                    修改成功
                </div>
            </div>

            <div class="control-group phone">
                <label class="control-label">手机号码：</label>
                <input type="hidden" class="input" name="phone.id" value="${noticeContactWay.id}">
                <input type="hidden" class="input bn" name="phone.contactValue" id="phoneCode" value="${noticeContactWay.contactValue}">
                <div class="controls ph-text">${soulFn:overlayTel(noticeContactWay.contactValue)}</div>
            </div>

            <div class="control-group">
                <label class="control-label">验证码：</label>
                <div class="controls">
                    <input type="text" class="input input-money" placeholder="请输入接收到的短信验证码" name="phone.phoneVerificationCode" maxlength="6">
                    <soul:button target="sendPhoneCode" text="" opType="function" cssClass="btn-gray btn btn-code">获取验证码</soul:button>
                </div>
            </div>

            <div class="change-btn">
                <soul:button target="checkPhoneCode" text="" opType="function" cssClass="btn-blue btn large-big">
                    下一步
                </soul:button>

                <a href="/personInfo/password/forgetPwd3.html" nav-target="mainFrame" class="checkPhoneCode btn-blue btn large-big" style="display: none">下一步</a>
            </div>
        </form>
    </div>
</div>
<soul:import res="site/personInfo/ForgetPwd"/>


