package so.wwb.gamebox.pcenter.recommend.controller;

import com.fasterxml.jackson.core.type.TypeReference;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.net.ServletTool;
import org.soul.commons.security.Base36;
import org.soul.model.sys.po.SysParam;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.iservice.master.report.IPlayerRecommendAwardService;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteI18nEnum;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.company.setting.po.SysCurrency;
import so.wwb.gamebox.model.company.site.po.SiteI18n;
import so.wwb.gamebox.model.company.site.vo.SiteConfineIpVo;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.model.master.report.po.PlayerRecommendAward;
import so.wwb.gamebox.model.master.report.vo.PlayerRecommendAwardListVo;
import so.wwb.gamebox.model.master.setting.po.GradientTemp;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.common.cache.Cache;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;

import javax.servlet.http.HttpServletRequest;
import java.util.ArrayList;
import java.util.Map;


/**
 * 控制器
 *
 * @author cheery
 * @time 2015-11-1 11:14:42
 */
@Controller
//region your codes 1
@RequestMapping("/playerRecommendAward")
public class PlayerRecommendAwardController {

    private static final Log LOG = LogFactory.getLog(PlayerRecommendAward.class);
    private static final String RECORD_TYPE = "record";
//endregion your codes 1

    private String getViewBasePath() {
        //region your codes 2
        return "/recommend/";
        //endregion your codes 2
    }

    private IPlayerRecommendAwardService getService() {
        return ServiceSiteTool.playerRecommendAwardService();
    }

    //region your codes 3
    @RequestMapping("/recommendRecord")
    public String recommendRecord(Model model, PlayerRecommendAwardListVo listVo, HttpServletRequest request) {
        getRecord(listVo, model);
        if (ServletTool.isAjaxSoulRequest(request)) {
            return getViewBasePath() + "RecommendRecordPartial";
        }
        //查询推荐好友数量、奖励总金额、奖励总红利
        getTotalRecommend(listVo, model);
        return getViewBasePath() + "RecommendRecord";
    }

    @RequestMapping("/recommend")
    @DemoModel(menuCode = DemoMenuEnum.TJHY)
    public String recommend(Model model, String type, PlayerRecommendAwardListVo listVo, HttpServletRequest request) {
        if (RECORD_TYPE.equals(type)) {
            getRecord(listVo, model);
            getTotalRecommend(listVo, model);
        } else {
            recommendBaseData(model, new SiteConfineIpVo(), listVo);
        }
        if (ServletTool.isAjaxSoulRequest(request) && StringTool.isBlank(type)) {
            return getViewBasePath() + "RecommendPartial";
        } else if (ServletTool.isAjaxSoulRequest(request) && RECORD_TYPE.equals(type)) {
            return getViewBasePath() + "RecommendRecord";
        } else {
            return getViewBasePath() + "Recommend";
        }
    }

    /**
     * 查询推荐好友数量、奖励总金额、奖励总红利
     *
     * @param listVo
     * @param model
     */
    private void getTotalRecommend(PlayerRecommendAwardListVo listVo, Model model) {
        //查询推荐好友数量、奖励总金额、奖励总红利
        Map map = getService().searchCountAndAmountAndRebate(listVo);
        model.addAttribute("map", map);
    }

    /**
     * 获取推荐记录
     *
     * @param listVo
     * @param model
     */
    private void getRecord(PlayerRecommendAwardListVo listVo, Model model) {
        //查询被该玩家推荐的好友记录奖励表
        listVo.getSearch().setUserId(SessionManager.getUserId());
        listVo.getSearch().setStartTime(SessionManager.getDate().getYestoday());
        listVo.getSearch().setEndTime(SessionManager.getDate().getToday());
        listVo = getService().searchRewardRecode(listVo);
        model.addAttribute("command", listVo);
        //判断是否展现推荐单次奖励/推荐红利
        SysParam rewardTheway = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_REWARD_THEWAY);
        SysParam bonus = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_BONUS);
        model.addAttribute("rewardTheway", rewardTheway);
        model.addAttribute("bonus", bonus);
    }

    /**
     * 推荐页面基础数据（包含推荐内容、推荐规则、推荐链接等）
     *
     * @param model
     * @param siteConfineIpVo
     * @param listVo
     */
    private void recommendBaseData(Model model, SiteConfineIpVo siteConfineIpVo, PlayerRecommendAwardListVo listVo) {
        //推荐设置参数
        SysParam reward = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_REWARD);
        SysParam rewardMoney = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_REWARD_MONEY);
        SysParam rewardTheway = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_REWARD_THEWAY);
        SysParam bonusBonusMax = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_BONUS_BONUSMAX);
        SysParam bonusTrading = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_BONUS_TRADING);
        SysParam bonus = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_BONUS);
        SysParam bonusAudit = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_BONUS_AUDIT);
        SysParam bonusJson = ParamTool.getSysParam(SiteParamEnum.SETTING_RECOMMENDED_BONUS_JSON);

        if (bonusJson != null && StringTool.isNotBlank(bonusJson.getParamValue())) {
            ArrayList<GradientTemp> gradientTempArrayList = JsonTool.fromJson(bonusJson.getParamValue(), new TypeReference<ArrayList<GradientTemp>>() {
            });
            siteConfineIpVo.setGradientTempList(gradientTempArrayList);
        }
        siteConfineIpVo.setBonusJsonId(bonusJson.getId());
        siteConfineIpVo.setBonusAudit(bonusAudit);
        siteConfineIpVo.setIsReward(reward);
        siteConfineIpVo.setRewardMoney(rewardMoney);
        siteConfineIpVo.setRewardTheWay(rewardTheway);
        siteConfineIpVo.setBonusBonusMax(bonusBonusMax);
        siteConfineIpVo.setBonusTrading(bonusTrading);
        siteConfineIpVo.setBonus(bonus);
        model.addAttribute("command", siteConfineIpVo);

        //活动规则
        Map<String, SiteI18n> ruleMap = Cache.getSiteI18n(SiteI18nEnum.MASTER_RECOMMEND_RULE, SessionManager.getSiteId());
        model.addAttribute("rule", ruleMap.get(SessionManager.getLocale().toString()));
        Map<String, SiteI18n> contentMap = Cache.getSiteI18n(SiteI18nEnum.MASTER_RECOMMEND_CONTENT, SessionManager.getSiteId());
        model.addAttribute("content", contentMap.get(SessionManager.getLocale().toString()));

        //查询玩家
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceSiteTool.userPlayerService().get(userPlayerVo);
        if(userPlayerVo.getResult()!=null){
            model.addAttribute("player", userPlayerVo.getResult());
            String invitationCode = userPlayerVo.getResult().getRegistCode() + SessionManager.getUserId().toString();
            model.addAttribute("invitationCode", Base36.encryptIgnoreCase(invitationCode));
            LOG.info("玩家邀请码:[" + userPlayerVo.getResult().getRegistCode() + "][" + SessionManager.getUserId().toString() + "]" + Base36.encryptIgnoreCase(invitationCode));
        }

        //查询玩家主货币
        String defaultCurrency = SessionManager.getUser().getDefaultCurrency();
        if (StringTool.isNotBlank(defaultCurrency)) {
            SysCurrency sysCurrency = Cache.getSysCurrency().get(defaultCurrency);
            String currencySign = sysCurrency.getCurrencySign();
            model.addAttribute("currency", currencySign);//玩家主货币
        }
        //查询推荐好友数量、奖励总金额、奖励总红利
        listVo.getSearch().setUserId(SessionManager.getUserId());
        Map map = getService().searchRecomdCountAndAmount(listVo);
        model.addAttribute("map", map);
    }


    //endregion your codes 3

}
