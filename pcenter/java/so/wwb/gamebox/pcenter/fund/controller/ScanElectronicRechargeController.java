package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.CollectionTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.StringTool;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.TerminalEnum;
import so.wwb.gamebox.model.company.enums.BankCodeEnum;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.content.so.PayAccountSo;
import so.wwb.gamebox.model.master.content.vo.PayAccountListVo;
import so.wwb.gamebox.model.master.content.vo.PayAccountVo;
import so.wwb.gamebox.model.master.enums.PayAccountAccountType;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.pcenter.session.SessionManager;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * Created by cherry on 18-2-5.
 */
@Controller
@RequestMapping("/fund/recharge/ScanElectronic")
public class ScanElectronicRechargeController extends RechargeBaseController {
    private static final String WECHATPAY_URI = "/fund/recharge/Wechatpay";
    private static final String ALIPAY_URI = "/fund/recharge/Alipay";

    /**
     * 微信支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/wechatpay")
    public String wechatpay(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, null, new String[]{PayAccountAccountType.WECHAT.getCode(), PayAccountAccountType.WECHAT_MICROPAY.getCode()}));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.FAST_WECHAT.getCode(), RechargeTypeEnum.WECHATPAY_FAST.getCode()));
        model.addAttribute("command", new PayAccountVo());
        return WECHATPAY_URI;
    }

    /**
     * 微信支付
     *
     * @param model
     * @return
     */
    @RequestMapping("/alipay")
    public String alipay(Model model) {
        PlayerRank rank = getRank();
        model.addAttribute("scan", getScanAccount(rank, null, new String[]{PayAccountAccountType.ALIPAY.getCode(), PayAccountAccountType.ALIPAY_MICROPAY.getCode()}));
        model.addAttribute("electronic", getElectronicAccount(rank, BankCodeEnum.FAST_ALIPAY.getCode(), RechargeTypeEnum.ALIPAY_FAST.getCode()));
        return ALIPAY_URI;
    }

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
            Map<String, String> i18n = I18nTool.getDictMapByEnum(SessionManager.getLocale(), DictEnum.FUND_RECHARGE_TYPE);
            payAccount.setAliasName(i18n.get(rechargeType));
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
}
