package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.MapTool;
import org.soul.commons.currency.CurrencyTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.master.fund.enums.FundTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.TransactionTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.WithdrawStatusEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerWithdraw;
import so.wwb.gamebox.model.master.fund.vo.PlayerWithdrawVo;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.model.master.player.po.PlayerTransaction;
import so.wwb.gamebox.model.master.player.po.UserBankcard;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.*;
import so.wwb.gamebox.pcenter.fund.form.SettingRealNameForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;
import so.wwb.gamebox.web.common.token.Token;
import so.wwb.gamebox.web.fund.controller.BaseWithdrawController;
import so.wwb.gamebox.web.fund.form.WithdrawForm;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 控制器
 *
 * @author orange
 * @time 2015-10-20 16:12:04
 */
@Controller
@RequestMapping("/player/withdraw")
public class WithdrawController extends BaseWithdrawController {

    private static final Log LOG = LogFactory.getLog(WithdrawController.class);

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
    @DemoModel(menuCode = DemoMenuEnum.QKZQ)
    protected String withdrawList(Model model) {
        return withdraw(model);
    }

    @RequestMapping("/pleaseWithdraw")
    @ResponseBody
    @Token(valid = true)
    public Map pleaseWithdraw(HttpServletRequest request, PlayerTransactionVo transactionVo, Model model, @FormModel @Valid WithdrawForm form, BindingResult result) {
        return submitWithdraw(request, transactionVo, model, result);
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
        PlayerRank rank = getRank();

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
        PlayerRank rank = getRank();
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
        Map map = new HashMap(2, 1f);
        sysUserVo.getResult().setId(SessionManager.getUserId());
        sysUserVo.setProperties(SysUser.PROP_REAL_NAME);
        boolean success = ServiceTool.sysUserService().updateOnly(sysUserVo).isSuccess();
        SessionManager.getUser().setRealName(sysUserVo.getResult().getRealName());
        map.put("state", success);
        if (success) {
            map.put("msg", LocaleTool.tranMessage("player_auto", "设置真实姓名成功"));
            SessionManager.clearPrivilegeStatus();
            SessionManager.refreshUser();
        } else {
            map.put("msg", LocaleTool.tranMessage("player_auto", "设置真实姓名失败"));
        }
        return map;
    }

    //***************************************************end设置真实姓名************************************************************//

}