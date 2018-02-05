<%--支付渠道---%>
<div class="deposit-info-warp  clearfix">
    <div class="titleline pull-left">
        <div class="btn-group table-desc-right-t-dropdown bank-down-menu" initprompt="10条" callback="query">
            <input type="hidden" name="" value="">
            <button type="button" class="btn btn btn-default" data-toggle="dropdown" aria-expanded="false">
                <i class="pay-third wechatpay"></i> <span class="carat"></span>
            </button>
            <ul class="dropdown-menu" role="menu" aria-labelledby="dropdownMenu1">
                <li role="presentation">
                    <a role="menuitem" tabindex="-1" href="online-pay1.html" key="10"><i
                            class="pay-third unionpay"></i></a>
                </li>
                <li role="presentation">
                    <a role="menuitem" tabindex="-1" href="javascript:void(0)" key="20"><i
                            class="pay-third ebankpay"></i></a>
                </li>
                <li role="presentation">
                    <a role="menuitem" tabindex="-1" href="javascript:void(0)" key="30"><i
                            class="pay-third wechatpay"></i></a>
                </li>
            </ul>
        </div>
    </div>
    <a href="/fund/playerRecharge/recharge.html" nav-Target="mainFrame" class="btn-gray btn btn-big pull-right">返回上一级</a>
</div>
