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
            <div class="change-link-wrap step-wrap">
                <div class="change-link step-btn active">
                    <span class="step-btn-num">1</span>
                    选择校验方式
                </div>
                <div class="change-link step-btn">
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
            <c:if test="${phone}">
                <a href="/personInfo/password/forgetPwd2.html" nav-target="mainFrame" class="verification-wrap">
                    <span class="verification-title">绑定手机找回</span>
                    <span class="verification-txt">可通过绑定手机号+短信验证码，找回密码</span>
                </a>
            </c:if>

            <a <c:choose><c:when test="${customerService!=null}">href="${customerService}" target="_blank" </c:when><c:otherwise> href="javascript:"</c:otherwise></c:choose> class="verification-wrap">
                <span class="verification-title">联系客服处理</span>
                <span class="verification-txt">可通过联系客服并提交相关信息，找回密码</span>
            </a>

        </form>
    </div>
</div>
<soul:import res="site/personInfo/ForgetPwd"/>


