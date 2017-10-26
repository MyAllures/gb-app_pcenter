package so.wwb.gamebox.pcenter.fund.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import org.soul.commons.collections.CollectionQueryTool;
import org.soul.commons.collections.CollectionTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.string.RandomStringTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.commons.net.ServletTool;
import org.soul.iservice.pay.IOnlinePayService;
import org.soul.model.comet.vo.MessageVo;
import org.soul.model.pay.enums.CommonFieldsConst;
import org.soul.model.pay.enums.PayApiTypeConst;
import org.soul.model.pay.vo.OnlinePayVo;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.Module;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.TerminalEnum;
import so.wwb.gamebox.model.common.Const;
import so.wwb.gamebox.model.common.MessageI18nConst;
import so.wwb.gamebox.model.common.notice.enums.CometSubscribeType;
import so.wwb.gamebox.model.company.enums.BankEnum;
import so.wwb.gamebox.model.company.po.Bank;
import so.wwb.gamebox.model.company.sys.po.VSysSiteDomain;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.content.vo.PayAccountVo;
import so.wwb.gamebox.model.master.dataRight.DataRightModuleType;
import so.wwb.gamebox.model.master.dataRight.vo.SysUserDataRightListVo;
import so.wwb.gamebox.model.master.enums.DepositWayEnum;
import so.wwb.gamebox.model.master.enums.PayAccountAccountType;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.fund.enums.RechargeStatusEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeParentEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerRecharge;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.model.master.operation.po.VActivityMessage;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.pcenter.fund.form.OnlinePayForm;
import so.wwb.gamebox.pcenter.fund.form.ScanCodeForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.token.Token;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.*;

/**
 * Created by cherry on 16-9-11.
 */
@Controller
@RequestMapping("/fund/recharge/online")
public class OnlineRechargeController extends RechargeBaseController {
    //线上支付页面
    private static final String ONLINE_PAY = "/fund/recharge/OnlinePay";
    //扫码支付
    private static final String SCAN_CODE = "/fund/recharge/ScanCode";
    //线上支付（含微信支付、支付宝支付）等待支付页面
    private static final String ONLINE_PENDING_PAY = "/fund/recharge/OnlinePendingPay";
    //线上支付（含微信支付、支付宝支付）存款失败页面
    private static final String ONLINE_FAIL = "/fund/recharge/OnlineFail";
    //线上支付（含微信支付、支付宝支付）存款成功页面
    private static final String ONLINE_SUCCESS = "/fund/recharge/OnlineSuccess";
    //线上支付（含微信支付、支付宝支付）存款超时页面
    private static final String ONLINE_OVERTIME = "/fund/recharge/OnlineOvertime";
    /*站长中心-线上支付链接*/
    private static final String MCENTER_ONLINE_RECHARGE_URL = "fund/deposit/online/list.html";
    private static Log LOG = LogFactory.getLog(OnlineRechargeController.class);

    /**
     * 线上支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/onlinePay")
    @Token(generate = true)
    public String onlinePay(Model model, String realNameDialog) {
        //可用银行
        List<Bank> banks = searchBank(BankEnum.TYPE_BANK.getCode());
        //层级
        PlayerRank rank = getRank();
        //玩家可用收款账号
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.ONLINE_ACCOUNT.getCode(), PayAccountAccountType.THIRTY.getCode(), TerminalEnum.PC.getCode());
        model.addAttribute("payAccountMap", getOnlinePayAccountMap(rank, banks, payAccounts));
        model.addAttribute("username", SessionManager.getUserName());
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("sales", searchSales(DepositWayEnum.ONLINE_DEPOSIT.getCode()));
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(OnlinePayForm.class));
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("realNameDialog", realNameDialog);
        model.addAttribute("rank", rank);
        return ONLINE_PAY;
    }

    /**
     * 扫码支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/scanCode")
    @Token(generate = true)
    public String scanCode(Model model, String realNameDialog) {
        PlayerRank rank = getRank();
        //微信支付收款账号
        PayAccount weChatPayAccount = getWeChatAlipay(rank, PayAccountAccountType.WECHAT.getCode());
        //支付宝收款账号
        PayAccount alipayPayAccount = getWeChatAlipay(rank, PayAccountAccountType.ALIPAY.getCode());
        //QQ钱包收款账号
        PayAccount qqWalletPayAccount = getWeChatAlipay(rank, PayAccountAccountType.QQWALLET.getCode());
        Map<String, PayAccount> payAccountMap = new HashMap<>(3, 1f);
        if (weChatPayAccount != null) {
            payAccountMap.put(WECHATPAY, weChatPayAccount);
        }
        if (alipayPayAccount != null) {
            payAccountMap.put(ALIPAY, alipayPayAccount);
        }
        if (qqWalletPayAccount != null) {
            payAccountMap.put(QQWALLET, qqWalletPayAccount);
        }
        model.addAttribute("payAccountMap", payAccountMap);
        model.addAttribute("currency", getCurrencySign());
        //优惠存款方式
        if (alipayPayAccount != null || weChatPayAccount != null || qqWalletPayAccount != null) {
            String type = DepositWayEnum.WECHATPAY_SCAN.getCode();
            if (weChatPayAccount == null) {
                if (alipayPayAccount != null) {
                    type = DepositWayEnum.ALIPAY_SCAN.getCode();
                } else {
                    type = DepositWayEnum.QQWALLET_SCAN.getCode();
                }
            }
            model.addAttribute("sales", searchSales(type));
        }
        model.addAttribute("username", SessionManager.getUserName());
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(ScanCodeForm.class));
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("realNameDialog", realNameDialog);
        model.addAttribute("rank", rank);
        return SCAN_CODE;
    }

    /**
     * 更改扫码支付方式,相应的优惠要变更
     *
     * @param amount
     * @param rechargeType
     * @return
     */
    @RequestMapping("/changeScanType")
    @ResponseBody
    public List<VActivityMessage> changeScanType(Double amount, String rechargeType) {
        List<VActivityMessage> vActivityMessages;
        if (amount == null) {
            vActivityMessages = searchSales(rechargeType);
        } else {
            vActivityMessages = searchSaleByAmount(amount, rechargeType);
        }
        return vActivityMessages;
    }

    /**
     * 远程验证线上支付存款金额是否超出
     *
     * @param rechargeAmount amount
     * @param payerBank      payerBank
     * @return boolean
     */
    @RequestMapping("/checkOnlineRechargeAmount")
    @ResponseBody
    public boolean checkOnlineRechargeAmount(@RequestParam("result.rechargeAmount") String rechargeAmount, @RequestParam("result.payerBank") String payerBank) {
        PlayerRank rank = getRank();
        PayAccount payAccount = getOnlinePayAccount(rank, payerBank);//确认收款账号
        return amountIsCorrect(payAccount, rank, rechargeAmount);
    }

    /**
     * 远程验证支付宝支付存款金额是否超出
     */
    @RequestMapping("/checkScanCodeAmount")
    @ResponseBody
    public boolean checkScanCodeAmount(@RequestParam("result.rechargeAmount") String rechargeAmount, @RequestParam("result.rechargeType") String rechargeType) {
        PlayerRank rank = getRank();
        PayAccount payAccount = getScanCodePayAccount(rank, rechargeType);
        return amountIsCorrect(payAccount, rank, rechargeAmount);
    }

    @RequestMapping("/onlineSubmit")
    @Token(valid = true)
    @ResponseBody
    public Map<String, Object> onlineSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid OnlinePayForm form, BindingResult result) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            return getResultMsg(false, null, null);
        }

        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        PlayerRank rank = getRank();
        PayAccount payAccount = getOnlinePayAccount(rank, playerRecharge.getPayerBank());
        boolean randomAmount = payAccount.getRandomAmount();
        if (randomAmount){
            Double rechargeAmount = playerRecharge.getRechargeAmount();
            if (rechargeAmount.intValue() == rechargeAmount){
                double random = Double.parseDouble(RandomStringTool.random(2,11,99,false,true))*0.01;
                rechargeAmount+= random;
                playerRecharge.setRechargeAmount(rechargeAmount);
            }
        }
        playerRecharge.setRechargeType(RechargeTypeEnum.ONLINE_DEPOSIT.getCode());
        return commonSubmit(playerRechargeVo, payAccount);
    }

    private Map<String, Object> getResultMsg(boolean isSuccess, String msg, String transactionNo) {
        Map<String, Object> map = new HashMap<>(3, 1f);
        map.put("state", isSuccess);
        if (isSuccess) {
            map.put("transactionNo", transactionNo);
        } else if (StringTool.isNotBlank(msg)) {
            map.put("msg", msg);
        }
        return map;
    }

    @RequestMapping("/scanCodeSubmit")
    @ResponseBody
    @Token(valid = true)
    public Map<String, Object> ScanCodeSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid ScanCodeForm form, BindingResult result) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            return getResultMsg(false, null, null);
        }

        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        PlayerRank rank = getRank();
        PayAccount payAccount = getScanCodePayAccount(rank, playerRecharge.getRechargeType());
        boolean randomAmount = payAccount.getRandomAmount();
        if (randomAmount){
            Double rechargeAmount = playerRecharge.getRechargeAmount();
            if (rechargeAmount.intValue() == rechargeAmount){
                double random = Double.parseDouble(RandomStringTool.random(2,11,99,false,true))*0.01;
                rechargeAmount+= random;
                playerRecharge.setRechargeAmount(rechargeAmount);
            }
        }
        return commonSubmit(playerRechargeVo, payAccount);
    }

    /**
     * 调用第三方接口
     *
     * @param playerRechargeVo
     * @param response
     * @param request
     */
    @RequestMapping("/pay")
    public void callOnline(PlayerRechargeVo playerRechargeVo, HttpServletResponse response, HttpServletRequest request) {
        if (StringTool.isBlank(playerRechargeVo.getSearch().getTransactionNo())) {
            return;
        }
        try {
            playerRechargeVo = playerRechargeService().searchPlayerRecharge(playerRechargeVo);
            PlayerRecharge playerRecharge = playerRechargeVo.getResult();
            PayAccount payAccount = getPayAccount(playerRecharge.getPayAccountId());
            List<Map<String, String>> accountJson = JsonTool.fromJson(payAccount.getChannelJson(), new TypeReference<ArrayList<Map<String, String>>>() {
            });

            String domain = ServletTool.getDomainPath(request);
            for (Map<String, String> map : accountJson) {
                if (map.get("column").equals(CommonFieldsConst.PAYDOMAIN)) {
                    domain = map.get("value");
                    break;
                }
            }

            if (domain != null && (RechargeStatusEnum.PENDING_PAY.getCode().equals(playerRecharge.getRechargeStatus())
                    || RechargeStatusEnum.OVER_TIME.getCode().equals(playerRecharge.getRechargeStatus()))) {
                String uri = "/onlinePay/abcefg.html?search.transactionNo=" + playerRecharge.getTransactionNo() + "&origin=" + TerminalEnum.PC.getCode();
                domain = getDomain(domain, payAccount);
                String url = domain + uri;
                //添加支付网址
                playerRecharge.setPayUrl(domain);
                playerRechargeVo.setProperties(PlayerRecharge.PROP_PAY_URL);
                ServiceTool.playerRechargeService().updateOnly(playerRechargeVo);
                response.sendRedirect(url);
            }
        } catch (Exception e) {
            LOG.error(e);
        }
    }

    public String getDomain(String domain, PayAccount payAccount) {
        domain = domain.replace("http://", "");
        VSysSiteDomain siteDomain = Cache.getSiteDomain().get(domain);
        Boolean sslEnabled = false;
        if (siteDomain != null && siteDomain.getSslEnabled() != null && siteDomain.getSslEnabled()) {
            sslEnabled = true;
        }
        String sslDomain = "https://" + domain;
        String notSslDomain = "http://" + domain;
        ;
        if (!sslEnabled) {
            return notSslDomain;
        }
        try {
            OnlinePayVo onlinePayVo = new OnlinePayVo();
            onlinePayVo.setChannelCode(payAccount.getBankCode());
            onlinePayVo.setApiType(PayApiTypeConst.PAY_SSL_ENABLE);
            sslEnabled = ServiceTool.onlinePayService().getSslEnabled(onlinePayVo);
            LOG.info("支付{0}是否支持ssl:{1}", payAccount.getBankCode(), sslEnabled);
        } catch (Exception e) {
            LOG.error(e);
        }
        if (sslEnabled) {
            return sslDomain;
        }
        return notSslDomain;
    }

    @RequestMapping("/onlinePending")
    public String onlinePending(Model model, Boolean state, String msg) {
        model.addAttribute("customerService", getCustomerService());
        if (StringTool.isNotBlank(msg)) {
            model.addAttribute("msg", msg);
        }
        if (state != null && !state) {
            return ONLINE_FAIL;
        }
        return ONLINE_PENDING_PAY;
    }

    /**
     * 线上支付（含微信、支付宝）超时
     *
     * @param model
     * @param playerRechargeVo
     * @return
     */
    @RequestMapping("/onlineOverTime")
    public String onlineOverTime(Model model, PlayerRechargeVo playerRechargeVo) {
        playerRechargeVo.setIp(SessionManager.getIpDb().getIp());
        playerRechargeVo.setOperatorName(SessionManager.getUserName());
        playerRechargeVo = playerRechargeService().handleOnlineRechargeResult(playerRechargeVo, null);
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        if (playerRecharge == null || RechargeStatusEnum.OVER_TIME.getCode().equals(playerRecharge.getRechargeStatus()) || RechargeStatusEnum.PENDING_PAY.getCode().equals(playerRecharge.getRechargeStatus())) {
            model.addAttribute("customerService", getCustomerService());
            return ONLINE_OVERTIME;
        }
        if (RechargeStatusEnum.ONLINE_SUCCESS.getCode().equals(playerRecharge.getRechargeStatus())) {
            return onlineSuccessPage(model, playerRecharge);
        }
        if (RechargeStatusEnum.ONLINE_FAIL.getCode().equals(playerRecharge.getRechargeStatus())) {
            return onlineFailPage(model, playerRecharge);
        }
        model.addAttribute("customerService", getCustomerService());
        return ONLINE_OVERTIME;
    }

    /**
     * 返回线上成功页面
     */
    private String onlineSuccessPage(Model model, PlayerRecharge recharge) {
        model.addAttribute("rechargeTotal", recharge.getRechargeAmount());
        model.addAttribute("userPlayer", getUserPlayer());
        model.addAttribute("currency", getCurrencySign());
        return ONLINE_SUCCESS;
    }

    /**
     * 返回线上失败页面
     *
     * @param model
     * @param playerRecharge
     * @return
     */
    private String onlineFailPage(Model model, PlayerRecharge playerRecharge) {
        model.addAttribute("customerService", getCustomerService());
        model.addAttribute("msg", playerRecharge.getCheckRemark());
        model.addAttribute("checkResult", playerRecharge.getFailureTitle());
        return ONLINE_FAIL;
    }

    /**
     * 线上支付（含扫码支付）提交公共方法
     *
     * @param playerRechargeVo
     * @param payAccount
     * @return
     */
    private Map<String, Object> commonSubmit(PlayerRechargeVo playerRechargeVo, PayAccount payAccount) {
        if (payAccount == null) {
            return getResultMsg(false, LocaleTool.tranMessage(Module.FUND.getCode(), MessageI18nConst.RECHARGE_PAY_ACCOUNT_LOST), null);
        }
        playerRechargeVo = saveRecharge(playerRechargeVo, payAccount, RechargeTypeParentEnum.ONLINE_DEPOSIT.getCode(), playerRechargeVo.getResult().getRechargeType());
        if (playerRechargeVo.isSuccess()) {
            //声音提醒站长中心
            onlineToneWarn();
            //设置session相关存款数据
            setRechargeCount();
            return getResultMsg(true, null, playerRechargeVo.getResult().getTransactionNo());
        } else {
            return getResultMsg(false, playerRechargeVo.getErrMsg(), null);
        }
    }

    /**
     * 在线支付提醒站长后台
     */
    private void onlineToneWarn() {
        MessageVo message = new MessageVo();
        message.setSubscribeType(CometSubscribeType.MCENTER_ONLINE_RECHARGE_REMINDER.getCode());
        message.setSendToUser(true);
        message.setCcenterId(SessionManager.getSiteParentId());
        message.setSiteId(SessionManager.getSiteId());
        message.setMasterId(SessionManager.getSiteUserId());
        message.setMsgBody(SiteParamEnum.WARMING_TONE_ONLINEPAY.getType());

        SysUserDataRightListVo sysUserDataRightListVo = new SysUserDataRightListVo();
        sysUserDataRightListVo.getSearch().setUserId(SessionManager.getUserId());
        sysUserDataRightListVo.getSearch().setModuleType(DataRightModuleType.ONLINEDEPOSIT.getCode());
        List<Integer> userIdByUrl = ServiceTool.sysUserDataRightService().searchPlayerDataRightEntityId(sysUserDataRightListVo);
        userIdByUrl.add(Const.MASTER_BUILT_IN_ID);
        message.addUserIds(userIdByUrl);
        ServiceTool.messageService().sendToMcenterMsg(message);
    }

    /**
     * 获取线上支付收款账号
     *
     * @param rank
     * @param bankCode
     * @return
     */
    private PayAccount getOnlinePayAccount(PlayerRank rank, String bankCode) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.ONLINE_ACCOUNT.getCode(), PayAccountAccountType.THIRTY.getCode(), TerminalEnum.PC.getCode());
        IOnlinePayService payService = ServiceTool.onlinePayService();
        //获取可用渠道货币
        Map<String, Set<String>> channelBankCode = null;
        Map<String, Set<String>> channelCurrency = null;
        try {
            channelBankCode = payService.getSupportDirectBank(new OnlinePayVo());
            channelCurrency = payService.getSupportCurrency(new OnlinePayVo());
        } catch (Exception e) {
            LOG.error(e);
        }

        if (channelBankCode == null || channelCurrency == null) {
            LOG.error("channelBankCode或者channelCurrency为空");
            return null;
        }
        Set<String> currencyChannels = channelCurrency.get(SessionManager.getUser().getDefaultCurrency());
        if (CollectionTool.isEmpty(currencyChannels)) {
            LOG.error("currencyChannels为空");
            return null;
        }
        Set<String> bankChannels = channelBankCode.get(bankCode);
        if (CollectionTool.isEmpty(bankChannels)) {
            LOG.error("bankChannels为空");
            return null;
        }
        List<String> channels = (List<String>) CollectionTool.intersection(currencyChannels, bankChannels);
        payAccounts = CollectionQueryTool.inQuery(payAccounts, PayAccount.PROP_BANK_CODE, channels);
        return getPayAccountBySort(rank, payAccounts);
    }

    /**
     * 获取扫描支付收款账号
     *
     * @param rank
     * @param rechargeType
     * @return
     */
    private PayAccount getScanCodePayAccount(PlayerRank rank, String rechargeType) {
        PayAccount payAccount = null;
        if (RechargeTypeEnum.ALIPAY_SCAN.getCode().equals(rechargeType)) {
            payAccount = getWeChatAlipay(rank, PayAccountAccountType.ALIPAY.getCode());
        } else if (RechargeTypeEnum.WECHATPAY_SCAN.getCode().equals(rechargeType)) {
            payAccount = getWeChatAlipay(rank, PayAccountAccountType.WECHAT.getCode());
        } else if (RechargeTypeEnum.QQWALLET_SCAN.getCode().equals(rechargeType)) {
            payAccount = getWeChatAlipay(rank, PayAccountAccountType.QQWALLET.getCode());
        }
        return payAccount;
    }

    /**
     * 获取线上支付的收款账号map
     *
     * @param rank
     * @param banks
     * @param payAccounts
     * @return
     */
    private Map<String, PayAccount> getOnlinePayAccountMap(PlayerRank rank, List<Bank> banks, List<PayAccount> payAccounts) {
        if (CollectionTool.isEmpty(payAccounts)) {
            return null;
        }
        IOnlinePayService payService = ServiceTool.onlinePayService();
        //获取可用渠道货币
        Map<String, Set<String>> channelBankCode = null;
        Map<String, Set<String>> channelCurrency = null;
        try {
            channelBankCode = payService.getSupportDirectBank(new OnlinePayVo());
            channelCurrency = payService.getSupportCurrency(new OnlinePayVo());
        } catch (Throwable e) {
            LOG.error(e);
        }

        if (channelBankCode == null || channelCurrency == null) {
            return null;
        }
        Set<String> currencyChannels = channelCurrency.get(SessionManager.getUser().getDefaultCurrency());
        if (CollectionTool.isEmpty(currencyChannels)) {
            return null;
        }
        Map<String, PayAccount> payAccountMap = new LinkedHashMap<>();
        PayAccount payAccount;
        Set<String> bankChannels;
        List<String> channels;
        List<PayAccount> accounts;
        for (Bank bank : banks) {
            bankChannels = channelBankCode.get(bank.getBankName());
            if (CollectionTool.isEmpty(bankChannels)) {
                continue;
            }
            channels = (List<String>) CollectionTool.intersection(currencyChannels, bankChannels);
            if (CollectionTool.isEmpty(channels)) {
                continue;
            }
            accounts = CollectionQueryTool.inQuery(payAccounts, PayAccount.PROP_BANK_CODE, channels);
            payAccount = getPayAccountBySort(rank, accounts);
            if (payAccount != null) {
                payAccountMap.put(bank.getBankName(), payAccount);
            }
        }
        return payAccountMap;
    }

    /**
     * 根据轮流入款获取指定收款账号
     *
     * @param rank
     * @param accounts
     * @return
     */
    private PayAccount getPayAccountBySort(PlayerRank rank, List<PayAccount> accounts) {
        if (CollectionTool.isNotEmpty(accounts)) {
            //轮流打开，根据最后一条线上支付存款记录确认收款账号
            if (rank.getIsTakeTurns() == null || rank.getIsTakeTurns()) {
                Integer payAccountId = playerRechargeService().searchLastPayAccountId(new PlayerRechargeVo());
                if (payAccountId == null) {
                    return accounts.get(0);
                } else {
                    int i = 0;
                    for (PayAccount payAccount : accounts) {
                        i++;
                        if (payAccountId.intValue() == payAccount.getId().intValue()) {
                            break;
                        }
                    }
                    return i == accounts.size() ? accounts.get(0) : accounts.get(i);
                }
            } else { //轮流关闭，取第一个收款账号
                return accounts.get(0);
            }
        }
        return null;
    }

    /**
     * 查询微信支付、支付宝收款账号
     *
     * @param rank
     * @param accountType
     * @return
     */
    private PayAccount getWeChatAlipay(PlayerRank rank, String accountType) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.ONLINE_ACCOUNT.getCode(), accountType, TerminalEnum.PC.getCode());
        return getPayAccountBySort(rank, payAccounts);
    }

    /**
     * 判断存款金额是否合法
     *
     * @param payAccount
     * @param rank
     * @param rechargeAmount
     * @return
     */
    private boolean amountIsCorrect(PayAccount payAccount, PlayerRank rank, String rechargeAmount) {
        if (payAccount == null) {
            return false;
        }
        double amount = NumberTool.toDouble(rechargeAmount);
        Integer max = payAccount.getSingleDepositMax();
        Integer min = payAccount.getSingleDepositMin();
        if ((max != null && max < amount) || (min != null && min > amount)) {
            return false;
        }
        double fee = calculateFee(rank, amount);
        return (amount + fee) > 0;
    }

}
