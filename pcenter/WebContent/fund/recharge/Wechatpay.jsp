<%--@elvariable id="scan" type="java.util.Map<java.lang.String,so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="electronic" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.content.vo.PayAccountVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="notice">
    <div class="notice-left"><em class="path"></em></div>
    <div class="path-right">
        <a href="javascript:;">${views.sysResource['存款专区']}</a>
    </div>
</div>
<%--渠道选择--%>
<%@include file="Channel.jsp"%>

<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>选择支付方式：</h4>
        <span class="deposit-info-title">步骤1<img src="${resRoot}/images/online-pay1.png"></span>
        <div class="bank-deposit">
            <div class="bank-total">
                <c:set var="index" value="0"/>
                <c:forEach items="${scan}" var="i">
                    <c:set var="bankCode" value="${i.key}"/>
                    <c:set var="account" value="${i.value}"/>
                    <c:set var="name" value="${dicts.common.bankname[bankCode]}"/>
                    <c:set var="accountType" value="${account.accountType}"/>
                    <c:set var="authCode" value="${accountType eq '10' || accountType eq '11' || accountType eq '12'}"/>
                    <c:choose>
                        <c:when test="${accountType eq '10'}">
                            <c:set var="tutorialImg" value="wxzf-fs"/>
                            <c:set var="name" value="${dicts.content.account_type[accountType]}"/>
                        </c:when>
                        <c:when test="${accountType eq '12'}">
                            <c:set var="tutorialImg" value="qqqb-fs"/>
                            <c:set var="name" value="${dicts.content.account_type[accountType]}"/>
                        </c:when>
                        <c:when test="${accountType eq '11'}">
                            <c:set var="tutorialImg" value="zfb-fs"/>
                            <c:set var="name" value="${dicts.content.account_type[accountType]}"/>
                        </c:when>
                    </c:choose>
                    <c:set var="onlinePayMax" value="${account.singleDepositMax}"/>
                    <c:set var="onlinePayMin" value="${account.singleDepositMin}"/>
                    <c:set var="onlinePayMin" value="${empty onlinePayMin || onlinePayMin<=0?0.01:onlinePayMin}"/>
                    <c:set var="onlinePayMax" value="${empty onlinePayMax?99999999:onlinePayMax}"/>
                    <c:if test="${index==0}">
                        <c:set var="isAuthCode" value="${authCode}"/>
                        <c:set var="tutorial" value="${dicts.content.account_type[accountType]}教程"/>
                        <c:set var="firstTutorialImg" value="${tutorialImg}"/>
                    </c:if>
                    <label class="bank ${index == 0?'':'select'}">
                        <span class="radio"><input name="bankcode" placeholder="*范围:${soulFn:formatCurrency(onlinePayMin)} ~ ${soulFn:formatCurrency(onlinePayMax)}" payMin="${onlinePayMin}" payMax="${onlinePayMax}" type="radio" tutorialImg="${tutorialImg}" tutorial="${dicts.content.account_type[accountType]}教程" isAuthCode="${authCode}" randomAmount="${i.value.randomAmount}" checked="checked"  account="${command.getSearchId(account.id)}"></span>
                        <span class="radio-bank" title="${name}">
                            <i class="pay-third sm ${bankCode}"></i><font class="diy-pay-title">${name}</font>
                        </span>
                        <span class="bank-logo-name">${name}</span>
                    </label>
                    <c:set var="index" value="${index+1}"/>
                </c:forEach>
                <c:forEach items="${electronic}" var="account">
                    <label class="bank ${index == 0?'':'select'}">
                        <c:set var="name" value="${account.aliasName}"/>
                        <span class="radio"><input name="bankcode" type="radio" checked="checked"></span>
                        <span class="radio-bank" title="${name}">
                            <i class="pay-third sm ${account.bankCode}"></i>
                            <font class="diy-pay-title">${name}</font>
                        </span>
                        <span class="bank-logo-name">${name}</span>
                    </label>
                    <c:set var="index" value="${index+1}"/>
                </c:forEach>
            </div>
            <div class="clear"></div>
        </div>


    </div>
</div>
<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>请填写存款金额：</h4>
        <span class="deposit-info-title">步骤2<img src="images/online-pay2.png"></span>
        <form>
            <div class="control-group">
                <label class="control-label" for="inputEmail">存款帐号：</label>
                <div class="controls"> HASDFJASF192
                </div>
            </div>
            <div class="control-group">

                <label class="control-label" for="inputEmail">存款金额：</label>
                <div class="controls">
                    <input type="text" class="input" placeholder="">
                    <span class="right-decimals">.66</span>
                </div>
            </div>
            <div class="control-group">

                <label class="control-label" for="inputEmail">申请优惠：</label>
                <div class="controls">
                    <div><span class="radiotwo">
      <input name="bankcode" type="radio"></span><i class="item-title-ico goryorange">分类一</i> 满500送50，满1000送200…&nbsp;&nbsp;
                        <a href="#">收起其他优惠</a><i class="bank-arrico up"></i></div>
                    <div><span class="radiotwo">
  <input name="bankcode" type="radio"></span><i class="item-title-ico gorylightblue">分类一</i> 满500送50，满1000送200…
                        <a href="#"></a></div>
                </div>
            </div>


            <div class=" control-group">
                <label class="control-label"></label>
                <button type="button" class="btn-blue btn large-big">立即存款</button>
            </div>
            <div class="applysale">
                <ul class="transfer-tips">
                    <li>支付成功后，请等待几秒钟，提示[<span class="red">支付成功</span>]后按确认件后再关闭支付窗口。</li>
                    <li>如充值后未到账，请联系在线客服。<a href="#">点击联系在线客服</a></li>
                </ul>
            </div>

            <div>
            </div>

        </form>
    </div>
</div>


<div class="account-list account-info-warp">
    <div class="left-ico-message clearfix">
        <h4>请用微信支付存款至以下帐户：</h4>
        <span class="deposit-info-title">步骤2<img src="images/online-pay2.png"></span>
        <form>


            <div class="left-warp">
                <div class="bank-paidtotal">
                    <ul>
                        <li>
                            <div class="bankinfo bankinfo-m">
                                <h1><i class="pay-third wechatpay"></i></h1>
                                    <span class="orange paidnumber select"><em class="bank-number">125663@163.com</em><a
                                            href="javascript:void(0)" class="btn-copy">复制</a></span>
                                    <span class="paidname select"><em class="gray">姓名：</em><em class="gathering-name">欧高光</em><a
                                            href="javascript:void(0)" class="btn-copy">复制</a></span>
                            </div>
                        </li>
                    </ul>
                </div>


                <div class=" control-group">
                    <div class="m-l">
                        请先搜索微信号或者扫描二维码添加好友。特此声明，本公司并未启用微信公众号，为了您的资金安全，请勿关注微信公众号。温馨提示：本公司微信单笔最低存款限额为10元，10元以下的款项系统是无法添加的。
                    </div>
                    <a href="#" class="m-l">查看微信支付转帐演示？</a>
                </div>
            </div>

            <div>
            </div>

        </form>
        <div class="pull-left">
     <span class="two-dimension"><img src="images/two-dimension.png">
     <em><img src="images/two-dimension-ico.png" class="pull-left">微信扫一扫付款</em>
     </span>
            <span><img src="images/two-dimension123.png"></span>

        </div>
    </div>
</div>

<div class="account-list account-info-warp">
    <div class="left-ico-message">
        <h4>请填写存款金额：</h4>
        <span class="deposit-info-title">步骤3<img src="images/online-pay2.png"></span>
        <form>
            <div class="control-group">

                <label class="control-label" for="inputEmail">您的微信昵称：</label>
                <div class="controls">
                    <input type="text" class="input" placeholder="* 如：陈XX">
                </div>
            </div>
            <div class="control-group">

                <label class="control-label" for="inputEmail">存款金额：</label>
                <div class="controls">
                    <input type="text" class="input" placeholder="* 范围 100.00 ~ 10,000.00">
                </div>
            </div>
            <div class="control-group">

                <label class="control-label" for="inputEmail">申请优惠：</label>
                <div class="controls">
                    <div><span class="radiotwo">
      <input name="bankcode" type="radio"></span><i class="item-title-ico goryorange">分类一</i> 满500送50，满1000送200…&nbsp;&nbsp;
                        <a href="#">收起其他优惠</a><i class="bank-arrico up"></i></div>
                    <div><span class="radiotwo">
  <input name="bankcode" type="radio"></span><i class="item-title-ico gorylightblue">分类一</i> 满500送50，满1000送200…
                        <a href="#"></a></div>
                </div>
            </div>


            <div class=" control-group">
                <label class="control-label"></label>
                <button type="button" class="btn-blue btn large-big" data-toggle="modal"
                        data-target="#notice-list-1">立即存款
                </button>
            </div>
            <div class="applysale">
                <ul class="transfer-tips">
                    <li>支付成功后，请等待几秒钟，提示[<span class="red">支付成功</span>]后按确认件后再关闭支付窗口。</li>
                    <li>如充值后未到账，请联系在线客服。<a href="#">点击联系在线客服</a></li>
                </ul>
            </div>

            <div>
            </div>

        </form>
    </div>
</div>