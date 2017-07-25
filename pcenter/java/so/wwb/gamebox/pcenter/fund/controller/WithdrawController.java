package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.MapTool;
import org.soul.commons.currency.CurrencyTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.commons.net.ServletTool;
import org.soul.commons.support._Module;
import org.soul.model.comet.vo.MessageVo;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.sys.po.SysParam;
import org.soul.web.session.SessionManagerBase;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.Const;
import so.wwb.gamebox.model.master.dataRight.DataRightModuleType;
import so.wwb.gamebox.model.master.dataRight.po.SysUserDataRight;
import so.wwb.gamebox.model.master.dataRight.vo.SysUserDataRightListVo;
import so.wwb.gamebox.model.master.dataRight.vo.SysUserDataRightVo;
import so.wwb.gamebox.model.master.enums.RankFeeType;
import so.wwb.gamebox.model.master.enums.TransactionOriginEnum;
import so.wwb.gamebox.model.master.enums.UserTaskEnum;
import so.wwb.gamebox.model.master.fund.enums.FundTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.TransactionTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.WithdrawStatusEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerWithdraw;
import so.wwb.gamebox.model.master.fund.vo.PlayerWithdrawVo;
import so.wwb.gamebox.model.master.fund.vo.VPcenterWithdrawVo;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.model.master.player.po.PlayerTransaction;
import so.wwb.gamebox.model.master.player.po.UserBankcard;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.*;
import so.wwb.gamebox.model.master.tasknotify.vo.UserTaskReminderVo;
import so.wwb.gamebox.pcenter.fund.form.AddBankcardForm;
import so.wwb.gamebox.pcenter.fund.form.SettingRealNameForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.bank.BankHelper;
import so.wwb.gamebox.web.common.token.Token;
import so.wwb.gamebox.web.common.token.TokenHandler;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.text.DecimalFormat;
import java.util.*;

/**
 * 控制器
 *
 * @author orange
 * @time 2015-10-20 16:12:04
 */
@Controller
@RequestMapping("/player/withdraw")
public class WithdrawController {

    private static final Log LOG = LogFactory.getLog(WithdrawController.class);

    //添加银行卡
    private static final String INTO_BANKCARD = "fund/withdraw/IntoBankcard";
    //进入取款页面
    private static final String WITHDRAW_INDEX = "fund/withdraw/Index";
    //正在努力计算中
    private static final String WITHDRAW_CALCULATION = "fund/withdraw/Calculation";
    //成功弹窗
    private static final String WITHDRAW_SUCCESS_DIALOG = "fund/withdraw/WithdrawSuccessDialog";
    //失败弹窗
    private static final String WITHDRAW_FAIL_DIALOG = "fund/withdraw/WithdrawFailDialog";
    //取款次数24小时不能超过3次
    private static final String WITHDRAW_COUNT_MAX = "fund/withdraw/WithdrawCountMax";
    //拜托财务姐姐帮忙手动核算
    private static final String WITHDRAW_NO_AUDIT = "fund/withdraw/NoAudit";
    //站长中心-玩家取款审核url
    private static final String MCENTER_PLAYER_WITHDRAW_URL = "fund/withdraw/withdrawAuditView.html";

    private String getViewBasePath() {
        return "fund/withdraw/";
    }

    /**
     * 进入首页玩家中心是否有待处理的取款订单
     */
    @RequestMapping("/searchPlayerWithdraw")
    @ResponseBody
    public Map searchPlayerWithdraw() {
        Map<String, Object> map = new HashMap<>();
        PlayerWithdraw withdraw = getPlayerWithdraw();

        // 在玩家中心显示是否继续取款
        if (withdraw != null) {
            map.put("withdrawId", withdraw.getId());
            map.put("state", true);
        } else {
            map.put("state", false);
        }
        return map;
    }

    /**
     * 获取玩家取款信息
     *
     * @return 玩家取款信息
     */
    private PlayerWithdraw getPlayerWithdraw() {
        PlayerWithdrawVo vo = new PlayerWithdrawVo();
        if (SessionManager.getUserId() != null) {
            vo.getSearch().setPlayerId(SessionManager.getUserId());
            vo.getSearch().setWithdrawStatus(WithdrawStatusEnum.PENDING_SUB.getCode());
            vo = ServiceTool.playerWithdrawService().search(vo);
        }
        return vo.getResult();
    }

    /**
     * 进入取款页面
     */
    @RequestMapping({"/withdrawList"})
    @Token(generate = true)
    protected String withdrawList(HttpServletRequest request, VPcenterWithdrawVo withdrawVo, Model model) {
        // 表单校验
        model.addAttribute("validate", JsRuleCreator.create(AddBankcardForm.class));
        // 获取用户信息
        model.addAttribute("user", getUser(model));

        // 是否设置收款账号
        UserBankcard bankcard = BankHelper.getUserBankcard();
        UserBankcardVo userBankcardVo = new UserBankcardVo();
        userBankcardVo.setResult(bankcard);
        model.addAttribute("userBankcardVo", userBankcardVo);
        SysParam sysParam = ParamTool.getSysParam(SiteParamEnum.SETTING_SYSTEM_SETTINGS_IS_LOTTERY_SITE);
        model.addAttribute("isLottery",sysParam);
        if (bankcard != null) {
            if("true".equals(sysParam.getParamValue())){
                fetchUserBalanceFromApi();
            }

            //查询是否已存在取款订单
            Long existence = isExistence();
            model.addAttribute("playerWithdrawExist", existence);
            if (existence > 0) {
                return ServletTool.isAjaxSoulRequest(request) ? WITHDRAW_INDEX + "Partial" : WITHDRAW_INDEX;
            }
            //余额冻结
            UserPlayer player = getPlayer();
            model.addAttribute("player", player);
            boolean flag = player.getBalanceFreezeEndTime() != null && player.getBalanceFreezeEndTime().getTime() > new Date().getTime();
            model.addAttribute("balanceFreezen", flag);
            if (flag) {
                return ServletTool.isAjaxSoulRequest(request) ? WITHDRAW_INDEX + "Partial" : WITHDRAW_INDEX;
            }
            //层级上下限金额
            model.addAttribute("rank", getRank(player));

            //取款信息
            withdrawVo.getSearch().setId(SessionManager.getUserId());
            withdrawVo = ServiceTool.vPcenterWithdrawService().search(withdrawVo);
            model.addAttribute("command", withdrawVo);
            Map auditMap = getAuditMap();
            model.addAttribute("auditMap", auditMap);
            return ServletTool.isAjaxSoulRequest(request) ? WITHDRAW_INDEX + "Partial" : WITHDRAW_INDEX;

        } else {
            model.addAttribute("bankListVo", BankHelper.getBankListVo());
            model.addAttribute("type", "withdraw");
            return INTO_BANKCARD;
        }
    }

    private void fetchUserBalanceFromApi(){
        try{
            UserPlayerVo userPlayerVo = new UserPlayerVo();
            userPlayerVo.getSearch().setId(SessionManager.getUserId());
            userPlayerVo = ServiceTool.userPlayerService().fetchUserBalanceFromApi(userPlayerVo);
            LOG.info("更新玩家余额是否成功:{0}",userPlayerVo.isSuccess());
        }catch (Exception ex){
            LOG.error(ex,"更新玩家余额出错");
        }
    }

    private Map getAuditMap() {
        LOG.info("进行取款稽核");
        if (SessionManager.getUserId() == null) {
            throw new RuntimeException("玩家ID不存在");
        }
        PlayerTransactionVo transactionVo = new PlayerTransactionVo();
        transactionVo.setResult(new PlayerTransaction());
        transactionVo.setPlayerId(SessionManager.getUserId());
        transactionVo.setAuditDate(new Date());
        Map transactionMap = ServiceTool.getPlayerTransactionService().getTransactionMap(transactionVo);
        return toAuditObjectMap(transactionVo, transactionMap);
    }

    /**
     * 检测卡号是否存在
     * 如果支持银行卡修改要考虑 && !isExists.getUserId().equals(SessionManager.getUserId())
     */
    @RequestMapping(value = "/checkCardIsExists")
    @ResponseBody
    public String checkCardIsExists(@RequestParam("result.bankcardNumber") String bankcardNumber) {
        UserBankcardVo vo = new UserBankcardVo();
        vo.getSearch().setBankcardNumber(bankcardNumber);
        UserBankcard isExists = ServiceTool.userBankcardService().cardIsExists(vo);
        if (isExists != null && isExists.getIsDefault()) {
            return "false";
        }
        return "true";
    }

    /**
     * 获取收款账号信息 用于兼容 userBankcardVo
     *
     * @return 账号信息
     */
    private UserBankcard getBankcard() {
        if (SessionManager.getUserId() == null) {
            return null;
        }
        UserBankcardVo bankcardVo = new UserBankcardVo();
        bankcardVo.setResult(new UserBankcard());
        bankcardVo.getSearch().setUserId(SessionManager.getUserId());
        bankcardVo.getSearch().setIsDefault(true);
        bankcardVo = ServiceTool.userBankcardService().search(bankcardVo);
        return bankcardVo.getResult();
    }

    /**
     * 获取玩家信息
     *
     * @return 玩家信息
     */
    private UserPlayer getPlayer() {
        if (SessionManager.getUserId() == null) {
            return null;
        }
        UserPlayerVo playerVo = new UserPlayerVo();
        playerVo.setResult(new UserPlayer());
        playerVo.getSearch().setId(SessionManager.getUserId());
        playerVo = ServiceTool.userPlayerService().get(playerVo);
        return playerVo.getResult();
    }

    /**
     * 获取玩家层级
     *
     * @param player 玩家
     * @return 层级信息
     */
    private PlayerRank getRank(UserPlayer player) {
        if (player == null || player.getRankId() == null) {
            return null;
        }
        PlayerRankVo rankVo = new PlayerRankVo();
        rankVo.setResult(new PlayerRank());
        rankVo.getSearch().setId(player.getRankId());
        rankVo = ServiceTool.playerRankService().get(rankVo);
        return rankVo.getResult();
    }

    /**
     * 查询是否已存在取款订单
     */
    private Long isExistence() {
        //如果session不存在，不让取款
        if (SessionManager.getUserId() == null) {
            LOG.info("session不存在");
            return 1l;
        }
        PlayerWithdrawVo playerWithdrawVo = new PlayerWithdrawVo();
        playerWithdrawVo.setResult(new PlayerWithdraw());
        playerWithdrawVo.getSearch().setPlayerId(SessionManager.getUserId());
        Long aLong = ServiceTool.playerWithdrawService().existPlayerWithdrawCount(playerWithdrawVo);
        LOG.info("是否存在未取款订单:" + aLong);
        return aLong;
    }

    @RequestMapping("/pleaseWithdraw")
    @ResponseBody
    @Token(valid = true)
    public Map pleaseWithdraw(PlayerTransactionVo transactionVo, Model model, PlayerWithdraw playerWithdraw) {
        Map result = new HashMap();
        try {
            Long length = isExistence();
            if (length == 0) {
                LOG.info("玩家{0}开始取款", SessionManager.getUserName());
                result = toWithdraw(transactionVo, model);
            } else {
                LOG.info("已存在取款订单");
                result.put("state", false);
                result.put("msg", "已存在取款订单");
                result.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
                model.addAttribute("errmsg", "已存在取款订单");
            }
        } catch (Exception ex) {
            LOG.error(ex, "申请取款出错");
            result.put("state", false);
            result.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        }
        if (result.get("state") != null && MapTool.getBoolean(result, "state")) {
            // 生成任务提醒
            LOG.info("生成任务提醒");
            PlayerWithdrawVo withdrawVo = new PlayerWithdrawVo();
            if (playerWithdraw == null) {
                playerWithdraw = new PlayerWithdraw();
            }
            withdrawVo.setResult(playerWithdraw);
            withdrawVo.getResult().setTransactionNo(MapTool.getString(result, "transactionNo"));
            tellerReminder(withdrawVo);//发送提醒消息给站长中心
        } else {
            result.put("state", false);
            result.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        }

        return result;
    }

    private PlayerTransactionVo insertTransactionData(PlayerTransactionVo transactionVo) {
        SysUser user = SessionManager.getUser();
        if (user == null) {
            LOG.info("SESSION为空");
            throw new RuntimeException("玩家不在线");
        }
        //添加交易表和取款表数据
        transactionVo.setSuccess(false);
        transactionVo.setSysUser(user);
        transactionVo.getResult().setOrigin(TransactionOriginEnum.PC.getCode());

        //ip处理
        transactionVo.setIpWithdraw(SessionManagerBase.getIpDb().getIp());
        transactionVo.setIpDictCode(SessionManagerBase.getIpDictCode());

        LOG.info("开始插入取款数据");
        transactionVo = ServiceTool.getPlayerTransactionService().insertData(transactionVo);
        LOG.info("插入取款数据结束：{0}", transactionVo.isSuccess());
        return transactionVo;
    }

    /**
     * 进入取款页面
     */
    private Map toWithdraw(PlayerTransactionVo transactionVo, Model model) {
        Map result = new HashMap();
        // 判断取款次数24小时不能超过3次
        UserPlayer player = getPlayer();
        if (player == null) {
            LOG.info("获取玩家信息为空");
            result.put("state", false);
            return result;
        } else {
            LOG.info("取款玩家ID为:{0}", player.getId());
        }
        PlayerRank rank = getRank(player);
        if (rank == null) {
            LOG.info("获取层级信息为空");
            result.put("state", false);
            return result;
        }
        UserBankcard bankcard = getBankcard();
        if (bankcard == null) {
            LOG.info("获取银行卡信息为空");
            result.put("state", false);
            return result;
        }
        transactionVo.setUserBankcard(bankcard);
        // 取款金额
        Double amount = transactionVo.getWithdrawAmount();
        LOG.info("玩家{0}取款金额：{1}", SessionManager.getUserName(), amount);
        if (amount == null) {
            result.put("state", false);
            return result;
        }
        // 手续费
        double poundage = getPoundage(amount, rank);
        LOG.info("计算出玩家{0}需要手续费：{1}", SessionManager.getUserName(), poundage);
        Map auditMap = getAuditMap();

        double administrativeFee = MapTool.getDouble(auditMap, "administrativeFee");
        double deductFavorable = MapTool.getDouble(auditMap, "deductFavorable");
        LOG.info("玩家{0}需扣除行政费用：{1}和扣除优惠：{2}", SessionManager.getUserName(), administrativeFee, deductFavorable);
        DecimalFormat df = new DecimalFormat("#.00");
        poundage = Double.valueOf(df.format(poundage));
        administrativeFee = Double.valueOf(df.format(administrativeFee));
        deductFavorable = Double.valueOf(df.format(deductFavorable));
        double withdrawAmount = amount - poundage - administrativeFee - deductFavorable;
        LOG.info("玩家{0}最终可取款金额：{1}", SessionManager.getUserName(), withdrawAmount);
        if (withdrawAmount <= 0) {
            result = setErrorMsg(result, "withdrawForm.withdrawAmountZero");
            return result;
        }

        // 玩家账户余额 >= 取款金额 + 手续费
        if (player != null && player.getWalletBalance() >= amount && (amount > poundage) && bankcard != null) {
            setTransactionMoney(transactionVo, amount, poundage, administrativeFee, deductFavorable, withdrawAmount);
            // 判断是否启用取款限制
            if (rank != null && rank.getIsWithdrawLimit()) {
                // 24H内已取款次数
                Integer count = get24HHasCount();
                if (count < rank.getWithdrawCount()) {
                    transactionVo = insertTransactionData(transactionVo);
                    result.put("state", transactionVo.isSuccess());
                    result.put("transactionNo", transactionVo.getResult().getTransactionNo());
                } else {    // 已达取款次数上限
                    LOG.info("24小时内取款次数已达上限{0}", rank.getWithdrawCount());
                    result = setErrorMsg(result, "withdrawForm.maxCount");
                    return result;
                }
            } else {
                transactionVo = insertTransactionData(transactionVo);
                result.put("state", transactionVo.isSuccess());
                result.put("transactionNo", transactionVo.getResult().getTransactionNo());
            }
        } else {
            result = setErrorMsg(result, "withdrawForm.balanceNotEnough");
            return result;
        }
        return result;
    }

    private Map setErrorMsg(Map result, String type) {
        String msg = LocaleTool.tranMessage("fund", type);
        result.put("state", false);
        result.put("type", type);
        return result;
    }

    /**
     * 设置取款金额手续费等
     *
     * @param transactionVo
     * @param amount
     * @param poundage
     * @param administrativeFee
     * @param deductFavorable
     * @param withdrawAmount
     */
    private void setTransactionMoney(PlayerTransactionVo transactionVo, double amount, double poundage,
                                     double administrativeFee, double deductFavorable, double withdrawAmount) {
        transactionVo.setPoundage(poundage);
        transactionVo.setActualWithdrawAmount(withdrawAmount);
        transactionVo.setResult(new PlayerTransaction());
        transactionVo.getResult().setAdministrativeFee(administrativeFee);
        transactionVo.getResult().setDeductFavorable(deductFavorable);
        transactionVo.getResult().setPlayerId(SessionManager.getUser().getId());
        transactionVo.getResult().setTransactionMoney(amount);
    }

    @RequestMapping("/showAuditLog")
    public String showAuditLog(PlayerTransactionListVo listVo, Model model) {
        //查询列表前先进行集合一下
        getAuditMap();
        List<PlayerTransaction> list = getAuditLogList(listVo);
        initAuditData(SessionManager.getUserId(), list);
        model.addAttribute("list", list);
        model.addAttribute("user", getUser(model));
        return getViewBasePath() + "AuditLog";
    }

    private void initAuditData(Integer playerId, List<PlayerTransaction> playerTransactions) {
        if (playerId == null || playerTransactions == null || playerTransactions.size() == 0) {
            return;
        }
        UserPlayer player = getPlayer();
        if (player == null || player.getRankId() == null) {
            return;
        }
        PlayerRankVo playerRankVo = new PlayerRankVo();
        playerRankVo.getSearch().setId(player.getRankId());
        playerRankVo = ServiceTool.playerRankService().get(playerRankVo);
        if (playerRankVo.getResult() == null || playerRankVo.getResult().getWithdrawNormalAudit() == null) {
            return;
        }
        for (PlayerTransaction transaction : playerTransactions) {
            if (transaction.getRechargeAuditPoints() == null && TransactionTypeEnum.DEPOSIT.getCode().equals(transaction.getTransactionType())
                    && !FundTypeEnum.ARTIFICIAL_DEPOSIT.getCode().equals(transaction.getFundType())) {
                Double rap = transaction.getTransactionMoney() * playerRankVo.getResult().getWithdrawNormalAudit();
                transaction.setRechargeAuditPoints(rap);
            }
        }
    }

    private List<PlayerTransaction> getAuditLogList(PlayerTransactionListVo listVo) {
        listVo.getSearch().setPlayerId(SessionManager.getUser().getId());
        listVo.getSearch().setCreateTime(new Date());
        return ServiceTool.getPlayerTransactionService().searchAuditLog(listVo);
    }

    /**
     * 取得24H内已取款次数
     *
     * @return 已取款次数
     */
    private Integer get24HHasCount() {
        Date nowTime = SessionManager.getDate().getToday(); // 今天零时时间
        PlayerWithdrawVo withdrawVo = new PlayerWithdrawVo();
        withdrawVo.getSearch().setPlayerId(SessionManager.getUserId());
        withdrawVo.getSearch().setCreateTime(nowTime);
        Long count = ServiceTool.playerWithdrawService().searchPlayerWithdrawNum(withdrawVo);
        count = count == null ? 0L : count;
        return count.intValue();
    }


    /**
     * 创建任务提醒
     */
    private void createSchedule(List<Integer> subUserIds) {
        UserTaskReminderVo reminderVo = new UserTaskReminderVo();
        reminderVo.setUserIds(subUserIds);
        reminderVo.setTaskEnum(UserTaskEnum.PLAYERWITHDRAW);
        ServiceTool.userTaskReminderService().addTaskReminder(reminderVo);
    }

    private Map<String, Object> toAuditObjectMap(PlayerTransactionVo transactionVo, Map auditMap) {
        double favorableSum = MapTool.getDouble(auditMap, "favorableSum");
        double depositSum = MapTool.getDouble(auditMap, "depositSum");
        double withdrawAmount = 0;
        if (auditMap.get("withdrawAmount") != null) {
            withdrawAmount = MapTool.getDouble(auditMap, "withdrawAmount");
        }
        double poundage = getPoundage(transactionVo, withdrawAmount);
        double actualWithdraw = withdrawAmount - depositSum - favorableSum - poundage;
        //用于显示用的手续用，不能用来计算
        String counterFee = ServiceTool.playerWithdrawService().getDisplayCounterFee(transactionVo);

        Map<String, Object> result = new HashMap<>();
        result.put("actualWithdraw", actualWithdraw);
        result.put("deductFavorable", auditMap.get("favorableSum"));
        result.put("transactionNo", auditMap.get("transactionNo"));
        result.put("administrativeFee", depositSum);
        result.put("withdrawAmount", withdrawAmount);
        result.put("withdrawFeeMoney", poundage);
        result.put("counterFee", counterFee);
        boolean flag = MapTool.getBoolean(auditMap, "depositRecord");
        boolean flag2 = MapTool.getBoolean(auditMap, "favorableRecord");
        if (flag || flag2) {
            result.put("recordList", true);
        } else {
            result.put("recordList", false);
        }
        return result;
    }

    /**
     * 获取手续费
     */
    private double getPoundage(PlayerTransactionVo transactionVo, double withdrawAmount) {
        PlayerWithdrawVo withdrawVo = new PlayerWithdrawVo();
        withdrawVo.setResult(new PlayerWithdraw());
        withdrawVo.getSearch().setTransactionNo(transactionVo.getResult().getTransactionNo());
        withdrawVo.getResult().setWithdrawAmount(withdrawAmount);
        Double poundage = ServiceTool.playerWithdrawService().getWithdrawFeeNum(transactionVo, withdrawVo, transactionVo.getPlayerId());
        return poundage == null ? 0 : poundage;
    }

    @RequestMapping("/withdrawSuccess")
    private String withdrawSuccess(PlayerWithdrawVo withdrawVo, Model model) {
        if (StringTool.isNotBlank(withdrawVo.getSearch().getTransactionNo())) {
            withdrawVo = ServiceTool.playerWithdrawService().search(withdrawVo);
        }
        return successDialog(withdrawVo, model);
    }

    /**
     * 稽核成功弹窗
     *
     * @return 操作结果
     */
    private String successDialog(PlayerWithdrawVo withdrawVo, Model model) {
        if (withdrawVo.getResult() == null) {
            model.addAttribute("errmsg", "找不到玩家取款信息");
            return getViewBasePath() + "WithdrawError";
        }
        PlayerRank rank = getRank(getPlayer());

        if (rank != null) {
            Integer count = get24HHasCount();
            //是否启用取款限制
            if (rank.getIsWithdrawLimit() != null && rank.getIsWithdrawLimit()) {
                Integer withdrawCount = rank.getWithdrawCount();
                model.addAttribute("withdrawCount", withdrawCount - count - 1);
            }
            //是否启用超额取款审核
            Boolean checkStatus = rank.getWithdrawExcessCheckStatus();
            //checkStatus = checkStatus != null;
            if (checkStatus) {
                if (withdrawVo.getResult().getWithdrawAmount() >= rank.getWithdrawExcessCheckNum()) {
                    Integer withdrawExcessCheckTime = rank.getWithdrawExcessCheckTime();
                    model.addAttribute("withdrawExcessCheckTime", withdrawExcessCheckTime);
                } else {    //是否启用普通提现审核
                    checkStatus = rank.getWithdrawCheckStatus();
                    if (checkStatus) {
                        Integer withdrawCheckTime = rank.getWithdrawCheckTime();
                        model.addAttribute("withdrawCheckTime", withdrawCheckTime);
                    }
                }
            } else {
                checkStatus = rank.getWithdrawCheckStatus();
                if (checkStatus) {
                    Integer withdrawCheckTime = rank.getWithdrawCheckTime();
                    model.addAttribute("withdrawCheckTime", withdrawCheckTime);
                }
            }
        }
        model.addAttribute("rank", rank);
        model.addAttribute("nowTime", SessionManager.getDate().getNow());
        return WITHDRAW_SUCCESS_DIALOG;
    }

    /**
     * 24小时取款次数超过3次-弹窗
     */
    @RequestMapping("/withdrawCountMax")
    public String withdrawCountMax() {
        return WITHDRAW_COUNT_MAX;
    }

    @RequestMapping("/withdrawError")
    public String withdrawError(String type, Model model) {
        if (StringTool.isNotBlank(type)) {
            String errmsg = LocaleTool.tranMessage("fund", type);
            model.addAttribute("errmsg", errmsg);
        }
        return getViewBasePath() + "WithdrawError";
    }

    /**
     * 添加银行卡
     */
    @RequestMapping("/submitBankCard")
    @ResponseBody
    @Token(valid = true)
    public Map submitBankCard(UserBankcardVo bankcardVo, @FormModel @Valid AddBankcardForm form, BindingResult result) {

        Map<String, Object> map = new HashMap<>(2);
        if (result.hasErrors()) {
            map.put("state", false);
            map.put("msg", "信息有误");
            map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
            return map;
        }

        try {
            SessionManager.refreshUser();
            bankcardVo = ServiceTool.userBankcardService().updateUserBankCard(bankcardVo, SessionManager.getUser());
            if (bankcardVo.isSuccess()) {
                map.put("msg", LocaleTool.tranMessage(_Module.COMMON, "save.success"));
                SessionManager.refreshUser();
            } else {
                map.put("msg", LocaleTool.tranMessage(_Module.COMMON, "save.failed"));
                map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
            }
        } catch (Exception ex) {
            map.put("state", false);
            map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
            LOG.error(ex, "玩家中心－添加银行卡错误");
        }
        map.put("state", bankcardVo.isSuccess());
        return map;
    }

    /**
     * 添加银行卡信息
     *
     * @param bankcardVo 银行卡信息
     * @param user       用户信息
     * @return bankcardVo
     */
    private UserBankcardVo insertBankcard(UserBankcardVo bankcardVo, SysUser user) {
        bankcardVo.getResult().setUserId(SessionManager.getUserId());
        bankcardVo.getResult().setBankcardMasterName(user.getRealName());
        bankcardVo.getResult().setCreateTime(SessionManager.getDate().getNow());
        bankcardVo.getResult().setUseCount(0);
        bankcardVo.getResult().setUseStauts(false);
        bankcardVo.getResult().setIsDefault(true);
        bankcardVo = ServiceTool.userBankcardService().insert(bankcardVo);

        if (bankcardVo.isSuccess()) {
            bankcardVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, "save.success"));
        } else {
            bankcardVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, "save.failed"));
        }
        return bankcardVo;
    }

    /**
     * 获取用户信息
     *
     * @param model model 用于兼容 sysUserVo
     * @return 用户信息
     */
    private SysUser getUser(Model model) {
        SysUserVo sysUserVo = new SysUserVo();
        sysUserVo.setResult(new SysUser());
        sysUserVo.getSearch().setId(SessionManager.getUserId());
        sysUserVo = ServiceTool.sysUserService().get(sysUserVo);
        if (model != null) {
            model.addAttribute("sysUserVo", sysUserVo);
        }
        return sysUserVo.getResult();
    }

    /**
     * 人家算不出来了啦……
     */
    @RequestMapping("/noAudit")
    public String noAudit() {
        return WITHDRAW_NO_AUDIT;
    }

    /**
     * 取款消息发送给站长中心
     */
    private void tellerReminder(PlayerWithdrawVo withdrawVo) {
        if (withdrawVo.getResult() == null || StringTool.isBlank(withdrawVo.getResult().getTransactionNo())) {
            return;
        }
        PlayerWithdrawVo newWithdrawVo = new PlayerWithdrawVo();
        newWithdrawVo.getSearch().setTransactionNo(withdrawVo.getResult().getTransactionNo());
        newWithdrawVo = ServiceTool.playerWithdrawService().search(newWithdrawVo);
        if (newWithdrawVo.getResult() == null || WithdrawStatusEnum.CANCELLATION_OF_ORDERS.getCode().equals(newWithdrawVo.getResult().getWithdrawStatus())) {
            return;
        }
        //推送消息给前端
        MessageVo message = new MessageVo();
        message.setSubscribeType("MCENTER-TELLER-REMINDER");
        PlayerWithdraw withdraw = newWithdrawVo.getResult();
        Map<String, Object> map = new HashMap<>(3);
        map.put("date", withdraw.getCreateTime());
        map.put("currency", StringTool.isBlank(SessionManager.getUser().getDefaultCurrency()) ? "" : SessionManager.getUser().getDefaultCurrency());
        map.put("type", withdraw.getWithdrawTypeParent());
        map.put("status", withdraw.getWithdrawStatus());
        map.put("amount", CurrencyTool.formatCurrency(withdraw.getWithdrawAmount()));
        map.put("id", withdraw.getId());
        message.setMsgBody(JsonTool.toJson(map));
        message.setSendToUser(true);
        message.setCcenterId(SessionManager.getSiteParentId());
        message.setSiteId(SessionManager.getSiteId());
        message.setMasterId(SessionManager.getSiteUserId());

        SysUserDataRightListVo sysUserDataRightListVo = new SysUserDataRightListVo();
        sysUserDataRightListVo.getSearch().setUserId(SessionManager.getUserId());
        sysUserDataRightListVo.getSearch().setModuleType(DataRightModuleType.PLAYERWITHDRAW.getCode());
        List<Integer> list = ServiceTool.sysUserDataRightService().searchPlayerDataRightEntityId(sysUserDataRightListVo);
        list.add(Const.MASTER_BUILT_IN_ID);

        //判断账号是否可以查看该层级的记录 add by Bruce.QQ
        filterUnavailableSubAccount(withdrawVo, list);
        message.addUserIds(list);
        ServiceTool.messageService().sendToMcenterMsg(message);
        createSchedule(list);
    }

    private void filterUnavailableSubAccount(PlayerWithdrawVo withdrawVo, List<Integer> list) {
        SysUserDataRightVo sysUserDataRightVo = new SysUserDataRightVo();
        sysUserDataRightVo.getSearch().setModuleType(DataRightModuleType.PLAYERWITHDRAW.getCode());
        Map<Integer, List<SysUserDataRight>> udrMap = ServiceTool.sysUserDataRightService().searchDataRightsByModuleType(sysUserDataRightVo);
        Integer rankId = withdrawVo.getResult().getRankId();
        if (rankId == null) {
            UserPlayerVo userPlayerVo = new UserPlayerVo();
            userPlayerVo.getSearch().setId(SessionManager.getUserId());
            userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);
            rankId = userPlayerVo.getResult().getRankId();
        }
        for (Iterator<Integer> iterator = list.iterator(); iterator.hasNext(); ) {
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

    /**
     * 远程验证取款金额
     */
    @RequestMapping("/checkOnlineWithdrawAmount")
    @ResponseBody
    public String checkOnlineWithdrawAmount(@RequestParam("withdrawAmount") String withdrawAmount) {
        boolean number = NumberTool.isNumber(withdrawAmount);
        if (!number) {
            return "false";
        }
        SysUserVo sysUserVo = new SysUserVo();
        sysUserVo.getSearch().setId(SessionManager.getUserId());
        PlayerRank rank = ServiceTool.playerRankService().searchRankByPlayerId(sysUserVo);//查询层级
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);

        double money = Double.valueOf(withdrawAmount);
        if (userPlayerVo.getResult().getWalletBalance() < money
                || (rank.getWithdrawMaxNum() != null && rank.getWithdrawMaxNum() < money)
                || (rank.getWithdrawMinNum() != null && rank.getWithdrawMinNum() > money)) {
            return "false";
        }
        return "true";
    }

    /**
     * 实时输入存款金额计算手续费
     *
     * @param withdrawAmount 存款金额
     * @return map
     */
    @RequestMapping("/withdrawFeeNum")
    @ResponseBody
    public Map withdrawFeeNum(@RequestParam("withdrawAmount") String withdrawAmount) {
        LOG.info("计算取款金额{0}的手续费", withdrawAmount);
        if (!NumberTool.isNumber(withdrawAmount)) {
            return null;
        }

        Map<String, Object> map = new HashMap<>();

        //取款手续费
        double amount = Double.valueOf(withdrawAmount);
        PlayerRank rank = getRank(getPlayer());
        Double poundage = getPoundage(amount, rank);
        Map auditMap = getAuditMap();
        Double administrativeFee = MapTool.getDouble(auditMap, "administrativeFee");
        Double deductFavorable = MapTool.getDouble(auditMap, "deductFavorable");
        double result = amount - poundage - administrativeFee - deductFavorable;
        if (amount <= poundage) {
            LOG.info("取款金额小于手续费{0}", poundage);
            map.put("withdrawAmountTooSmall", "true");
        } else {
            map.put("withdrawAmountTooSmall", "false");
        }
        LOG.info("手续费为{0},最终可取款金额为{1}", poundage, result);
        map.put("actualWithdraw", formatCurrency(result));
        map.put("fee", formatCurrency(poundage));
        return map;
    }

    private String formatCurrency(Number number) {
        String frontInt = CurrencyTool.formatInteger(number);
        String zero = CurrencyTool.formatDecimals(number);
        if (StringTool.isNotBlank(zero)) {
            frontInt = frontInt + zero;
        }
        return frontInt;
    }

    /**
     * 获取手续费
     *
     * @param withdrawAmount 取款金额
     * @return 手续费
     */
    private double getPoundage(Double withdrawAmount, PlayerRank rank) {

        Integer hasCount = 0;     // 设定时间内已取款次数
        Integer freeCount = rank.getWithdrawFreeCount();
        // 有设置取款次数限制
        if (rank.getWithdrawTimeLimit() != null && freeCount != null) {
            hasCount = getHasCount(rank);
        }
        LOG.info("已取款次数：{0}", hasCount);
        Double poundage = 0.0d; // 手续费
        // 超过免手续费次数(n+1次：即已取款次数+当前取款次数)时需要扣除手续费
        if (hasCount >= (freeCount == null ? 0 : freeCount)) {
            LOG.info("已取款次数超过免手续费次数：{0}", freeCount);
            poundage = calPoundage(withdrawAmount, rank);
        }

        // 手续费上限
        Double maxFee = rank.getWithdrawMaxFee();
        if (maxFee != null && poundage > maxFee) {
            LOG.info("手续费超过最大手续费：{0}", maxFee);
            poundage = maxFee;
        }

        DecimalFormat df = new DecimalFormat("#.00");
        df.format(poundage);
        return poundage;
    }

    /**
     * 设定时间内已取款次数
     */
    private Integer getHasCount(PlayerRank rank) {
        //返回多次取款次数，收取手续费
        if (SessionManager.getUserId() == null) {
            throw new RuntimeException("玩家ID不存在");
        }
        Date date = new Date();
        Date lastTime = DateTool.addHours(date, -rank.getWithdrawTimeLimit());
        PlayerWithdrawVo withdrawVo = new PlayerWithdrawVo();
        withdrawVo.setResult(new PlayerWithdraw());
        withdrawVo.getSearch().setPlayerId(SessionManager.getUserId());
        withdrawVo.setStartTime(lastTime);
        withdrawVo.setEndTime(date);
        Long count = ServiceTool.playerWithdrawService().searchTwoHoursPlayerWithdrawCount(withdrawVo);
        return count.intValue();
    }

    /**
     * 计算平台设定的手续费
     *
     * @param withdrawAmount 取款金额
     * @param rank           玩家层级信息
     * @return 手续费
     */
    private Double calPoundage(Double withdrawAmount, PlayerRank rank) {
        Double ratioOrFee = rank.getWithdrawFeeNum();  // 比例或固定费用
        ratioOrFee = ratioOrFee == null ? 0d : ratioOrFee;

        Double poundage = 0d;
        if (RankFeeType.PROPORTION.getCode().equals(rank.getWithdrawFeeType())) {   // 比例收费
            poundage = ratioOrFee / 100 * withdrawAmount;
        } else if (RankFeeType.FIXED.getCode().equals(rank.getWithdrawFeeType())) { // 固定收费
            poundage = ratioOrFee;
        }
        return poundage == null ? 0d : poundage;
    }


    //***************************************************begin设置真实姓名************************************************************//

    /**
     * 跳转到真实姓名设置窗口
     */
    @RequestMapping("/toSettingRealName")
    public String toSettingRealName(Model model) {
        model.addAttribute("settingRealNameRule", JsRuleCreator.create(SettingRealNameForm.class));
        return getViewBasePath() + "SettingRealName";
    }

    /**
     * 更新真实姓名
     *
     * @param sysUserVo
     * @return
     */
    @RequestMapping("/updateRealName")
    @ResponseBody
    public Map updateRealName(SysUserVo sysUserVo) {
        Map map = new HashMap(2);
        sysUserVo.getResult().setId(SessionManager.getUserId());
        sysUserVo.setProperties(SysUser.PROP_REAL_NAME);
        boolean success = ServiceTool.sysUserService().updateOnly(sysUserVo).isSuccess();
        SessionManager.getUser().setRealName(sysUserVo.getResult().getRealName());
        map.put("state", success);
        if (success) {
            map.put("msg", LocaleTool.tranMessage("player", "设置真实姓名成功"));
            SessionManager.clearPrivilegeStatus();
            SessionManager.refreshUser();
        } else {
            map.put("msg", LocaleTool.tranMessage("player", "设置真实姓名失败"));
        }
        return map;
    }

    //***************************************************end设置真实姓名************************************************************//

}