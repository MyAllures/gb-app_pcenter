package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.CollectionQueryTool;
import org.soul.commons.collections.CollectionTool;
import org.soul.commons.currency.CurrencyTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.RandomStringTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.commons.query.Criteria;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.query.sort.Order;
import org.soul.model.comet.vo.MessageVo;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.session.SessionKey;
import org.soul.model.sys.po.SysParam;
import org.soul.web.session.SessionManagerBase;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceActivityTool;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService;
import so.wwb.gamebox.model.Module;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteI18nEnum;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.Const;
import so.wwb.gamebox.model.common.MessageI18nConst;
import so.wwb.gamebox.model.common.notice.enums.CometSubscribeType;
import so.wwb.gamebox.model.company.po.Bank;
import so.wwb.gamebox.model.company.setting.po.SysCurrency;
import so.wwb.gamebox.model.company.site.po.SiteCustomerService;
import so.wwb.gamebox.model.company.site.po.SiteI18n;
import so.wwb.gamebox.model.master.content.enums.PayAccountStatusEnum;
import so.wwb.gamebox.model.master.content.po.PayAccount;
import so.wwb.gamebox.model.master.content.so.PayAccountSo;
import so.wwb.gamebox.model.master.content.vo.PayAccountListVo;
import so.wwb.gamebox.model.master.content.vo.PayAccountVo;
import so.wwb.gamebox.model.master.dataRight.DataRightModuleType;
import so.wwb.gamebox.model.master.dataRight.vo.SysUserDataRightListVo;
import so.wwb.gamebox.model.master.enums.ActivityTypeEnum;
import so.wwb.gamebox.model.master.enums.PayAccountType;
import so.wwb.gamebox.model.master.enums.RankFeeType;
import so.wwb.gamebox.model.master.enums.TransactionOriginEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.RechargeTypeParentEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerRecharge;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeListVo;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.model.master.operation.po.VActivityMessage;
import so.wwb.gamebox.model.master.operation.vo.VActivityMessageListVo;
import so.wwb.gamebox.model.master.operation.vo.VActivityMessageVo;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.token.TokenHandler;
import so.wwb.gamebox.web.passport.captcha.CaptchaUrlEnum;

import java.util.*;

/**
 * Created by cherry on 16-9-11.
 */
public abstract class RechargeBaseController {
    private static Log LOG = LogFactory.getLog(RechargeBaseController.class);
    /*支付宝*/
    public static final String ALIPAY = "alipay";
    /*微信支付*/
    public static final String WECHATPAY = "wechatpay";
    /*QQ钱包*/
    public static final String QQWALLET = "qqwallet";
    /*比特币支付*/
    public static final String BITCOIN = "bitcoin";
    /*存款次数超3次，需输入验证码*/
    private static final int RECHARGE_COUNT = 3;
    /*清零存款订单提交次数间隔时间(以分钟为单位)*/
    private static final int RECHARGE_TIME = 30;

    /**
     * 验证码校验
     *
     * @param code
     * @return
     */
    public boolean checkCaptcha(@RequestParam("code") String code) {
        return !StringTool.isEmpty(code) && code.equalsIgnoreCase((String) SessionManager.getAttribute(SessionKey.S_CAPTCHA_PREFIX + CaptchaUrlEnum.CODE_RECHARGE.getSuffix()));
    }

    /**
     * 计算手续费
     *
     * @param rechargeAmount
     * @return
     */
    @RequestMapping("/counterFee")
    @ResponseBody
    public Map<String, Object> counterFee(@RequestParam("result.rechargeAmount") String rechargeAmount, @RequestParam("type") String type) {
        double amount = NumberTool.toDouble(rechargeAmount);
        double fee = calculateFee(getRank(), amount);
        Map<String, Object> map = new HashMap<>();
        map.put("counterFee", getCurrencySign() + CurrencyTool.formatCurrency(Math.abs(fee)));
        map.put("fee", fee);
        map.put("sales", searchSaleByAmount(amount, type));
        return map;
    }

    /**
     * 计算手续费
     *
     * @param rechargeAmount 存款金额
     * @return
     */
    public double calculateFee(PlayerRank rank, double rechargeAmount) {
        if (rank == null) {
            return 0d;
        }
        //手续费标志
        boolean isFee = !(rank.getIsFee() == null || !rank.getIsFee());
        //返手续费标志
        boolean isReturnFee = !(rank.getIsReturnFee() == null || !rank.getIsReturnFee());
        if (!isFee && !isReturnFee) {
            return 0d;
        }
        if (isReturnFee && rechargeAmount < rank.getReachMoney()) {
            return 0d;
        }
        // 规定时间内存款次数
        long count = getDepositCountInTime(rank, isFee, isReturnFee);
        if (isFee && rank.getFreeCount() != null && count < rank.getFreeCount()) {
            return 0d;
        }
        if (isReturnFee && rank.getReturnFeeCount() != null && count >= rank.getReturnFeeCount()) {
            return 0d;
        }
        double fee = 0d;
        if (isFee && rank.getFeeMoney() != null) {
            fee = computeFee(rank.getFeeType(), rank.getFeeMoney(), rechargeAmount, rank.getMaxFee());
        } else if (isReturnFee && rank.getReturnMoney() != null) {
            fee = computeFee(rank.getReturnType(), rank.getReturnMoney(), rechargeAmount, rank.getMaxReturnFee());
        }
        if (isFee) {
            fee = -Math.abs(fee);
        } else {
            fee = Math.abs(fee);
        }
        return fee;
    }

    /**
     * 按计算手续费方式计算手续费
     *
     * @param feeType        计算手续费方式：按比例、固定
     * @param feeMoney       收取手续费固定值
     * @param rechargeAmount 存款金额
     * @param maxFee         手续费最大值
     * @return
     */
    private double computeFee(String feeType, Double feeMoney, double rechargeAmount, Double maxFee) {
        double fee = 0d;
        if (RankFeeType.PROPORTION.getCode().equals(feeType)) {
            fee = rechargeAmount * feeMoney / 100.0;
        } else if (RankFeeType.FIXED.getCode().equals(feeType)) {
            fee = feeMoney;
        }
        if (maxFee != null && fee > maxFee) {
            fee = maxFee;
        }
        return fee;
    }


    /**
     * 计算在层级设置的符合免手续费的存款次数
     *
     * @param rank        玩家层级
     * @param isFee       手续费标志
     * @param isReturnFee 返手续费标志
     * @return
     */
    private long getDepositCountInTime(PlayerRank rank, boolean isFee, boolean isReturnFee) {
        PlayerRechargeListVo listVo = new PlayerRechargeListVo();
        Date now = SessionManager.getDate().getNow();
        listVo.getSearch().setEndTime(now);
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        if (isFee && rank.getFreeCount() != null && rank.getFreeCount() > 0 && rank.getFeeTime() != null) {
            listVo.getSearch().setStartTime(DateTool.addHours(now, -rank.getFeeTime()));
        } else if (isReturnFee && rank.getReturnFeeCount() != null && rank.getReturnFeeCount() > 0 && rank.getReturnTime() != null) {
            listVo.getSearch().setStartTime(DateTool.addHours(now, -rank.getReturnTime()));
        }
        listVo.setRank(rank);
        return playerRechargeService().searchPlayerRechargeCount(listVo);
    }

    /**
     * 设置存款其他基础数据
     *
     * @param playerRechargeVo
     * @param rank
     * @param payAccount
     * @param rechargeTypeParent
     * @param rechargeType
     */
    public void setRechargeOtherData(PlayerRechargeVo playerRechargeVo, PlayerRank rank, PayAccount payAccount, String rechargeTypeParent, String rechargeType) {
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        playerRecharge.setRechargeTypeParent(rechargeTypeParent);
        playerRecharge.setRechargeType(rechargeType);
        playerRecharge.setCounterFee(calculateFee(rank, playerRecharge.getRechargeAmount()));
        playerRecharge.setPlayerId(SessionManager.getUserId());
        playerRecharge.setMasterBankType(payAccount.getAccountType());
        playerRecharge.setPayAccountId(payAccount.getId());
        if (StringTool.isBlank(playerRecharge.getPayerBank())) {
            playerRecharge.setPayerBank(payAccount.getBankCode());
        }
        playerRechargeVo.setCustomBankName(payAccount.getCustomBankName());
        //ip处理
        playerRecharge.setIpDeposit(SessionManagerBase.getIpDb().getIp());
        playerRecharge.setIpDictCode(SessionManagerBase.getIpDictCode());
    }

    /**
     * 保存存款数据
     *
     * @param playerRechargeVo
     * @param payAccount
     * @param rechargeTypeParent
     * @param rechargeType
     * @return
     */
    public PlayerRechargeVo saveRecharge(PlayerRechargeVo playerRechargeVo, PayAccount payAccount, String rechargeTypeParent, String rechargeType) {
        playerRechargeVo.setPayAccount(payAccount);
        PlayerRank rank = getRank();
        //设置存款其他数据
        setRechargeOtherData(playerRechargeVo, rank, payAccount, rechargeTypeParent, rechargeType);
        playerRechargeVo.setSysUser(SessionManager.getUser());
        playerRechargeVo.setOrigin(TransactionOriginEnum.PC.getCode());
        playerRechargeVo.setRankId(rank.getId());
        //存款总额（存款金额+手续费）>0才能继续执行(比特币支付例外)
        PlayerRecharge playerRecharge = playerRechargeVo.getResult();
        if ((playerRecharge.getCounterFee() + playerRecharge.getRechargeAmount() <= 0) && !RechargeTypeEnum.BITCOIN_FAST.getCode().equals(playerRecharge.getRechargeType())) {
            playerRechargeVo.setSuccess(false);
            playerRechargeVo.setErrMsg(LocaleTool.tranMessage(Module.FUND.getCode(), MessageI18nConst.RECHARGE_AMOUNT_LT_FEE));
            return playerRechargeVo;
        }
        //上分消费用到收款账号
        playerRechargeVo.setPayAccount(payAccount);
        //保存订单
        return playerRechargeService().savePlayerRecharge(playerRechargeVo);
    }

    /**
     * 查询玩家可选择的存款渠道
     *
     * @param type String
     */
    public List<Bank> searchBank(String type) {
        Map<String, Bank> bankMap = Cache.getBank();
        return CollectionQueryTool.query(bankMap.values(), Criteria.add(Bank.PROP_TYPE, Operator.EQ, type), Order.asc(Bank.PROP_ORDER_NUM));
    }

    /**
     * 查询收款账号
     */
    public List<PayAccount> searchPayAccount(PayAccountListVo payAccountListVo, Boolean supportAtmCounter, String[] accountTypes) {
        PayAccountSo payAccountSo = payAccountListVo.getSearch();
        Map<String, Object> map = new HashMap<>(7, 1f);
        map.put("playerId", SessionManager.getUserId());
        map.put("type", payAccountSo.getType());
        map.put("accountType", payAccountSo.getAccountType());
        map.put("currency", SessionManager.getUser().getDefaultCurrency());
        map.put("terminal", payAccountSo.getTerminal());
        map.put("supportAtmCounter", supportAtmCounter);
        map.put("accountTypes", accountTypes);
        map.put(PayAccount.PROP_BANK_CODE, payAccountSo.getBankCode());
        payAccountListVo.setConditions(map);
        return ServiceSiteTool.payAccountService().searchPayAccountByRank(payAccountListVo);
    }

    /**
     * 查询收款账号
     */
    public List<PayAccount> searchPayAccount(String type, String accountType, String terminal, Boolean supportAtmCounter, String[] accountTypes) {
        PayAccountListVo listVo = new PayAccountListVo();
        Map<String, Object> map = new HashMap<>(7, 1f);
        map.put("playerId", SessionManager.getUserId());
        map.put("type", type);
        map.put("accountType", accountType);
        map.put("currency", SessionManager.getUser().getDefaultCurrency());
        if (StringTool.isNotBlank(terminal)) {
            map.put("terminal", terminal);
        }
        map.put("supportAtmCounter", supportAtmCounter);
        map.put("accountTypes", accountTypes);
        //map.put(PayAccount.PROP_BANK_CODE,)
        listVo.setConditions(map);
        return ServiceSiteTool.payAccountService().searchPayAccountByRank(listVo);
    }

    /**
     * 查询收款账号(无终端)
     *
     * @param type
     * @param accountType
     * @return
     */
    public List<PayAccount> searchPayAccount(String type, String accountType, Boolean supportAtmCounter) {
        return searchPayAccount(type, accountType, null, supportAtmCounter, null);
    }

    /**
     * 获取优惠
     *
     * @param type
     * @return
     */
    public List<VActivityMessage> searchSales(String type) {
        if (StringTool.isBlank(type)) {
            return null;
        }
        VActivityMessageListVo listVo = new VActivityMessageListVo();
        listVo.getSearch().setDepositWay(type);
        listVo = playerRechargeService().searchSale(listVo, SessionManager.getUserId());
        return setClassifyKeyName(listVo.getResult());
    }

    /**
     * 根据存款金额、存款方式获取优惠
     *
     * @param rechargeAmount
     * @param type
     * @return
     */
    public List<VActivityMessage> searchSaleByAmount(Double rechargeAmount, String type) {
        UserPlayer userPlayer = getUserPlayer();
        VActivityMessageVo vActivityMessageVo = new VActivityMessageVo();
        vActivityMessageVo.getSearch().setDepositWay(type);
        vActivityMessageVo.setDepositAmount(rechargeAmount);
        vActivityMessageVo.setRankId(userPlayer.getRankId());
        vActivityMessageVo.setLocal(SessionManager.getLocale().toString());
        vActivityMessageVo = ServiceActivityTool.vActivityMessageService().searchDepositPromotions(vActivityMessageVo);
        LinkedHashSet<VActivityMessage> vActivityMessages = vActivityMessageVo.getvActivityMessageList();
        if (CollectionTool.isEmpty(vActivityMessages)) {
            return new ArrayList<>();
        }
        //如果玩家首存可同时显示首存送和存就送
        if (userPlayer.getIsFirstRecharge() != null && userPlayer.getIsFirstRecharge()) {
            return setClassifyKeyName(new ArrayList(vActivityMessages));
        }
        //玩家非首存，查询存就送优惠
        List<VActivityMessage> activityList = CollectionQueryTool.query(vActivityMessages, Criteria.add(VActivityMessage.PROP_CODE, Operator.EQ, ActivityTypeEnum.DEPOSIT_SEND.getCode()));
        return setClassifyKeyName(activityList);
    }

    /**
     * 设置分类
     *
     * @param vActivityMessages
     * @return
     */
    private List<VActivityMessage> setClassifyKeyName(List<VActivityMessage> vActivityMessages) {
        Map<String, SiteI18n> siteI18nMap = Cache.getOperateActivityClassify();
        StringBuffer stringBuffer;
        for (VActivityMessage message : vActivityMessages) {
            stringBuffer = new StringBuffer();
            stringBuffer.append(message.getActivityClassifyKey()).append(":").append(SessionManager.getLocale());
            if (siteI18nMap != null && siteI18nMap.get(stringBuffer.toString()) != null) {
                message.setClassifyKeyName(siteI18nMap.get(stringBuffer.toString()).getValue());
            }
        }
        return vActivityMessages;
    }

    /**
     * 设置线上支付（含微信、支付宝）的session最后一次存款时间及次数
     */
    public void setRechargeCount() {
        Date date = SessionManager.getRechargeLastTime();
        Date nowDate = SessionManager.getDate().getNow();
        if (date == null) {
            SessionManager.setRechargeCount(1);
        } else if (DateTool.minutesBetween(date, nowDate) > RECHARGE_TIME) {
            SessionManager.setRechargeCount(1);
        } else {
            SessionManager.setRechargeCount(SessionManager.getRechargeCount() + 1);
        }
        SessionManager.setRechargeLastTime(nowDate);
    }

    /**
     * 获取主货币符号
     *
     * @return
     */
    public String getCurrencySign() {
        String defaultCurrency = SessionManager.getUser().getDefaultCurrency();
        if (StringTool.isBlank(defaultCurrency)) {
            return "";
        }
        SysCurrency sysCurrency = Cache.getSysCurrency().get(defaultCurrency);
        if (sysCurrency != null) {
            return sysCurrency.getCurrencySign();
        }
        return "";
    }

    /**
     * 获取玩家信息
     *
     * @return
     */
    public UserPlayer getUserPlayer() {
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceSiteTool.userPlayerService().get(userPlayerVo);
        return userPlayerVo.getResult();
    }

    /**
     * 获取玩家层级
     *
     * @return
     */
    public PlayerRank getRank() {
        SysUserVo vo = new SysUserVo();
        vo.getSearch().setId(SessionManager.getUserId());
        return ServiceSiteTool.playerRankService().searchRankByPlayerId(vo);
    }

    /**
     * 判断是否需要弹真实姓名弹窗
     *
     * @return
     */
    public boolean isRealName() {
        SysUser sysUser = SessionManager.getUser();
        return StringTool.isBlank(sysUser.getRealName());
    }

    /**
     * 根据id获取收款账号
     *
     * @param payAccountId
     * @return
     */
    public PayAccount getPayAccount(Integer payAccountId) {
        PayAccountVo payAccountVo = new PayAccountVo();
        payAccountVo.getSearch().setId(payAccountId);
        payAccountVo = ServiceSiteTool.payAccountService().get(payAccountVo);
        return payAccountVo.getResult();
    }

    /**
     * 获取默认客服
     *
     * @return
     */
    public String getCustomerService() {
        SiteCustomerService siteCustomerService = Cache.getDefaultCustomerService();
        if (siteCustomerService == null) {
            return null;
        }
        String url = siteCustomerService.getParameter();
        if (StringTool.isNotBlank(url) && !url.contains("http")) {
            url = "http://" + url;
        }
        return url.replace("\r\n","");
    }

    /**
     * 存款前奏：判断是否符合条件(表单验证、验证码验证)
     *
     * @param result
     * @param code
     * @return
     */
    public boolean rechargePre(BindingResult result, String code) {
        if (result.hasErrors()) {
            LOG.error("提交存款表单不通过{0}", result.toString());
            return false;
        }
        int rechargeCount = SessionManager.getRechargeCount();
        return !(rechargeCount >= RECHARGE_COUNT && !checkCaptcha(code));
    }

    public IPlayerRechargeService playerRechargeService() {
        return ServiceSiteTool.playerRechargeService();
    }

    /**
     * 是否隐藏收款账号
     *
     * @param model
     */
    public void isHide(Model model, SiteParamEnum paramEnum) {
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

    public PayAccount getPayAccountBySearchId(String searchId) {
        PayAccountVo payAccountVo = new PayAccountVo();
        payAccountVo.setSearchId(searchId);
        payAccountVo = ServiceSiteTool.payAccountService().get(payAccountVo);
        PayAccount payAccount = payAccountVo.getResult();
        if (payAccount != null && !PayAccountStatusEnum.USING.getCode().equals(payAccount.getStatus())) {
            LOG.info("账号{0}已停用,故返回收款账号null", payAccount.getPayName());
            return null;
        }
        return payAccount;
    }

    /**
     * 收款账号支持随机金额，重新获取随机金额
     *
     * @param payAccount
     * @param playerRecharge
     * @return
     */
    public Double getRechargeAmount(PayAccount payAccount, PlayerRecharge playerRecharge) {
        Double rechargeAmount = playerRecharge.getRechargeAmount();
        if (payAccount != null && payAccount.getRandomAmount() != null && payAccount.getRandomAmount() && rechargeAmount.intValue() == rechargeAmount) {
            double random = Double.parseDouble(RandomStringTool.random(2, 11, 99, false, true)) * 0.01;
            if (random < 0.11) {
                random += 0.11;
            }
            rechargeAmount += random;
        }
        return rechargeAmount;
    }

    /**
     * 线上支付（含扫码支付）提交公共方法
     *
     * @param playerRechargeVo
     * @param payAccount
     * @return
     */
    public Map<String, Object> commonOnlineSubmit(PlayerRechargeVo playerRechargeVo, PayAccount payAccount) {
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

    public Map<String, Object> getResultMsg(boolean isSuccess, String msg, String transactionNo) {
        Map<String, Object> map = new HashMap<>(3, 1f);
        map.put("state", isSuccess);
        if (isSuccess) {
            map.put("transactionNo", transactionNo);
        } else {
            map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        }
        if (StringTool.isNotBlank(msg)) {
            map.put("msg", msg);
        }
        return map;
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
        List<Integer> userIdByUrl = ServiceSiteTool.sysUserDataRightService().searchPlayerDataRightEntityId(sysUserDataRightListVo);
        userIdByUrl.add(Const.MASTER_BUILT_IN_ID);
        message.addUserIds(userIdByUrl);
        ServiceTool.messageService().sendToMcenterMsg(message);
    }

    /**
     * 存款消息提醒发送消息给前端
     *
     * @param playerRechargeVo
     */
    public void tellerReminder(PlayerRechargeVo playerRechargeVo) {
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
        List<Integer> userIdByUrl = ServiceSiteTool.sysUserDataRightService().searchPlayerDataRightEntityId(sysUserDataRightListVo);
        userIdByUrl.add(Const.MASTER_BUILT_IN_ID);

        //判断账号是否可以查看该层级的记录 add by Bruce.QQ
//        filterUnavailableSubAccount(userIdByUrl);
        message.addUserIds(userIdByUrl);
        ServiceTool.messageService().sendToMcenterMsg(message);
    }

    /**
     * 存款确认弹窗显示信息内容
     *
     * @param playerRechargeVo
     * @return
     */
    public Map<String, Object> companyRechargeConfirmInfo(PlayerRechargeVo playerRechargeVo) {
        PlayerRank rank = getRank();
        Double rechargeAmount = playerRechargeVo.getResult().getRechargeAmount();
        double fee = calculateFee(rank, rechargeAmount);
        Integer failureCount = ServiceSiteTool.playerRechargeService().statisticalFailureCount(playerRechargeVo,SessionManager.getUserId());
        Map<String, Object> map = new HashMap<>(7, 1f);
        map.put("state", true);
        map.put("fee", fee);
        map.put("formatFee", CurrencyTool.formatCurrency(fee));
        map.put("rechargeAmount", CurrencyTool.formatCurrency(rechargeAmount));
        map.put("rechargeTotal", CurrencyTool.formatCurrency(rechargeAmount + fee));
        map.put("isThird", true);
        map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        map.put("failureCount",failureCount);
        return map;
    }

    /**
     * 公共的公司入款存款提交方法
     *
     * @param playerRechargeVo
     * @param result
     * @param rechargeType
     * @return
     */
    public Map<String, Object> commonCompanyRechargeSubmit(PlayerRechargeVo playerRechargeVo, BindingResult result, String rechargeType) {
        if (result.hasErrors()) {
            LOG.info("存款参数有误");
            return getResultMsg(false, null, null);
        }
        PayAccount payAccount = getPayAccountBySearchId(playerRechargeVo.getAccount());
        if (payAccount == null || PayAccountType.ONLINE_ACCOUNT_CODE.equals(payAccount.getType())) {
            LOG.info("收款账号有误");
            return getResultMsg(false, null, null);
        }
        return companySaveRecharge(playerRechargeVo, payAccount, rechargeType);
    }

    /**
     * 保存公司入款
     *
     * @param playerRechargeVo
     * @param payAccount
     * @param rechargeType
     * @return
     */
    public Map<String, Object> companySaveRecharge(PlayerRechargeVo playerRechargeVo, PayAccount payAccount, String rechargeType) {
        playerRechargeVo = saveRecharge(playerRechargeVo, payAccount, RechargeTypeParentEnum.COMPANY_DEPOSIT.getCode(), rechargeType);
        if (playerRechargeVo.isSuccess()) {
            tellerReminder(playerRechargeVo);
            //设置session相关存款数据
            setRechargeCount();
        }
        return getResultMsg(playerRechargeVo.isSuccess(), null, null);
    }
}
