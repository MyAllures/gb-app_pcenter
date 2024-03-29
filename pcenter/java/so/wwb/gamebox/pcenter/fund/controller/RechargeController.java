package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.lang.string.StringTool;
import org.soul.commons.query.sort.Direction;
import org.soul.model.session.SessionKey;
import org.soul.model.sys.po.SysParam;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.TerminalEnum;
import so.wwb.gamebox.model.master.content.enums.CttAnnouncementTypeEnum;
import so.wwb.gamebox.model.master.content.po.CttAnnouncement;
import so.wwb.gamebox.model.master.content.vo.CttAnnouncementListVo;
import so.wwb.gamebox.model.master.content.vo.PayAccountListVo;
import so.wwb.gamebox.model.master.digiccy.po.DigiccyAccountInfo;
import so.wwb.gamebox.model.master.operation.po.VActivityMessage;
import so.wwb.gamebox.model.master.player.po.PlayerRank;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;
import so.wwb.gamebox.web.passport.captcha.CaptchaUrlEnum;

import java.util.*;

/**
 * Created by cherry on 16-9-12.
 */
@Controller
@RequestMapping("/fund/playerRecharge")
public class RechargeController extends RechargeBaseController {
    //存款页面
    private static final String RECHARGE_URI = "/fund/recharge/Recharge";
    //银行公告页面
    private static final String BANK_NOTICE_URI = "/fund/recharge/BankNotice";

    @RequestMapping("/recharge")
    @DemoModel(menuCode = DemoMenuEnum.CKZQ)
    public String recharge(Model model) {
        PayAccountListVo payAccountListVo = new PayAccountListVo();
        payAccountListVo.getSearch().setTerminal(TerminalEnum.PC.getCode());
        payAccountListVo.setPlayerId(SessionManager.getUserId());
        payAccountListVo.setCurrency(SessionManager.getUser().getDefaultCurrency());
        Map<String, Long> channelCountMap = ServiceSiteTool.payAccountService().queryChannelCount(payAccountListVo);
        model.addAttribute("map", channelCountMap);
        model.addAttribute("customerService", getCustomerService());
        Map<String, Object> channelMap = new HashMap<>();
        //快速充值地址
        fastRecharge(model, channelMap);
        //是否支持数字货币
        DigiccyAccountInfo digiccyAccountInfo = ParamTool.getDigiccyAccountInfo();
        model.addAttribute("digiccyAccountInfo", digiccyAccountInfo);
        channelMap.put("channel", channelCountMap);
        channelMap.put("digiccy", digiccyAccountInfo);
        SessionManager.setRechargeChannel(channelMap);
        return RECHARGE_URI;
    }

    public void fastRecharge(Model model, Map<String, Object> channelMap) {
        SysParam rechargeUrlParam = ParamTool.getSysParam(SiteParamEnum.SETTING_RECHARGE_URL);
        if (rechargeUrlParam == null || StringTool.isBlank(rechargeUrlParam.getParamValue())) {
            model.addAttribute("isFastRecharge", false);
            return;
        }
        //快速充值地址
        model.addAttribute("rechargeUrlParam", rechargeUrlParam);
        channelMap.put("rechargeUrlParam", rechargeUrlParam);
        //是否包含全部层级
        SysParam allRank = ParamTool.getSysParam(SiteParamEnum.SETTING_RECHARGE_URL_ALL_RANK);
        if (allRank != null && "true".equals(allRank.getParamValue())) {
            model.addAttribute("isFastRecharge", true);
            channelMap.put("isFastRecharge", true);
            return;
        }
        SysParam ranksParam = ParamTool.getSysParam(SiteParamEnum.SETTING_RECHARGE_URL_RANKS);
        boolean isFastRecharge = false;
        if (ranksParam != null && StringTool.isNotBlank(ranksParam.getParamValue())) {
            PlayerRank rank = getRank();
            String[] ranks = ranksParam.getParamValue().split(",");
            for (String rankId : ranks) {
                if (String.valueOf(rank.getId()).equals(rankId)) {
                    isFastRecharge = true;
                    break;
                }
            }
        }
        channelMap.put("isFastRecharge", isFastRecharge);
        model.addAttribute("isFastRecharge", isFastRecharge);
    }

    @RequestMapping("/loadBankNotice")
    public String loadBankNotice(Model model) {
        CttAnnouncementListVo cttAnnouncementListVo = new CttAnnouncementListVo();
        cttAnnouncementListVo.getSearch().setAnnouncementType(CttAnnouncementTypeEnum.BANK_ANNOOUNCEMENT.getCode());
        cttAnnouncementListVo.getSearch().setLocalLanguage(SessionManager.getLocale().toString());
        cttAnnouncementListVo.getSearch().setPublishTime(new Date());
        cttAnnouncementListVo.getSearch().setDisplay(true);
        cttAnnouncementListVo.getQuery().addOrder(CttAnnouncement.PROP_ORDER_NUM, Direction.ASC);
        cttAnnouncementListVo.getPaging().setPageSize(3);
        cttAnnouncementListVo = ServiceSiteTool.cttAnnouncementService().search(cttAnnouncementListVo);
        model.addAttribute("bankNotices", cttAnnouncementListVo);
        return BANK_NOTICE_URI;
    }

    /**
     * 验证码校验
     *
     * @param code
     * @return
     */
    @RequestMapping("/checkCaptcha")
    @ResponseBody
    public boolean checkCaptcha(@RequestParam("code") String code) {
        return !StringTool.isEmpty(code) && code.equalsIgnoreCase((String) SessionManager.getAttribute(SessionKey.S_CAPTCHA_PREFIX + CaptchaUrlEnum.CODE_RECHARGE.getSuffix()));
    }

    /**
     * 根据存款方式获取
     *
     * @param amount
     * @param rechargeType
     * @return
     */
    @RequestMapping("/sale")
    @ResponseBody
    public List<VActivityMessage> sale(Double amount, String rechargeType) {
        if (ParamTool.isOpenActivityHall()) {
            return new ArrayList<>(0);
        }
        List<VActivityMessage> vActivityMessages;
        if (amount == null) {
            vActivityMessages = searchSales(rechargeType);
        } else {
            vActivityMessages = searchSaleByAmount(amount, rechargeType);
        }
        return vActivityMessages;
    }
}
