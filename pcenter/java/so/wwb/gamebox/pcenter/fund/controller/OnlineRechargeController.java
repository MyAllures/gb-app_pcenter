package so.wwb.gamebox.pcenter.fund.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.commons.net.ServletTool;
import org.soul.commons.security.CryptoTool;
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
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.model.CacheBase;
import so.wwb.gamebox.model.TerminalEnum;
import so.wwb.gamebox.model.company.enums.BankEnum;
import so.wwb.gamebox.model.company.po.Bank;
import so.wwb.gamebox.model.company.sys.po.VSysSiteDomain;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.content.vo.PayAccountListVo;
import so.wwb.gamebox.model.master.content.vo.PayAccountVo;
import so.wwb.gamebox.model.master.enums.DepositWayEnum;
import so.wwb.gamebox.model.master.enums.PayAccountAccountType;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.fund.enums.RechargeStatusEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerRecharge;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.model.master.operation.po.VActivityMessage;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.pcenter.fund.form.OnlinePayForm;
import so.wwb.gamebox.pcenter.fund.form.ScanCodeForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.token.Token;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

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
    //易收付支付页面
    private static final String YSF_PAY = "/fund/recharge/Ysfpay";
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
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.ONLINE_ACCOUNT.getCode(), PayAccountAccountType.THIRTY.getCode(), TerminalEnum.PC.getCode(), null, null);
        deleteMaintainChannel(payAccounts);
        PayAccountListVo payAccountListVo = new PayAccountListVo();
        payAccountListVo.setResult(payAccounts);
        payAccountListVo.setPlayerRank(rank);
        payAccountListVo.setCurrency(SessionManager.getUser().getDefaultCurrency());
        payAccountListVo.setBanks(banks);
        model.addAttribute("payAccountMap", ServiceSiteTool.payAccountService().getOnlineAccount(payAccountListVo));
        model.addAttribute("username", SessionManager.getUserName());
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("sales", searchSales(DepositWayEnum.ONLINE_DEPOSIT.getCode()));
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(OnlinePayForm.class));
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("realNameDialog", realNameDialog);
        model.addAttribute("rank", rank);
        model.addAttribute("command", payAccountListVo);
        model.addAttribute("bankCode", "onlinepay");
        model.addAttribute("customerService", getCustomerService());
        Double rechargeDecimals = Math.random() * 99 + 1;
        model.addAttribute("rechargeDecimals", rechargeDecimals.intValue());
        return ONLINE_PAY;
    }

    /**
     * 去除维护中收款账户
     *
     * @param payAccounts
     */
    private void deleteMaintainChannel(List<PayAccount> payAccounts) {
        Map<String, Bank> bankMap = CacheBase.getBank();
        Bank bank;
        Iterator<PayAccount> accountIterator = payAccounts.iterator();
        while (accountIterator.hasNext()) {
            PayAccount payAccount = accountIterator.next();
            bank = bankMap.get(payAccount.getBankCode());
            if (bank == null || (bank.getIsUse() != null && !bank.getIsUse())) {
                accountIterator.remove();
            }
        }
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
        String[] accountTypes = new String[]{PayAccountAccountType.WECHAT.getCode(), PayAccountAccountType.ALIPAY.getCode(), PayAccountAccountType.QQWALLET.getCode(), PayAccountAccountType.JD_PAY.getCode(), PayAccountAccountType.BAIFU_PAY.getCode(), PayAccountAccountType.UNION_PAY.getCode(), PayAccountAccountType.WECHAT_MICROPAY.getCode(), PayAccountAccountType.QQ_MICROPAY.getCode(), PayAccountAccountType.ALIPAY_MICROPAY.getCode()};
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.ONLINE_ACCOUNT.getCode(), null, TerminalEnum.PC.getCode(), null, accountTypes);
        PayAccountListVo payAccountListVo = new PayAccountListVo();
        payAccountListVo.setResult(payAccounts);
        payAccountListVo.setPlayerRank(rank);
        payAccountListVo.setCurrency(SessionManager.getUser().getDefaultCurrency());
        model.addAttribute("payAccountMap", ServiceSiteTool.payAccountService().getScanAccount(payAccountListVo));
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("username", SessionManager.getUserName());
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(ScanCodeForm.class));
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("realNameDialog", realNameDialog);
        model.addAttribute("rank", rank);
        model.addAttribute("command", payAccountListVo);
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
     * 远程验证金额是否超出
     *
     * @param rechargeAmount
     * @param account
     * @return
     */
    @RequestMapping("/checkRechargeAmount")
    @ResponseBody
    public boolean checkRechargeAmount(@RequestParam("result.rechargeAmount") String rechargeAmount, @RequestParam("account") String account) {
        if (StringTool.isBlank(account)) {
            return false;
        }
        PlayerRank rank = getRank();
        Integer payAccountId = NumberTool.toInt(CryptoTool.aesDecrypt(account, "BaseVo"));
        PayAccount payAccount = getPayAccount(payAccountId);
        if (payAccount == null) {
            return false;
        }
        return amountIsCorrect(payAccount, rank, rechargeAmount);
    }

    @RequestMapping("/onlineSubmit")
    @Token(valid = true)
    @ResponseBody
    public Map<String, Object> onlineSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid OnlinePayForm form, BindingResult result) {
        return onlineSubmit(playerRechargeVo, form.get$code(), result, RechargeTypeEnum.ONLINE_DEPOSIT.getCode());
    }

    /**
     * 线上支付公共提交方法
     *
     * @param playerRechargeVo
     * @param code
     * @param result
     * @param rechargeType
     * @return
     */
    private Map<String, Object> onlineSubmit(PlayerRechargeVo playerRechargeVo, String code, BindingResult result, String rechargeType) {
        boolean flag = rechargePre(result, code);
        if (!flag) {
            return getResultMsg(false, null, null);
        }
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        PayAccount payAccount = getOnlinePayAccount(playerRechargeVo.getAccount());
        playerRecharge.setRechargeType(rechargeType);
        playerRechargeVo.getResult().setPayerBank(payAccount.getBankCode());
        Integer failureCount = ServiceSiteTool.playerRechargeService().statisticalFailureCount(playerRechargeVo,SessionManager.getUserId());
        Map<String, Object> map = commonOnlineSubmit(playerRechargeVo, payAccount);
        map.put("failureCount",failureCount);
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
        PayAccount payAccount = getOnlinePayAccount(playerRechargeVo.getAccount());
        //如果账号支持随机金额 重新设置存款金额
        playerRecharge.setRechargeAmount(getRechargeAmount(payAccount, playerRecharge));
        return commonOnlineSubmit(playerRechargeVo, payAccount);
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
                ServiceSiteTool.playerRechargeService().updateOnly(playerRechargeVo);
                response.sendRedirect(url);
            }
        } catch (Exception e) {
            LOG.error(e);
        }
    }

    public String getDomain(String domain, PayAccount payAccount) {
        domain = domain.replace("http://", "");
        VSysSiteDomain siteDomain = Cache.getSiteDomain(domain);
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
     * 获取线上支付收款账号
     *
     * @param account
     * @return
     */
    private PayAccount getOnlinePayAccount(String account) {
        PayAccount payAccount = getPayAccountBySearchId(account);
        if (payAccount == null) {
            return null;
        }
       /* Bank bank = Cache.getBank().get(payAccount.getBankCode());
        if (bank == null || (bank.getIsUse() != null && !bank.getIsUse())) {
            LOG.info("{0}渠道已关闭，故返回收款账号null", payAccount.getBankCode());
            return null;
        }*/
        return payAccount;
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
