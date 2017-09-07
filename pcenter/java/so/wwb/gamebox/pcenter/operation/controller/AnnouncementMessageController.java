package so.wwb.gamebox.pcenter.operation.controller;

import org.soul.commons.currency.CurrencyTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.dict.DictTool;
import org.soul.commons.dubbo.DubboTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.net.ServletTool;
import org.soul.commons.query.Criterion;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.support._Module;
import org.soul.model.comet.vo.MessageVo;
import org.soul.model.msg.notice.po.VNoticeReceivedText;
import org.soul.model.msg.notice.vo.NoticeReceiveVo;
import org.soul.model.msg.notice.vo.VNoticeReceivedTextListVo;
import org.soul.model.msg.notice.vo.VNoticeReceivedTextVo;
import org.soul.model.security.privilege.vo.SysResourceListVo;
import org.soul.model.session.SessionKey;
import org.soul.model.sys.po.SysParam;
import org.soul.commons.locale.DateQuickPicker;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.iservice.comet.IMessageService;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.Const;
import so.wwb.gamebox.model.common.MessageI18nConst;
import so.wwb.gamebox.model.common.notice.enums.CometSubscribeType;
import so.wwb.gamebox.model.company.operator.po.VSystemAnnouncement;
import so.wwb.gamebox.model.company.operator.vo.VSystemAnnouncementListVo;
import so.wwb.gamebox.model.master.enums.AnnouncementTypeEnum;
import so.wwb.gamebox.model.master.enums.UserTaskEnum;
import so.wwb.gamebox.model.master.fund.po.PlayerWithdraw;
import so.wwb.gamebox.model.master.operation.po.PlayerAdvisoryRead;
import so.wwb.gamebox.model.master.operation.vo.PlayerAdvisoryReadVo;
import so.wwb.gamebox.model.master.player.enums.PlayerAdvisoryEnum;
import so.wwb.gamebox.model.master.player.po.PlayerAdvisory;
import so.wwb.gamebox.model.master.player.po.PlayerAdvisoryReply;
import so.wwb.gamebox.model.master.player.po.VPlayerAdvisory;
import so.wwb.gamebox.model.master.player.vo.*;
import so.wwb.gamebox.model.master.tasknotify.vo.UserTaskReminderVo;
import so.wwb.gamebox.pcenter.operation.form.AdvisoryMessageForm;
import so.wwb.gamebox.pcenter.operation.form.PlayerAdvisoryForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.passport.captcha.CaptchaUrlEnum;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.Serializable;
import java.util.*;


/**
 * 玩家中心-系统公告视图控制器
 *
 * @author orange
 * @time 2015-10-26 16:29:08
 */
@Controller
@RequestMapping("/operation/pAnnouncementMessage")
public class AnnouncementMessageController {

    private static final String MESSAGE_INDEX_URL = "/operation/announcementMessage/Index";
    private static final String ANNOUNCEMENT_DETAIL_URL = "/operation/announcementMessage/MessageDetail";
    private static final String ADVISORY_MESSAGE_URL = "/operation/announcementMessage/AdvisoryMessage";
    private static final String ADVISORY_MESSAGE_DETAIL = "/operation/announcementMessage/AdvisoryMessageDetail";
    private static final String SEND_MESSAGE = "/operation/announcementMessage/SendMessage";
    private static final String GAME_NOTICE_URL = "/operation/announcementMessage/GameNotice";
    //系统公告
    private static final String SYSTEM_NOTICE_HISTORY_URL = "/operation/announcementMessage/SystemNoticeHistory";
    //系统公告详情
    private static final String SYSTEM_NOTICE_DETAIL_URL = "/operation/announcementMessage/SystemNoticeDetail";
    //游戏公告详情
    private static final String GAME_NOTICE_DETAIL_URL = "/operation/announcementMessage/GameNoticeDetail";
    //公告弹窗
    private static final String ANNOUNCEMENT_POPUP_URL = "/operation/announcementMessage/AnnouncementPopup";

    protected String getViewBasePath() {
        return "/operation/announcementMessage/";
    }

    /**
     * 玩家中心-系统消息-显示
     *
     * @param listVo
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("/messageList")
    public String messageList(VNoticeReceivedTextListVo listVo, VPlayerAdvisoryListVo aListVo, Model model, HttpServletRequest request) {
        listVo.getSearch().setReceiverId(SessionManager.getUserId());
        listVo = ServiceTool.noticeService().fetchReceivedSiteMsg(listVo);
        List<VNoticeReceivedText> texts = new ArrayList<>();
        for (VNoticeReceivedText text : listVo.getResult()) {
            text.setContent(text.getContent().replaceAll("\\$\\{user\\}", SessionManager.getUserName()));
            text.setTitle(text.getTitle().replaceAll("\\$\\{user\\}", SessionManager.getUserName()));
            texts.add(text);
        }
        listVo.setResult(texts);
        model.addAttribute("command", listVo);

        //未读数量
        this.unReadCount(aListVo, model);

        return ServletTool.isAjaxSoulRequest(request) ? MESSAGE_INDEX_URL + "Partial" : MESSAGE_INDEX_URL;
    }

    private VPlayerAdvisoryListVo unReadCount(VPlayerAdvisoryListVo listVo, Model model) {
        //系统消息-未读数量
        VNoticeReceivedTextVo vNoticeReceivedTextVo = new VNoticeReceivedTextVo();
        Long length = ServiceTool.noticeService().fetchUnclaimedMsgCount(vNoticeReceivedTextVo);
        model.addAttribute("length", length);
        //玩家咨询-未读数量
        listVo.setSearch(null);
        listVo.getSearch().setSearchType("player");
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        listVo.getSearch().setAdvisoryTime(DateTool.addDays(new Date(), -30));
        listVo.getSearch().setPlayerDelete(false);
        listVo = ServiceTool.vPlayerAdvisoryService().search(listVo);
        Integer advisoryUnReadCount = 0;
        String tag = "";
        //所有咨询数据
        for (VPlayerAdvisory obj : listVo.getResult()) {
            //查询回复表每一条在已读表是否存在
            PlayerAdvisoryReplyListVo parListVo = new PlayerAdvisoryReplyListVo();
            parListVo.getSearch().setPlayerAdvisoryId(obj.getId());
            parListVo = ServiceTool.playerAdvisoryReplyService().searchByIdPlayerAdvisoryReply(parListVo);
            for (PlayerAdvisoryReply replay : parListVo.getResult()) {
                PlayerAdvisoryReadVo readVo = new PlayerAdvisoryReadVo();
                readVo.setResult(new PlayerAdvisoryRead());
                readVo.getSearch().setUserId(SessionManager.getUserId());
                readVo.getSearch().setPlayerAdvisoryReplyId(replay.getId());
                readVo = ServiceTool.playerAdvisoryReadService().search(readVo);
                //不存在未读+1，标记已读咨询Id
                if (readVo.getResult() == null && !tag.contains(replay.getPlayerAdvisoryId().toString())) {
                    advisoryUnReadCount++;
                    tag += replay.getPlayerAdvisoryId().toString() + ",";
                }
            }
        }
        //判断已标记的咨询Id除外的未读咨询id,添加未读标记isRead=false;
        String[] tags = tag.split(",");
        for (VPlayerAdvisory vo : listVo.getResult()) {
            for (int i = 0; i < tags.length; i++) {
                if (tags[i] != "") {
                    VPlayerAdvisoryVo pa = new VPlayerAdvisoryVo();
                    pa.getSearch().setId(Integer.valueOf(tags[i]));
                    VPlayerAdvisoryVo vpaVo = ServiceTool.vPlayerAdvisoryService().get(pa);
                    if (vo.getId().equals(vpaVo.getResult().getContinueQuizId()) || vo.getId().equals(vpaVo.getResult().getId())) {
                        vo.setIsRead(false);
                    }
                }
            }
        }
        model.addAttribute("advisoryUnReadCount", advisoryUnReadCount);
        return listVo;
    }

    /**
     * 玩家中心-系统消息详细
     *
     * @param vo
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("/announcementDetail")
    public String announcementDetail(VNoticeReceivedTextVo vo, VPlayerAdvisoryListVo aListVo, NoticeReceiveVo noticeReceiveVo, Model model, HttpServletRequest request) {
        List list = new ArrayList();
        list.add(noticeReceiveVo.getSearch().getId());
        noticeReceiveVo.setIds(list);
        ServiceTool.noticeService().markSiteMsg(noticeReceiveVo);

        vo = ServiceTool.noticeService().fetchReceivedSiteMsgDetail(vo);
        vo.getResult().setContent(vo.getResult().getContent().replaceAll("\\$\\{user\\}", SessionManager.getUserName()));
        vo.getResult().setTitle(vo.getResult().getTitle().replaceAll("\\$\\{user\\}", SessionManager.getUserName()));
        model.addAttribute("command", vo);

        //未读数量
        this.unReadCount(aListVo, model);

        return ANNOUNCEMENT_DETAIL_URL;
    }

    /**
     * 玩家中心-删除系统消息
     *
     * @param vo
     * @param ids
     * @return
     */
    @RequestMapping("/deleteNoticeReceived")
    @ResponseBody
    public Map deleteNoticeReceived(NoticeReceiveVo vo, String ids) {
        String[] idArray = ids.split(",");
        List<Integer> list = new ArrayList();
        for (String id : idArray) {
            list.add(Integer.valueOf(id));
        }
        vo.setIds(list);
        boolean bool = ServiceTool.noticeService().deleteSiteMsg(vo);

        if (bool) {
            vo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.DELETE_SUCCESS));
        } else {
            vo.setErrMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.DELETE_FAILED));
        }
        HashMap map = new HashMap(2,1f);
        map.put("msg", StringTool.isNotBlank(vo.getOkMsg()) ? vo.getOkMsg() : vo.getErrMsg());
        map.put("state", Boolean.valueOf(vo.isSuccess()));
        return map;
    }


    /**
     * 玩家中心-系统消息-标记已读
     *
     * @param ids
     * @return
     */
    @RequestMapping("/systemMessageEditStatus")
    @ResponseBody
    public Map messageEditStatus(NoticeReceiveVo noticeReceiveVo, String ids) {
        String[] idArray = ids.split(",");
        List<Integer> list = new ArrayList();
        for (String id : idArray) {
            list.add(Integer.valueOf(id));
        }
        noticeReceiveVo.setIds(list);
        boolean b = ServiceTool.noticeService().markSiteMsg(noticeReceiveVo);

        if (b) {
            noticeReceiveVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, "update.success"));
        } else {
            noticeReceiveVo.setErrMsg(LocaleTool.tranMessage(_Module.COMMON, "update.failed"));
        }
        HashMap map = new HashMap(2,1f);
        map.put("msg", StringTool.isNotBlank(noticeReceiveVo.getOkMsg()) ? noticeReceiveVo.getOkMsg() : noticeReceiveVo.getErrMsg());
        map.put("state", Boolean.valueOf(b));
        return map;
    }

    /**
     * 系统公告
     *
     * @param request
     * @param vListVo
     * @param model
     * @return
     */
    @RequestMapping("/systemNoticeHistory")
    public String systemNoticeHistory(HttpServletRequest request, VPlayerAdvisoryListVo aListVo, VSystemAnnouncementListVo vListVo, Model model) {
        if (vListVo.getSearch().getStartTime() == null && vListVo.getSearch().getEndTime() == null) {
            vListVo.getSearch().setStartTime(DateTool.addMonths(SessionManager.getDate().getNow(), -1));
            vListVo.getSearch().setEndTime(SessionManager.getDate().getNow());
        }
        vListVo.getSearch().setLocal(SessionManager.getLocale().toString());
        vListVo.getSearch().setAnnouncementType(AnnouncementTypeEnum.SYSTEM.getCode());
        vListVo.getSearch().setPublishTime(SessionManager.getUser().getCreateTime());
        vListVo = ServiceTool.vSystemAnnouncementService().searchMasterSystemNotice(vListVo);
        for (VSystemAnnouncement vSystemAnnouncement : vListVo.getResult()) {
            vSystemAnnouncement.setContent(StringTool.replaceHtml(vSystemAnnouncement.getContent()));
        }
        model.addAttribute("command", vListVo);
        model.addAttribute("maxDate", new Date());
        //未读数量
//        this.unReadCount(aListVo, model);
        return ServletTool.isAjaxSoulRequest(request) ? SYSTEM_NOTICE_HISTORY_URL + "Partial" : SYSTEM_NOTICE_HISTORY_URL;
    }

    /**
     * 系统公告详细
     *
     * @param model
     * @param vSystemAnnouncementListVo
     * @return
     */
    @RequestMapping("/systemNoticeDetail")
    public String systemNoticeDetail(Model model, VPlayerAdvisoryListVo aListVo, VSystemAnnouncementListVo vSystemAnnouncementListVo) {
        vSystemAnnouncementListVo.getSearch().setLocal(SessionManager.getLocale().toString());
        vSystemAnnouncementListVo = ServiceTool.vSystemAnnouncementService().search(vSystemAnnouncementListVo);
        model.addAttribute("vSystemAnnouncementListVo", vSystemAnnouncementListVo);
        //未读数量
        this.unReadCount(aListVo, model);
        return SYSTEM_NOTICE_DETAIL_URL;
    }


    /**
     * 玩家中心-咨询消息显示
     *
     * @param listVo
     * @param model
     * @return
     */
    @RequestMapping("/advisoryMessage")
    public String advisoryMessage(VPlayerAdvisoryListVo listVo, VPlayerAdvisoryListVo aListVo, Model model, HttpServletRequest request) {
        //提问内容+未读数量
        listVo = this.unReadCount(listVo, model);
        model.addAttribute("command", listVo);
        return ServletTool.isAjaxSoulRequest(request) ? ADVISORY_MESSAGE_URL + "Partial" : ADVISORY_MESSAGE_URL;
    }

    /**
     * 我的消息-详细
     *
     * @param vPlayerAdvisoryListVo
     * @param id
     * @param continueQuizId
     * @param listVo
     * @param model
     * @return
     */
    @RequestMapping({"/playerAdvisoryDetail"})
    public String playerAdvisory(VPlayerAdvisoryListVo aListVo, VPlayerAdvisoryListVo vPlayerAdvisoryListVo, Integer id, Integer continueQuizId, VPlayerAdvisoryReplyListVo listVo, Model model) {
        //表单校验
        model.addAttribute("validate", JsRuleCreator.create(AdvisoryMessageForm.class, "result"));

        //当前咨询信息
        listVo.getPaging().setPageSize(60);
        if (continueQuizId != null) {
            vPlayerAdvisoryListVo.getSearch().setId(continueQuizId);
        } else {
            vPlayerAdvisoryListVo.getSearch().setId(id);
        }
        List<VPlayerAdvisory> vPlayerAdvisoryList = ServiceTool.vPlayerAdvisoryService().searchVPlayerAdvisoryReply(vPlayerAdvisoryListVo);
        Map map = new TreeMap(new Comparator() {
            @Override
            public int compare(Object o1, Object o2) {
                return ((Integer) o1) - ((Integer) o2);
            }
        });
        for (VPlayerAdvisory obj : vPlayerAdvisoryList) {
            //回复标题和内容
            listVo.getSearch().setPlayerAdvisoryId(obj.getId());
            listVo = ServiceTool.vPlayerAdvisoryReplyService().search(listVo);
            map.put(obj.getId(), listVo);

            //判断是否已读
            //当前回复表Id
            PlayerAdvisoryReplyListVo parListVo = new PlayerAdvisoryReplyListVo();
            parListVo.getSearch().setPlayerAdvisoryId(obj.getId());
            parListVo = ServiceTool.playerAdvisoryReplyService().searchByIdPlayerAdvisoryReply(parListVo);

            PlayerAdvisoryReadVo readVo = new PlayerAdvisoryReadVo();
            readVo.getSearch().setUserId(SessionManager.getUserId());
            readVo.getSearch().setPlayerAdvisoryId(obj.getId());
            readVo.getQuery().setCriterions(new Criterion[]{new Criterion(PlayerAdvisoryRead.PROP_USER_ID, Operator.EQ, readVo.getSearch().getUserId())
                    , new Criterion(PlayerAdvisoryRead.PROP_PLAYER_ADVISORY_ID, Operator.EQ, readVo.getSearch().getPlayerAdvisoryId())});
            ServiceTool.playerAdvisoryReadService().batchDeleteCriteria(readVo);

            for (PlayerAdvisoryReply replay : parListVo.getResult()) {
                PlayerAdvisoryReadVo parVo = new PlayerAdvisoryReadVo();
                parVo.setResult(new PlayerAdvisoryRead());
                parVo.getResult().setUserId(SessionManager.getUserId());
                parVo.getResult().setPlayerAdvisoryReplyId(replay.getId());
                parVo.getResult().setPlayerAdvisoryId(obj.getId());
                ServiceTool.playerAdvisoryReadService().insert(parVo);
            }
        }

        model.addAttribute("command", vPlayerAdvisoryList);
        model.addAttribute("map", map);

        //未读数量
        this.unReadCount(aListVo, model);

        return ADVISORY_MESSAGE_DETAIL;
    }


    /**
     * 发送消息
     *
     * @param model
     * @return
     */
    @RequestMapping("/beforeSendMessage")
    public String beforeSendMessage(VPlayerAdvisoryListVo aListVo, Model model) {
        //表单校验
        model.addAttribute("validate", JsRuleCreator.create(PlayerAdvisoryForm.class, "result"));
        Map<String, Serializable> advisoryType = DictTool.get(DictEnum.ADVISORY_TYPE);
        model.addAttribute("advisoryType", advisoryType);
        //未读数量
        this.unReadCount(aListVo, model);
        return SEND_MESSAGE;
    }

    /**
     * 保存消息
     *
     * @param playerAdvisoryVo
     * @param model
     * @return
     */
    @RequestMapping("/sendMessage")
    @ResponseBody
    public Map sendMessage(PlayerAdvisoryVo playerAdvisoryVo, Model model) {
        playerAdvisoryVo.setSuccess(false);
        playerAdvisoryVo.getResult().setAdvisoryTime(SessionManager.getDate().getNow());
        playerAdvisoryVo.getResult().setPlayerId(SessionManager.getUserId());
        playerAdvisoryVo.getResult().setReplyCount(0);
        playerAdvisoryVo.getResult().setQuestionType(PlayerAdvisoryEnum.QUESTION.getCode());
        playerAdvisoryVo = ServiceTool.playerAdvisoryService().insert(playerAdvisoryVo);

        if (playerAdvisoryVo.isSuccess()) {
            playerAdvisoryVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.SAVE_SUCCESS));
            //生成任务提醒
            UserTaskReminderVo userTaskReminderVo = new UserTaskReminderVo();
            userTaskReminderVo.setTaskEnum(UserTaskEnum.PLAYERCONSULTATION);
            boolean isSuccess = ServiceTool.userTaskReminderService().addTaskReminder(userTaskReminderVo);
            //任务声音提醒
            if (isSuccess) {
                sendTaskMessage();
            }
        } else {
            playerAdvisoryVo.setErrMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.SAVE_FAILED));
        }

        HashMap map = new HashMap(2,1f);
        map.put("msg", StringTool.isNotBlank(playerAdvisoryVo.getOkMsg()) ? playerAdvisoryVo.getOkMsg() : playerAdvisoryVo.getErrMsg());
        map.put("state", Boolean.valueOf(playerAdvisoryVo.isSuccess()));
        return map;
    }

    private void sendTaskMessage() {
        SysParam noticeParam = ParamTool.getSysParam(SiteParamEnum.WARMING_TONE_NOTICE);
        if (noticeParam == null || StringTool.isBlank(noticeParam.getParamValue())) {
            return;
        }
        MessageVo message = new MessageVo();
        message.setCcenterId(SessionManager.getSiteParentId());
        message.setMasterId(SessionManager.getSiteUserId());
        message.setSiteId(SessionManager.getSiteId());
        message.setSubscribeType(CometSubscribeType.TASK_REMINDER.getCode());
        message.setSendToUser(true);
        SysResourceListVo sysResourceListVo = new SysResourceListVo();
        sysResourceListVo.getSearch().setUrl("/operation/announcementMessage/advisoryList.html");
        List<Integer> userIdByUrl = ServiceTool.playerRechargeService().findUserIdByUrl(sysResourceListVo);
        userIdByUrl.add(Const.MASTER_BUILT_IN_ID);
        message.addUserIds(userIdByUrl);
        Map<String, String> msgBody = new HashMap<>(1,1f);
        msgBody.put("toneType", noticeParam.getParamValue());
        message.setMsgBody(JsonTool.toJson(msgBody));
        DubboTool.getService(IMessageService.class).sendToMcenterMsg(message);
    }

    /**
     * 咨询-保存消息
     *
     * @param playerAdvisoryVo
     * @param model
     * @return
     */
    @RequestMapping("/subAdvisoryMessage")
    @ResponseBody
    public Map subAdvisoryMessage(PlayerAdvisoryVo playerAdvisoryVo, Model model, @FormModel @Valid AdvisoryMessageForm form, BindingResult result) {
        HashMap map = new HashMap(2,1f);
        if (result.hasErrors()) {
            map.put("msg", LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.SAVE_FAILED));
            map.put("state", false);
            return map;
        }
        Date nowTime = SessionManager.getDate().getNow();
        Date advisoryMessageTime = SessionManager.getAdvisoryMessageTime();
        if (advisoryMessageTime != null && DateTool.secondsBetween(nowTime, advisoryMessageTime) < 15) {
            map.put("msg", LocaleTool.tranMessage(_Module.COMMON, "submit.timeInterval.tips"));
            map.put("state", false);
            return map;
        }
        playerAdvisoryVo.setSuccess(false);
        playerAdvisoryVo.getResult().setAdvisoryTime(nowTime);
        playerAdvisoryVo.getResult().setPlayerId(SessionManager.getUserId());
        playerAdvisoryVo.getResult().setReplyCount(0);
        playerAdvisoryVo.getResult().setQuestionType("2");
        playerAdvisoryVo.getResult().setLatestTime(SessionManager.getDate().getNow());
        playerAdvisoryVo = ServiceTool.playerAdvisoryService().insert(playerAdvisoryVo);

        PlayerAdvisoryVo paVo = new PlayerAdvisoryVo();
        paVo.setResult(new PlayerAdvisory());
        if (playerAdvisoryVo.isSuccess()) {
            paVo.setSuccess(false);
            paVo.getResult().setId(playerAdvisoryVo.getResult().getContinueQuizId());
            paVo.getResult().setContinueQuizCount((playerAdvisoryVo.getResult().getContinueQuizCount() == null ? 0 : playerAdvisoryVo.getResult().getContinueQuizCount()) + 1);
            paVo.setProperties(PlayerAdvisory.PROP_CONTINUE_QUIZ_COUNT);
            paVo = ServiceTool.playerAdvisoryService().updateOnly(paVo);
            if (paVo.isSuccess()) {
                SessionManager.setAdvisoryMessageTime(nowTime);
                paVo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.SAVE_SUCCESS));
            } else {
                paVo.setErrMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.SAVE_FAILED));
            }
        }
        //生成任务提醒
        UserTaskReminderVo userTaskReminderVo = new UserTaskReminderVo();
        userTaskReminderVo.setTaskEnum(UserTaskEnum.PLAYERCONSULTATION);
        ServiceTool.userTaskReminderService().addTaskReminder(userTaskReminderVo);
        map.put("msg", StringTool.isNotBlank(paVo.getOkMsg()) ? paVo.getOkMsg() : paVo.getErrMsg());
        map.put("state", Boolean.valueOf(paVo.isSuccess()));
        return map;
    }

    /**
     * 取款消息发送给站长中心
     */
    private void tellerReminder(PlayerAdvisoryVo playerAdvisoryVo) {
        if (playerAdvisoryVo.getResult() == null) {
            return;
        }
        //推送消息给前端
        MessageVo message = new MessageVo();
        message.setSubscribeType("MCENTER-TELLER-REMINDER");
        PlayerWithdraw withdraw = new PlayerWithdraw();
        Map<String, Object> map = new HashMap<>(3,1f);
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

        SysResourceListVo sysResourceListVo = new SysResourceListVo();
        sysResourceListVo.getSearch().setUrl("");
        List<Integer> list = ServiceTool.playerRechargeService().findUserIdByUrl(sysResourceListVo);
        list.add(Const.MASTER_BUILT_IN_ID);
        message.addUserIds(list);
        ServiceTool.messageService().sendToMcenterMsg(message);
    }

    /**
     * 玩家中心-咨询消息-删除
     *
     * @param vo
     * @param ids
     * @param model
     * @return
     */
    @RequestMapping("/deleteAdvisoryMessage")
    @ResponseBody
    public Map deleteAdvisoryMessage(PlayerAdvisoryVo vo, String ids, Model model) {
        String[] id = ids.split(",");
        for (String messageId : id) {
            PlayerAdvisoryListVo listVo = new PlayerAdvisoryListVo();
            listVo.getSearch().setContinueQuizId(Integer.valueOf(messageId));
            listVo = ServiceTool.playerAdvisoryService().search(listVo);
            for (PlayerAdvisory obj : listVo.getResult()) {
                vo.setSuccess(false);
                vo.setResult(new PlayerAdvisory());
                vo.getResult().setId(obj.getId());
                vo.getResult().setPlayerDelete(true);
                vo.setProperties(PlayerAdvisory.PROP_PLAYER_DELETE);
                vo = ServiceTool.playerAdvisoryService().updateOnly(vo);
            }
            vo.setSuccess(false);
            vo.setResult(new PlayerAdvisory());
            vo.getResult().setId(Integer.valueOf(messageId));
            vo.getResult().setPlayerDelete(true);
            vo.setProperties(PlayerAdvisory.PROP_PLAYER_DELETE);
            vo = ServiceTool.playerAdvisoryService().updateOnly(vo);
        }
        if (vo.isSuccess()) {
            vo.setOkMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.DELETE_SUCCESS));
        } else {
            vo.setErrMsg(LocaleTool.tranMessage(_Module.COMMON, MessageI18nConst.DELETE_FAILED));
        }
        HashMap map = new HashMap(2,1f);
        map.put("msg", StringTool.isNotBlank(vo.getOkMsg()) ? vo.getOkMsg() : vo.getErrMsg());
        map.put("state", Boolean.valueOf(vo.isSuccess()));
        return map;
    }


    /**
     * 玩家中心-我的消息-标记已读
     *
     * @param ids
     * @return
     */
    @RequestMapping("/getSelectAdvisoryMessageIds")
    @ResponseBody
    public Map getSelectAdvisoryMessageIds(String ids) {
        String[] id = ids.split(",");
        for (String messageId : id) {
            //当前回复表Id
            PlayerAdvisoryReplyListVo parListVo = new PlayerAdvisoryReplyListVo();
            parListVo.getSearch().setPlayerAdvisoryId(Integer.valueOf(messageId));
            parListVo = ServiceTool.playerAdvisoryReplyService().searchByIdPlayerAdvisoryReply(parListVo);

            //判断是否已读
            PlayerAdvisoryReadVo readVo = new PlayerAdvisoryReadVo();
            readVo.getSearch().setUserId(SessionManager.getUserId());
            readVo.getSearch().setPlayerAdvisoryId(Integer.valueOf(messageId));
            readVo.getQuery().setCriterions(new Criterion[]{new Criterion(PlayerAdvisoryRead.PROP_USER_ID, Operator.EQ, readVo.getSearch().getUserId())
                    , new Criterion(PlayerAdvisoryRead.PROP_PLAYER_ADVISORY_ID, Operator.EQ, readVo.getSearch().getPlayerAdvisoryId())});
            ServiceTool.playerAdvisoryReadService().batchDeleteCriteria(readVo);

            for (PlayerAdvisoryReply replay : parListVo.getResult()) {
                PlayerAdvisoryReadVo parVo = new PlayerAdvisoryReadVo();
                parVo.setResult(new PlayerAdvisoryRead());
                parVo.getResult().setUserId(SessionManager.getUserId());
                parVo.getResult().setPlayerAdvisoryReplyId(replay.getId());
                parVo.getResult().setPlayerAdvisoryId(Integer.valueOf(messageId));
                ServiceTool.playerAdvisoryReadService().insert(parVo);
            }
        }
        HashMap map = new HashMap(1,1f);
        map.put("state", true);
        return map;
    }

    /**
     * 玩家中心-游戏公告
     *
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("/gameNotice")
    public String gameNotice(VSystemAnnouncementListVo listVo, Model model, HttpServletRequest request) {
        if (listVo.getSearch().getStartTime() == null && listVo.getSearch().getEndTime() == null) {
            listVo.getSearch().setStartTime(DateTool.addMonths(SessionManager.getDate().getNow(), -1));
            listVo.getSearch().setEndTime(DateQuickPicker.getInstance().getNow());
        }
        listVo.getSearch().setLocal(SessionManager.getLocale().toString());
        listVo.getSearch().setAnnouncementType(AnnouncementTypeEnum.GAME.getCode());
        listVo.getSearch().setPublishTime(SessionManager.getUser().getCreateTime());
        listVo = ServiceTool.vSystemAnnouncementService().searchMasterSystemNotice(listVo);
        model.addAttribute("command", listVo);
        model.addAttribute("maxDate", new Date());
        //获取SiteApi
        Map apiMap = Cache.getSiteApiI18n();
        model.addAttribute("apiMap", apiMap);
        //未读数量
//        this.unReadCount(aListVo, model);
        return ServletTool.isAjaxSoulRequest(request) ? GAME_NOTICE_URL + "Partial" : GAME_NOTICE_URL;
    }


    /**
     * 运营商-系统公告-发布信息-展示弹窗
     *
     * @param model
     * @param vSystemAnnouncementListVo
     * @return
     */
    @RequestMapping("/announcementPopup")
    public String announcementPopup(Model model, VSystemAnnouncementListVo vSystemAnnouncementListVo) {
        vSystemAnnouncementListVo.getSearch().setLocal(SessionManager.getLocale().toString());
        vSystemAnnouncementListVo = ServiceTool.vSystemAnnouncementService().search(vSystemAnnouncementListVo);
        model.addAttribute("vSystemAnnouncementListVo", vSystemAnnouncementListVo);
        return ANNOUNCEMENT_POPUP_URL;
    }


    /**
     * 玩家中心-游戏消息详细显示
     *
     * @param model
     * @return
     */
    @RequestMapping("/gameNoticeDetail")
    public String gameNoticeDetail(VSystemAnnouncementListVo vSystemAnnouncementListVo, Model model) {
        vSystemAnnouncementListVo.getSearch().setLocal(SessionManager.getLocale().toString());
        vSystemAnnouncementListVo.getSearch().setAnnouncementType(AnnouncementTypeEnum.GAME.getCode());
        vSystemAnnouncementListVo = ServiceTool.vSystemAnnouncementService().search(vSystemAnnouncementListVo);
        model.addAttribute("vSystemAnnouncementListVo", vSystemAnnouncementListVo);
        return GAME_NOTICE_DETAIL_URL;
    }

    /**
     * 校验验证码
     *
     * @param code
     * @param request
     * @return
     */
    @RequestMapping("/checkCaptcha")
    @ResponseBody
    public boolean checkCaptcha(@RequestParam("code") String code, HttpServletRequest request) {
        if (StringTool.isEmpty(code)) {
            return false;
        }
        return code.equalsIgnoreCase((String) SessionManager.getAttribute(SessionKey.S_CAPTCHA_PREFIX + CaptchaUrlEnum.CODE_CONTINUE_QUESTION.getSuffix()));
    }

}