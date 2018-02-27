<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="modal-backdrop in" style="display: none" id="backdrop"></div>
<%--完成存款弹窗--%>
<div class="modal inmodal in" style="display: none" id="confirmDialog" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content animated bounceInRight family">
            <div class="modal-header">
                <span class="filter">完成存款，提交申请</span>
                <soul:button target="closeConfirmDialog" text="取消提交" opType="function" cssClass="close" tag="button">
                    <span aria-hidden="true">×</span>
                    <span class="sr-only">关闭</span>
                </soul:button>
            </div>
            <div class="modal-body">
                <div class="withdraw-not text-15p">
                    <div class="form-group clearfix line-hi45 m-b-xxs" name="bitcoinRecharge">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['比特币']}：</label>
                        <div class="col-xs-6 p-x  f-size26" id="bitAmount"></div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs" name="companyRecharge">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['存款金额']}：</label>
                        <div class="col-xs-6 p-x f-size26" id="confirmRechargeAmount"></div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs" name="companyRecharge">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['手续费/返手续费']}：</label>
                        <div class="col-xs-6 p-x">
                            <%--green--%>
                            <em class="red f-size26" id="confirmFee"></em>
                        </div>
                    </div>
                    <div class="form-group clearfix line-hi45 m-b-xxs" name="companyRecharge">
                        <label class="col-xs-5 al-right bold">${views.fund_auto['实际到账']}：</label>
                        <div class="col-xs-6 p-x">
                            <em class="red f-size26" id="confirmRechargeTotal"></em>
                        </div>
                    </div>
                </div>
                <div class="clearfix bg-gray p-t-xs al-center">
                    <div class="clearfix line-hi25 p-sm caution-pop">
                        <em><i class="mark plaintsmall"></i>${views.fund_auto['审核提醒']}</em>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button target="companyConfirmSubmit" precall="validateForm" text="${views.fund_auto['已存款确认提交']}" opType="function" cssClass="btn btn-filter" tag="button"/>
                <soul:button target="closeConfirmDialog" text="${views.fund_auto['取消提交']}" opType="function" cssClass="btn btn-outline btn-filter" tag="button"/>
            </div>
        </div>
    </div>
</div>
<%--失败弹窗--%>
<div class="modal inmodal in" style="display: none" id="failDialog" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content animated bounceInRight family">
            <div class="modal-header">
                <span class="filter">${views.fund['Deposit.deposit.depositFail']}</span>
                <soul:button target="closeConFailDialog" text="${views.fund_auto['取消提交']}" opType="function" cssClass="close" tag="button">
                    <span aria-hidden="true">×</span>
                    <span class="sr-only">关闭</span>
                </soul:button>
            </div>
            <div class="modal-body">
                <div class="theme-popcon">
                    <h3 class="popalign"><i class="tipbig fail"></i>${views.fund['Deposit.deposit.depositFail']}</h3>
                    <div class="text">
                        <p>${views.fund['Deposit.deposit.failureReason']}</p>
                        <p>${views.fund['Deposit.deposit.failOtherReason']}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button tag="button" target="back" text="${views.fund_auto['再存一次']}" opType="function" cssClass="btn btn-filter"/>
                <soul:button tag="button" target="customerService" text="${views.common['contactCustomerService']}" cssClass="btn btn-outline btn-filter" url="${customerService}" opType="function"/>
            </div>
        </div>
    </div>
</div>
<%--成功弹窗--%>
<div class="modal inmodal in" style="display: none" id="successDialog" tabindex="-1" role="dialog">
    <div class="modal-dialog">
        <div class="modal-content animated bounceInRight family">
            <div class="modal-header">
                <span class="filter">${views.fund['Deposit.deposit.submitSuccess']}</span>
                <soul:button target="back" text="" opType="function" cssClass="close" tag="button">
                    <span aria-hidden="true">×</span>
                    <span class="sr-only">关闭</span>
                </soul:button>
            </div>
            <div class="modal-body">
                <div class="theme-popcon">
                    <h3 class="popalign"><i class="tipbig fail"></i>${views.fund['Deposit.deposit.submitSuccess']}</h3>
                    <div class="text">
                        <p>${views.fund['Deposit.deposit.submitSuccessTips']}</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <soul:button tag="button" target="back" text="${views.fund_auto['再存一次']}" opType="function" cssClass="btn btn-filter"/>
                <soul:button tag="button" target="viewRecharge" text="${views.fund['Deposit.deposit.viewTrasaction']}" cssClass="btn btn-outline btn-filter" opType="function"/>
            </div>
        </div>
    </div>
</div>