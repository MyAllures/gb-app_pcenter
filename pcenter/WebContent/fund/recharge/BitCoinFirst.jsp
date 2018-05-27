<%--@elvariable id="payAccountList" type="java.util.List<so.wwb.gamebox.model.master.content.po.PayAccount>"--%>
<%--@elvariable id="rank" type="so.wwb.gamebox.model.master.player.po.PlayerRank"--%>
<%--@elvariable id="command" type="so.wwb.gamebox.model.master.content.vo.PayAccountVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--电子支付平台-->
<form>
    <input type="hidden" name="isRealName" value="${isRealName}"/>
    <gb:token/>
    <a href="javascript:;" name="realNameDialog" style="display: none"></a>
    <div id="validateRule" style="display: none">${validateRule}</div>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <%@include file="Channel.jsp"%>
    <c:if test="${fn:length(payAccountList)<=0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h2 class="m-bigl m-t-sm">${views.fund_auto['暂无收款账户，请选择其他存款方式！']}</h2>
                <span class="deposit-info-title info-top-no"><img src="${resRoot}/images/online-pay4.png"></span>
            </div>
        </div>
    </c:if>
    <c:if test="${fn:length(payAccountList)>0}">
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['选择存款方式']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤1']}<img src="${resRoot}/images/online-pay1.png"></span>
                <div class="bank-deposit">
                    <div class="bank-total">
                        <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                            <label class="bank ${vs.index==0?'select':''}">
                                <span class="radio"><input name="account" showSuccMsg="false" value="${command.getSearchId(i.id)}" account="${i.account}" type="radio" ${vs.index==0?'checked':''}></span>
                                <span class="radio-bank" title="${dicts.common.bankname[i.bankCode]}"><i class="pay-third ${i.bankCode}"></i></span>
                                <span class="bank-logo-name">${dicts.common.bankname[i.bankCode]}</span>
                            </label>
                        </c:forEach>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
        <div class="account-list account-info-warp">
            <c:forEach items="${payAccountList}" varStatus="vs" var="i">
                <div class="left-ico-message clearfix accountMap" id="payAccount${i.account}" style="${vs.index==0?'':'display:none'}">
                    <h4>${fn:replace(views.fund_auto['请存款至以下账户'], "{0}",dicts.common.bankname[i.bankCode])}：</h4>
                    <span class="deposit-info-title">${views.fund_auto['步骤2']}<img src="${resRoot}/images/online-pay2.png"></span>
                    <div class="left-warp">
                        <div class="bank-paidtotal">
                            <ul>
                                <li>
                                    <div class="bankinfo bankinfo-m">
                                        <c:set var="flag" value="${empty i.customBankName||dicts.common.bankname[i.bankCode]==i.customBankName}"/>
                                        <h1><i class="${flag?'pay-third ':''} ${flag?i.bankCode:''}" style="font-size: small;">${flag?'':i.customBankName}</i></h1>
                                        <c:choose>
                                            <c:when test="${isHide}">
                                               <span class="orange select">
                                                    <i class="orange fontsbig">${views.fund_auto['账号代码']}：${i.code}</i>
                                                    <i class="m-bigl">
                                                        <soul:button target="customerService" text="${(empty hideContent.value) ? views.fund_auto['联系客服获取账号'] : hideContent.value}" url="${customerService}" opType="function"/>
                                                    </i>
                                               </span>
                                            </c:when>
                                            <c:otherwise>
                                              <span class="orange paidname select" data-clipboard-text="${i.account}" name="copy">
                                                <em class="bank-number" id="bankCard${i.id}">${i.account}</em>
                                                <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                            </span>
                                            </c:otherwise>
                                        </c:choose>
                                        <span class="paidname select" data-clipboard-text="${i.fullName}" name="copy">
                                            <em class="gray">${views.fund_auto['姓名']}：</em>
                                            <em class="gathering-name" id="fullName${i.id}">${i.fullName}</em>
                                           <a href="javascript:;" class="btn-copy">${views.common['copy']}</a>
                                        </span>
                                    </div>
                                </li>
                            </ul>
                        </div>
                        <c:if test="${!empty i.remark}">
                            <div>
                                <p style="margin: 15px 23px">${i.remark}</p>
                            </div>
                        </c:if>
                        <div class=" control-group">
                            <c:if test="${!empty banks[i.bankCode].website}">
                                <a href="${banks[i.bankCode].website}" target="_blank" type="button" class="btn btn-outline btn-filter m-l">${fn:replace(views.fund_auto['去转账'],"{0}", dicts.common.bankname[i.bankCode])}</a>
                            </c:if>
                            <c:if test="${!vs.last}">
                                <a href="javascript:;" data-href="/commonPage/help.html?pageNumber=1&pagingKey=hpdc&dataChildren=62" class="m-l openPage">${fn:replace(views.fund_auto['是否查看转账演示'],"{0}", dicts.common.bankname[i.bankCode])}</a>
                            </c:if>
                        </div>
                    </div>
                    <c:if test="${! empty i.qrCodeUrl}">
                        <div class="pull-left">
                        <span class="two-dimension">
                            <img src="${soulFn:getThumbPath(domain,i.qrCodeUrl,176,176)}" style="width: 176px;height: 176px;"/>
                            <em><img src="${resRoot}/images/two-dimension-ico.png" class="pull-left">${dicts.common.bankname[i.bankCode]}${views.fund_auto['扫一扫付款']}</em>
                        </span>
                            <span><img src="${resRoot}/images/two-dimension123.png"></span>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </div>
        <div class="account-list account-info-warp">
            <div class="left-ico-message">
                <h4>${views.fund_auto['请填写回执信息']}：</h4>
                <span class="deposit-info-title">${views.fund_auto['步骤3']}<img src="${resRoot}/images/online-pay2.png"></span>
                <div class="control-group">
                    <label class="control-label" for="result.bitAmount">${views.fund_auto['比特币']}：</label>
                    <div class="controls">
                        <input type="text" class="input" id="result.bitAmount" name="result.bitAmount" autocomplete="off">
                        <span class="fee"></span>
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="result.payerBankcard">${views.fund_auto['您的比特币地址']}：</label>
                    <div class="controls">
                        <input type="text" class="input" style="width:60%" id="result.payerBankcard" name="result.payerBankcard" autocomplete="off">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label" for="result.bankOrder">txId：</label>
                    <div class="controls">
                        <input type="text" class="input" style="width:60%" id="result.bankOrder" name="result.bankOrder" autocomplete="off">
                    </div>
                </div>
                <div class="control-group">
                    <label class="control-label">${views.fund_auto['交易时间']}：</label>
                    <div class="controls">
                        <gb:dateRange name="result.returnTime" style="width:70%" format="${DateFormat.DAY_SECOND}"/>
                    </div>
                </div>
                <%@include file="sale.jsp" %>
                <%@include file="CaptchaCode.jsp" %>
                <div class=" control-group">
                    <label class="control-label"></label>
                    <soul:button target="submit" precall="validateForm" text="${views.fund_auto['提交申请']}" opType="function" cssClass="btn-blue btn large-big _submit"/>
                </div>
                <div class="applysale">
                    <ul class="transfer-tips \AMG">
                        <li>温馨提示：</li>
                        <li>为了方便系统快速完成转账，请输入正确的<span style="color:red">txId</span>、<span style="color:red">交易时间</span>，以加快系统入款速度。</li>
                        <li>如出现充值失败或充值后未到账等情况，请联系在线客服获取帮助。
                            <soul:button target="customerService" text="点击联系在线客服" url="${customerService}" opType="function"/>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <%@include file="CompanyRechargeDialog.jsp"%>
    </c:if>
</form>

<script type="text/javascript">
    curl(['site/fund/recharge/BitCoinFirst'], function(Page) {
        page = new Page();
        page.bindButtonEvents();
    });
</script>

