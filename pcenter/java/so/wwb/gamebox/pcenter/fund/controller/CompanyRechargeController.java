package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.CollectionTool;
import org.soul.commons.collections.MapTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.SystemTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.model.log.audit.enums.OpType;
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
import so.wwb.gamebox.model.common.Audit;
import so.wwb.gamebox.model.company.enums.BankCodeEnum;
import so.wwb.gamebox.model.company.enums.BankEnum;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.content.vo.PayAccountVo;
import so.wwb.gamebox.model.master.enums.DepositWayEnum;
import so.wwb.gamebox.model.master.enums.PayAccountAccountType;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.fund.enums.RechargeStatusEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerRecharge;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeListVo;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.model.master.operation.po.ActivityDepositWay;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.pcenter.fund.form.AtmCounterForm;
import so.wwb.gamebox.pcenter.fund.form.BitCoinPayForm;
import so.wwb.gamebox.pcenter.fund.form.OnlineBankForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.BussAuditLogTool;
import so.wwb.gamebox.web.common.token.Token;
import so.wwb.gamebox.web.common.token.TokenHandler;

import javax.validation.Valid;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by cherry on 16-9-11.
 */
@Controller
@RequestMapping("/fund/recharge/company")
public class CompanyRechargeController extends RechargeBaseController {
    //网银存款步奏1-选择收款账户
    private static final String ONLINE_BANK_FIRST = "/fund/recharge/OnlineBankFirst";
    //网银存款步奏3-确认提交存款
    private static final String ONLINE_BANK_THIRD = "/fund/recharge/OnlineBankThird";
    //柜员机/柜台存款步奏1-选择收款账号
    private static final String ATM_COUNTER_FIRST = "/fund/recharge/AtmCounterFirst";
    //比特币支付步骤1
    private static final String BIT_COIN_FIRST = "/fund/recharge/BitCoinFirst";

    private static Log LOG = LogFactory.getLog(CompanyRechargeController.class);

    /**
     * 网银存款步奏1-选择收款账户
     *
     * @param model
     * @return
     */
    @RequestMapping("/onlineBankFirst")
    @Token(generate = true)
    public String onlineBankFirst(Model model, PlayerRechargeVo playerRechargeVo) {
        //玩家可用收款账号
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.BANKACCOUNT.getCode(), null);
        PlayerRank rank = getRank();
        boolean display = rank != null && rank.getDisplayCompanyAccount() != null && rank.getDisplayCompanyAccount();
        //获取公司入款收款账号
        if (!display) {
            model.addAttribute("accounts", getCompanyPayAccount(payAccounts));
        } else {
            model.addAttribute("accounts", getCompanyPayAccounts(payAccounts));
        }
        model.addAttribute("rank", rank);
        boolean isOpenActivityHall = ParamTool.isOpenActivityHall();
        model.addAttribute("isOpenActivityHall", isOpenActivityHall);
        if (!isOpenActivityHall) {
            model.addAttribute("sales", searchSales(ActivityDepositWay.COMPANY));
        }
        model.addAttribute("currency", getCurrencySign());
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(OnlineBankForm.class));
        model.addAttribute("playerRechargeVo", playerRechargeVo);
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("displayAccounts", display);
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_ONLINE_BANKING);
        //可用的网银转账链接
        model.addAttribute("bankList", searchBank(BankEnum.TYPE_BANK.getCode()));
        model.addAttribute("bankCode", "ebankpay");
        model.addAttribute("customerService", getCustomerService());
        return ONLINE_BANK_FIRST;
    }

    /**
     * 比特币支付步奏1-选择收款账号
     *
     * @param model
     * @return
     */
    @RequestMapping("/bitCoinFirst")
    @Token(generate = true)
    public String bitCoinFirst(Model model) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.THIRTY.getCode(), null);
        //获取公司入款收款账号
        List<PayAccount> payAccountList = getCompanyPayAccount(payAccounts);
        Map<String, List<PayAccount>> payAccountMap = CollectionTool.groupByProperty(payAccountList, PayAccount.PROP_BANK_CODE, String.class);
        model.addAttribute("payAccountList", payAccountMap.get(BITCOIN));
        PlayerRank rank = getRank();
        //是否隐藏收款账号
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_E_PAYMENT);
        model.addAttribute("rank", rank);
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("bankCode", BankCodeEnum.BITCOIN.getCode());
        model.addAttribute("command", new PayAccountVo());
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(BitCoinPayForm.class));
        PlayerRechargeVo playerRechargeVo = new PlayerRechargeVo();
        PlayerRecharge playerRecharge = new PlayerRecharge();
        playerRecharge.setRechargeType(RechargeTypeEnum.BITCOIN_FAST.getCode());
        playerRecharge.setPlayerId(SessionManager.getUserId());
        playerRechargeVo.setResult(playerRecharge);
        model.addAttribute("sales", searchSales(playerRecharge.getRechargeType()));
        //上一次填写的账号/昵称
        model.addAttribute("payerBankcard", playerRechargeService().searchLastPayerBankcard(playerRechargeVo));
        model.addAttribute("customerService", getCustomerService());
        return BIT_COIN_FIRST;
    }

    /**
     * 柜员机/柜台存款步奏1-选择收款账号
     *
     * @param model
     * @return
     */
    @RequestMapping("/atmCounterFirst")
    @Token(generate = true)
    public String atmCountFirst(Model model) {
        List<PayAccount> payAccounts = searchPayAccount(PayAccountType.COMPANY_ACCOUNT.getCode(), PayAccountAccountType.BANKACCOUNT.getCode(), true);
        PlayerRank rank = getRank();
        boolean display = rank != null && rank.getDisplayCompanyAccount() != null && rank.getDisplayCompanyAccount();
        //获取公司入款收款账号
        if (!display) {
            model.addAttribute("accounts", getCompanyPayAccount(payAccounts));
        } else {
            model.addAttribute("accounts", getCompanyPayAccounts(payAccounts));
        }
        model.addAttribute("rank", rank);
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("displayAccounts", display);
        //验证规则
        model.addAttribute("validateRule", JsRuleCreator.create(AtmCounterForm.class));
        model.addAttribute("isRealName", isRealName());
        model.addAttribute("bankCode", "gyjgt");
        model.addAttribute("customerService", getCustomerService());
        model.addAttribute("userName", SessionManager.getUserName());
        model.addAttribute("payAccountVo", new PayAccountVo());
        boolean isOpenActivityHall = ParamTool.isOpenActivityHall();
        model.addAttribute("isOpenActivityHall",isOpenActivityHall);
        if(!isOpenActivityHall) {
            model.addAttribute("sales", searchSales(DepositWayEnum.COMPANY_DEPOSIT.getCode()));
        }
        isHide(model, SiteParamEnum.PAY_ACCOUNT_HIDE_ATM_COUNTER);
        return ATM_COUNTER_FIRST;
    }

    /**
     * 确认柜员机/柜台存款
     *
     * @param playerRechargeVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping("/atmCounterConfirm")
    @ResponseBody
    @Token(valid = true)
    public Map<String, Object> atmCounterConfirm(PlayerRechargeVo playerRechargeVo, @FormModel @Valid AtmCounterForm form, BindingResult result) {
        if (result.hasErrors()) {
            LOG.info("玩家存款参数有误");
            return getResultMsg(false, null, null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null || !PayAccountType.COMMPANY_ACCOUNT_CODE.equals(payAccount.getType())) {
            LOG.info("玩家存款收款帐号有误");
            return getResultMsg(false, null, null);
        }
        playerRechargeVo.getResult().setPayerBank(payAccount.getBankCode());
        return companyRechargeConfirmInfo(playerRechargeVo);
    }

    @RequestMapping("/onlineBankConfirm")
    @ResponseBody
    @Token(valid = true)
    public Map<String, Object> onlineBankConfirm(PlayerRechargeVo playerRechargeVo, @FormModel @Valid OnlineBankForm form, BindingResult result) {
        if (result.hasErrors()) {
            LOG.info("玩家存款参数有误");
            return getResultMsg(false, null, null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null || !PayAccountType.COMMPANY_ACCOUNT_CODE.equals(payAccount.getType())) {
            LOG.info("玩家存款收款帐号有误");
            return getResultMsg(false, null, null);
        }
        playerRechargeVo.getResult().setPayerBank(payAccount.getBankCode());
        return companyRechargeConfirmInfo(playerRechargeVo);
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
    @ResponseBody
    @Token(valid = true)
    @Audit(module = Module.MASTER_OPERATION, moduleType = ModuleType.PLAYER_RECHARGE, opType = OpType.CREATE)
    public Map<String, Object> onlineBankSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid OnlineBankForm form, BindingResult result) {
        Map<String, Object> rtnMap = commonCompanyRechargeSubmit(playerRechargeVo, result, RechargeTypeEnum.ONLINE_BANK.getCode());
        //存款记录保存完成,记录各个参数日志
        if (MapTool.getBoolean(rtnMap, "state")) {
            BussAuditLogTool.addLog("PLAYER_RECHARGE",
                    MapTool.getString(rtnMap,"transactionNo"),
                    (JsonTool.toJson(playerRechargeVo.getRechargeFeeSchemaVo()) +
                            JsonTool.toJson(playerRechargeVo.getPlayerRank())).replace("{", "").replace("}", ""));
        }
        return rtnMap;
    }

    /**
     * 比特币确认
     * @param playerRechargeVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping("/bitCoinConfirm")
    @ResponseBody
    @Token(valid = true)
    public Map<String, Object> bitCoinConfirm(PlayerRechargeVo playerRechargeVo, @FormModel @Valid BitCoinPayForm form, BindingResult result) {
        boolean flag = rechargePre(result, form.get$code());
        if (!flag) {
            return getResultMsg(false, null, null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null) {
            return getResultMsg(false, null, null);
        }
        Map<String, Object> map = new HashMap<>(7, 1f);
        map.put("state", true);
        DecimalFormat format = new DecimalFormat("#.########");
        map.put("bitAmount", format.format(playerRechargeVo.getResult().getBitAmount()));
        map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        return map;
    }

    /**
     * 提交比特币
     * @param playerRechargeVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping("/bitCoinSubmit")
    @ResponseBody
    @Token(valid = true)
    @Audit(module = Module.MASTER_OPERATION, moduleType = ModuleType.PLAYER_RECHARGE, opType = OpType.CREATE)
    public Map<String, Object> bitCoinSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid BitCoinPayForm form, BindingResult result) {
        if (result.hasErrors()) {
            return getResultMsg(false, null, null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null || !BankCodeEnum.BITCOIN.getCode().equals(payAccount.getBankCode())) {
            return getResultMsg(false, null, null);
        }
        String rechargeType = RechargeTypeEnum.BITCOIN_FAST.getCode();
        playerRechargeVo.getResult().setRechargeAmount(0d);
        Map<String, Object> rtnMap = companySaveRecharge(playerRechargeVo, payAccount, rechargeType);
        //存款记录保存完成,记录各个参数日志
        if (MapTool.getBoolean(rtnMap, "state")) {
            BussAuditLogTool.addLog("PLAYER_RECHARGE",
                    MapTool.getString(rtnMap,"transactionNo"),
                    (JsonTool.toJson(playerRechargeVo.getRechargeFeeSchemaVo()) +
                            JsonTool.toJson(playerRechargeVo.getPlayerRank())).replace("{", "").replace("}", ""));
        }
        return rtnMap;
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
    @ResponseBody
    @Token(valid = true)
    @Audit(module = Module.MASTER_OPERATION, moduleType = ModuleType.PLAYER_RECHARGE, opType = OpType.CREATE)
    public Map<String, Object> atmCounterSubmit(PlayerRechargeVo playerRechargeVo, @FormModel @Valid AtmCounterForm form, BindingResult result) {
        String rechargeType = playerRechargeVo.getResult().getRechargeType();
        if (!RechargeTypeEnum.ATM_COUNTER.getCode().equals(rechargeType) && !RechargeTypeEnum.ATM_MONEY.getCode().equals(rechargeType) && !RechargeTypeEnum.ATM_RECHARGE.getCode().equals(rechargeType)) {
            rechargeType = RechargeTypeEnum.ATM_COUNTER.getCode();
        }
        Map<String, Object> rtnMap = commonCompanyRechargeSubmit(playerRechargeVo, result, rechargeType);
        //存款记录保存完成,记录各个参数日志
        if (MapTool.getBoolean(rtnMap, "state")) {
            BussAuditLogTool.addLog("PLAYER_RECHARGE",
                    MapTool.getString(rtnMap,"transactionNo"),
                    (JsonTool.toJson(playerRechargeVo.getRechargeFeeSchemaVo()) +
                            JsonTool.toJson(playerRechargeVo.getPlayerRank())).replace("{", "").replace("}", ""));
        }
        return rtnMap;
    }

    /**
     * 远程验证存款金额是否超出
     *
     * @param rechargeAmount
     * @return
     */
    @RequestMapping("/checkAmount")
    @ResponseBody
    public boolean checkAmount(@RequestParam("result.rechargeAmount") String rechargeAmount,
                               @RequestParam("account") String account) {
        PlayerRank rank = getRank();
        double amount = NumberTool.toDouble(rechargeAmount);
        Long max = rank.getOnlinePayMax();
        Long min = rank.getOnlinePayMin();
        if ((max != null && max < amount) || (min != null && min > amount)) {
            return false;
        }
        double fee = calculateFeeSchemaAndRank(rank, amount, account,null);
        return (amount + fee) > 0;
    }

    /**
     * 获取公司入款收款账号（根据固定顺序获取收款账户）
     *
     * @param accounts
     * @return
     */
    private List<PayAccount> getCompanyPayAccount(List<PayAccount> accounts) {
        List<String> bankCodes = new ArrayList<>();
        List<PayAccount> payAccounts = new ArrayList<>();
        for (PayAccount payAccount : accounts) {
            if (!bankCodes.contains(payAccount.getBankCode())) {
                payAccounts.add(payAccount);
                bankCodes.add(payAccount.getBankCode());
            }
        }
        return payAccounts;
    }


    private List<PayAccount> getCompanyPayAccounts(List<PayAccount> accounts) {
        Map<String, Integer> countMap = new HashMap<>();
        Map<String, String> i18n = I18nTool.getDictMapByEnum(SessionManager.getLocale(), DictEnum.BANKNAME);
        Map<String, List<PayAccount>> accountMap = CollectionTool.groupByProperty(accounts, PayAccount.PROP_BANK_CODE, String.class);
        for (PayAccount payAccount : accounts) {
            if (StringTool.isBlank(payAccount.getAliasName())) {
                String bankCode = payAccount.getBankCode();
                if (countMap.get(bankCode) == null) {
                    countMap.put(bankCode, 1);
                } else {
                    countMap.put(bankCode, countMap.get(bankCode) + 1);
                }
                if (BankCodeEnum.OTHER.getCode().equals(bankCode) || BankCodeEnum.OTHER_BANK.getCode().equals(bankCode)) {
                    payAccount.setAliasName(payAccount.getCustomBankName());
                } else {
                    if (accountMap.get(bankCode).size() > 1) {
                        payAccount.setAliasName(i18n.get(bankCode) + countMap.get(bankCode));
                    } else {
                        payAccount.setAliasName(i18n.get(bankCode));
                    }
                }
            }
        }
        return accounts;
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
        return ServiceSiteTool.playerRechargeService().isExistsTxId(listVo);
    }

    /**
     * 模拟存款后播放声音
     * @param playerRechargeVo
     * @return
     */
    @RequestMapping("/testDepositVoice")
    @ResponseBody
    public Map<String, Object> testDepositVoice(PlayerRechargeVo playerRechargeVo) {
        if(SystemTool.isDebug()){
            playerRechargeVo.getSearch().setId(1009306);
            playerRechargeVo = ServiceSiteTool.playerRechargeService().get(playerRechargeVo);
            tellerReminder(playerRechargeVo);
        }
        return null;
    }

}
