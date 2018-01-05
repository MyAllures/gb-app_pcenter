package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.bean.Pair;
import org.soul.commons.collections.CollectionQueryTool;
import org.soul.commons.collections.CollectionTool;
import org.soul.commons.collections.ListTool;
import org.soul.commons.collections.MapTool;
import org.soul.commons.dict.DictTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.net.ServletTool;
import org.soul.commons.query.Criteria;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.query.sort.Order;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.sys.po.SysParam;
import org.soul.web.controller.NoMappingCrudController;
import org.soul.web.session.SessionManagerBase;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.iservice.master.report.IVPlayerTransactionService;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.master.enums.CommonStatusEnum;
import so.wwb.gamebox.model.master.fund.enums.TransactionTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.TransactionWayEnum;
import so.wwb.gamebox.model.master.fund.vo.VPlayerWithdrawVo;
import so.wwb.gamebox.model.master.report.po.VPlayerTransaction;
import so.wwb.gamebox.model.master.report.vo.VPlayerTransactionListVo;
import so.wwb.gamebox.model.master.report.vo.VPlayerTransactionVo;
import so.wwb.gamebox.pcenter.fund.form.PlayerTransactionForm;
import so.wwb.gamebox.pcenter.fund.form.PlayerTransactionSearchForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;

import javax.servlet.http.HttpServletRequest;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;


/**
 * 玩家交易表控制器
 *
 * @author jeff
 * @time 2015-10-30 15:43:35
 */
@Controller
//region your codes 1
@RequestMapping("/fund/transaction")
public class PlayerTransactionController extends NoMappingCrudController<IVPlayerTransactionService, VPlayerTransactionListVo, VPlayerTransactionVo, PlayerTransactionSearchForm, PlayerTransactionForm, VPlayerTransaction, Integer> {
//endregion your codes 1

    @Override
    protected String getViewBasePath() {
        //region your codes 2 transfers
        return "/fund/transaction/";
        //endregion your codes 2
    }

    //region your codes 3
    public static final String CHART_INDEX = "Chart";
    public static final String CHART_PARTIAL_INDEX = "ChartPartial";
    public static final String VIEW = "View";
    public static final String INDEX = "Index";
    public static final String INDEX_PARTIAL = "IndexPartial";
    public static final Integer DEFAULT_SEARCH_DAY = 6;//默认查询天数
    /**
     * 玩家中心查询订单最大间隔天数
     */
    private static final int DATE_INTERVAL = -30;

    @RequestMapping("/list")
    @DemoModel(menuCode = DemoMenuEnum.ZJJL)
    public String list(VPlayerTransactionListVo listVo, PlayerTransactionSearchForm form, BindingResult result, Model model, HttpServletRequest request) {

        /*查询当前登录玩家的资金记录*/
        initDate(listVo);
        SysParam sysParam = ParamTool.getSysParam(SiteParamEnum.SETTING_SYSTEM_SETTINGS_IS_LOTTERY_SITE);
        if(sysParam!=null&& "true".equals(sysParam.getParamValue())){
            listVo.getSearch().setLotterySite(true);
        }
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        listVo.setMaxDate(SessionManager.getDate().getToday());
        //玩家中心不展示派彩相关资金记录
        listVo.getSearch().setNoDisplay(TransactionWayEnum.MANUAL_PAYOUT.getCode());
//        listVo.getSearch().setFromPcenter(true);
        listVo = getService().search(listVo);
//        CollectionTool.ba TODO Jeff batchUpdate 条件
        listVo = preList(listVo);
        model.addAttribute("command", listVo);
        if (ServletTool.isAjaxSoulRequest(request)) {
            return getViewBasePath() + INDEX_PARTIAL;
        } else {
            return getViewBasePath() + INDEX;
        }
    }

    /*图表模式*/
    @RequestMapping("/chart")
    public String asd(Model model, HttpServletRequest request, VPlayerTransactionListVo listVo) {
        initDate(listVo);
        listVo.setMaxDate(SessionManager.getDate().getToday());
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        //玩家中心不展示派彩相关资金记录
        listVo.getSearch().setNoDisplay(TransactionWayEnum.MANUAL_PAYOUT.getCode());
        //listVo = getService().playerTransactionChar(listVo);
        listVo.setPaging(null);
        //资金记录转换成图标模式
        listVo = getService().search(listVo);
        listVo = playerTransactionChar(listVo);
        model.addAttribute("command", preList(listVo));
        if (ServletTool.isAjaxSoulRequest(request)) {
            return getViewBasePath() + CHART_PARTIAL_INDEX;
        } else {
            return getViewBasePath() + CHART_INDEX;
        }
    }

    private void initDate(VPlayerTransactionListVo listVo) {
        Date today = SessionManager.getDate().getToday();
        Date maxDate = DateTool.addSeconds(SessionManagerBase.getDate().getTomorrow(), -1);
        Date minDate = DateTool.addDays(today, DATE_INTERVAL);
        Date beginCreateTime = listVo.getSearch().getBeginCreateTime();
        Date endCreateTime = listVo.getSearch().getEndCreateTime();
        if (beginCreateTime == null) {
            listVo.getSearch().setBeginCreateTime(DateTool.addDays(today, -DEFAULT_SEARCH_DAY));
        } else if (beginCreateTime.getTime() < minDate.getTime()) {
            listVo.getSearch().setBeginCreateTime(beginCreateTime);
        }
        if (endCreateTime == null || endCreateTime.getTime() > maxDate.getTime()) {
            listVo.getSearch().setEndCreateTime(maxDate);
        } else {
            listVo.getSearch().setEndCreateTime(DateTool.addDays(endCreateTime, 1));
        }
        listVo.setMinDate(minDate);
    }

    /**
     * 资金记录转换成图标模式
     *
     * @param listVo
     * @return
     */
    private VPlayerTransactionListVo playerTransactionChar(VPlayerTransactionListVo listVo) {
        List<VPlayerTransaction> playerTransactionList = listVo.getResult();
        if (CollectionTool.isNotEmpty(playerTransactionList)) {
            List<VPlayerTransaction> transactions = new ArrayList<>();
            List<VPlayerTransaction> transfersTmp = new ArrayList<>();
            for (VPlayerTransaction transaction : playerTransactionList) {
                if (TransactionTypeEnum.TRANSFERS.getCode().equals(transaction.getTransactionType())) {
                    transfersTmp.add(transaction);
                } else {
                    transactions.add(transaction);
                }
            }
            List<VPlayerTransaction> transfers = new ArrayList<>();
            if (CollectionTool.isNotEmpty(transfersTmp)) {
                Map<String, List<VPlayerTransaction>> transferMap = CollectionTool.groupByProperty(transfersTmp, VPlayerTransaction.PROP_CRATE_DATE, String.class);
                for (List<VPlayerTransaction> transactionList : transferMap.values()) {
                    transactionList.get(0).set_count(transactionList.size());
                    transfers.add(transactionList.get(0));
                }
            }
            List<VPlayerTransaction> sumList = ListTool.sum(transactions, transfers);
            sumList = CollectionQueryTool.sort(sumList, Order.desc(VPlayerTransaction.PROP_CREATE_TIME));
            listVo.setResult(sumList);
        }
        return listVo;
    }

    public VPlayerTransactionListVo preList(VPlayerTransactionListVo playerTransactionListVo) {
        Map<String, Serializable> transactionTypeDict = DictTool.get(DictEnum.COMMON_TRANSACTION_TYPE);
        SysParam sysParam = ParamTool.getSysParam(SiteParamEnum.SETTING_SYSTEM_SETTINGS_IS_LOTTERY_SITE);
        if(sysParam!=null&& "true".equals(sysParam.getParamValue())){
            transactionTypeDict.remove(TransactionTypeEnum.TRANSFERS.getCode());
        }
        playerTransactionListVo.setDictCommonTransactionType(transactionTypeDict);
        Map<String, Serializable> dictCommonStatus = DictTool.get(DictEnum.COMMON_STATUS);
        /*删掉稽核失败待处理状态*/
        dictCommonStatus.remove(CommonStatusEnum.DEAL_AUDIT_FAIL.getCode());
        playerTransactionListVo.setDictCommonStatus(dictCommonStatus);
        /*将 返水 推荐 的成功状态 修改为已发放*/
        Criteria criteriaType = Criteria.add(VPlayerTransaction.PROP_TRANSACTION_TYPE, Operator.IN, ListTool.newArrayList(TransactionTypeEnum.BACKWATER.getCode(), TransactionTypeEnum.RECOMMEND.getCode()));
        Criteria criteria = Criteria.add(VPlayerTransaction.PROP_STATUS, Operator.EQ, CommonStatusEnum.LSSUING.getCode());
        if (!playerTransactionListVo.getResult().isEmpty()) {
            CollectionTool.batchUpdate(playerTransactionListVo.getResult(), Criteria.and(criteria, criteriaType), MapTool.newHashMap(new Pair<String, Object>(VPlayerTransaction.PROP_STATUS, CommonStatusEnum.SUCCESS.getCode())));
        }
        return playerTransactionListVo;
    }


    /**
     * 反手续费弹窗 -弹与其相关联的存款订单
     *
     * @param playerTransactionListVo
     * @return
     */
    @RequestMapping("/refundFeeView")
    public String refundFeeView(VPlayerTransactionListVo playerTransactionListVo, Model model) {
        Integer transactionId = ServiceSiteTool.getPlayerTransactionService().getRefundFeeRelatedRechargeTransactionId(playerTransactionListVo);
        VPlayerTransactionVo playerTransactionVo = new VPlayerTransactionVo();
        playerTransactionVo.getSearch().setId(transactionId);
        model.addAttribute("command", getService().get(playerTransactionVo));
        return getViewBasePath() + VIEW;
    }

    @RequestMapping("/view")
    public String view(VPlayerTransactionVo vo, Model model) {
        if (vo.getSearch().getId() != null) {
            vo = super.doView(vo, model);
            if (vo.getResult() != null && TransactionTypeEnum.WITHDRAWALS.getCode().equals(vo.getResult().getTransactionType())) {
                if (StringTool.isNotBlank(vo.getResult().getTransactionNo())) {
                    VPlayerWithdrawVo withdrawVo = new VPlayerWithdrawVo();
                    withdrawVo.getSearch().setId(vo.getResult().getSourceId());
                    withdrawVo = ServiceSiteTool.vPlayerWithdrawService().get(withdrawVo);
                    model.addAttribute("withdrawVo", withdrawVo);
                }
                if (vo.getResult().getPlayerId() != null) {
                    SysUserVo sysUserVo = new SysUserVo();
                    sysUserVo.getSearch().setId(vo.getResult().getPlayerId());
                    sysUserVo = ServiceTool.sysUserService().get(sysUserVo);
                    model.addAttribute("sysUserVo", sysUserVo);
                }
            }

        }

        model.addAttribute("command", vo);
        return getViewBasePath() + VIEW;
    }
    //endregion your codes 3

}