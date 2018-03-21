package so.wwb.gamebox.pcenter.gameOrder.controller;

import org.soul.commons.collections.CollectionTool;
import org.soul.commons.collections.MapTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.dict.DictTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.DateQuickPicker;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.net.ServletTool;
import org.soul.model.gameapi.param.ExtendParam;
import org.soul.model.gameapi.result.GameApiResult;
import org.soul.model.sys.po.SysParam;
import org.soul.web.validation.form.annotation.FormModel;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceGameApiTool;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.model.ApiGameTool;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.company.setting.po.ApiI18n;
import so.wwb.gamebox.model.company.setting.po.GameI18n;
import so.wwb.gamebox.model.company.setting.po.SysCurrency;
import so.wwb.gamebox.model.company.site.po.SiteApiI18n;
import so.wwb.gamebox.model.company.site.po.SiteApiTypeI18n;
import so.wwb.gamebox.model.company.site.po.SiteGame;
import so.wwb.gamebox.model.company.site.po.SiteGameI18n;
import so.wwb.gamebox.model.company.site.vo.SiteGameVo;
import so.wwb.gamebox.model.master.player.po.PlayerGameOrder;
import so.wwb.gamebox.model.master.player.vo.PlayerGameOrderDetailVo;
import so.wwb.gamebox.model.master.player.vo.PlayerGameOrderListVo;
import so.wwb.gamebox.model.master.player.vo.PlayerGameOrderVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;
import so.wwb.gamebox.web.report.betting.form.PlayerGameOrderDetailSearchForm;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 玩家中心-投注记录
 * Created by cherry on 16-9-4.
 */
@RequestMapping("/gameOrder")
@Controller
public class PlayerGameOrderController {
    private static final Log LOG = LogFactory.getLog(PlayerGameOrderController.class);
    private static final String INDEX_URI = "/gameOrder/Index";
    private static final String INDEX_PARTIAL_URI = "/gameOrder/IndexPartial";
    /**
     * 选择游戏类型页面
     */
    private static final String GAME_URI = "/gameOrder/Game";
    /**
     * 投注订单详细页
     */
    private static final String GAME_RECORD_DETAIL_URI = "/gameOrder/GameRecordDetail";
    /**
     * 玩家中心查询订单间隔天数
     */
    private static final int DATE_INTERVAL = -62;

    @RequestMapping("/index")
    @DemoModel(menuCode = DemoMenuEnum.TZJL)
    public String index(HttpServletRequest request, PlayerGameOrderListVo listVo, Model model) {
        //玩家中心可查询40天之内的订单
        Date today = SessionManager.getDate().getToday();
        Date maxDate = DateQuickPicker.getInstance().getTomorrow();//DateTool.addSeconds(SessionManagerBase.getDate().getTomorrow(), -1);
        Date minDate = DateTool.addDays(today, DATE_INTERVAL);
        Date beginBetTime = listVo.getSearch().getBeginBetTime();
        //默认查询今日数据
        if (beginBetTime == null) {
            listVo.getSearch().setBeginBetTime(today);
        } else if (beginBetTime.getTime() < minDate.getTime()) {
            listVo.getSearch().setBeginBetTime(minDate);
        }
        Date endBetTime = listVo.getSearch().getEndBetTime();
        if (endBetTime == null || endBetTime.getTime() > maxDate.getTime()) {
            listVo.getSearch().setEndBetTime(maxDate);
        }
        listVo.setMinDate(minDate);
        listVo.setMaxDate(maxDate);
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        listVo = ServiceSiteTool.playerGameOrderService().search(listVo);
        setApiNameAndGame(listVo.getResult());
        //统计数据
        statisticsData(listVo, model);
        model.addAttribute("command", listVo);
        model.addAttribute("currency", getCurrencySign());
        model.addAttribute("orderState", DictTool.get(DictEnum.GAME_ORDER_STATE));
        SysParam sysParam = ParamTool.getSysParam(SiteParamEnum.SETTING_SYSTEM_SETTINGS_IS_LOTTERY_SITE);
        model.addAttribute("isLottery", sysParam);
        return ServletTool.isAjaxSoulRequest(request) ? INDEX_PARTIAL_URI : INDEX_URI;
    }

    private void setApiNameAndGame(List<PlayerGameOrder> playerGameOrders) {
        if (CollectionTool.isEmpty(playerGameOrders)) {
            return;
        }
        Map<Integer, Map<Integer, String>> apiNameGroupByApiType = ApiGameTool.getSiteApiNameByApiType(Cache.getSiteApiTypeRelactionI18n());
        Map<String, SiteApiI18n> siteApiI18nMap = Cache.getSiteApiI18n();
        Map<String, ApiI18n> apiI18nMap = Cache.getApiI18n();
        Map<String, SiteGameI18n> siteGameI18nMap = Cache.getSiteGameI18n();
        Map<String, GameI18n> gameI18nMap = Cache.getGameI18n();
        Integer gameId;
        for (PlayerGameOrder playerGameOrder : playerGameOrders) {
            playerGameOrder.setApiName(ApiGameTool.getSiteApiName(apiNameGroupByApiType, siteApiI18nMap, apiI18nMap, playerGameOrder.getApiId(), playerGameOrder.getApiTypeId()));
            gameId = playerGameOrder.getGameId();
            if (gameId != null && gameId != 0) {
                playerGameOrder.setGameName(ApiGameTool.getSiteGameName(siteGameI18nMap, gameI18nMap, String.valueOf(gameId)));
            }
        }
    }

    @RequestMapping("/game")
    public String game(Model model) {
        //游戏一级分类
        apiTypes(model);
        //游戏二级分类
        gameTypes(model);
        return GAME_URI;
    }

    @RequestMapping("/gameRecordDetail")
    public String gameRecordDetail(PlayerGameOrderVo playerGameOrderVo, Model model) {
        playerGameOrderVo = ServiceSiteTool.playerGameOrderService().getGameOrderDetail(playerGameOrderVo);
        PlayerGameOrder playerGameOrder = playerGameOrderVo.getResult();
        //如果不是这个玩家的投注订单，则视无该笔订单
        if (playerGameOrder == null || playerGameOrder.getPlayerId() != SessionManager.getUserId().intValue()) {
            playerGameOrderVo.setResultArray(null);
            playerGameOrderVo.setResult(null);
        }
        model.addAttribute("command", playerGameOrderVo);
        model.addAttribute("resultArray", playerGameOrderVo.getResultArray());
        return GAME_RECORD_DETAIL_URI;
    }

    /**
     * 统计当前页数据
     *
     * @param listVo
     * @param model
     */
    private void statisticsData(PlayerGameOrderListVo listVo, Model model) {
        // 统计数据
        if (listVo.getPaging().getTotalCount() != 0) {
            Map map = ServiceSiteTool.playerGameOrderService().queryTotalPayoutAndEffect(listVo);
            model.addAttribute("singleAmount", map.get("single"));
            model.addAttribute("effectAmount", map.get("effective"));
            model.addAttribute("profitAmount", map.get("profit"));
            model.addAttribute("winningAmount", map.get("winning"));
        }
    }

    /**
     * 获取主货币符号
     *
     * @return
     */
    private String getCurrencySign() {
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
     * 游戏一级分类
     *
     * @param model
     */
    private void apiTypes(Model model) {
        Map<String, SiteApiTypeI18n> siteApiTypeI18nMap = Cache.getSiteApiTypeI18n();
        Map<Integer, String> apiTypes = new HashMap<>(siteApiTypeI18nMap.size(), 1f);
        for (SiteApiTypeI18n siteApiTypeI18n : siteApiTypeI18nMap.values()) {
            if (SessionManager.isMockAccountModel()) {
                if (siteApiTypeI18n.getApiTypeId() == 3 || siteApiTypeI18n.getApiTypeId() == 4) {
                    apiTypes.put(siteApiTypeI18n.getApiTypeId(), siteApiTypeI18n.getName());
                }
            } else {
                apiTypes.put(siteApiTypeI18n.getApiTypeId(), siteApiTypeI18n.getName());

            }
        }
        model.addAttribute("apiTypes", apiTypes);
    }

    /**
     * 游戏二级分类
     *
     * @param model
     */
    private void gameTypes(Model model) {
        SiteGameVo siteGameVo = new SiteGameVo();
        siteGameVo.getSearch().setSiteId(SessionManager.getSiteId());
        List<SiteGame> siteGames = ServiceTool.siteGameService().searchGameTpeOfEachApi(siteGameVo);
        //游戏分类数据<apiId,<游戏二级分类，游戏一级分类id>>
        Map<Integer, Map<String, Integer>> gameTypes = new HashMap<>();
        Integer apiId;
        for (SiteGame siteGame : siteGames) {
            apiId = siteGame.getApiId();
            if (SessionManager.isMockAccountModel()) {
                if (apiId == 21 || apiId == 22) {
                    if (gameTypes.get(apiId) == null) {
                        gameTypes.put(apiId, new HashMap<String, Integer>());
                    }
                    gameTypes.get(apiId).put(siteGame.getGameType(), siteGame.getApiTypeId());
                }
            } else {
                if (gameTypes.get(apiId) == null) {
                    gameTypes.put(apiId, new HashMap<String, Integer>());
                }
                gameTypes.get(apiId).put(siteGame.getGameType(), siteGame.getApiTypeId());
            }


        }
        model.addAttribute("gameTypes", gameTypes);
    }

    /**
     * 获取注单游戏详情
     *
     * @param playerGameOrderDetailVo
     * @return
     */
    @RequestMapping("/GameDetailLink")
    @ResponseBody
    public Map gameDetailLink(PlayerGameOrderDetailVo playerGameOrderDetailVo, @Valid @FormModel PlayerGameOrderDetailSearchForm playerGameOrderDetailSearchForm, BindingResult result) {
        Map map = new HashMap<>(2, 1f);
        if (result.hasErrors()) {
            map.put("state", false);
            map.put("msg", "请检查提交的数据是否正确");
            return map;
        }
        PlayerGameOrderDetailVo detail = ServiceSiteTool.playerGameOrderDetailService().search(playerGameOrderDetailVo);
        ExtendParam extendParam = new ExtendParam(detail.getResult().getApiId());
        String link = getMGLink(detail, extendParam);
        LOG.info("注单游戏详情detaillink={0}", link);
        if (StringTool.isNotBlank(link)) {
            map.put("state", true);
            map.put("msg", link);
        } else {
            map.put("state", false);
            map.put("msg", "获取游戏详情链接失败！");
        }
        return map;
    }

    /**
     * 获取MG 游戏详情链接
     *
     * @param detail
     * @param extendParam
     * @return
     */
    private String getMGLink(PlayerGameOrderDetailVo detail, ExtendParam extendParam) {
        String resultJson = detail.getResult().getResultJson();
        resultJson = resultJson.substring(1, resultJson.length() - 1);
        Map resultMap = JsonTool.fromJson(resultJson, Map.class);
        extendParam.getParams().put("betId", resultMap.get("id"));
        extendParam.getParams().put("currency", resultMap.get("currency_unit"));
        GameApiResult extend = ServiceGameApiTool.gameApiCallService().extend(extendParam);
        Map additionalResult = extend.getAdditionalResult();
        String link = MapTool.getString(additionalResult, "detailUrl");
        return link;
    }
}


