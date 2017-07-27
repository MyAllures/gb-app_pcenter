package so.wwb.gamebox.pcenter.controller;

import org.json.JSONObject;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.dict.DictTool;
import org.soul.commons.dubbo.DubboTool;
import org.soul.commons.init.context.CommonContext;
import org.soul.commons.lang.SystemTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleDateTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.support._Module;
import org.soul.commons.tree.TreeNode;
import org.soul.iservice.security.privilege.ISysResourceService;
import org.soul.model.comet.vo.MessageVo;
import org.soul.model.msg.notice.vo.NoticeVo;
import org.soul.model.msg.notice.vo.VNoticeReceivedTextVo;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.po.VSysUserResource;
import org.soul.model.security.privilege.so.SysUserSo;
import org.soul.model.security.privilege.vo.SysResourceVo;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.sys.po.SysParam;
import org.soul.web.controller.BaseIndexController;
import org.soul.web.security.privilege.controller.SysResourceController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.enums.UserTypeEnum;
import so.wwb.gamebox.model.master.enums.CreateChannelEnum;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.PlayerApiListVo;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.pcenter.init.ConfigManager;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.cache.Cache;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.*;


/**
 * Created by tony on 15-4-29.
 */
@Controller
public class IndexController extends BaseIndexController {
    private static final String INDEX_URI = "index";
    private static final String INDEX_PLAYER_INFO_URI = "index.include/PlayerInfo";
    private static final String INDEX_PLAYER_MESSAGE_URI = "index.include/Message";
    private static final String INDEX_CONTENT_URI = "index.include/content";
    private static final String INDEX_MESSAGE_URI = "index.include/Message";
    private static final String INDEX_SET_TIMEZONE = "index.include/SetTimezone";

    @Override
    protected String content(Integer parentId, HttpServletRequest request, HttpServletResponse response, Model model) {
        SysResourceVo o = new SysResourceVo();
        UserTypeEnum userTypeEnum = UserTypeEnum.enumOf(SessionManager.getUser().getUserType());
        switch (userTypeEnum) {
            case MASTER_SUB:
            case TOP_AGENT_SUB:
            case AGENT_SUB:
                o.getSearch().setUserId(SessionManager.getUserId());
                break;
            default:
                break;
        }
        o.getSearch().setSubsysCode(ConfigManager.getConfigration().getSubsysCode());
        o.getSearch().setParentId(parentId);
        List<TreeNode<VSysUserResource>> menuNodeList = DubboTool.getService(ISysResourceService.class).getAllMenus(o);
        SysResourceController.loadLocal(menuNodeList);
        model.addAttribute("command", menuNodeList);
        return INDEX_CONTENT_URI;
    }

    @RequestMapping(value = "index")
    protected String index(HttpServletRequest request, HttpServletResponse response, Model model) {
        /* 获取当前用户未接收的站内信 */
        ServiceTool.noticeService().fetchUnReceivedMsgs(new NoticeVo());
        content(null, request, response, model);
        model.addAttribute("isDebug", SystemTool.isDebug());
        return INDEX_URI;
    }

    /**
     * 顶部右边的玩家信息
     */
    @RequestMapping(value = "playerInfo")
    protected String playerInfo(HttpServletRequest request, HttpServletResponse response, Model model) {
        SysUserVo sysUserVo = new SysUserVo();
        sysUserVo.setResult(SessionManager.getUser());
        model.addAttribute("sysUserVo", sysUserVo);

        //获取总资产
        model.addAttribute("totalAssets", queryPlayerAssets());
        return INDEX_PLAYER_INFO_URI;
    }

    /**
     * 查询玩家总资产
     * @return
     */
    private double queryPlayerAssets() {
        PlayerApiListVo playerApiListVo = new PlayerApiListVo();
        playerApiListVo.getSearch().setPlayerId(SessionManager.getUserId());
        playerApiListVo.setApis(Cache.getApi());
        playerApiListVo.setSiteApis(Cache.getSiteApi());
        return ServiceTool.playerApiService().queryPlayerAssets(playerApiListVo);
    }

    @RequestMapping(value = "/index/queryAssets")
    @ResponseBody
    public Map<String, Object> queryAssets() {
        Map<String, Object> map = new HashMap<>();
        map.put("totalAssets", queryPlayerAssets());
        return map;
    }

    /**
     * 顶部右边的玩家未读信息
     */
    @RequestMapping(value = "playerMessage")
    protected String playerMessage(HttpServletRequest request, HttpServletResponse response, Model model) {
        //系统消息-未读数量
        VNoticeReceivedTextVo vNoticeReceivedTextVo = new VNoticeReceivedTextVo();
        Long number = ServiceTool.noticeService().fetchUnclaimedMsgCount(vNoticeReceivedTextVo);
        model.addAttribute("unReadCount", number);
        return INDEX_PLAYER_MESSAGE_URI;
    }

    /**
     * 头部：消息下拉框
     */
    @RequestMapping(value = "/index/message")
    protected String message(Model model) {
        //TODO Mark this is just for test, will be delete
        MessageVo message = new MessageVo();
        message.setSubscribeType("MSITE-Notice");
        message.setMsgBody("如果您看到此消息，说明消息推送成功。");
        message.setSendToGuest(true);
        message.setSendToUser(true);
        ServiceTool.messageService().sendToMsiteMsg(message);
        //TODO Mark End
        return INDEX_MESSAGE_URI;
    }

    /**
     * 更新是否提示消息session
     */
    @RequestMapping(value = "/index/updateIsReminderMsg")
    @ResponseBody
    protected void updateIsReminderMsg() {
        if (SessionManager.getIsReminderMsg()) {
            SessionManager.setIsReminderMsg(false);
        }
    }

    /**
     * 用户所在时区时间
     */
    @RequestMapping(value = "/index/getUserTimeZoneDate")
    @ResponseBody
    public String getUserTimeZoneDate() {
        Map<String, String> map = new HashMap<>(2,1f);
        map.put("dateTimeFromat", CommonContext.getDateFormat().getDAY_SECOND());
        map.put("dateTime", SessionManager.getUserDate(CommonContext.getDateFormat().getDAY_SECOND()));
        map.put("time", String.valueOf(new Date().getTime()));
        return JsonTool.toJson(map);
    }

    /**玩家是否需要设置时区*/
    @RequestMapping(value = "/index/needSetTimezone")
    @ResponseBody
    public boolean needSetTimezone() {
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.setResult(new UserPlayer());
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);
        SysUserVo sysUserVo = new SysUserVo();
        sysUserVo.setSearch(new SysUserSo());
        sysUserVo.getSearch().setId(SessionManager.getUserId());
        sysUserVo = ServiceTool.sysUserService().get(sysUserVo);
        return CreateChannelEnum.TRANSFER.getCode().equals(userPlayerVo.getResult().getCreateChannel()) && StringTool.isBlank(sysUserVo.getResult().getDefaultTimezone());
    }

    @RequestMapping(value = "/index/setTimezone", method = RequestMethod.GET)
    public String setTimezone(Model model) {
        model.addAttribute("command", DictTool.get(DictEnum.COMMON_TIME_ZONE));
        return INDEX_SET_TIMEZONE;
    }


    @RequestMapping("/index/getDateByTimezone")
    @ResponseBody
    public String getDateByTimezone(@RequestParam("result.defaultTimezone") String timezone) {
        return LocaleDateTool.formatDate(new Date(), CommonContext.getDateFormat().getDAY_SECOND(), timezone);
    }

    @RequestMapping(value = "/index/setTimezone", method = RequestMethod.POST)
    @ResponseBody
    public Map changeTimezone(HttpServletRequest request) {
        SysUserVo sysUserVo = new SysUserVo();
        String defaultTimezone = request.getParameter("result.defaultTimezone");
        sysUserVo.getSearch().setId(SessionManager.getUserId());
        sysUserVo = ServiceTool.sysUserService().get(sysUserVo);
        sysUserVo.setProperties(SysUser.PROP_DEFAULT_TIMEZONE);
        sysUserVo.getResult().setDefaultTimezone(defaultTimezone);
        ServiceTool.sysUserService().updateOnly(sysUserVo);
        sysUserVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, "save.success"));
        Map<String, Object> map = new HashMap(2,1f);

        if (sysUserVo.isSuccess() && StringTool.isBlank(sysUserVo.getOkMsg())) {
            sysUserVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, "save.success"));

        } else if (!sysUserVo.isSuccess() && StringTool.isBlank(sysUserVo.getErrMsg())) {
            sysUserVo.setErrMsg(LocaleTool.tranMessage(_Module.COMMON, "save.failed"));
        }
        map.put("msg", StringTool.isNotBlank(sysUserVo.getOkMsg()) ? sysUserVo.getOkMsg() : sysUserVo.getErrMsg());
        map.put("state", sysUserVo.isSuccess());
        return map;
    }

    /**
     * 查出站长设置的声音
     */
    @RequestMapping({"/index/queryTones"})
    @ResponseBody
    public Collection<SysParam> queryTones() {
        return ParamTool.getSysParams(SiteParamEnum.WARMING_TONE_DEPOSIT);
    }

    /**
     * 初始化加载语言字典
     */
    @RequestMapping(value = "index/language")
    @ResponseBody
    protected String language() {
        JSONObject jb = new JSONObject();
        String languageCurrent = CommonContext.get().getLocale().toString();
        Map languageDicts = Cache.getAvailableSiteLanguage();
        Map<String, Map<String, Map<String, String>>> dicts = I18nTool.getDictsMap(languageCurrent);
        jb.put("languageCurrent", languageCurrent);
        jb.put("languageDicts", languageDicts);
        jb.put("languageI18n", dicts.get("common").get("language"));

        return jb.toString();
    }
}
