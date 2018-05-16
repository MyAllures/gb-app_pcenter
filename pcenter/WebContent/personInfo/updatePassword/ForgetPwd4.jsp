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
                <div class="change-link step-btn">
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
                <div class="change-link step-btn active">
                    <span class="step-btn-num">4</span>
                    修改成功
                </div>
            </div>

            <h3 class="popalign"><i class="tipbig success"></i></h3>
            <div class="tip-text">
                <span class="tip-text-title">恭喜，操作成功</span>
                <span>亲爱的，您的安全密码已经设置成功，请牢记。</span>
            </div>
            <div class="change-btn">
                <a href="/pcenter/passport/logout.html" class="btn-blue btn large-big">马上登陆试试</a>
            </div>
        </form>
    </div>
</div>
<soul:import res="site/personInfo/ForgetPwd"/>


