<%--@elvariable id="userDigiccyList" type="java.util.List<so.wwb.gamebox.model.master.digiccy.po.UserDigiccy>"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form>
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <!--扫码支付-->
    <div class="deposit-info-warp  clearfix">
        <div class="titleline pull-left"><h2>数字货币存款</h2></div>
        <a href="/fund/playerRecharge/recharge.html" class="btn-gray btn btn-big pull-right" nav-Target="mainFrame">${views.fund_auto['返回上一级']}</a>
    </div>
    <c:forEach items="${userDigiccyList}" var="i">
        <div class="account-list account-info-warp">
            <div class="sc-left-warp"><img src="${resRoot}/images/scqk-btb.png"></div>
            <div class="sc-right-warp">
                <div class="st-r-tit">
                    <span class="s-title">比特币</span>
                  <span class="s-yue">
                       <em>余额:</em>
                       <i class="orange">999,999,999,999.00</i>
                       <i class="ico-ask refresh"></i>
                       <button type="button" class="btn btn-filter btn-outline btn-lg">兑换金额</button>
                  </span>
                </div>
                <div class="st-r-gn">
                    <div class="sao-ewm">
                        <span class="title">二维码</span>
                        <span class="ewm-img"><img src="${resRoot}/images/ewm.png"></span>
                    </div>
                    <div class="lzdz">
                        <span class="title">数字货币的地址 <button type="button" class="btn btn-filter btn-xs">复制</button></span>
                        <textarea class="textarea" placeholder="">http://www.baidu.com?/=bl5rx </textarea>
                    </div>
                </div>
            </div>
        </div>
    </c:forEach>
</form>