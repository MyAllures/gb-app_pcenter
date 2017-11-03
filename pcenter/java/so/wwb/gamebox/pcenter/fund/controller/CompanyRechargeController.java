package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.CollectionTool;
import org.soul.commons.currency.CurrencyTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.model.comet.vo.MessageVo;
import org.soul.model.sys.po.SysParam;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteI18nEnum;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.Const;
import so.wwb.gamebox.model.common.notice.enums.CometSubscribeType;
import so.wwb.gamebox.model.company.enums.BankCodeEnum;
import so.wwb.gamebox.model.company.enums.BankEnum;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.dataRight.DataRightModuleType;
import so.wwb.gamebox.model.master.dataRight.po.SysUserDataRight;
import so.wwb.gamebox.model.master.dataRight.vo.SysUserDataRightListVo;
import so.wwb.gamebox.model.master.dataRight.vo.SysUserDataRightVo;
import so.wwb.gamebox.model.master.enums.DepositWayEnum;
import so.wwb.gamebox.model.master.enums.PayAccountAccountType;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.fund.enums.RechargeStatusEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeParentEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerRecharge;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeListVo;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.model.master.operation.po.ActivityDepositWay;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.pcenter.fund.form.*;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.token.Token;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.*;

/**
 * Created by cherry on 16-9-11.
 */
@Controller
@RequestMapping("/fund/recharge/company")
public class CompanyRechargeController extends RechargeBaseController {
    //网银存款步奏1-选择收款账户
    private static final String ONLINE_BANK_FIRST = "/fund/recharge/OnlineBankFirst";
    //网银存款步奏2-生成存款金额
    private static final String ONLINE_BANK_SECOND = "/fund/recharge/OnlineBankSecond";
    //网银存款步奏3-确认提交存款
    private static final String ONLINE_BANK_THIRD = "/fund/recharge/OnlineBankThird";
    //电子支付步奏1-选择收款账号
    private static final String ELECTRONIC_PAY_FIRST = "/fund/recharge/ElectronicPayFirst";
    //电子支付步奏2-填写回执信息
    private static final String ELECTRONIC_PAY_SECOND = "/fund/recharge/ElectronicPaySecond";
    //柜员机/柜台存款步奏1-选择收款账号
    private static final String ATM_COUNTER_FIRST = "/fund/recharge/AtmCounterFirst";
    //柜员机/柜台存款步奏2-生成存款金额
    private static final String ATM_COUNTER_SECOND = "/fund/recharge/AtmCounterSecond";
    //提交公司入款订单结果页面
    private static final String SUBMIT_SUCCESS = "/fund/recharge/SubmitSuccess";
    //存款失败页面
    private static final String ONLINE_FAIL = "/fund/recharge/OnlineFail";
    //比特币支付步骤1
    private static final String BIT_COIN_FIRST = "/fund/recharge/BitCoinFirst";
    //比特币支付步骤2
    private static final String BIT_COIN_SECOND = "/fund/recharge/BitCoinSecond";

    private static Log LOG = LogFactory.getLog(CompanyRechargeController.class);

    /**
     * 网银存款步奏1-选择收款账户
     *
     * @param model
     * @return
     */
    @RequestMapping("/onlineBankFirst")
    public String onlineBankFirst(Model model, PlayerRechargeVo playerRechargeVo) {
        //玩家可用收款账号
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.BANKACCOUNT.getCode(), null);
        PlayerRank rank = getRank();
        boolean display = rank != null && rank.getDisplayCompanyAccount() != null && rank.getDisplayCompanyAccount();
        //获取公司入款收款账号
        if (!display) {
            Map<String, PayAccount> payAccountMap = getCompanyPayAccount(payAccounts);
            model.addAttribute("payAccountMap", payAccountMap);
        } else {
            model.addAttribute("accounts", getCompanyPayAccounts(payAccounts));
        }
        model.addAttribute("rank", rank);
        model.addAttribute("sales", searchSales(ActivityDepositWay.COMPANY));
        model.addAttribute("currency", getCurrencySign());
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(OnlineBankForm.class));
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("displayAccounts", display);
        return ONLINE_BANK_FIRST;
    }

    /**
     * 网银存款步奏2-生成存款金额
     *
     * @param playerRechargeVo
     * @param form
     * @param result
     * @param model
     * @return
     */
    @RequestMapping("/onlineBankSecond")
    public String onlineBankSecond(PlayerRechargeVo playerRechargeVo, @FormModel @Valid OnlineBankForm form, BindingResult result, Model model) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            return null;
        }
        //获取收款账号
        PayAccount payAccount = getPayAccount(playerRechargeVo.getResult().getPayAccountId());
        model.addAttribute("payAccount", payAccount);
        //是否隐藏收款账号
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_ONLINE_BANKING);
        model.addAttribute("bank", Cache.getBank().get(payAccount.getBankCode()));
        //可用的网银转账链接
        model.addAttribute("bankList", searchBank(BankEnum.TYPE_BANK.getCode()));
        //生成存款金额
        playerRechargeVo.getResult().setRechargeAmount(generalAmount(playerRechargeVo.getResult().getRechargeAmount()));
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        model.addAttribute("validateRule", JsRuleCreator.create(OnlineBankSecondForm.class));
        return ONLINE_BANK_SECOND;
    }

    /**
     * 比特币支付步奏1-选择收款账号
     *
     * @param model
     * @return
     */
    @RequestMapping("/bitCoinFirst")
    public String bitCoinFirst(Model model) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.THIRTY.getCode(), null);
        //获取公司入款收款账号
        Map<String, PayAccount> payAccountMap = getCompanyPayAccount(payAccounts);
        //调整顺序微信、支付宝、比特币、其他
        List<PayAccount> payAccountList = new ArrayList<>(payAccountMap.size());
        addPayAccount(payAccountList, payAccountMap, BITCOIN);
        model.addAttribute("payAccountList", payAccountList);
        PlayerRank rank = getRank();
        //是否隐藏收款账号
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_E_PAYMENT);
        model.addAttribute("rank", rank);
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("isRealName", isRealName());
        return BIT_COIN_FIRST;
    }

    /**
     * 电子支付步奏1-选择收款账号
     *
     * @param model
     * @return
     */
    @RequestMapping("/electronicPayFirst")
    public String electronicPayFirst(Model model) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.THIRTY.getCode(), null);
        //获取公司入款收款账号
        Map<String, PayAccount> payAccountMap = getCompanyPayAccount(payAccounts);
        PlayerRank rank = getRank();
        boolean display = rank != null && rank.getDisplayCompanyAccount() != null && rank.getDisplayCompanyAccount();
        List<PayAccount> payAccountList;
        if (display) {
            payAccountList = getCompanyPayAccounts(payAccounts);
        } else {
            //调整顺序微信、支付宝、qq钱包、京东钱包、百度钱包、１码付、其他
            payAccountList = new ArrayList<>(payAccountMap.size());
            addPayAccount(payAccountList, payAccountMap, WECHATPAY);
            addPayAccount(payAccountList, payAccountMap, ALIPAY);
            addPayAccount(payAccountList, payAccountMap, BankCodeEnum.QQWALLET.getCode());
            addPayAccount(payAccountList, payAccountMap, BankCodeEnum.JDWALLET.getCode());
            addPayAccount(payAccountList, payAccountMap, BankCodeEnum.BDWALLET.getCode());
            addPayAccount(payAccountList, payAccountMap, BankCodeEnum.ONECODEPAY.getCode());
            for (PayAccount payAccount : payAccountMap.values()) {
                if (BankCodeEnum.OTHER.getCode().equals(payAccount.getBankCode())) {
                    payAccountList.add(payAccount);
                }
            }
        }
        model.addAttribute("payAccountList", payAccountList);
        //是否隐藏收款账号
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_E_PAYMENT);
        model.addAttribute("rank", rank);
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("isRealName", isRealName());
        return ELECTRONIC_PAY_FIRST;
    }

    private void addPayAccount(List<PayAccount> payAccountList, Map<String, PayAccount> payAccountMap, String bankCode) {
        PayAccount payAccount = payAccountMap.get(bankCode);
        if (payAccount != null) {
            payAccountList.add(payAccount);
        }
    }

    /**
     * 电子支付步奏2-回执单
     *
     * @param model
     * @param playerRechargeVo
     * @return
     */
    @RequestMapping("/electronicPaySecond")
    public String electronicPaySecond(Model model, PlayerRechargeVo playerRechargeVo) {
        PayAccount payAccount = getPayAccount(playerRechargeVo.getResult().getPayAccountId());
        String rechargeType = RechargeTypeEnum.OTHER_FAST.getCode();
        if (WECHATPAY.equals(payAccount.getBankCode())) {
            rechargeType = RechargeTypeEnum.WECHATPAY_FAST.getCode();
        } else if (ALIPAY.equals(payAccount.getBankCode())) {
            rechargeType = RechargeTypeEnum.ALIPAY_FAST.getCode();
        }
        playerRechargeVo.getResult().setRechargeType(rechargeType);
        model.addAttribute("sales", searchSales(rechargeType));
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        model.addAttribute("sales", searchSales(rechargeType));
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(ElectronicPayForm.class));
        model.addAttribute("rank", getRank());
        model.addAttribute("payAccount", payAccount);
        playerRechargeVo.getResult().setPlayerId(SessionManager.getUserId());
        //上一次填写的账号/昵称
        model.addAttribute("payerBankcard", playerRechargeService().searchLastPayerBankcard(playerRechargeVo));
        return ELECTRONIC_PAY_SECOND;
    }


    /**
     * 比特币支付步奏2-回执单
     *
     * @param model
     * @param playerRechargeVo
     * @return
     */
    @RequestMapping("/bitCoinSecond")
    public String bitCoinSecond(Model model, PlayerRechargeVo playerRechargeVo) {
        PayAccount payAccount = getPayAccount(playerRechargeVo.getResult().getPayAccountId());
        String rechargeType = RechargeTypeEnum.BITCOIN_FAST.getCode();
        playerRechargeVo.getResult().setRechargeType(rechargeType);
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(BitCoinPayForm.class));
        model.addAttribute("payAccount", payAccount);
        playerRechargeVo.getResult().setPlayerId(SessionManager.getUserId());
        model.addAttribute("sales", searchSales(rechargeType));
        //上一次填写的账号/昵称
        model.addAttribute("payerBankcard", playerRechargeService().searchLastPayerBankcard(playerRechargeVo));
        return BIT_COIN_SECOND;
    }

    /**
     * 柜员机/柜台存款步奏1-选择收款账号
     *
     * @param model
     * @return
     */
    @RequestMapping("/atmCounterFirst")
    public String atmCountFirst(Model model) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.BANKACCOUNT.getCode(), true);
        Map<String, List<PayAccount>> payAccountMap = CollectionTool.groupByProperty(payAccounts, PayAccount.PROP_BANK_CODE, String.class);
        model.addAttribute("payAccountMap", payAccountMap);
        model.addAttribute("rank", getRank());
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("sales", searchSales(DepositWayEnum.COMPANY_DEPOSIT.getCode()));
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(AtmCounterForm.class));
        model.addAttribute("isRealName", isRealName());
        return ATM_COUNTER_FIRST;
    }

    /**
     * 柜员机/柜台存款步奏2-生成存款金额
     *
     * @param model
     * @param playerRechargeVo
     * @return
     */
    @RequestMapping("/atmCounterSecond")
    public String atmCounterSecond(Model model, PlayerRechargeVo playerRechargeVo, HttpServletRequest request, @FormModel @Valid AtmCounterForm form, BindingResult result) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            return null;
        }
        //是否隐藏账号
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_ATM_COUNTER);
        //柜员现金无需生成小数点金额
        if (!RechargeTypeEnum.ATM_MONEY.getCode().equals(playerRechargeVo.getResult().getRechargeType())) {
            playerRechargeVo.getResult().setRechargeAmount(generalAmount(playerRechargeVo.getResult().getRechargeAmount()));
        }
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        model.addAttribute("payAccount", getPayAccount(playerRechargeVo.getResult().getPayAccountId()));
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(AtmCounterSecondForm.class));
        return ATM_COUNTER_SECOND;
    }

    /**
     * 公司入款确认存款页-确认提交存款
     *
     * @param model
     * @param playerRechargeVo
     * @return
     */
    @RequestMapping("/confirmRecharge")
    @Token(generate = true)
    public String confirmDeposit(Model model, PlayerRechargeVo playerRechargeVo) {
        //手续费
        if (!RechargeTypeEnum.BITCOIN_FAST.getCode().equals(playerRechargeVo.getResult().getRechargeType())) {
            model.addAttribute("fee", calculateFee(getRank(), playerRechargeVo.getResult().getRechargeAmount()));
        }
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        return ONLINE_BANK_THIRD;
    }

    /**
     * 网银存款提交
     *
     * @param playerRechargeVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping("/onlineBankSubmit")
    @Token(valid = true)
    public String onlineBankSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid OnlineBankSecondForm form, BindingResult result) {
        playerRechargeVo.setAcbKeyParam(ParamTool.getSysParam(SiteParamEnum.SITE_PAY_KEY));
        return companySubmit(playerRechargeVo, RechargeTypeEnum.ONLINE_BANK.getCode(), result);
    }

    @RequestMapping("electronicPaySubmit")
    @Token(valid = true)
    public String electronicPaySubmit(PlayerRechargeVo playerRechargeVo, HttpServletRequest request, @FormModel @Valid ElectronicPayForm form, BindingResult result, Model model) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            playerRechargeVo.setSuccess(false);
            model.addAttribute("customerService", getCustomerService());
            return ONLINE_FAIL;
        }
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        PayAccount payAccount = getPayAccount(playerRecharge.getPayAccountId());
        if (payAccount == null) {
            playerRechargeVo.setSuccess(false);
            model.addAttribute("customerService", getCustomerService());
            return ONLINE_FAIL;
        }
        String rechargeType = RechargeTypeEnum.OTHER_FAST.getCode();
        if (WECHATPAY.equals(payAccount.getBankCode())) {
            rechargeType = RechargeTypeEnum.WECHATPAY_FAST.getCode();
        } else if (ALIPAY.equals(payAccount.getBankCode())) {
            rechargeType = RechargeTypeEnum.ALIPAY_FAST.getCode();
        }

        playerRechargeVo = saveRecharge(playerRechargeVo, payAccount, RechargeTypeParentEnum.COMPANY_DEPOSIT.getCode(), rechargeType);
        return depositAfter(playerRechargeVo, model);
    }

    @RequestMapping("bitCoinSubmit")
    @Token(valid = true)
    public String bitCoinSubmit(PlayerRechargeVo playerRechargeVo, HttpServletRequest request, @FormModel @Valid BitCoinPayForm form, BindingResult result, Model model) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            playerRechargeVo.setSuccess(false);
            model.addAttribute("customerService", getCustomerService());
            return ONLINE_FAIL;
        }
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        PayAccount payAccount = getPayAccount(playerRecharge.getPayAccountId());
        if (payAccount == null) {
            playerRechargeVo.setSuccess(false);
            model.addAttribute("customerService", getCustomerService());
            return ONLINE_FAIL;
        }
        String rechargeType = RechargeTypeEnum.BITCOIN_FAST.getCode();
        playerRecharge.setRechargeAmount(0d);
        playerRechargeVo = saveRecharge(playerRechargeVo, payAccount, RechargeTypeParentEnum.COMPANY_DEPOSIT.getCode(), rechargeType);
        return depositAfter(playerRechargeVo, model);
    }

    /**
     * 柜员机柜台存款公司入款提交
     *
     * @param playerRechargeVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping("atmCounterSubmit")
    @Token(valid = true)
    public String atmCounterSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid AtmCounterSecondForm form, BindingResult result) {
        return companySubmit(playerRechargeVo, playerRechargeVo.getResult().getRechargeType(), result);
    }

    /**
     * 远程验证存款金额是否超出
     *
     * @param rechargeAmount
     * @return
     */
    @RequestMapping("/checkAmount")
    @ResponseBody
    public boolean checkAmount(@RequestParam("result.rechargeAmount") String rechargeAmount) {
        PlayerRank rank = getRank();
        double amount = NumberTool.toDouble(rechargeAmount);
        Integer max = rank.getOnlinePayMax();
        Integer min = rank.getOnlinePayMin();
        if ((max != null && max < amount) || (min != null && min > amount)) {
            return false;
        }
        double fee = calculateFee(rank, amount);
        return (amount + fee) > 0;
    }

    private String companySubmit(PlayerRechargeVo playerRechargeVo, String rechargeType, BindingResult result) {
        if (result.hasErrors()) {
            return ONLINE_FAIL;
        }
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        PayAccount payAccount = getPayAccount(playerRecharge.getPayAccountId());
        if (payAccount == null) {
            return ONLINE_FAIL;
        }

        playerRechargeVo = saveRecharge(playerRechargeVo, payAccount, RechargeTypeParentEnum.COMPANY_DEPOSIT.getCode(), rechargeType);
        return depositAfter(playerRechargeVo);
    }

    /**
     * 存款后操作
     *
     * @param playerRechargeVo
     * @return
     */
    private String depositAfter(PlayerRechargeVo playerRechargeVo) {
        if (playerRechargeVo.isSuccess()) {
            tellerReminder(playerRechargeVo);
            //设置session相关存款数据
            setRechargeCount();
            return SUBMIT_SUCCESS;
        }
        return ONLINE_FAIL;
    }

    private String depositAfter(PlayerRechargeVo playerRechargeVo, Model model) {
        if (playerRechargeVo.isSuccess()) {
            tellerReminder(playerRechargeVo);
            //设置session相关存款数据
            setRechargeCount();
            return SUBMIT_SUCCESS;
        }
        model.addAttribute("customerService", getCustomerService());
        return ONLINE_FAIL;
    }

    /**
     * 获取公司入款收款账号Map（根据固定顺序获取收款账户）
     *
     * @param accounts
     * @return
     */
    private Map<String, PayAccount> getCompanyPayAccount(List<PayAccount> accounts) {
        Map<String, PayAccount> payAccountMap = new HashMap<>();
        for (PayAccount payAccount : accounts) {
            payAccountMap.put(payAccount.getBankCode(), payAccount);
        }
        return payAccountMap;
    }

    private List<PayAccount> getCompanyPayAccounts(List<PayAccount> accounts) {
        Map<String, Integer> countMap = new HashMap<>();
        Map<String, String> i18n = I18nTool.getDictMapByEnum(SessionManager.getLocale(), DictEnum.BANKNAME);
        for (PayAccount payAccount : accounts) {
            if (StringTool.isBlank(payAccount.getAliasName())) {
                if (countMap.get(payAccount.getBankCode()) == null) {
                    countMap.put(payAccount.getBankCode(), 1);
                } else {
                    countMap.put(payAccount.getBankCode(), countMap.get(payAccount.getBankCode()) + 1);
                }
                payAccount.setAliasName(i18n.get(payAccount.getBankCode()) + countMap.get(payAccount.getBankCode()));
            }
        }
        return accounts;
    }

    /**
     * 是否隐藏收款账号
     *
     * @param model
     */
    private void isHide(Model model, SiteParamEnum paramEnum) {
        // 查询隐藏参数
        SysParam sysParam = ParamTool.getSysParam(SiteParamEnum.CONTENT_PAY_ACCOUNT_HIDE);
        if (sysParam == null) return;

        SysParam hideParam = ParamTool.getSysParam(paramEnum);

        // 判断是否隐藏收款账号
        if ("true".equals(sysParam.getParamValue()) && "true".equals(hideParam.getParamValue())) {
            model.addAttribute("isHide", true);
            model.addAttribute("hideContent", Cache.getSiteI18n(SiteI18nEnum.MASTER_CONTENT_HIDE_ACCOUNT_CONTENT).get(SessionManager.getLocale().toString()));
            model.addAttribute("customerService", getCustomerService());
        }
    }

    /**
     * 随机生成存款金额的小数点后两位
     *
     * @param rechargeAmount
     * @return
     */
    private Double generalAmount(Double rechargeAmount) {
       /* String decimal;
        do {
            decimal = RandomStringTool.random(2, false, true);
        } while (NumberTool.toInt(decimal) == 0);
        return rechargeAmount + NumberTool.toDouble(decimal) / 100;*/
        return rechargeAmount;
    }

    /**
     * 存款消息提醒发送消息给前端
     *
     * @param playerRechargeVo
     */
    private void tellerReminder(PlayerRechargeVo playerRechargeVo) {
        PlayerRecharge recharge = playerRechargeVo.getResult();
        if (recharge == null || recharge.getId() == null) {
            return;
        }
        //推送消息给前端
        MessageVo message = new MessageVo();
        message.setSubscribeType(CometSubscribeType.MCENTER_RECHARGE_REMINDER.getCode());
        Map<String, Object> map = new HashMap<>(3, 1f);
        map.put("date", recharge.getCreateTime() == null ? new Date() : recharge.getCreateTime());
        map.put("currency", getCurrencySign());
        map.put("type", recharge.getRechargeTypeParent());
        map.put("amount", CurrencyTool.formatCurrency(recharge.getRechargeAmount()));
        map.put("id", recharge.getId());
        map.put("transactionNo", recharge.getTransactionNo());
        message.setMsgBody(JsonTool.toJson(map));
        message.setSendToUser(true);
        message.setCcenterId(SessionManager.getSiteParentId());
        message.setSiteId(SessionManager.getSiteId());
        message.setMasterId(SessionManager.getSiteUserId());


        SysUserDataRightListVo sysUserDataRightListVo = new SysUserDataRightListVo();
        sysUserDataRightListVo.getSearch().setUserId(SessionManager.getUserId());
        sysUserDataRightListVo.getSearch().setModuleType(DataRightModuleType.COMPANYDEPOSIT.getCode());
        List<Integer> userIdByUrl = ServiceTool.sysUserDataRightService().searchPlayerDataRightEntityId(sysUserDataRightListVo);
        userIdByUrl.add(Const.MASTER_BUILT_IN_ID);

        //判断账号是否可以查看该层级的记录 add by Bruce.QQ
//        filterUnavailableSubAccount(userIdByUrl);
        message.addUserIds(userIdByUrl);
        ServiceTool.messageService().sendToMcenterMsg(message);
    }

    /**
     * 验证txId是否已提交过
     *
     * @param txId
     * @return
     */
    @RequestMapping("/checkTxId")
    @ResponseBody
    public boolean checkTxId(@RequestParam("result.bankOrder") String txId) {
        PlayerRechargeListVo listVo = new PlayerRechargeListVo();
        listVo.getSearch().setBankOrder(txId);
        listVo.getSearch().setRechargeStatus(RechargeStatusEnum.FAIL.getCode());
        return ServiceTool.playerRechargeService().isExistsTxId(listVo);
    }

    private void filterUnavailableSubAccount(List<Integer> userIdByUrl) {
        SysUserDataRightVo sysUserDataRightVo = new SysUserDataRightVo();
        sysUserDataRightVo.getSearch().setModuleType(DataRightModuleType.COMPANYDEPOSIT.getCode());
        Map<Integer, List<SysUserDataRight>> udrMap = ServiceTool.sysUserDataRightService().searchDataRightsByModuleType(sysUserDataRightVo);

        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);
        Integer rankId = userPlayerVo.getResult().getRankId();
        for (Iterator<Integer> iterator = userIdByUrl.iterator(); iterator.hasNext(); ) {
            Integer userId = iterator.next();
            List<SysUserDataRight> dataRights = udrMap.get(userId);
            if (dataRights == null || dataRights.size() == 0) {
                continue;
            }
            if (rankId != null) {
                boolean flag = true;
                for (SysUserDataRight sysUserDataRight : dataRights) {
                    if (rankId.equals(sysUserDataRight.getEntityId())) {
                        flag = false;
                        break;
                    }
                }
                if (flag) {
                    iterator.remove();
                }
            }
        }
    }

}
