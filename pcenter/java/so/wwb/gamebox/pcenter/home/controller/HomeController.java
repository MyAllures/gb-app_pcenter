package so.wwb.gamebox.pcenter.home.controller;

import org.soul.commons.collections.CollectionTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.query.Paging;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.model.company.enums.GameStatusEnum;
import so.wwb.gamebox.model.company.operator.vo.VSystemAnnouncementListVo;
import so.wwb.gamebox.model.company.setting.po.Api;
import so.wwb.gamebox.model.company.site.po.SiteApi;
import so.wwb.gamebox.model.company.site.po.SiteI18n;
import so.wwb.gamebox.model.listop.StatusEnum;
import so.wwb.gamebox.model.master.content.po.CttCarousel;
import so.wwb.gamebox.model.master.enums.AnnouncementTypeEnum;
import so.wwb.gamebox.model.master.enums.CarouselTypeEnum;
import so.wwb.gamebox.model.master.operation.vo.PlayerActivityMessage;
import so.wwb.gamebox.model.master.operation.vo.PlayerActivityMessageListVo;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.cache.Cache;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

/**
 * 玩家中心首页
 * <p>
 * Created by cheery on 15-8-27.
 */
@Controller
@RequestMapping("/home")
public class HomeController {
    private static final String HOME_INDEX_URI = "/home/Index";
    private static final String HOME_ASSETS_URI = "/home/index.include/Assets";
    private static final String HOME_GAME_AND_SALE_URI = "/home/index.include/GameAndSale";
    private static final String HOME_CAROUSEL_URI = "/home/index.include/Carousel";
    private static final String HOME_GAMEANNOUNCEMENT_URI = "/home/index.include/GameAnnouncement";
    private static final String HOME_ACTIVITYMESSAGE_URI = "/home/index.include/ActivityMessage";

    @RequestMapping("/loadCarousel")
    public String loadCarousel(Model model) {
        List<Map> carouselList = searchAdvertisement();
        model.addAttribute("carouselList", carouselList);
        return HOME_CAROUSEL_URI;
    }

    @RequestMapping("/loadGameAnnouncement")
    public String loadGameAnnouncement(Model model) {
        VSystemAnnouncementListVo listVo = new VSystemAnnouncementListVo();
        listVo.getPaging().setPageSize(5);
        listVo.getSearch().setLocal(SessionManager.getLocale().toString());
        listVo.getSearch().setAnnouncementType(AnnouncementTypeEnum.GAME.getCode());
        listVo.getSearch().setPublishTime(SessionManager.getUser().getCreateTime());
        listVo = ServiceTool.vSystemAnnouncementService().searchMasterSystemNotice(listVo);
        model.addAttribute("gameAnnouncement", listVo);
        //获取SiteApi
        Map apiMap = Cache.getSiteApiI18n();
        model.addAttribute("apiMap", apiMap);
        return HOME_GAMEANNOUNCEMENT_URI;
    }

    @RequestMapping("/loadActivityMessage")
    public String loadActivityMessage(Model model) {
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);

        String language = SessionManager.getLocale().toString();
        //获取活动分类
        getOperationActivityClassify(model, language);
        PlayerActivityMessageListVo playerActivityMessageListVo = new PlayerActivityMessageListVo();
        Integer userId = SessionManager.getUserId();
        playerActivityMessageListVo.setUserId(userId);
        playerActivityMessageListVo.setActivityVersion(language);
        playerActivityMessageListVo.setRankId(userPlayerVo.getResult().getRankId());
        playerActivityMessageListVo.setRegisterTime(SessionManager.getUser().getCreateTime());

        //分页计算
        Paging paging = playerActivityMessageListVo.getPaging();
        paging.setTotalCount(ServiceTool.playerActivityMessageService().countPlayerActivityMessage(playerActivityMessageListVo));
        paging.cal();

        List<PlayerActivityMessage> playerActivityMessageList = ServiceTool.playerActivityMessageService().queryPlayerActivityMessage(playerActivityMessageListVo);

        playerActivityMessageListVo.setResult(playerActivityMessageList);
        model.addAttribute("sale", playerActivityMessageListVo);
        return HOME_ACTIVITYMESSAGE_URI;
    }

    /**
     * 广告
     */
    private List<Map> searchAdvertisement() {
        int carouselNum = 6;//广告推荐位取前6位
        Map<String, CttCarousel> siteCarousel = Cache.getSiteCarousel();
        Iterator<String> iter = siteCarousel.keySet().iterator();
        List<Map> carouselList = new ArrayList<>(carouselNum);
        Map<String, Api> apis = Cache.getApi();
        Map<String, SiteApi> siteApis = Cache.getSiteApi();
        int count = 0;
        while (iter.hasNext() && count < carouselNum) {
            String key = iter.next();
            Map cttCarousel = (Map) siteCarousel.get(key);
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            try {
                Date endTime = sdf.parse(cttCarousel.get("end_time").toString());
                if (DateTool.secondsBetween(endTime, new Date()) > 0) {
                    addCarousel(cttCarousel, count, carouselList, apis, siteApis);
                }
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return carouselList;
    }

    private void addCarousel(Map cttCarousel, int count, List<Map> carouselList, Map<String, Api> apis, Map<String, SiteApi> siteApis) {
        if (SessionManager.getLocale().toString().equals(cttCarousel.get("language")) &&
                CarouselTypeEnum.CAROUSEL_TYPE_PLAYER_INDEX.getCode().equals(cttCarousel.get("type")) && "true".equals(cttCarousel.get("status").toString())) {
            String typeJson = cttCarousel.get("link") == null ? "" : cttCarousel.get("link").toString();
            if (StringTool.isNotBlank(typeJson)) {
                Map jsonMap = JsonTool.fromJson(typeJson, Map.class);
                if (jsonMap != null) {
                    String apiId = (String) jsonMap.get("apiId");
                    Api api = apis.get(apiId);
                    SiteApi siteApi = siteApis.get(apiId);
                    if (api != null && siteApi != null && !GameStatusEnum.DISABLE.getCode().equals(api.getSystemStatus()) && !GameStatusEnum.DISABLE.getCode().equals(siteApi.getSystemStatus())) {
                        cttCarousel.putAll(jsonMap);
                        if(api.getMaintainStartTime()!=null) cttCarousel.put("maintainStart",api.getMaintainStartTime().getTime());
                        if (api.getMaintainEndTime()!=null) cttCarousel.put("maintainEnd",api.getMaintainEndTime().getTime());
                        count++;
                        carouselList.add(cttCarousel);
                    }
                }
            } else {
                count++;
                carouselList.add(cttCarousel);
            }
        }
    }

    @RequestMapping("/gameAndSale")
    protected String gameAndSale(Model model) {
        //游戏公告
        gameAnnouncement(model);
        //优惠活动
        sale(model, new PlayerActivityMessageListVo());
        return HOME_GAME_AND_SALE_URI;
    }

    //刷新余额
    @RequestMapping("/refreshWalletBalance")
    @ResponseBody
    private Map refreshWalletBalance() {
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.setResult(new UserPlayer());
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);
        HashMap map = new HashMap(2,1f);
        map.put("state", Boolean.valueOf(userPlayerVo.isSuccess()));
        map.put("walletBalance", userPlayerVo.getResult().getWalletBalance());
        return map;
    }

    /**
     * 查询公告
     *
     * @param model
     * @param listVo
     */
    /*private void announcement(Model model, VSystemAnnouncementListVo listVo) {
        listVo.getSearch().setLocal(SessionManager.getLocale().toString());
        listVo.getPaging().setPageSize(5);
        List<VSystemAnnouncement> vList = ServiceTool.vSystemAnnouncementService().searchAnnouncement(listVo);
        model.addAttribute("announcementList", vList);
    }*/

    /**
     * 优惠活动
     *
     * @param model
     * @param playerActivityMessageListVo
     */
    private void sale(Model model, PlayerActivityMessageListVo playerActivityMessageListVo) {
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);

        /*String language = SessionManager.getLocale().toString();
        getOperationActivityClassify(model, language);

        //查询优惠活动条件
        listVo.getSearch().setActivityVersion(language);
        listVo.getSearch().setIsDisplay(true);
        listVo.getSearch().setIsDeleted(false);
        listVo.getSearch().setRankid(userPlayerVo.getResult().getRankId().toString() + ',');
        listVo.getSearch().setCheckStatus(ContentCheckEnum.PASS.getCode());
        listVo.getSearch().setActivityState(ActivityStateEnum.RELEASE.getCode());
        listVo.getSearch().setStates(ActivityStateEnum.PROCESSING.getCode());
        listVo.getSearch().setIsAllRank(true);
        listVo.getSearch().setRegisterTime(SessionManager.getUser().getCreateTime());
        listVo.getPaging().setPageSize(8);
        listVo = ServiceTool.vPlayerActivityMessageService().search(listVo);
        model.addAttribute("sale", listVo);*/

        String language = SessionManager.getLocale().toString();
        //获取活动分类
        getOperationActivityClassify(model, language);

        Integer userId = SessionManager.getUserId();
        playerActivityMessageListVo.setUserId(userId);
        playerActivityMessageListVo.setActivityVersion(language);
        playerActivityMessageListVo.setRankId(userPlayerVo.getResult().getRankId());
        playerActivityMessageListVo.setRegisterTime(SessionManager.getUser().getCreateTime());

        //分页计算
        Paging paging = playerActivityMessageListVo.getPaging();
        paging.setTotalCount(ServiceTool.playerActivityMessageService().countPlayerActivityMessage(playerActivityMessageListVo));
        paging.cal();

        List<PlayerActivityMessage> playerActivityMessageList = ServiceTool.playerActivityMessageService().queryPlayerActivityMessage(playerActivityMessageListVo);

        playerActivityMessageListVo.setResult(playerActivityMessageList);
        model.addAttribute("sale", playerActivityMessageListVo);
    }

    /**
     * 获取活动分类
     *
     * @param model
     * @param language
     */
    private void getOperationActivityClassify(Model model, String language) {
        Map<String, SiteI18n> siteI18nMap = Cache.getOperateActivityClassify();
        List<SiteI18n> siteI18ns = new ArrayList<>();
        for (String siteI18nMapKey : siteI18nMap.keySet()) {
            String[] key = StringTool.split(siteI18nMapKey, ":");
            if (language.equals(key[1])) {
                siteI18ns.add(siteI18nMap.get(siteI18nMapKey));
            }
        }
        if (siteI18ns != null && siteI18ns.size() > 0) {
            Map<String, SiteI18n> siteI18nMap2 = CollectionTool.toEntityMap(siteI18ns, SiteI18n.PROP_KEY, String.class);
            model.addAttribute("siteI18nMap", siteI18nMap2);
        }
        model.addAttribute("siteI18ns", siteI18ns);
    }

    /**
     * 获取游戏公告
     *
     * @param model
     */
    private void gameAnnouncement(Model model) {
        VSystemAnnouncementListVo listVo = new VSystemAnnouncementListVo();
        listVo.getPaging().setPageSize(5);
        listVo.getSearch().setLocal(SessionManager.getLocale().toString());
        listVo.getSearch().setAnnouncementType(AnnouncementTypeEnum.GAME.getCode());
        listVo.getSearch().setPublishTime(SessionManager.getUser().getCreateTime());
        listVo = ServiceTool.vSystemAnnouncementService().searchMasterSystemNotice(listVo);
        model.addAttribute("gameAnnouncement", listVo);
        //获取SiteApi
        Map apiMap = Cache.getSiteApiI18n();
        model.addAttribute("apiMap", apiMap);

    }
}
