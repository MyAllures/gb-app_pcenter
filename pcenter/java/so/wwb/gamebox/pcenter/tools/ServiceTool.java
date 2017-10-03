package so.wwb.gamebox.pcenter.tools;

import org.soul.commons.dubbo.DubboTool;
import org.soul.iservice.msg.notice.INoticeService;
import org.soul.iservice.pay.IOnlinePayService;
import org.soul.iservice.security.privilege.ISysResourceService;
import org.soul.iservice.security.privilege.ISysRoleService;
import org.soul.iservice.security.privilege.ISysUserService;
import org.soul.iservice.smsinterface.ISmsInterfaceService;
import org.soul.iservice.sys.ISysAuditLogService;
import org.soul.iservice.sys.ISysParamService;
import org.soul.iservice.taskschedule.ITaskScheduleService;
import so.wwb.gamebox.iservice.boss.taskschedule.ITaskRunRecordService;
import so.wwb.gamebox.iservice.common.ICustomSysAuditLogService;
import so.wwb.gamebox.iservice.company.IBankExtendService;
import so.wwb.gamebox.iservice.company.IBankService;
import so.wwb.gamebox.iservice.company.filter.ISysMasterListOperatorService;
import so.wwb.gamebox.iservice.company.setting.ICurrencyExchangeRateService;
import so.wwb.gamebox.iservice.company.setting.IExceptionTransferService;
import so.wwb.gamebox.iservice.company.site.*;
import so.wwb.gamebox.iservice.company.sys.ISysDomainService;
import so.wwb.gamebox.iservice.company.sys.ISysSiteService;
import so.wwb.gamebox.iservice.company.sys.IUserExtendService;
import so.wwb.gamebox.iservice.master.content.ICttLogoService;
import so.wwb.gamebox.iservice.master.content.IVCttCarouselService;
import so.wwb.gamebox.iservice.master.digiccy.IUserDigiccyService;
import so.wwb.gamebox.iservice.master.fund.IAgentWithdrawOrderService;
import so.wwb.gamebox.iservice.master.fund.IPlayerTransferService;
import so.wwb.gamebox.iservice.master.fund.IVAgentWithdrawOrderService;
import so.wwb.gamebox.iservice.master.fund.IVPlayerWithdrawService;
import so.wwb.gamebox.iservice.master.operation.*;
import so.wwb.gamebox.iservice.master.player.*;
import so.wwb.gamebox.iservice.master.setting.*;
import so.wwb.gamebox.iservice.master.tasknotify.IUserTaskReminderService;
import so.wwb.gamebox.iservice.site.report.IVPlayerGameOrderService;

import static org.soul.commons.dubbo.DubboTool.getService;

/**
 * 远程服务实例获取工具类
 *
 * @author bruce
 * @time 2016-6-15 14:46:35
 */
public class ServiceTool {

    //region your codes 1

    /**
     * 返回玩家远程服务实例
     *
     * @return 玩家远程服务实例
     */
    public static IUserPlayerService userPlayerService() {
        return getService(IUserPlayerService.class);
    }

    public static IVUserPlayerService vUserPlayerService() {
        return getService(IVUserPlayerService.class);
    }

    public static ISysUserService sysUserService() {
        return getService(ISysUserService.class);
    }

    public static IVPlayerTagAllService vPlayerTagAllService() {
        return getService(IVPlayerTagAllService.class);
    }

    public static IPlayerAddressService playerAddressService() {
        return getService(IPlayerAddressService.class);
    }


    public static IVPlayerAdvisoryService vPlayerAdvisoryService() {
        return getService(IVPlayerAdvisoryService.class);
    }

    public static IPlayerAdvisoryReplyService playerAdvisoryReplyService() {
        return getService(IPlayerAdvisoryReplyService.class);
    }

    public static IVPlayerAdvisoryReplyService vPlayerAdvisoryReplyService() {
        return getService(IVPlayerAdvisoryReplyService.class);
    }

    public static IPlayerAdvisoryService playerAdvisoryService() {
        return getService(IPlayerAdvisoryService.class);
    }

    public static IUserExtendService userExtendService() {
        return getService(IUserExtendService.class);
    }

    public static IVSysUserPlayerFrozenService sysUserPlayerFrozenService() {
        return getService(IVSysUserPlayerFrozenService.class);
    }

    public static ITaskScheduleService taskScheduleService(String dubboVersion) {
        return getService(ITaskScheduleService.class, dubboVersion);
    }


    public static IUserTaskReminderService userTaskReminderService() {
        return getService(IUserTaskReminderService.class);
    }

    public static ISysResourceService sysResourceService() {
        return getService(ISysResourceService.class);
    }

    public static ISysAuditLogService sysAuditLogService() {
        return getService(ISysAuditLogService.class);
    }


    public static IVPlayerWithdrawService vPlayerWithdrawService() {
        return getService(IVPlayerWithdrawService.class);
    }

    public static IVPlayerTagService vPlayerTagService() {
        return getService(IVPlayerTagService.class);
    }

    public static IVUserShortcutMenuService vUserShortcutMenuService() {
        return getService(IVUserShortcutMenuService.class);
    }

    public static ISysMasterListOperatorService sysMasterListOperatorService() {
        return getService(ISysMasterListOperatorService.class);
    }

    /**
     * 返回系统公告视图远程服务实例
     *
     * @return 系统公告视图远程服务实例
     */
    public static so.wwb.gamebox.iservice.company.operator.IVSystemAnnouncementService vSystemAnnouncementService() {
        return getService(so.wwb.gamebox.iservice.company.operator.IVSystemAnnouncementService.class);
    }

    /**
     * 返回系统公告远程服务实例
     *
     * @return 系统公告远程服务实例
     */
    public static so.wwb.gamebox.iservice.company.operator.ISystemAnnouncementService systemAnnouncementService() {
        return getService(so.wwb.gamebox.iservice.company.operator.ISystemAnnouncementService.class);
    }

    /**
     * 返回任务运行结果远程服务实例
     *
     * @return 任务运行结果远程服务实例
     */
    public static ITaskRunRecordService taskRunRecordService(String dubboVersion) {
        return getService(ITaskRunRecordService.class, dubboVersion);
    }

    /**
     * 返回player_advisory_read表远程服务实例
     *
     * @return player_advisory_read表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.operation.IPlayerAdvisoryReadService playerAdvisoryReadService() {
        return getService(so.wwb.gamebox.iservice.master.operation.IPlayerAdvisoryReadService.class);
    }

    /**
     * 返回玩家层级表远程服务实例
     *
     * @return 玩家层级表远程服务实例
     */
    public static IPlayerRankService playerRankService() {
        return getService(IPlayerRankService.class);
    }


    public static ISysRoleService sysRoleService() {
        return DubboTool.getService(ISysRoleService.class);
    }

    public static so.wwb.gamebox.iservice.master.setting.ISysRoleService mSysRoleService() {
        return DubboTool.getService(so.wwb.gamebox.iservice.master.setting.ISysRoleService.class);
    }

    /**
     * 返回收款账户表远程服务实例
     *
     * @return 收款账户表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.IPayAccountService payAccountService() {
        return getService(so.wwb.gamebox.iservice.master.content.IPayAccountService.class);
    }

    /**
     * 返回玩家层级对应支付限制表远程服务实例
     *
     * @return 玩家层级对应支付限制表远程服务实例
     */
    public static IPayRankService payRankService() {
        return getService(IPayRankService.class);
    }

    /**
     * 玩家提现表
     *
     * @return
     */
    public static IVPlayerWithdrawService getVPlayerWithdrawService() {
        return getService(IVPlayerWithdrawService.class);
    }

    /**
     * v_pcenter_withdraw 取款
     *
     * @return
     */
    public static so.wwb.gamebox.iservice.master.fund.IVPcenterWithdrawService vPcenterWithdrawService() {
        return getService(so.wwb.gamebox.iservice.master.fund.IVPcenterWithdrawService.class);
    }


    /**
     * 提现交易表
     *
     * @return
     */
    public static IPlayerTransactionService getPlayerTransactionService() {
        return getService(IPlayerTransactionService.class);
    }


    /**
     * 汇率表
     */
    public static ICurrencyExchangeRateService getCurrencyExchangeRateService() {
        return getService(ICurrencyExchangeRateService.class);
    }

    /**
     * 返回玩家层级对应支付限制视图远程服务实例
     *
     * @return 玩家层级对应支付限制视图远程服务实例
     */
    public static IVPayRankService vPayRankService() {
        return getService(IVPayRankService.class);
    }

    /**
     * 返回玩家层级统计远程服务实例
     *
     * @return 玩家层级统计远程服务实例
     */
    public static IVPlayerRankStatisticsService vPlayerRankStatisticsService() {
        return getService(IVPlayerRankStatisticsService.class);
    }

    /**
     * 玩家充值记录表
     *
     * @return
     */
    public static so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService playerRechargeService() {
        return getService(so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService.class);
    }

    /**
     * 玩家提现记录表
     *
     * @return
     */
    public static so.wwb.gamebox.iservice.master.fund.IPlayerWithdrawService playerWithdrawService() {
        return getService(so.wwb.gamebox.iservice.master.fund.IPlayerWithdrawService.class);
    }

    /**
     * 返回收款账户对应币种表远程服务实例
     *
     * @return 收款账户对应币种表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.IPayAccountCurrencyService payAccountCurrencyService() {
        return getService(so.wwb.gamebox.iservice.master.content.IPayAccountCurrencyService.class);
    }

    /**
     * 返回币种表--lorne远程服务实例
     *
     * @return 币种表--lorne远程服务实例
     */
    public static ISiteCurrencyService sysSiteCurrencyService() {
        return getService(ISiteCurrencyService.class);
    }


    /**
     * 返回内容管理-轮播管理远程服务实例
     *
     * @return 内容管理-轮播管理远程服务实例
     */
    public static IVCttCarouselService vCttCarouselService() {
        return getService(IVCttCarouselService.class);
    }

    /**
     * 返回收款账户远程服务实例
     *
     * @return 收款账户远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.IVPayAccountService vPayAccountService() {
        return getService(so.wwb.gamebox.iservice.master.content.IVPayAccountService.class);
    }

    /**
     * 返回内容管理-浮动图片表远程服务实例
     *
     * @return 内容管理-浮动图片表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.ICttFloatPicService cttFloatPicService() {
        return getService(so.wwb.gamebox.iservice.master.content.ICttFloatPicService.class);
    }


    /**
     * 返回收款账户远程服务实例
     *
     * @return 收款账户远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.IPayAccountService PayAccountService() {
        return getService(so.wwb.gamebox.iservice.master.content.IPayAccountService.class);
    }

    /**
     * 玩家api关系远程服务实例
     *
     * @return
     */
    public static IPlayerApiService playerApiService() {
        return getService(IPlayerApiService.class);
    }

    /**
     * 返回限制访问站点的地区表远程服务实例
     *
     * @return 限制访问站点的地区表远程服务实例
     */
    public static ISiteConfineAreaService siteConfineAreaService() {
        return getService(ISiteConfineAreaService.class);
    }

    /**
     * 返回限制/允许访问站点/管理中心的IP表远程服务实例
     *
     * @return 限制/允许访问站点/管理中心的IP表远程服务实例
     */
    public static ISiteConfineIpService siteConfineIpService() {
        return getService(ISiteConfineIpService.class);
    }

    /**
     * 返回系统联系人表远程服务实例
     *
     * @return 系统联系人表远程服务实例
     */
    public static ISiteContactsService siteContactsService() {
        return getService(ISiteContactsService.class);
    }

    /**
     * 返回系统联系人职位表远程服务实例
     *
     * @return 系统联系人职位表远程服务实例
     */
    public static ISiteContactsPositionService siteContactsPositionService() {
        return getService(ISiteContactsPositionService.class);
    }

    /**
     * 返回站点语言表远程服务实例
     *
     * @return 站点语言表远程服务实例
     */
    public static ISiteLanguageService siteLanguageService() {
        return getService(ISiteLanguageService.class);
    }

    /**
     * 返回经营地区表远程服务实例
     *
     * @return 经营地区表远程服务实例
     */
    public static ISiteOperateAreaService siteOperateAreaService() {
        return getService(ISiteOperateAreaService.class);
    }

    /**
     * 返回系统联系人视图-lorne远程服务实例
     *
     * @return 系统联系人视图-lorne远程服务实例
     */
    public static IVSiteContactsService vSiteContactsService() {
        return getService(IVSiteContactsService.class);
    }

    /**
     * 返回客服设置表远程服务实例
     *
     * @return 客服设置表远程服务实例
     */
    public static ISiteCustomerServiceService siteCustomerServiceService() {
        return getService(ISiteCustomerServiceService.class);
    }

    /**
     * 返回偏好设置远程服务实例
     *
     * @return 偏好设置远程服务实例
     */
    public static IPreferenceService preferenceService() {
        return getService(IPreferenceService.class);
    }


    /**
     * 返回内容管理-域名与层级关联表远程服务实例
     *
     * @return 内容管理-域名与层级关联表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.ICttDomainRankService cttDomainRankService() {
        return getService(so.wwb.gamebox.iservice.master.content.ICttDomainRankService.class);
    }


    /**
     * 返回站长站点表服务实例
     *
     * @return 返回站长站点表远程服务实例
     */
    public static ISysSiteService sysSiteService() {
        return getService(ISysSiteService.class);
    }

    /**
     * 返回玩家游戏下单表远程服务实例
     *
     * @return 玩家游戏下单表远程服务实例
     */
    public static IPlayerGameOrderService playerGameOrderService() {
        return getService(IPlayerGameOrderService.class);
    }

    public static ISysParamService getSysParamService() {
        return getService(ISysParamService.class);
    }

    public static ICttLogoService getCttLogService() {
        return getService(ICttLogoService.class);
    }

    /**
     * 返回站点国际化远程服务实例
     *
     * @return 站点国际化远程服务实例
     */
    public static ISiteI18nService siteI18nService() {
        return getService(ISiteI18nService.class);
    }

    /**
     * 返回内容管理-公告表远程服务实例
     *
     * @return 内容管理-公告表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.content.ICttAnnouncementService cttAnnouncementService() {
        return getService(so.wwb.gamebox.iservice.master.content.ICttAnnouncementService.class);
    }

    /**
     * 返回通知模板远程服务实例
     *
     * @return 通知模板远程服务实例
     */
    public static INoticeTmplService noticeTmplService() {
        return getService(INoticeTmplService.class);
    }

    /**
     * 返回站长域名表-修改完会替换 sys_domain远程服务实例
     *
     * @return 站长域名表-修改完会替换 sys_domain远程服务实例
     */
    public static ISysDomainService sysDomainService() {
        return getService(ISysDomainService.class);
    }

    /**
     * 返回活动信息表远程服务实例
     *
     * @return 活动信息表远程服务实例
     */
    public static IActivityMessageService activityMessageService() {
        return getService(IActivityMessageService.class);
    }

    /**
     * 活动申请玩家表
     *
     * @return
     */
    public static IVActivityPlayerApplyService vActivityPlayerApplyService() {
        return getService(IVActivityPlayerApplyService.class);
    }

    /**
     * 返回活动申请玩家表远程服务实例
     *
     * @return 活动申请玩家表远程服务实例
     */
    public static IActivityPlayerApplyService activityPlayerApplyService() {
        return getService(IActivityPlayerApplyService.class);
    }

    public static so.wwb.gamebox.iservice.comet.IMessageService messageService() {
        return getService(so.wwb.gamebox.iservice.comet.IMessageService.class);
    }

    /**
     * 返回邮件接口视图远程服务实例
     *
     * @return 邮件接口视图远程服务实例
     */
    public static IVNoticeEmailInterfaceService vNoticeEmailInterfaceService() {
        return getService(IVNoticeEmailInterfaceService.class);
    }


    /**
     * 返回运营概况表远程服务实例
     *
     * @return 运营概况表远程服务实例
     */
    public static so.wwb.gamebox.iservice.report.IOperationProfileService operationProfileService() {
        return getService(so.wwb.gamebox.iservice.report.IOperationProfileService.class);
    }

    /**
     * 返回游戏概况表远程服务实例
     *
     * @return 游戏概况表远程服务实例
     */
    public static so.wwb.gamebox.iservice.report.IGameSurveyService gameSurveyService() {
        return getService(so.wwb.gamebox.iservice.report.IGameSurveyService.class);
    }

    /**
     * 返回玩家银行卡远程服务实例
     *
     * @return
     */
    public static IUserBankcardService userBankcardService() {
        return getService(IUserBankcardService.class);
    }

    /**
     * 返回银行表远程服务实例
     *
     * @return 银行表远程服务实例
     */
    public static IBankService bankService() {
        return getService(IBankService.class);
    }

    /**
     * 返回银行扩展表远程服务实例
     *
     * @return
     */
    public static IBankExtendService bankExtendService() {
        return getService(IBankExtendService.class);
    }

    /**
     * 返回联系方式表远程服务实例
     *
     * @return 联系方式表远程服务实例
     */
    public static org.soul.iservice.msg.notice.INoticeContactWayService noticeContactWayService() {
        return getService(org.soul.iservice.msg.notice.INoticeContactWayService.class);
    }

    /**
     * 返回账号保护表远程服务实例
     *
     * @return 账号保护表远程服务实例
     */
    public static org.soul.iservice.security.privilege.ISysUserProtectionService sysUserProtectionService() {
        return getService(org.soul.iservice.security.privilege.ISysUserProtectionService.class);
    }


    /**
     * 返回活动国际化信息表远程服务实例
     *
     * @return 活动国际化信息表远程服务实例
     */
    public static IActivityMessageI18nService activityMessageI18nService() {
        return getService(IActivityMessageI18nService.class);
    }

    /**
     * 返回优惠规则表远程服务实例
     *
     * @return 优惠规则表远程服务实例
     */
    public static IActivityPreferentialRuleService activityPreferentialRuleService() {
        return getService(IActivityPreferentialRuleService.class);
    }

    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static IVPlayerOnlineService vPlayerOnlineService() {
        return getService(IVPlayerOnlineService.class);
    }

    /**
     * 返回站务账单表远程服务实例
     *
     * @return 站务账单表远程服务实例
     */
    public static so.wwb.gamebox.iservice.report.operation.IStationBillService stationBillService() {
        return getService(so.wwb.gamebox.iservice.report.operation.IStationBillService.class);
    }

    /**
     * 返回站务其他账单远程服务实例
     *
     * @return 站务其他账单远程服务实例
     */
    public static so.wwb.gamebox.iservice.report.operation.IStationBillOtherService stationBillOtherService() {
        return getService(so.wwb.gamebox.iservice.report.operation.IStationBillOtherService.class);
    }

    /**
     * 返回游戏盈亏账单远程服务实例
     *
     * @return 游戏盈亏账单远程服务实例
     */
    public static so.wwb.gamebox.iservice.report.operation.IStationProfitLossService stationProfitLossService() {
        return getService(so.wwb.gamebox.iservice.report.operation.IStationProfitLossService.class);
    }

    /**
     * 返回总代API占成表远程服务实例
     *
     * @return 总代API占成表远程服务实例
     */
    public static IUserAgentApiService userAgentApiService() {
        return getService(IUserAgentApiService.class);
    }


    /**
     * 返回代理/总代 返水关联表远程服务实例
     *
     * @return 代理/总代 返水关联表远程服务实例
     */
    public static IUserAgentRakebackService userAgentRakebackService() {
        return getService(IUserAgentRakebackService.class);
    }

    /**
     * 返回代理/总代 返佣关联表远程服务实例
     *
     * @return 代理/总代 返佣关联表远程服务实例
     */
    public static IUserAgentRebateService userAgentRebateService() {
        return getService(IUserAgentRebateService.class);
    }

    /**
     * 返回代理子账号远程服务实例
     *
     * @return 代理子账号远程服务实例
     */
    public static IUserAgentService userAgentService() {
        return getService(IUserAgentService.class);
    }

    /**
     * 代理子账号
     *
     * @return
     */
    public static IUserAgentService getUserAgentService() {
        return getService(IUserAgentService.class);
    }

    /**
     * 返回返水设置表远程服务实例
     *
     * @return 返水设置表远程服务实例
     */
    public static IRakebackSetService rakebackSetService() {
        return getService(IRakebackSetService.class);
    }

    /**
     * 返回返佣设置表远程服务实例
     *
     * @return 返佣设置表远程服务实例
     */
    public static IRebateSetService rebateSetService() {
        return getService(IRebateSetService.class);
    }


    /**
     * 返回返水明细表远程服务实例
     *
     * @return 返水明细表远程服务实例
     */
    public static IRakebackApiService rakebackApiService() {
        return getService(IRakebackApiService.class);
    }


    /**
     * 返回玩家返水表远程服务实例
     *
     * @return 玩家返水表远程服务实例
     */
    public static IRakebackPlayerService rakebackPlayerService() {
        return getService(IRakebackPlayerService.class);
    }

    /**
     * 返回返水结算表远程服务实例
     *
     * @return 返水结算表远程服务实例
     */
    public static IRakebackBillService rakebackBillService() {
        return getService(IRakebackBillService.class);
    }

    /**
     * 代理取款订单表
     *
     * @return
     */
    public static IAgentWithdrawOrderService getAgentWithdrawOrderService() {
        return getService(IAgentWithdrawOrderService.class);
    }

    /**
     * 代理取款订单表
     *
     * @return
     */
    public static IVAgentWithdrawOrderService getVAgentWithdrawOrderService() {
        return getService(IVAgentWithdrawOrderService.class);
    }

    /**
     * 站点游戏表远程服务实例
     *
     * @return 站点游戏表远程服务实例
     */
    public static ISiteGameService siteGameService() {
        return getService(ISiteGameService.class);
    }

    /**
     * 返回返佣结算表远程服务实例
     *
     * @return 返佣结算表远程服务实例
     */
    public static IRebateBillService settlementRebateService() {
        return getService(IRebateBillService.class);
    }

    /**
     * 返回玩家返佣表远程服务实例
     *
     * @return 玩家返佣表远程服务实例
     */
    public static IRebateAgentService settlementRebateAgentService() {
        return getService(IRebateAgentService.class);
    }

    /**
     * 返回代理流水账单表远程服务实例
     *
     * @return 代理流水账单表远程服务实例
     */
    public static IAgentWaterBillService agentWaterBillService() {
        return getService(IAgentWaterBillService.class);
    }

    /**
     * 返回代理（总代）管理远程服务实例
     *
     * @return 代理（总代）管理远程服务实例
     */
    public static IVUserAgentManageService vUserAgentManageService() {
        return getService(IVUserAgentManageService.class);
    }

    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static IVUserTopAgentManageService vUserTopAgentManageService() {
        return getService(IVUserTopAgentManageService.class);
    }

    /**
     * 返回代理/总代-返水/返佣/限额方案汇总视图远程服务实例
     *
     * @return 代理/总代-返水/返佣/限额方案汇总视图远程服务实例
     */
    public static IVProgramService vProgramService() {
        return getService(IVProgramService.class);
    }

    public static INoticeService noticeService() {
        return getService(INoticeService.class);
    }

    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static IVUserAgentService vUserAgentService() {
        return getService(IVUserAgentService.class);
    }

    /**
     * 返回返水设置梯度表远程服务实例
     *
     * @return 返水设置梯度表远程服务实例
     */
    public static IRakebackGradsService rakebackGradsService() {
        return getService(IRakebackGradsService.class);
    }

    /**
     * 返回返水设置梯度API比例表远程服务实例
     *
     * @return 返水设置梯度API比例表远程服务实例
     */
    public static IRakebackGradsApiService rakebackGradsApiService() {
        return getService(IRakebackGradsApiService.class);
    }

    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static IVRakebackSetService vRakebackSetService() {
        return getService(IVRakebackSetService.class);
    }

    /**
     * 返回代理返佣交易订单表远程服务实例
     *
     * @return 代理返佣交易订单表远程服务实例
     */
    public static IAgentRebateOrderService agentRebateOrderService() {
        return getService(IAgentRebateOrderService.class);
    }

    public static IUserShortcutMenuService userShortcutMenuService() {
        return getService(IUserShortcutMenuService.class);
    }

    /**
     * 返回玩家游戏下单视图远程服务实例
     *
     * @return 玩家游戏下单视图远程服务实例
     */
    public static IVPlayerGameOrderService vPlayerGameOrderService() {
        return getService(IVPlayerGameOrderService.class);
    }


    public static so.wwb.gamebox.iservice.company.setting.IApiService apiService() {
        return getService(so.wwb.gamebox.iservice.company.setting.IApiService.class);
    }

    /**
     * 返回游戏表远程服务实例
     *
     * @return 游戏表远程服务实例
     */
    public static so.wwb.gamebox.iservice.company.setting.IGameService gameService() {
        return getService(so.wwb.gamebox.iservice.company.setting.IGameService.class);
    }

    /**
     * 返回活动类型表远程服务实例
     *
     * @return 活动类型表远程服务实例
     */
    public static IActivityTypeService activityTypeService() {
        return getService(IActivityTypeService.class);
    }

    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static IVActivityMessageService vActivityMessageService() {
        return getService(IVActivityMessageService.class);
    }


    /**
     * 返回玩家优惠信息表远程服务实例
     *
     * @return 玩家优惠信息表远程服务实例
     */
    public static IActivityPlayerPreferentialService activityPlayerPreferentialService() {
        return getService(IActivityPlayerPreferentialService.class);
    }

    /**
     * 返回活动优惠方式关系表远程服务实例
     *
     * @return 活动优惠方式关系表远程服务实例
     */
    public static IActivityWayRelationService activityWayRelationService() {
        return getService(IActivityWayRelationService.class);
    }

    /**
     * 接口参数服务接口
     *
     * @return
     */
    public static IOnlinePayService onlinePayService() {
        return getService(IOnlinePayService.class);
    }

    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.operation.IVPlayerActivityMessageService vPlayerActivityMessageService() {
        return getService(so.wwb.gamebox.iservice.master.operation.IVPlayerActivityMessageService.class);
    }

    public static so.wwb.gamebox.iservice.master.operation.IPlayerActivityMessageService playerActivityMessageService() {
        return getService(so.wwb.gamebox.iservice.master.operation.IPlayerActivityMessageService.class);
    }

    /**
     * 返回api游戏类别视图远程服务实例
     *
     * @return api游戏类别视图远程服务实例
     */
    public static so.wwb.gamebox.iservice.company.site.IVGameTypeService vGameTypeService() {
        return getService(so.wwb.gamebox.iservice.company.site.IVGameTypeService.class);
    }

    public static ICustomSysAuditLogService customSysAuditLogService() {
        return getService(ICustomSysAuditLogService.class);
    }

    /**
     * 返回活动优惠关系表远程服务实例
     *
     * @return 活动优惠关系表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.operation.IActivityPreferentialRelationService activityPreferentialRelationService() {
        return getService(so.wwb.gamebox.iservice.master.operation.IActivityPreferentialRelationService.class);
    }

    /**
     * 返回活动规则表远程服务实例
     *
     * @return 活动规则表远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.operation.IActivityRuleService activityRuleService() {
        return getService(so.wwb.gamebox.iservice.master.operation.IActivityRuleService.class);
    }

    public static so.wwb.gamebox.iservice.master.report.IVPlayerTransactionService vPlayerTransactionService() {
        return getService(so.wwb.gamebox.iservice.master.report.IVPlayerTransactionService.class);
    }

    public static IExceptionTransferService exceptionTransferService() {
        return getService(IExceptionTransferService.class);
    }

    public static IPlayerTransferService playerTransferService() {
        return getService(IPlayerTransferService.class);
    }

    public static IPlayerApiAccountService playerApiAccountService() {
        return getService(IPlayerApiAccountService.class);
    }
    /**
     * 返回远程服务实例
     *
     * @return 远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.operation.IVPreferentialRecodeService vPreferentialRecodeService() {
        return getService(so.wwb.gamebox.iservice.master.operation.IVPreferentialRecodeService.class);
    }
    /**
     * 返回数据权限远程服务实例
     *
     * @return 数据权限远程服务实例
     */
    public static so.wwb.gamebox.iservice.master.dataRight.ISysUserDataRightService sysUserDataRightService() {
        return getService(so.wwb.gamebox.iservice.master.dataRight.ISysUserDataRightService.class);
    }

    public static ISmsInterfaceService smsInterfaceService() {
        return getService(ISmsInterfaceService.class);
    }

    public static IUserDigiccyService userDigiccyService() {
        return getService(IUserDigiccyService.class);
    }
//endregion your codes 1

}
