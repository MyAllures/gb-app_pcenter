package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.CollectionTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.math.NumberTool;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.model.*;
import so.wwb.gamebox.model.common.MessageI18nConst;
import so.wwb.gamebox.model.company.enums.BankCodeEnum;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.content.so.PayAccountSo;
import so.wwb.gamebox.model.master.content.vo.PayAccountListVo;
import so.wwb.gamebox.model.master.content.vo.PayAccountVo;
import so.wwb.gamebox.model.master.enums.PayAccountAccountType;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerRecharge;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.pcenter.fund.form.ScanElectronicRechargeForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.common.token.Token;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 存款渠道改版-扫码支付和电子支付和并
 * <p/>
 * Created by cherry on 18-2-5.
 */
@Controller
@RequestMapping("/fund/recharge/ScanElectronic")
public class ScanElectronicRechargeController extends RechargeBaseController {
    private static final String SCAN_ELECTRONIC_URI = "/fund/recharge/ScanElectronic";

    /**
     * 微信支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/wechatpay")
    @Token(generate = true)
    public String wechatpay(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, null, new String[]{PayAccountAccountType.WECHAT.getCode(), PayAccountAccountType.WECHAT_MICROPAY.getCode()}));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.FAST_WECHAT.getCode(), RechargeTypeEnum.WECHATPAY_FAST.getCode()));

        commonPage(model, rank, RechargeTypeEnum.WECHATPAY_SCAN.getCode(), RechargeTypeEnum.WECHATPAY_FAST.getCode());
        model.addAttribute("bankCode", BankCodeEnum.FAST_WECHAT.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 支付宝支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/alipay")
    @Token(generate = true)
    public String alipay(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, null, new String[]{PayAccountAccountType.ALIPAY.getCode(), PayAccountAccountType.ALIPAY_MICROPAY.getCode()}));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.FAST_ALIPAY.getCode(), RechargeTypeEnum.ALIPAY_FAST.getCode()));
        commonPage(model, rank, RechargeTypeEnum.ALIPAY_SCAN.getCode(), RechargeTypeEnum.ALIPAY_FAST.getCode());
        model.addAttribute("bankCode", BankCodeEnum.ALIPAY_MICROPAY.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * qq支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/qq")
    @Token(generate = true)
    public String qq(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, null, new String[]{PayAccountAccountType.QQWALLET.getCode(), PayAccountAccountType.QQ_MICROPAY.getCode()}));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.QQWALLET.getCode(), RechargeTypeEnum.QQWALLET_FAST.getCode()));
        commonPage(model, rank, RechargeTypeEnum.QQWALLET_SCAN.getCode(), RechargeTypeEnum.QQWALLET_FAST.getCode());
        model.addAttribute("bankCode", BankCodeEnum.QQWALLET.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 京东支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/jd")
    @Token(generate = true)
    public String jd(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, PayAccountAccountType.JD_PAY.getCode(), null));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.JDWALLET.getCode(), RechargeTypeEnum.JDWALLET_FAST.getCode()));
        commonPage(model, rank, RechargeTypeEnum.JDPAY_SCAN.getCode(), RechargeTypeEnum.JDWALLET_FAST.getCode());
        model.addAttribute("bankCode", BankCodeEnum.JDWALLET.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 百度支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/bd")
    @Token(generate = true)
    public String bd(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, PayAccountAccountType.BAIFU_PAY.getCode(), null));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.BDWALLET.getCode(), RechargeTypeEnum.BDWALLET_FAST.getCode()));
        commonPage(model, rank, RechargeTypeEnum.BDWALLET_SAN.getCode(), RechargeTypeEnum.BDWALLET_FAST.getCode());
        model.addAttribute("bankCode", BankCodeEnum.BDWALLET.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 银联支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/union")
    @Token(generate = true)
    public String union(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, PayAccountAccountType.UNION_PAY.getCode(), null));
        commonPage(model, rank, RechargeTypeEnum.UNION_PAY_SCAN.getCode(), null);
        model.addAttribute("bankCode", BankCodeEnum.UNIONPAY.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 一码付
     *
     * @param model
     * @return
     */
    @RequestMapping("/onecodepay")
    @Token(generate = true)
    public String onecodepay(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.ONECODEPAY.getCode(), RechargeTypeEnum.ONECODEPAY_FAST.getCode()));
        commonPage(model, rank, null, RechargeTypeEnum.ONECODEPAY_FAST.getCode());
        model.addAttribute("bankCode", BankCodeEnum.ONECODEPAY.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 其他电子支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/other")
    @Token(generate = true)
    public String other(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.OTHER.getCode(), RechargeTypeEnum.OTHER_FAST.getCode()));
        commonPage(model, rank, null, RechargeTypeEnum.OTHER_FAST.getCode());
        model.addAttribute("bankCode", "else");
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 易收付
     *
     * @param model
     * @return
     */
    @RequestMapping("/easyPay")
    @Token(generate = true)
    public String easyPay(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, PayAccountAccountType.EASY_PAY.getCode(), null));
        commonPage(model, rank, RechargeTypeEnum.EASY_PAY.getCode(), null);
        model.addAttribute("bankCode", BankCodeEnum.EASY_PAY.getCode());
        return SCAN_ELECTRONIC_URI;
    }

    /**
     * 支付页面公共页面元素部分
     *
     * @param model
     */
    private void commonPage(Model model, PlayerRank rank, String onlineType, String companyType) {
        model.addAttribute("command", new PayAccountVo());
        model.addAttribute("username", SessionManager.getUserName());
        model.addAttribute("rank", rank);
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_E_PAYMENT);
        model.addAttribute("customerService", getCustomerService());
        model.addAttribute("validateRule", JsRuleCreator.create(ScanElectronicRechargeForm.class));
        Double rechargeDecimals = Math.random() * 99 + 1;
        model.addAttribute("rechargeDecimals", rechargeDecimals.intValue());
        model.addAttribute("onlineType", onlineType);
        model.addAttribute("companyType", companyType);
        model.addAttribute("currency", SessionManager.getUser().getDefaultCurrency());
        model.addAttribute("isOpenActivityHall", ParamTool.isOpenActivityHall());
    }

    /**
     * 获取扫码支付对应收款帐号
     *
     * @param rank
     * @param accountType
     * @param accountTypes
     * @return
     */
    private Map<String, PayAccount> getScanAccount(PlayerRank rank, String accountType, String[] accountTypes) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.ONLINE_ACCOUNT.getCode(), accountType, TerminalEnum.PC.getCode(), null, accountTypes);
        PayAccountListVo payAccountListVo = new PayAccountListVo();
        payAccountListVo.setResult(payAccounts);
        payAccountListVo.setPlayerRank(rank);
        payAccountListVo.setCurrency(SessionManager.getUser().getDefaultCurrency());
        return ServiceSiteTool.payAccountService().getScanAccount(payAccountListVo);
    }

    private List<PayAccount> getElectronicAccount(PlayerRank rank, String bankCode, String rechargeType) {
        //获取该渠道下电子支付账号
        List<PayAccount> payAccounts = getElectronicPayAccount(bankCode);
        if (CollectionTool.isEmpty(payAccounts)) {
            return null;
        }
        //电子支付是否展示多个支付
        boolean display = rank != null && rank.getDisplayCompanyAccount() != null && rank.getDisplayCompanyAccount();
        List<PayAccount> payAccountList;
        if (display) {
            payAccountList = getCompanyPayAccounts(payAccounts, rechargeType);
        } else {
            //默认只展示一个
            PayAccount payAccount = payAccounts.get(0);
            if(StringTool.isBlank(payAccount.getAliasName())) {
                Map<String, String> i18n = I18nTool.getDictMapByEnum(SessionManager.getLocale(), DictEnum.FUND_RECHARGE_TYPE);
                payAccount.setAliasName(i18n.get(rechargeType));
            }
            payAccountList = new ArrayList<>(1);
            payAccountList.add(payAccount);
        }
        return payAccountList;
    }

    /**
     * 根据bankCode获取电子支付收款账号
     *
     * @param bankCode
     * @return
     */
    private List<PayAccount> getElectronicPayAccount(String bankCode) {
        PayAccountSo payAccountSo = new PayAccountSo();
        payAccountSo.setType(PayAccountType.COMMPANY_ACCOUNT_CODE);
        payAccountSo.setAccountType(PayAccountAccountType.THIRTY.getCode());
        payAccountSo.setBankCode(bankCode);
        PayAccountListVo payAccountListVo = new PayAccountListVo();
        payAccountListVo.setSearch(payAccountSo);
        return searchPayAccount(payAccountListVo, null, null);
    }


    /**
     * 展示电子支付多个收款账号
     *
     * @param accounts
     * @return
     */
    private List<PayAccount> getCompanyPayAccounts(List<PayAccount> accounts, String rechargeType) {
        if (CollectionTool.isEmpty(accounts)) {
            return null;
        }
        int size = accounts.size();
        int count = 1;
        Map<String, String> i18n = I18nTool.getDictMapByEnum(SessionManager.getLocale(), DictEnum.FUND_RECHARGE_TYPE);
        String bankName = i18n.get(rechargeType);
        String other = RechargeTypeEnum.OTHER_FAST.getCode();
        for (PayAccount payAccount : accounts) {
            if (StringTool.isBlank(payAccount.getAliasName())) {
                if (other.equals(rechargeType) || other.equals(rechargeType)) {
                    payAccount.setAliasName(payAccount.getCustomBankName());
                } else if (size > 1) {
                    payAccount.setAliasName(bankName + count);
                    count++;
                } else {
                    payAccount.setAliasName(bankName);
                }
            }
        }
        return accounts;
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
        if (StringTool.isBlank(account) || StringTool.isBlank(rechargeAmount)) {
            return false;
        }
        double amount = NumberTool.toDouble(rechargeAmount);
        PayAccountVo payAccountVo = new PayAccountVo();
        payAccountVo.setSearchId(account);
        payAccountVo = ServiceSiteTool.payAccountService().get(payAccountVo);
        PayAccount payAccount = payAccountVo.getResult();
        if (payAccount == null) {
            return false;
        }
        Long max;
        Long min;
        PlayerRank rank = getRank();
        if (PayAccountType.COMMPANY_ACCOUNT_CODE.equals(payAccount.getType())) {
            //公司入款使用层级设置的存款上下限
            max = rank.getOnlinePayMax();
            min = rank.getOnlinePayMin();
        } else {
            //线上支付使用收款帐号设置的上下限
            min = payAccount.getSingleDepositMin();
            max = payAccount.getSingleDepositMax();
        }
        if ((max != null && max < amount) || (min != null && min > amount)) {
            return false;
        }
        //计算手续费
        double fee = calculateFeeSchemaAndRank(rank, amount,account);
        return (amount + fee) > 0;
    }

    /**
     * 统计连续失败次数
     *
     * @param playerRechargeVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping("/sumFailureCount")
    @ResponseBody
    public Map<String, Object> sumFailureCount(PlayerRechargeVo playerRechargeVo, @FormModel @Valid ScanElectronicRechargeForm form, BindingResult result) {
        if (result.hasErrors()) {
            return getResultMsg(false, LocaleTool.tranView(Module.FUND.getCode(), MessageI18nConst.RECHARGE_PARAMS_DATA_ERROR), null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null) {
            return getResultMsg(false, LocaleTool.tranMessage(Module.FUND.getCode(), MessageI18nConst.RECHARGE_PAY_ACCOUNT_LOST), null);
        }
        PlayerRechargeVo playerRechargeVo4Count = new PlayerRechargeVo();
        playerRechargeVo4Count.getSearch().setPayAccountId(payAccount.getId());
        Integer failureCount = ServiceSiteTool.playerRechargeService().statisticalFailureCount(playerRechargeVo4Count, SessionManager.getUserId());
        Map<String, Object> map = new HashMap<>();
        map.put("failureCount", failureCount);
        return map;
    }

    @RequestMapping("/submit")
    @ResponseBody
    @Token(valid = true)
    public Map<String, Object> submit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid ScanElectronicRechargeForm form, BindingResult result, HttpServletRequest request) {
        if (result.hasErrors()) {
            return getResultMsg(false, LocaleTool.tranView(Module.FUND.getCode(), MessageI18nConst.RECHARGE_PARAMS_DATA_ERROR), null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null) {
            return getResultMsg(false, LocaleTool.tranMessage(Module.FUND.getCode(), MessageI18nConst.RECHARGE_PAY_ACCOUNT_LOST), null);
        }
        //公司入款展示确认弹窗：存款金额、实际到账、手续费
        if (PayAccountType.COMMPANY_ACCOUNT_CODE.equals(payAccount.getType())) {
            return companyRechargeConfirmInfo(playerRechargeVo);
        } else { //线上支付保存存款订单
            PlayerRecharge playerRecharge = playerRechargeVo.getResult();
            playerRecharge.setPayerBankcard(form.get$payerBankcard());
            String payAccountType = payAccount.getAccountType();
            String rechargeType = RechargeTypeEnum.ONLINE_DEPOSIT.getCode();
            if (PayAccountAccountType.WECHAT.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.WECHATPAY_SCAN.getCode();
            } else if (PayAccountAccountType.ALIPAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.ALIPAY_SCAN.getCode();
            } else if (PayAccountAccountType.QQWALLET.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.QQWALLET_SCAN.getCode();
            } else if (PayAccountAccountType.JD_PAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.JDPAY_SCAN.getCode();
            } else if (PayAccountAccountType.BAIFU_PAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.BDWALLET_SAN.getCode();
            } else if (PayAccountAccountType.WECHAT_MICROPAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.WECHATPAY_SCAN.getCode();
            } else if (PayAccountAccountType.ALIPAY_MICROPAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.ALIPAY_SCAN.getCode();
            } else if (PayAccountAccountType.QQ_MICROPAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.QQWALLET_SCAN.getCode();
            } else if (PayAccountAccountType.UNION_PAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.UNION_PAY_SCAN.getCode();
            } else if (PayAccountAccountType.EASY_PAY.getCode().equals(payAccountType)) {
                rechargeType = RechargeTypeEnum.EASY_PAY.getCode();
            }
            playerRecharge.setRechargeType(rechargeType);
            return commonOnlineSubmit(playerRechargeVo, payAccount, request);
        }
    }

    /**
     * 电子支付提交
     *
     * @param playerRechargeVo
     * @param form
     * @param result
     * @param model
     * @return
     */
    @RequestMapping("/electronicSubmit")
    @ResponseBody
    @Token(valid = true)
    public Map<String, Object> electronicSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid ScanElectronicRechargeForm form, BindingResult result, Model model) {
        if (result.hasErrors()) {
            return getResultMsg(false, null, null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null || PayAccountType.ONLINE_ACCOUNT_CODE.equals(payAccount.getType())) {
            return getResultMsg(false, null, null);
        }
        String bankCode = payAccount.getBankCode();
        String rechargeType = RechargeTypeEnum.WECHATPAY_FAST.getCode();
        if (BankCodeEnum.FAST_ALIPAY.getCode().equals(bankCode)) {
            rechargeType = RechargeTypeEnum.ALIPAY_FAST.getCode();
        } else if (BankCodeEnum.QQWALLET.getCode().equals(bankCode)) {
            rechargeType = RechargeTypeEnum.QQWALLET_FAST.getCode();
        } else if (BankCodeEnum.JDWALLET.getCode().equals(bankCode)) {
            rechargeType = RechargeTypeEnum.JDWALLET_FAST.getCode();
        } else if (BankCodeEnum.BDWALLET.getCode().equals(bankCode)) {
            rechargeType = RechargeTypeEnum.BDWALLET_FAST.getCode();
        } else if (BankCodeEnum.ONECODEPAY.getCode().equals(bankCode)) {
            rechargeType = RechargeTypeEnum.ONECODEPAY_FAST.getCode();
        } else if (BankCodeEnum.OTHER.getCode().equals(bankCode)) {
            rechargeType = RechargeTypeEnum.OTHER_FAST.getCode();
        }
        return companySaveRecharge(playerRechargeVo, payAccount, rechargeType);
    }

}
