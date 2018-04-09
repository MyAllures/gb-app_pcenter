package so.wwb.gamebox.pcenter.personInfo.controller;

import org.soul.commons.bean.Pair;
import org.soul.commons.collections.*;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.dict.DictTool;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.RandomStringTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.net.ServletTool;
import org.soul.commons.query.Criterion;
import org.soul.commons.query.enums.Operator;
import org.soul.commons.query.sort.Order;
import org.soul.model.msg.notice.po.NoticeContactWay;
import org.soul.model.msg.notice.vo.EmailMsgVo;
import org.soul.model.msg.notice.vo.NoticeContactWayListVo;
import org.soul.model.msg.notice.vo.NoticeContactWayVo;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.vo.SysUserProtectionVo;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.sms.SmsMessageVo;
import org.soul.model.sms_interface.po.SmsInterface;
import org.soul.model.sms_interface.vo.SmsInterfaceVo;
import org.soul.model.sys.po.SysDict;
import org.soul.model.sys.po.SysParam;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceSiteTool;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.model.*;
import so.wwb.gamebox.model.common.notice.enums.ContactWayType;
import so.wwb.gamebox.model.company.enums.SiteOperateStatusEnum;
import so.wwb.gamebox.model.company.site.po.SiteOperateArea;
import so.wwb.gamebox.model.master.player.PhoneCodeVo;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.model.master.setting.po.FieldSort;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.personInfo.form.*;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.SessionManagerCommon;
import so.wwb.gamebox.web.bank.BankHelper;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.SiteCustomerServiceHelper;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;
import so.wwb.gamebox.web.common.token.Token;
import so.wwb.gamebox.web.common.token.TokenHandler;
import so.wwb.gamebox.web.fund.form.AddBankcardForm;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.io.Serializable;
import java.util.*;

/**
 * Created by eagle on 15-10-29.
 */
@Controller
//region your codes 1
@RequestMapping("/personInfo")
public class PersonalInfoController {
    //endregion your codes 1

    //region your codes 3
    private static final Log LOG = LogFactory.getLog(PersonalInfoController.class);
    private static final String PLUS = "+";
    private static final String EMAIL = "email";
    private static final String PHONE = "phone";
    private static final String PERSON_INFO_PERSON_INFO = "personInfo/PersonInfo";
    private static final String PERSON_INFO_UPLOAD_HEAD_PORTRAIT = "personInfo/UploadHeadPortrait";
    private static final String PERSON_INFO_BIND_EMAIL = "personInfo/BindEmail";
    private static final String PERSON_INFO_BIND_EMAIL2 = "personInfo/BindEmail2";
    private static final String PERSON_INFO_BIND_PHONE = "personInfo/BindPhone";
    private static final String PERSON_INFO_BIND_PHONE2 = "personInfo/BindPhone2";

    /**
     * 个人资料
     *
     * @param model
     * @return
     */
    @RequestMapping("/index")
    @DemoModel(menuCode = DemoMenuEnum.GRZL)
    @Token(generate = true)
    public String index(Model model) {
        //获取玩家资料信息展示
        SysParam personalInformation = ParamTool.getSysParam(SiteParamEnum.CONNECTION_SETTING_PERSONAL_INFORMATION);
        model.addAttribute("personal_information", personalInformation);
        //获取玩家用户
        SysUserVo sysUserVo = getSysUser();
        model.addAttribute("sysUser", sysUserVo.getResult());
        model.addAttribute("sysUserVo", sysUserVo);

        //安全问题
        SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
        model.addAttribute("sysUserProtectionVo", sysUserProtectionVo);

        //获取玩家银行卡信息
        model.addAttribute("bankcardMap", BankHelper.getUserBankcards());
        model.addAttribute("bitcoinParam", ParamTool.getSysParam(SiteParamEnum.SETTING_WITHDRAW_TYPE_IS_BITCOIN));
        model.addAttribute("cashParam", ParamTool.getSysParam(SiteParamEnum.SETTING_WITHDRAW_TYPE_IS_CASH));

        //获取联系方式
        getNoticeContactWay(model);

        List<PhoneCodeVo> phoneCodeList = getPhoneCodeI18N(sysUserVo, model);
        model.addAttribute("phoneCodeList", phoneCodeList);

        boolean regSettingMailVerifcation = getRegSettingMailVerifcation() == null
                ? Boolean.FALSE
                : getRegSettingMailVerifcation().getActive();
        model.addAttribute("regSettingMailVerifcation", regSettingMailVerifcation);

        boolean regSettingPhoneVerifcation = getRegSettingPhoneVerifcation() == null
                ? Boolean.FALSE
                : getRegSettingPhoneVerifcation().getActive();
        model.addAttribute("regSettingPhoneVerifcation", regSettingPhoneVerifcation);

        model.addAttribute("validateRule", JsRuleCreator.create(PersonInfoForm.class));
        model.addAttribute("customerServiceUrl", SiteCustomerServiceHelper.getPCCustomerServiceUrl());


        ParamTool.refresh(SiteParamEnum.SETTING_REG_SETTING_FIELD_SETTING);
        SysParam param = ParamTool.getSysParam(SiteParamEnum.SETTING_REG_SETTING_FIELD_SETTING);
        List<FieldSort> fieldSortAll = (List<FieldSort>) JsonTool.fromJson(param.getParamValue(), JsonTool.createCollectionType(ArrayList.class, FieldSort.class));
        /*使用中的注册项*/
        List<FieldSort> fieldSorts = CollectionQueryTool.andQuery(fieldSortAll, ListTool.newArrayList(new Criterion(FieldSort.PROP_STATUS, Operator.NE, "2")), Order.asc(FieldSort.PROP_SORT));

        /*默认的注册项*/
        List<FieldSort> regFieldSorts = CollectionQueryTool.andQuery(fieldSorts, ListTool.newArrayList(new Criterion(FieldSort.PROP_STATUS, Operator.NE, "2"), new Criterion(FieldSort.PROP_IS_REGFIELD, Operator.NE, "2")), Order.asc(FieldSort.PROP_SORT));

        Map regFieldSortsMap = CollectionTool.toEntityMap(regFieldSorts, "name");
        /*必填的注册项name的json*/

        model.addAttribute("regFieldSortsMap", regFieldSortsMap);

        model.addAttribute("playerCallMaster", ParamTool.playerCallMaster());

        model.addAttribute("openPhoneCall", ParamTool.isOpenPhoneCall());


        return PERSON_INFO_PERSON_INFO;

    }

    /**
     * 个人信息上传头像--打开页面
     *
     * @param model
     * @return
     */
    @RequestMapping(value = "/toUploadHeadPortrait")
    public String toUploadHeadPortrait(Model model) {
        model.addAttribute("url", SessionManager.getUser().getAvatarUrl());
        model.addAttribute("playerId", SessionManager.getUser().getId());
        return PERSON_INFO_UPLOAD_HEAD_PORTRAIT;
    }

    /**
     * 个人信息上传头像--保存
     *
     * @param sysUserVo
     * @return
     */
    @RequestMapping(value = "/uploadHeadPortrait")
    @ResponseBody
    public Map uploadHeadPortrait(SysUserVo sysUserVo) {
        Map map = new HashMap(2, 1f);
        SysUser sysUser = sysUserVo.getResult();
        if (sysUser == null || StringTool.isBlank(sysUser.getAvatarUrl())) {
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.avatar.failed"));
            return map;
        }
        sysUser.setId(SessionManager.getUserId());
        sysUserVo.setProperties(SysUser.PROP_AVATAR_URL);
        boolean success = ServiceTool.sysUserService().updateOnly(sysUserVo).isSuccess();
        map.put("state", success);
        if (success) {
            SessionManager.refreshUser();
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.avatar.success"));
        } else {
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.avatar.failed"));
        }
        return map;
    }

    /**
     * 更新个人信息
     *
     * @param sysUserVo
     * @return
     */
    @RequestMapping("/updatePersonInfo")
    @ResponseBody
    public Map updatePersonInfo(SysUserVo sysUserVo, UserPlayerVo userPlayerVo,
                                @FormModel @Valid PersonInfoForm form, BindingResult result) {
        Map map = new HashMap();

        //前置验证
        if (result.hasErrors()) {
            LOG.info("个人资料："+String.valueOf(result.getFieldError()));
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.failed"));
            return map;
        }

        boolean regSettingMailVerifcation = getRegSettingMailVerifcation() == null
                ? Boolean.FALSE
                : getRegSettingMailVerifcation().getActive();
        if (regSettingMailVerifcation && StringTool.isNotBlank(userPlayerVo.getEmailFlag())
                && !EMAIL.equals(userPlayerVo.getEmailFlag())) {
            if (StringTool.isBlank(userPlayerVo.getVerificationCode())
                    || "false".equals(verifyCode(userPlayerVo.getVerificationCode()))) {
                map.put("state", false);
                map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.email.code"));
                map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
                return map;
            }
        }

        boolean regSettingPhoneVerifcation = getRegSettingPhoneVerifcation() == null
                ? Boolean.FALSE
                : getRegSettingPhoneVerifcation().getActive();
        if (regSettingPhoneVerifcation && StringTool.isNotBlank(userPlayerVo.getPhoneFlag())
                && !PHONE.equals(userPlayerVo.getPhoneFlag())) {
            if (StringTool.isBlank(userPlayerVo.getPhoneVerificationCode())
                    || "false".equals(verifyCode(userPlayerVo.getVerificationCode()))) {
                map.put("state", false);
                map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.code"));
                map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
                return map;
            }
        }

        sysUserVo.getResult().setId(SessionManager.getUserId());
        userPlayerVo.setIsNormal(true);

        if (userPlayerVo.getPhone() != null && StringTool.isNotBlank(userPlayerVo.getPhone().getContactValue())) {
            if (regSettingPhoneVerifcation) {
                //需要发送手机短信
                String phoneVerificationCode = userPlayerVo.getPhoneVerificationCode();
                String phone = userPlayerVo.getPhone().getContactValue();
                if (StringTool.isNotBlank(phoneVerificationCode)) {
                    if (isPhoneCodeAvailable(map, phoneVerificationCode, phone)) return map;
                }
            } else {
                UserPlayer userPlayer = new UserPlayer();
                userPlayer.setId(SessionManager.getUserId());
                userPlayer.setPhoneCode(userPlayerVo.getPhoneCode());
                userPlayerVo.setResult(userPlayer);
                userPlayerVo.setPhone(userPlayerVo.getPhone());
                if (regSettingPhoneVerifcation) {
                    userPlayerVo.setIsNormal(true);
                } else {
                    userPlayerVo.setIsNormal(false);
                }
            }
        }

        if (userPlayerVo.getEmail() != null && StringTool.isNotBlank(userPlayerVo.getEmail().getContactValue())) {
            if (regSettingMailVerifcation && StringTool.isNotBlank(userPlayerVo.getEmailFlag())
                    && EMAIL.equals(userPlayerVo.getEmailFlag())) {
                //需要发送邮件
                String emailCode = userPlayerVo.getVerificationCode();
                String email = userPlayerVo.getEmail().getContactValue();
                if (StringTool.isNotBlank(emailCode)) {
                    if (isCodeAvailable(map, emailCode, email)) return map;
                }
            } else {
                if (regSettingMailVerifcation) {
                    userPlayerVo.setIsNormal(true);
                } else {
                    userPlayerVo.setIsNormal(false);
                }
            }
        }

        sysUserVo = ServiceSiteTool.userPlayerService().updatePersonInfo(sysUserVo, userPlayerVo);
        map.put("state", sysUserVo.isSuccess());
        if (sysUserVo.isSuccess()) {
            SessionManager.refreshUser();
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.success"));
            SessionManager.clearPrivilegeStatus();
            SessionManager.removeEmailOrPhoneSession(EMAIL);
            SessionManager.removeEmailOrPhoneSession(PHONE);
        } else {
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.failed"));
            map.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        }
        return map;
    }

    /**
     * 获取玩家信息
     */
    private SysUserVo getSysUser() {
        SessionManager.refreshUser();
        SysUserVo sysUserVo = new SysUserVo();
        sysUserVo.setResult(SessionManager.getUser());
        return sysUserVo;
    }

    /**
     * 获取联系方式
     *
     * @param model
     */
    private void getNoticeContactWay(Model model) {
        NoticeContactWayListVo noticeContactWayListVo = new NoticeContactWayListVo();
        noticeContactWayListVo.getSearch().setUserId(SessionManager.getUserId());
        List<NoticeContactWay> noticeContactWayList = ServiceTool.noticeContactWayService().fetchByUserIdAndTypesAndStatuses(noticeContactWayListVo);
        if (noticeContactWayList != null && noticeContactWayList.size() > 0) {
            Map map = CollectionTool.toEntityMap(noticeContactWayList, NoticeContactWay.PROP_CONTACT_TYPE, Integer.class);
            model.addAttribute("noticeContactWayMap", map);
            model.addAttribute("noticeContactWays", noticeContactWayList.size());
        } else {
            model.addAttribute("noticeContactWays", 0);
        }

    }

    /**
     * 根据类型查询联系方式
     *
     * @param userId
     * @param contactWayType 联系方式类型
     * @return
     */
    private NoticeContactWayVo getContactWayByType(Integer userId, String contactWayType) {

        NoticeContactWayListVo noticeContactWayListVo = new NoticeContactWayListVo();
        noticeContactWayListVo.getSearch().setUserIds(Arrays.asList(userId));
        noticeContactWayListVo.getSearch().setContactType(contactWayType);

        List<NoticeContactWay> noticeContactWayList = ServiceTool.noticeContactWayService().fetchContactWaysByUserIdsAndType(noticeContactWayListVo);
        NoticeContactWayVo noticeContactWayVo = new NoticeContactWayVo();
        if (noticeContactWayList != null && noticeContactWayList.size() > 0) {
            noticeContactWayVo.setResult(noticeContactWayList.get(0));
        }
        return noticeContactWayVo;
    }

    /**
     * 获取用户设置的密保
     *
     * @param userId
     * @return
     */
    private SysUserProtectionVo getSysUserProtectionVo(Integer userId) {
        SysUserProtectionVo sysUserProtectionVo = new SysUserProtectionVo();
        sysUserProtectionVo.getSearch().setId(userId);
        sysUserProtectionVo = ServiceTool.sysUserProtectionService().get(sysUserProtectionVo);
        return sysUserProtectionVo;
    }

    /**
     * 发送验证码到邮箱
     *
     * @param email
     * @return
     */
    @RequestMapping("/getVerificationCode")
    @ResponseBody
    public Map getVerificationCode(String email) {

        Map map = new HashMap();
        if (email == null || "".equals(email)) {
            map.put("state", false);
            map.put("emailMsg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.notBlank"));
            return map;
        }

        if (StringTool.isNotBlank(email) && !email.matches(FormValidRegExps.EMAIL)) {
            map.put("state", false);
            map.put("emailMsg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.format.error"));
            return map;
        }

        //判断是否是100秒后,再次发起请求
        /*if (validCountDown(EMAIL)) {
            return map;
        }
        SessionManager.setLastSendTime(SessionManager.getDate().getNow(),EMAIL);*/

        String verificationCode = RandomStringTool.randomNumeric(6);

        String tmplContent = LocaleTool.tranMessage("notice", "tmpl.content.BIND_EMAIL_VERIFICATION_CODE");
        String tmplTitle = LocaleTool.tranMessage("notice", "tmpl.title.BIND_EMAIL_VERIFICATION_CODE");
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());

        int day = cal.get(Calendar.DAY_OF_MONTH);
        int mon = cal.get(Calendar.MONTH) + 1;
        int year = cal.get(Calendar.YEAR);
        tmplContent = StringTool.fillTemplate(tmplContent, MapTool.newHashMap(
                new Pair<>("verificationCode", verificationCode),
                new Pair<>("sitename", Cache.getSiteI18n(SiteI18nEnum.SETTING_SITE_NAME).get(SessionManager.getLocale().toString()).getValue()),
                new Pair<>("customer", SiteCustomerServiceHelper.getPCCustomerServiceUrl()),
                new Pair<>("year", Integer.toString(year)),
                new Pair<>("month", Integer.toString(mon)),
                new Pair<>("day", Integer.toString(day)))
        );
        tmplTitle = StringTool.fillTemplate(tmplTitle, MapTool.newHashMap(new Pair<>("sitename",
                Cache.getSiteI18n(SiteI18nEnum.SETTING_SITE_NAME).get(SessionManager.getLocale().toString()).getValue())));

        EmailMsgVo emailMsgVo = new EmailMsgVo();
        emailMsgVo.setContent(tmplContent);
        emailMsgVo.setTitle(tmplTitle);
        emailMsgVo.setToAddressSet(SetTool.newHashSet(email));
        try {
            ServiceTool.messageService().sendEmail(emailMsgVo);
        } catch (Exception ex) {
            LOG.error(ex, "发送邮件验证码错误");
        }

        setToSession(email, verificationCode, EMAIL);
        map.put("state", true);
        return map;
    }

    /**
     * 跳转到绑定邮箱弹窗
     *
     * @param model
     * @return
     */
    @RequestMapping("/toBindEmail")
    public String toBindEmail(Model model) {
        model.addAttribute("validateRule", JsRuleCreator.create(BindEmailForm.class));
        return PERSON_INFO_BIND_EMAIL;
    }

    /**
     * 绑定邮箱下一步
     *
     * @param emailCode
     * @param email
     * @return
     */
    @RequestMapping("/updateEmailCodeNext")
    @ResponseBody
    public Map updateEmailCodeNext(String emailCode, String email) {

        Map map = new HashMap();
        if (isCodeAvailable(map, emailCode, email)) return map;
        SessionManager.removeEmailOrPhoneSession(EMAIL);
        map.put("state", true);
        return map;
    }

    /**
     * 绑定邮件第二步
     *
     * @param model
     * @return
     */
    @RequestMapping("/toBindEmail2")
    public String toBindEmail2(Model model) {
        model.addAttribute("validateRule", JsRuleCreator.create(BindEmailForm2.class));

        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
        model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
        return PERSON_INFO_BIND_EMAIL2;
    }

    /**
     * 邮箱绑定--绑定邮箱
     *
     * @param sysUserVo
     * @param userPlayerVo
     * @return
     */
    @RequestMapping(value = "/updateEmail")
    @ResponseBody
    public Map updateEmail(SysUserVo sysUserVo, UserPlayerVo userPlayerVo) {
        Map map = new HashMap(2, 1f);

        String emailCode = userPlayerVo.getVerificationCode();
        String email = userPlayerVo.getEmail().getContactValue();
        if (StringTool.isNotBlank(emailCode)) {
            if (isCodeAvailable(map, emailCode, email)) return map;
        }

        sysUserVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo.setIsNormal(true);
        boolean success = ServiceSiteTool.userPlayerService().updateEmail(sysUserVo, userPlayerVo);
        map.put("state", success);
        if (success) {
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.success"));
            SessionManager.clearPrivilegeStatus();
            SessionManager.removeEmailOrPhoneSession(EMAIL);
        } else {
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.failed"));
        }
        return map;
    }

    /**
     * 跳转到绑定手机弹窗
     *
     * @param model
     * @return
     */
    @RequestMapping("/toBindPhone")
    public String toBindPhone(Model model) {
        model.addAttribute("validateRule", JsRuleCreator.create(BindPhoneForm.class));
        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
        model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
        return PERSON_INFO_BIND_PHONE;
    }

    /**
     * 绑定手机下一步
     *
     * @param code
     * @param phone
     * @return
     */
    @RequestMapping("/updatePhoneCodeNext")
    @ResponseBody
    public Map updatePhoneCodeNext(String code, String phone) {

        Map map = new HashMap();
        if (isPhoneCodeAvailable(map, code, phone)) return map;
        SessionManager.removeEmailOrPhoneSession(PHONE);
        map.put("state", true);
        return map;
    }

    /**
     * 绑定手机第二步
     *
     * @param model
     * @return
     */
    @RequestMapping("/toBindPhone2")
    public String toBindPhone2(Model model) {

        List<PhoneCodeVo> phoneCodeList = getPhoneCodeI18N(getSysUser(), model);
        model.addAttribute("phoneCodeList", phoneCodeList);

        model.addAttribute("validateRule", JsRuleCreator.create(BindPhoneForm2.class));
        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
        model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
        return PERSON_INFO_BIND_PHONE2;
    }

    /**
     * 获取手机验证码
     *
     * @param phone
     * @return
     */
    @RequestMapping("/getPhoneVerificationCode")
    @ResponseBody
    public Map getPhoneVerificationCode(String phone, HttpServletRequest request) {

        Map map = new HashMap();
        if (phone == null || "".equals(phone)) {
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.notBlank"));
            return map;
        }

        if (StringTool.isNotBlank(phone) && !phone.matches(FormValidRegExps.NUMBER_PHONE)) {
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.format.error"));
            return map;
        }

        //判断是否是100秒后,再次发起请求
        if (validCountDown(PHONE)) {
            return map;
        }
        SessionManager.setLastSendTime(SessionManager.getDate().getNow(), PHONE);

        //保存手机和验证码匹配成对
        String verificationCode = RandomStringTool.randomNumeric(6);
        LOG.info("手机{0}-验证码：{1}", phone, verificationCode);
        SmsInterface smsInterface = getSiteSmsInterface();
        SmsMessageVo smsMessageVo = new SmsMessageVo();
        smsMessageVo.setUserIp(ServletTool.getIpAddr(request));
        smsMessageVo.setProviderId(smsInterface.getId());
        smsMessageVo.setProviderName(smsInterface.getUsername());
        smsMessageVo.setProviderPwd(smsInterface.getPassword());
        smsMessageVo.setProviderKey(smsInterface.getDataKey());
        smsMessageVo.setPhoneNum(phone);
        smsMessageVo.setType(SmsTypeEnum.YZM.getCode());
        String siteName = SessionManagerCommon.getSiteName(request);
        smsMessageVo.setContent("验证码：" + verificationCode + " 【" + siteName + "】");
        try {
            ServiceTool.messageService().sendSmsMessage(smsMessageVo);
        } catch (Exception ex) {
            LOG.error(ex, "发送手机验证码错误");
        }

        setToSession(phone, verificationCode, PHONE);

        map.put("state", true);
        return map;
    }

    private SmsInterface getSiteSmsInterface() {
        SmsInterfaceVo smsInterfaceVo = new SmsInterfaceVo();
        smsInterfaceVo._setDataSourceId(SessionManager.getSiteId());
        smsInterfaceVo = ServiceTool.smsInterfaceService().search(smsInterfaceVo);
        return smsInterfaceVo.getResult();
    }

    private void setToSession(String phone, String verificationCode, String type) {
        List param = new ArrayList();
        param.add(verificationCode);
        param.add(SessionManager.getDate().getNow());
        param.add(phone);
        SessionManager.setEmailOrPhoneCode(param, type);
    }

    /**
     * 绑定手机
     *
     * @param sysUserVo
     * @param userPlayerVo
     * @return
     */
    @RequestMapping(value = "/updatePhone")
    @ResponseBody
    public Map updatePhone(SysUserVo sysUserVo, UserPlayerVo userPlayerVo) {
        Map map = new HashMap(2, 1f);

        String phoneCode = userPlayerVo.getPhoneVerificationCode();
        String phone = userPlayerVo.getPhone().getContactValue();
        if (StringTool.isNotBlank(phoneCode)) {
            if (isPhoneCodeAvailable(map, phoneCode, phone)) return map;
        }

        sysUserVo.getSearch().setId(SessionManager.getUserId());
        UserPlayer userPlayer = new UserPlayer();
        userPlayer.setId(SessionManager.getUserId());
        userPlayer.setPhoneCode(userPlayer.getPhoneCode());
        userPlayerVo.setResult(userPlayer);
        userPlayerVo.setIsNormal(true);
        boolean success = ServiceSiteTool.userPlayerService().updatePhone(sysUserVo, userPlayerVo);
        map.put("state", success);
        if (success) {
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.phone.success"));
            SessionManager.clearPrivilegeStatus();
            SessionManager.removeEmailOrPhoneSession(PHONE);
        } else {
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.phone.failed"));
        }
        return map;
    }

    /**
     * 获取国际电话区号
     *
     * @param sysUserVo
     * @param model
     * @return
     */
    private List<PhoneCodeVo> getPhoneCodeI18N(SysUserVo sysUserVo, Model model) {

        Map<String, Serializable> phoneCodeDictMap = DictTool.get(DictEnum.REGION_CALLING_CODE);
        Map i18nMap = I18nTool.getDictsMap(SessionManager.getLocale().toString()).get(DictEnum.REGION_CALLING_CODE.getModule().getCode())
                .get(DictEnum.REGION_CALLING_CODE.getType());

        List<PhoneCodeVo> phoneCodeVos = new ArrayList<>();
        for (String key : phoneCodeDictMap.keySet()) {

            SysDict sysDict = ((SysDict) phoneCodeDictMap.get(key));
            if (i18nMap.get(sysDict.getDictCode()) == null) {
                continue;
            }
            String i18n = i18nMap.get(sysDict.getDictCode()).toString();

            if (StringTool.isNotBlank(sysUserVo.getResult().getCountry())) {
                if (key.equalsIgnoreCase(sysUserVo.getResult().getCountry())) {
                    PhoneCodeVo defaultPhoneCodeVo = new PhoneCodeVo();
                    defaultPhoneCodeVo.setPhoneCode(PLUS + i18n);
                    defaultPhoneCodeVo.setCountryStandardCode(key);
                    model.addAttribute("phoneCodeVo2", defaultPhoneCodeVo);
                }
            } else {
                if (key.equalsIgnoreCase(SessionManager.getIpDb().getCountry())) {//此处代码根据IP获取数据有问题，先这样兼容一下
                    PhoneCodeVo defaultPhoneCodeVo = new PhoneCodeVo();
                    defaultPhoneCodeVo.setPhoneCode(PLUS + i18n);
                    defaultPhoneCodeVo.setCountryStandardCode(key);
                    model.addAttribute("phoneCodeVo2", defaultPhoneCodeVo);
                } else if (key.equalsIgnoreCase("CN")) {//默认显示中国国际电话区号
                    PhoneCodeVo defaultPhoneCodeVo = new PhoneCodeVo();
                    defaultPhoneCodeVo.setPhoneCode(PLUS + i18n);
                    defaultPhoneCodeVo.setCountryStandardCode(key);
                    model.addAttribute("phoneCodeVo2", defaultPhoneCodeVo);
                }
            }

            //获取经营地区  国际电话区号只显示经营地区
            Map<String, SiteOperateArea> siteOperateAreaMap = Cache.getSiteOperateArea();
            for (Map.Entry entry : siteOperateAreaMap.entrySet()) {
                SiteOperateArea siteOperateArea = (SiteOperateArea) entry.getValue();
                if (siteOperateArea != null && SiteOperateStatusEnum.USEING.getCode().equals(siteOperateArea.getStatus())) {
                    if (key.equals(siteOperateArea.getCode())) {
                        PhoneCodeVo phoneCodeVo = new PhoneCodeVo();
                        phoneCodeVo.setPhoneCode(PLUS + i18n);
                        phoneCodeVo.setCountryStandardCode(key);
                        phoneCodeVos.add(phoneCodeVo);
                    }
                }
            }

        }
        return phoneCodeVos;
    }

    /**
     * 获取邮箱设置：注册前验证after，注册后验证before
     *
     * @return
     */
    private SysParam getRegSettingMailVerifcation() {
        return ParamTool.getSysParam(SiteParamEnum.SETTING_REG_SETTING_MAIL_VERIFCATION);
    }

    /**
     * 获取手机设置：注册前验证after，注册后验证before
     *
     * @return
     */
    private SysParam getRegSettingPhoneVerifcation() {
        return ParamTool.getSysParam(SiteParamEnum.SETTING_REG_SETTING_PHONE_VERIFCATION);
    }

    /**
     * 判断验证码是否可用
     *
     * @param map
     * @param emailCode
     * @return
     */
    private boolean isCodeAvailable(Map map, String emailCode, String email) {
        boolean flag = false;

        if (SessionManager.getEmailOrPhoneCode(EMAIL) != null) {
            if (email.equals(SessionManager.getEmailOrPhoneCode(EMAIL).get(2))) {
                if (DateTool.minutesBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailOrPhoneCode(EMAIL).get(1)) > 30) {
                    map.put("state", false);
                    map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.captcha.due"));
                    flag = true;
                } else if (!emailCode.equals(SessionManager.getEmailOrPhoneCode(EMAIL).get(0))) {
                    map.put("state", false);
                    map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.captcha.error"));
                    flag = true;
                }
            } else {//验证获取验证码后邮箱是否更改
                map.put("state", false);
                map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.error"));
                flag = true;
            }
        } else {
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.captcha.error"));
            flag = true;
        }
        return flag;
    }

    /**
     * 邮箱验证码远程验证
     *
     * @param verificationCode
     * @return
     */
    @RequestMapping(value = "/checkCode")
    @ResponseBody
    public String verifyCode(@RequestParam("verificationCode") String verificationCode) {
        boolean flag = false;
        boolean isExpired = false;
        boolean isError = false;
        if (SessionManager.getEmailOrPhoneCode(EMAIL) != null) {
            isExpired = DateTool.minutesBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailOrPhoneCode(EMAIL).get(1)) > 30;
            isError = verificationCode.equals(SessionManager.getEmailOrPhoneCode(EMAIL).get(0));
            flag = !isExpired && isError;
        }
        return flag ? "true" : "false";
    }

    /**
     * 邮箱弹窗第一步远程验证
     *
     * @param email
     * @return
     */
    @RequestMapping(value = "/checkEmail2")
    @ResponseBody
    public String verifyEmail2(@RequestParam("email.contactValue") String email) {
        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
        if (noticeContactWayVo.getResult() == null) {
            return "false";
        }
        return noticeContactWayVo.getResult().getContactValue().equals(email) ? "true" : "false";
    }

    /**
     * 手机验证码远程验证
     *
     * @param phoneVerificationCode
     * @return
     */
    @RequestMapping(value = "/verifyPhoneVerificationCode")
    @ResponseBody
    public String verifyPhoneVerificationCode(@RequestParam("phoneVerificationCode") String phoneVerificationCode) {
        boolean flag = false;
        boolean isExpired = false;
        boolean isError = false;
        if (SessionManager.getEmailOrPhoneCode(PHONE) != null) {
            isExpired = DateTool.minutesBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailOrPhoneCode(PHONE).get(1)) > 30;
            isError = phoneVerificationCode.equals(SessionManager.getEmailOrPhoneCode(PHONE).get(0));
            flag = !isExpired && isError;
        }
        return flag ? "true" : "false";
    }

    /**
     * 手机验证码远程验证
     *
     * @param phoneVerificationCode
     * @return
     */
    @RequestMapping(value = "/verifyPhonePhoneVerificationCode")
    @ResponseBody
    public String verifyPhonePhoneVerificationCode(@RequestParam("phone.phoneVerificationCode") String phoneVerificationCode) {
       return verifyPhoneVerificationCode(phoneVerificationCode);
    }

    /**
     * 判断验证码是否可用
     *
     * @param map
     * @param phoneCode 手机验证码
     * @return
     */
    private boolean isPhoneCodeAvailable(Map map, String phoneCode, String email) {
        boolean flag = false;

        if (SessionManager.getEmailOrPhoneCode(PHONE) != null) {
            if (email.equals(SessionManager.getEmailOrPhoneCode(PHONE).get(2))) {
                if (DateTool.minutesBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailOrPhoneCode(PHONE).get(1)) > 30) {
                    map.put("state", false);
                    map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.code.due"));
                    flag = true;
                } else if (!phoneCode.equals(SessionManager.getEmailOrPhoneCode(PHONE).get(0))) {
                    map.put("state", false);
                    map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.code.error"));
                    flag = true;
                }
            } else {//验证获取验证码后邮箱是否更改
                map.put("state", false);
                map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.error"));
                flag = true;
            }
        } else {
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(Module.MASTER_SETTING, "personal.phone.captcha.error"));
            flag = true;
        }
        return flag;
    }

    /**
     * 邮箱弹窗第一步远程验证
     *
     * @param phone
     * @return
     */
    @RequestMapping(value = "/verifyCellPhone")
    @ResponseBody
    public String verifyCellPhone(@RequestParam("phone.contactValue") String phone) {
        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
        if (noticeContactWayVo.getResult() == null) {
            return "false";
        }
        return noticeContactWayVo.getResult().getContactValue().equals(phone) ? "true" : "false";
    }

    private boolean validCountDown(String type) {
        return SessionManager.getLastSendTime(type) != null &&
                DateTool.millisecondsBetween(SessionManager.getDate().getNow(),
                        SessionManager.getLastSendTime(type)) <= 100;
    }

    /**
     * 添加银行卡
     *
     * @param model
     * @return
     */
    @RequestMapping("/toUserBank")
    @Token(generate = true)
    public String toUserBank(Model model) {
        model.addAttribute("validate", JsRuleCreator.create(AddBankcardForm.class));
        model.addAttribute("bankListVo", BankHelper.getBankListVo());
        model.addAttribute("user", SessionManager.getUser());
        return "fund/withdraw/bankcard/IntoBankcard";
    }

    /**
     * 判断真实姓名的唯一性
     *
     * @return
     */
    @RequestMapping(value = "/checkRealNameExist")
    @ResponseBody
    public String checkRealNameExist(@RequestParam("result.realName") String realName, @RequestParam("realName") String name) {
        if (!ParamTool.isOnlyFiled("realName") || !"undefined".equals(name)) {
            return "true";
        }
        SysUserVo sysUserVo = new SysUserVo();
        sysUserVo.getSearch().setRealName(realName);
        sysUserVo.getSearch().setSiteId(SessionManager.getSiteId());
        sysUserVo.getSearch().setSubsysCode(SubSysCodeEnum.PCENTER.getCode());
        String isExistRealName = ServiceSiteTool.userAgentService().isExistRealName(sysUserVo);
        return isExistRealName;
    }

    //endregion your codes 3
}
