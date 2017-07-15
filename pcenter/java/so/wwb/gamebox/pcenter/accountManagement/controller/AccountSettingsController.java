package so.wwb.gamebox.pcenter.accountManagement.controller;

import org.soul.commons.bean.Pair;
import org.soul.commons.dict.DictTool;
import org.soul.commons.init.context.CommonContext;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.I18nTool;
import org.soul.commons.lang.string.RandomStringTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.query.sort.Direction;
import org.soul.commons.validation.form.PasswordRule;
import org.soul.model.msg.notice.enums.NoticeContactWayStatus;
import org.soul.model.msg.notice.enums.NoticePublishMethod;
import org.soul.model.msg.notice.po.NoticeContactWay;
import org.soul.model.msg.notice.po.NoticeTmpl;
import org.soul.model.msg.notice.vo.NoticeContactWayListVo;
import org.soul.model.msg.notice.vo.NoticeContactWayVo;
import org.soul.model.msg.notice.vo.NoticeVo;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.po.SysUserProtection;
import org.soul.model.security.privilege.po.SysUserStatus;
import org.soul.model.security.privilege.vo.SysUserProtectionVo;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.sys.po.SysDict;
import org.soul.model.sys.po.SysParam;
import org.soul.commons.locale.DateQuickPicker;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.security.AuthTool;
import so.wwb.gamebox.model.DictEnum;
import so.wwb.gamebox.model.Module;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.notice.enums.*;
import so.wwb.gamebox.model.company.enums.BankCardTypeEnum;
import so.wwb.gamebox.model.company.enums.BankEnum;
import so.wwb.gamebox.model.company.enums.SiteOperateStatusEnum;
import so.wwb.gamebox.model.company.po.Bank;
import so.wwb.gamebox.model.company.po.BankExtend;
import so.wwb.gamebox.model.company.site.po.SiteOperateArea;
import so.wwb.gamebox.model.company.site.vo.SiteOperateAreaListVo;
import so.wwb.gamebox.model.company.sys.vo.SysSiteVo;
import so.wwb.gamebox.model.company.vo.BankListVo;
import so.wwb.gamebox.model.listop.FreezeTime;
import so.wwb.gamebox.model.master.player.PhoneCodeVo;
import so.wwb.gamebox.model.master.player.po.UserBankcard;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.*;
import so.wwb.gamebox.pcenter.accountManagement.form.*;
import so.wwb.gamebox.pcenter.common.consts.FormValidRegExps;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.ServiceToolBase;
import so.wwb.gamebox.web.SessionManagerCommon;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.privilege.controller.PrivilegeController;

import javax.validation.Valid;
import java.io.Serializable;
import java.util.*;

/**
 * Created by eagle on 15-10-29.
 *
 * 该类的方法请勿使用,该类将会删除
 */
@Controller
//region your codes 1
@RequestMapping("/accountSettings")
public class AccountSettingsController {

	private static final Log LOG = LogFactory.getLog(AccountSettingsController.class);
	//endregion your codes 1

	//region your codes 3
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_SETTINGS = "/accountManagement/AccountSettings";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_CONFIRM_QUESTIONS = "accountManagement/account.include/ConfirmQuestions";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_SHOW_CONFIRM_QUESTIONS = "accountManagement/account.include/ShowConfirmQuestions";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_SHOW_QUESTIONS = "accountManagement/account.include/ShowQuestions";
	public static final String ACCOUNT_MANAGEMENT_SETTING_REAL_NAME = "/accountManagement/SettingRealName";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CODE = "/accountManagement/account.include/UpdateEmailCode";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CAPTCHA = "/accountManagement/account.include/UpdateEmailCaptcha";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_BANK = "/accountManagement/account.include/UpdateBank";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_VERIFY_MODE = "/accountManagement/account.include/VerifyMode";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CODE2 = "/accountManagement/account.include/UpdateEmailCode2";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_PHONE_CAPTCHA = "/accountManagement/account.include/UpdatePhoneCaptcha";
	public static final String ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_PHONE_CAPTCHA2 = "/accountManagement/account.include/UpdatePhoneCaptcha2";
	public static final String EMAIL = "email";
	public static final String PHONE = "phone";
	public static final String PLUS = "+";

	/**
	 * 账号管理--账号设置
	 *
	 * @param userPlayerVo
	 * @param model
	 * @return
	 */
	@RequestMapping("/list")
	public String accountInfo(UserPlayerVo userPlayerVo, Model model, String isSign, String type) {

		Integer userId = SessionManager.getUserId();
		//1.登录密码--获取玩家用户
		SysUserVo sysUserVo = getPlayerInfo();
		SysSiteVo sysSiteVo = getSysSite(sysUserVo);
		model.addAttribute("sysUserVo", sysUserVo);
		model.addAttribute("isSet", StringTool.isNotBlank(sysUserVo.getResult().getPermissionPwd()));
		model.addAttribute("postfix", sysSiteVo.getResult().getPostfix());
		//修改密码绑定表单验证
		model.addAttribute("loginPwdRule", JsRuleCreator.create(UpdatePasswordForm.class));

		//2.安全密码--安全密码绑定表单验证
		if (StringTool.isNotBlank(SessionManager.getPrivilegeCode())) {
			model.addAttribute("securityPwdRule", JsRuleCreator.create(UpdatePrivilegesPasswordForm2.class));
		} else {
			model.addAttribute("securityPwdRule", JsRuleCreator.create(UpdatePrivilegesPasswordForm.class));
		}

		//3.手机绑定
		NoticeContactWayVo noticeContactWayVo = getContactWayByType(userId, ContactWayType.CELLPHONE.getCode());
		if (noticeContactWayVo.getResult() == null) {
			List<PhoneCodeVo> phoneCodeList = getPhoneCodeI18N(sysUserVo, model);
			model.addAttribute("phoneCodeList", phoneCodeList);
		}
		model.addAttribute("noticeContactWay2", noticeContactWayVo.getResult());
		model.addAttribute("playerPhoneRule", JsRuleCreator.create(PlayerPhoneForm.class));

		//4.邮箱绑定
		boolean regSettingMailVerifcation = getRegSettingMailVerifcation() == null ? Boolean.FALSE : getRegSettingMailVerifcation().getActive();
		model.addAttribute("regSettingMailVerifcation", regSettingMailVerifcation);
		NoticeContactWayVo noticeContactWayVo2 = getContactWayByType(userId, ContactWayType.EMAIL.getCode());
		NoticeContactWay noticeContactWay = noticeContactWayVo2.getResult();
		model.addAttribute("noticeContactWay", noticeContactWay);
		if (noticeContactWay != null && NoticeContactWayStatus.UNACTIVATED.getCode().equals(noticeContactWay.getStatus()) && regSettingMailVerifcation) {
			model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailUnactivatedForm.class));
		} else {
			model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailForm.class));
		}

		//5.安全问题
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(userId);
		if (sysUserProtectionVo.getResult() != null) {
			//24小时后清空错误次数和最后操作时间
			if (sysUserProtectionVo.getResult().getErrorTimes() != null && sysUserProtectionVo.getResult().getErrorTimes() > 6) {
				Date lastOperateTime = sysUserProtectionVo.getResult().getLastOperateTime();
				Calendar calendar = Calendar.getInstance();
				calendar.setTime(lastOperateTime);
				calendar.add(Calendar.DATE, 1);
				if (DateTool.timesToNow(calendar.getTime()) <= 0) {
					SysUserProtection sysUserProtection = new SysUserProtection();
					sysUserProtection.setId(SessionManager.getUserId());
					sysUserProtection.setErrorTimes(0);
					sysUserProtection.setLastOperateTime(null);
					sysUserProtectionVo.setResult(sysUserProtection);
					sysUserProtectionVo.setProperties(SysUserProtection.PROP_ERROR_TIMES, SysUserProtection.PROP_LAST_OPERATE_TIME);
					sysUserProtectionVo = ServiceTool.sysUserProtectionService().updateOnly(sysUserProtectionVo);
				}
			}
		} else {
			getQuestions(model);
			model.addAttribute("safeQuestionRule", JsRuleCreator.create(SysUserProtectionForm.class));
		}
		model.addAttribute("sysUserProtection", sysUserProtectionVo.getResult());

		//5.银行卡信息--账号设置绑定表单 银行卡信息
		UserBankcardVo userBankcardVo = getUserBankcardVo(userId);
		if (userBankcardVo.getResult() == null) {
			BankListVo bankListVo = getBankList();
			model.addAttribute("bankListVo", bankListVo);
		}
		model.addAttribute("userBankcard", userBankcardVo.getResult());
		model.addAttribute("playerBankcardRule", JsRuleCreator.create(PlayerBankcardForm.class));

		model.addAttribute("type", userPlayerVo.getType());
		//账号安全评分
		AccountSecurityLevelVo accountSecurityLevelVo = new AccountSecurityLevelVo();
		accountSecurityLevelVo.setSysUserVo(sysUserVo);
		accountSecurityLevelVo.setPhone(noticeContactWayVo.getResult());
		accountSecurityLevelVo.setEmail(noticeContactWayVo2.getResult());
		accountSecurityLevelVo.setSysUserProtectionVo(sysUserProtectionVo);
		accountSecurityLevelVo.setUserBankcardVo(userBankcardVo);
		Map<String, Object> accountSecurityLevel = accountSecurityLevelVo.getScoreAndLevel();
		model.addAttribute("accountSecurityLevel", accountSecurityLevel);

		//玩家首页-左侧-个人信息-点击图标
		model.addAttribute("isSign", isSign);
		model.addAttribute("typeName", type);

//		generatorToken(model);
		return ACCOUNT_MANAGEMENT_ACCOUNT_SETTINGS;
	}



	//***************************************************begin绑定邮箱************************************************************//

	/**
	 * 邮箱绑定--绑定邮箱
	 *
	 * @param updateNoticeContactWayVo
	 * @return
	 */
	@RequestMapping(value = "/updateEmail")
	@ResponseBody
	public Map updateEmail(UpdateNoticeContactWayVo updateNoticeContactWayVo, SysUserVo sysUserVo, UserPlayerVo userPlayerVo) {
		Map map = new HashMap(2);

		String emailCode = updateNoticeContactWayVo.getVerificationCode();
		String email = updateNoticeContactWayVo.getEmail().getContactValue();
		if (StringTool.isNotBlank(emailCode)) {
			if (isCodeAvailable(map, emailCode, email)) return map;
		}

		sysUserVo.getSearch().setId(SessionManager.getUserId());
		boolean regSettingMailVerifcation = getRegSettingMailVerifcation() == null ? Boolean.FALSE : getRegSettingMailVerifcation().getActive();
		if (regSettingMailVerifcation) {
			userPlayerVo.setIsNormal(true);
		}
		boolean success = ServiceTool.userPlayerService().updateEmail(updateNoticeContactWayVo, sysUserVo, userPlayerVo);
		map.put("state", success);
		if (success) {
			if (regSettingMailVerifcation) {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.failed")));
			} else {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.COMMON, "operation.success")));
			}
			SessionManager.clearPrivilegeStatus();
			SessionManager.removeSessionEmailCodeKey();
		} else {
			if (regSettingMailVerifcation) {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.failed")));
			} else {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.COMMON, "operation.failed")));
			}

		}
		return map;
	}

	/**
	 * 邮箱绑定--更换邮箱决定修改方式
	 *
	 * @param model
	 * @param isClear 联系方式是否清楚标识
	 * @return
	 */
	@RequestMapping("/toUpdateEmail")
	public String toUpdateEmail(Model model, String isClear) {

		String str = "";

		if (isClear != null && isClear.equals(ContactWayStatus.CLEAR.getCode())) {
			Integer userId = SessionManager.getUserId();
			//1.安全密码是否设置
			SysUserVo sysUserVo = getPlayerInfo();
			model.addAttribute("permissionPwd", sysUserVo.getResult().getPermissionPwd());
			//2.安全问题是否设置
			SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(userId);
			model.addAttribute("sysUserProtectionVo", sysUserProtectionVo);
			//3.多没有设置 显示联系客服代表
			model.addAttribute("type", EMAIL);
			str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_VERIFY_MODE;
		} else {
			SysParam sysParam = getRegSettingMailVerifcation();
			NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
			model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
			if (sysParam.getActive()) {
				model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailCodeForm.class));//需要邮箱验证码
				str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CODE;
			} else {
				model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailCaptchaForm.class));//图形验证码
				str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CAPTCHA;
			}
		}
		return str;
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
			map.put("emailMsg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.notBlank")));
			return map;
		}

		if (StringTool.isNotBlank(email) && !email.matches(FormValidRegExps.EMAIL)) {
			map.put("state", false);
			map.put("emailMsg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.format.error")));
			return map;
		}

		NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
		if (noticeContactWayVo != null && noticeContactWayVo.getResult() != null && !noticeContactWayVo.getResult().getContactValue().equals(email)) {
			map.put("state", false);
			map.put("emailMsg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.error")));
			return map;
		}
		String verificationCode = RandomStringTool.randomNumeric(6);

		NoticeVo noticeVo = new NoticeVo();
		noticeVo.setSubscribeType(CometSubscribeType.READ_COUNT);
		noticeVo.setEventType(AutoNoticeEvent.BIND_EMAIL_VERIFICATION_CODE);
		noticeVo.setActualReceivers(email);
		noticeVo.addUserIds(SessionManager.getUserId());
		Map<NoticePublishMethod, Set<NoticeTmpl>> noticePublishMethodSetMap = ServiceTool.noticeService().fetchTmpls(noticeVo);
		noticeVo.setTmplMap(noticePublishMethodSetMap);
		noticeVo.addParams(new Pair<String, String>("verificationCode", verificationCode));
		try{
			ServiceTool.noticeService().publish(noticeVo);
		}catch (Exception ex){
			LOG.error(ex,"发布消息不成功");
		}

		List emailParam = new ArrayList();
		emailParam.add(verificationCode);
		emailParam.add(SessionManager.getDate().getNow());
		emailParam.add(email);
		SessionManager.setEmailCode(emailParam);

		map.put("state", true);
		return map;
	}

	@RequestMapping("/updateEmailCodeNext")
	@ResponseBody
	public Map updateEmailCodeNext(String emailCode, String email) {

		Map map = new HashMap();
		if (isCodeAvailable(map, emailCode, email)) return map;
		SessionManager.removeSessionEmailCodeKey();
		map.put("state", true);
		return map;
	}

	@RequestMapping("/toUpdateEmailCode")
	public String toUpdateEmailCode(Model model) {
		model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailCodeForm.class));
		NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
		model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
		return ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CODE2;
	}

	/**
	 * 取消修改
	 * @param model
	 * @return
	 */
	@RequestMapping("/cancelUpdateEmail")
	public String cancelUpdateEmail(Model model) {
		boolean regSettingMailVerifcation = getRegSettingMailVerifcation() == null ? Boolean.FALSE : getRegSettingMailVerifcation().getActive();
		model.addAttribute("regSettingMailVerifcation", regSettingMailVerifcation);
		NoticeContactWayVo noticeContactWayVo2 = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
		NoticeContactWay noticeContactWay = noticeContactWayVo2.getResult();
		model.addAttribute("noticeContactWay", noticeContactWay);
		if (noticeContactWay != null && NoticeContactWayStatus.UNACTIVATED.getCode().equals(noticeContactWay.getStatus()) && regSettingMailVerifcation) {
			model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailUnactivatedForm.class));
		} else {
			model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailForm.class));
		}
		return "/accountManagement/account.include/CancelUpdateEmail";
	}

	//***************************************************end绑定邮箱************************************************************//

	//***************************************************begin安全问题************************************************************//

	/**
	 * 安全问题--安全问题答案确认页面
	 *
	 * @param safeQuestionVo
	 * @param model
	 * @return
	 */
	@RequestMapping("/confirmQuestions")
	public String confirmQuestions(SafeQuestionVo safeQuestionVo, Model model) {
		model.addAttribute("safeQuestionVo", safeQuestionVo);
		model.addAttribute("safeQuestionRule", JsRuleCreator.create(SysUserProtectionForm2.class));
		return ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_CONFIRM_QUESTIONS;
	}

	/**
	 * 安全问题--修改密保页面
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping("/showconfirmQuestions")
	public String showconfirmQuestions(Model model) {
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		model.addAttribute("sysUserProtectionVo", sysUserProtectionVo);
		model.addAttribute("safeQuestionRule", JsRuleCreator.create(SysUserProtectionForm3.class));
		return ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_SHOW_CONFIRM_QUESTIONS;
	}

	/**
	 * 安全问题--输入次数控制
	 *
	 * @param safeQuestionVo
	 * @return
	 */
	@RequestMapping("/confirmAnswer")
	@ResponseBody
	public Map isAnswer(SafeQuestionVo safeQuestionVo) {

		Map map = new HashMap(3);
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		if (sysUserProtectionVo == null ||  (sysUserProtectionVo != null && sysUserProtectionVo.getResult() == null)) {
			map.put("state", false);
			return map;
		}

		SysUserProtection sysUserProtection = sysUserProtectionVo.getResult();
		String answer1 = sysUserProtection.getAnswer1();
		String answer2 = sysUserProtection.getAnswer2();
		String answer3 = sysUserProtection.getAnswer3();
		if (StringTool.isBlank(answer1) || StringTool.isBlank(answer2) || StringTool.isBlank(answer3)) {
			map.put("state", false);
			return map;
		}

		boolean state = false;
		boolean isAnswer1 = answer1.equals(safeQuestionVo.getAnswer1());
		boolean isAnswer2 = answer2.equals(safeQuestionVo.getAnswer2());
		boolean isAnswer3 = answer3.equals(safeQuestionVo.getAnswer3());

		if (!(isAnswer1 && isAnswer2 && isAnswer3)) {
			sysUserProtection.setErrorTimes(sysUserProtection.getErrorTimes() + 1);
			sysUserProtection.setLastOperateTime(SessionManager.getDate().getNow());
			sysUserProtectionVo.setProperties(SysUserProtection.PROP_ERROR_TIMES, SysUserProtection.PROP_LAST_OPERATE_TIME);
			sysUserProtectionVo = ServiceTool.sysUserProtectionService().updateOnly(sysUserProtectionVo);
			if (sysUserProtectionVo.getResult().getErrorTimes() != null && sysUserProtectionVo.getResult().getErrorTimes() > 3) {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.error")));
			} else if (sysUserProtectionVo.getResult().getErrorTimes() != null && sysUserProtectionVo.getResult().getErrorTimes() > 6) {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.often")));
			} else {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.answer")));
			}
			map.put("errorTimes", sysUserProtectionVo.getResult().getErrorTimes());
		} else {
			state = true;
		}
		map.put("state", state);
		return map;
	}

	/**
	 * 安全问题--安全问题选择页面
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping("/showQuestions")
	public String showQuestions(Model model) {
		getQuestions(model);
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		model.addAttribute("sysUserProtection", sysUserProtectionVo.getResult());
		model.addAttribute("safeQuestionRule", JsRuleCreator.create(SysUserProtectionForm.class));
		return ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_SHOW_QUESTIONS;
	}

	/**
	 * 安全问题--保存安全问题
	 *
	 * @return
	 */
	@RequestMapping(value = "/saveQuestions")
	@ResponseBody
	public Map saveQuestions(SysUserProtection sysUserProtection, Integer sysUserProtectionId) {
		Map map = new HashMap(2);
		SysUserProtectionVo vo = new SysUserProtectionVo();
		if (sysUserProtectionId != null) {
			//更新
			sysUserProtection.setId(sysUserProtectionId);
			sysUserProtection.setUpdateTime(new Date());
			vo.setProperties(SysUserProtection.PROP_QUESTION1,
                    SysUserProtection.PROP_ANSWER1,
                    SysUserProtection.PROP_QUESTION2,
                    SysUserProtection.PROP_ANSWER2,
                    SysUserProtection.PROP_QUESTION3,
                    SysUserProtection.PROP_ANSWER3,
                    SysUserProtection.PROP_UPDATE_TIME);
			vo.setResult(sysUserProtection);
			vo = ServiceTool.sysUserProtectionService().updateOnly(vo);
		}  else {
			//插入
			sysUserProtection.setId(SessionManager.getUserId());
			sysUserProtection.setCreateTime(new Date());
			sysUserProtection.setTotalValidateCount(0);
			sysUserProtection.setMatchCount(1);
			sysUserProtection.setErrorTimes(0);
			vo.setResult(sysUserProtection);
			vo = ServiceTool.sysUserProtectionService().insert(vo);
		}

		if (vo.isSuccess()) {
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.answer.success")));
		} else {
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.answer.failed")));
		}
		map.put("state", vo.isSuccess());
		return map;
	}

	//***************************************************end安全问题************************************************************//

	//***************************************************begin银行卡************************************************************//

	/**
	 * 银行卡信息--获取银行扩展信息
	 *
	 * @return
	 */
    /*@RequestMapping("/getBankExtendInfo")
    @ResponseBody
    public Map getBankExtendInfo(BankExtendVo bankExtendVo) {
        String account = bankExtendVo.getSearch().getBankCardBegin();
        BankExtend bankExtend = Cache.getBankExtend().get(account.substring(0, 6));
        Map<String, Bank> bankMap = Cache.getBank();
        Bank bank = null;
        if (bankExtend != null) {
            bank = bankMap.get(bankExtend.getBankName().toLowerCase());
        }

        Map map = new HashMap();
        if (bank == null) {

            Map<String, SiteOperateArea> siteOperateAreaUsingMap = new LinkedHashMap<>();
            //获取过滤使用中的经营地区
            Map<String, SiteOperateArea> siteOperateAreaMap = Cache.getSiteOperateArea();
            for (Map.Entry entry : siteOperateAreaMap.entrySet()) {
                SiteOperateArea siteOperateArea = (SiteOperateArea) entry.getValue();
                if (siteOperateArea != null && SiteOperateStatusEnum.USEING.getCode().equals(siteOperateArea.getStatus())) {
                    siteOperateAreaUsingMap.put(siteOperateArea.getCode(), siteOperateArea);
                }
            }

            //过滤掉没有启用的银行
            Map<String, Bank> tempBank = new LinkedHashMap<>();
            for (Map.Entry entry : bankMap.entrySet()) {
                Bank bank1 = (Bank) entry.getValue();
                if (bank1 != null && Boolean.TRUE.equals(bank1.getIsUse()) && BankEnum.TYPE_BANK.getCode().equals(bank1.getType())) {
                    tempBank.put(bank1.getBankName(), bank1);
                }
            }

            //获取在经营地区的银行
            List<Bank> bankNameList = new ArrayList<>();
            for (Map.Entry entry : tempBank.entrySet()) {
                Bank bank2 = (Bank) entry.getValue();
                if (siteOperateAreaUsingMap.get(bank2.getBankDistrict()) != null) {
                    bankNameList.add(bank2);
                }
            }
            map.put("bankNames", JsonTool.toJson(bankNameList));
        }
        map.put("bank", bank);
        map.put("state", true);
        return map;
    }*/

	private List<String> getOperatorArea(){
		SiteOperateAreaListVo areaListVo = new SiteOperateAreaListVo();
		areaListVo.getSearch().setSiteId(SessionManager.getSiteId());
		areaListVo.getSearch().setStatus(SysUserStatus.DISABLED.getCode());
		areaListVo = ServiceTool.siteOperateAreaService().search(areaListVo);
		List<String> areaList = new ArrayList<>();
		if(areaListVo.getResult()!=null&&areaListVo.getResult().size()>0){
			for (SiteOperateArea area : areaListVo.getResult()){
				areaList.add(area.getCode());
			}
		}
		return areaList;
	}



	/**
	 * 跳转到银行卡修改页面
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping("/updateBankInfo")
	public String updateBankInfo(Model model) {

		Integer userId = SessionManager.getUserId();
		SysUserVo sysUserVo = getPlayerInfo();
		model.addAttribute("sysUserVo", sysUserVo);
		BankListVo bankListVo = getBankList();
		model.addAttribute("bankListVo", bankListVo);
		UserBankcardVo userBankcardVo = getUserBankcardVo(userId);
		model.addAttribute("userBankcard", userBankcardVo.getResult());

		return ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_BANK;
	}

	/**
	 * 当前用户
	 *
	 * @return
	 */
	private SysUser getCurrentUser() {
		Integer userId = SessionManagerCommon.getUserId();
		SysUserVo userVo = new SysUserVo();
		userVo.getSearch().setId(userId);
		userVo = ServiceToolBase.sysUserService().get(userVo);
		if (userVo.getResult() != null) {
			return userVo.getResult();
		}
		return null;
	}

	/**
	 * 银行卡信息--保存银行卡信息
	 *
	 * @param vo
	 * @param form
	 * @return
	 */
	@RequestMapping({"/updateBank"})
	@ResponseBody
	public Map updateBank(UserBankcardVo vo, @FormModel("result") @Valid PlayerBankcardForm form,Model model) {
		Map map = new HashMap(2);
        /*if (!vo.isEmptyPwd()) {
            String permissionPwd = vo.getPermissionPwd();
            boolean isCorrect = recheckPermissionPwd(permissionPwd);
            if (!isCorrect) {
                map.put("state", false);
                map.put("msg", LocaleTool.tranMessage("player", "安全码不对"));
                return map;
            }
        }*/

		vo.getSearch().setBankcardNumber(vo.getBankcardNumber());
		UserBankcard oldBankCard = ServiceTool.userBankcardService().cardIsExists(vo);
		if (oldBankCard != null && oldBankCard.getIsDefault() && !oldBankCard.getUserId().equals(SessionManager.getUserId())) {
			map.put("state",false);
			map.put("msg",LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.bankCard.already")));
//			map.put("token",SessionManager.getTokenForPcenter());
			return map;
		}

		boolean success = false;
		if (oldBankCard != null && oldBankCard.getBankcardNumber().equals(vo.getBankcardNumber()) && oldBankCard.getIsDefault()) {
			oldBankCard.setBankcardNumber(vo.getBankcardNumber());
			oldBankCard.setBankName(vo.getBankName());
			oldBankCard.setBankDeposit(vo.getBankDeposit());
			vo.setResult(oldBankCard);
			success = ServiceTool.userBankcardService().update(vo).isSuccess();
		} else {
			Integer userId = SessionManager.getUserId();
			UserBankcard userBankcard = new UserBankcard();

			userBankcard.setUserId(userId);
			userBankcard.setBankcardMasterName(SessionManager.getUser().getRealName());
			userBankcard.setCreateTime(SessionManager.getDate().getNow());
			userBankcard.setUseCount(0);
			userBankcard.setUseStauts(false);
			userBankcard.setIsDefault(true);
			userBankcard.setBankcardNumber(vo.getBankcardNumber());
			userBankcard.setBankDeposit(vo.getBankDeposit());
			userBankcard.setBankName(vo.getBankName());
			userBankcard.setCustomBankName(vo.getCustomBankName());
			vo.setResult(userBankcard);
			success = ServiceTool.userBankcardService().updatePlayerBank(vo);
		}
		map.put("state", success);
		if (success) {
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.bankCard.success")));
		} else {
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.bankCard.success")));
//			map.put("token",SessionManager.getTokenForPcenter());
		}
		return map;
	}

	private boolean recheckPermissionPwd(String pwd) {
		String isCorrect = permissionPwdAuthentication(pwd);
		Date now = DateQuickPicker.getInstance().getNow();
		if ("false".equals(isCorrect)) {
			SysUser curUser = getCurrentUser();
			if (curUser == null) {
				return false;
			}
			int times = curUser.getSecpwdErrorTimes() == null ? 1 : curUser.getSecpwdErrorTimes();
			if (times == 0) {
				updateUserErrorTimes(1, null, null);
			} else {
				if (curUser.getSecpwdErrorTimes() != null) {
					times = curUser.getSecpwdErrorTimes();
					times++;
				}
				if (times >= PrivilegeController.TRY_TIMES) {

					Date endTime = DateTool.addHours(now, 3);
					updateUserErrorTimes(PrivilegeController.TRY_TIMES, now, endTime);
					//输错5次冻结
					freezeAccountBalance();
				} else {
					updateUserErrorTimes(times, null, null);
				}
			}
			return false;
		} else {
			updateUserErrorTimes(0, now, null);
		}
		return true;
	}

	private void updateUserErrorTimes(int times, Date startTime, Date endTime) {
		UserPlayerVo userPlayerVo = new UserPlayerVo();
		userPlayerVo.setTimes(times);
		userPlayerVo.setStartTime(startTime);
		userPlayerVo.setEndTime(endTime);
		userPlayerVo.setSysUser(getCurrentUser());
		ServiceToolBase.userPlayerService().updateUserErrorTimes(userPlayerVo);
		SessionManager.refreshUser();
	}

	//玩家冻结账户余额
	private void freezeAccountBalance() {
		AccountVo accountVo = new AccountVo();
		SysUser user = getCurrentUser();
		accountVo.setResult(user);
		accountVo.setChooseFreezeTime(FreezeTime.THREE.getCode());
		UserPlayer userPlayer = ServiceToolBase.userPlayerService().freezeAccountBalance(accountVo);
		sendNotice(user, userPlayer);
	}

	private void sendNotice(SysUser user, UserPlayer userPlayer) {
		Locale locale = LocaleTool.getLocale(user.getDefaultLocale());
		TimeZone timeZone = TimeZone.getTimeZone(user.getDefaultTimezone());
		NoticeVo noticeVo = NoticeVo.autoNotify(AutoNoticeEvent.BALANCE_AUTO_FREEZON, user.getId());
		noticeVo.addParams(new Pair(NoticeParamEnum.UN_FREEZE_TIME.getCode(),
				DateTool.formatDate(userPlayer.getBalanceFreezeEndTime(), locale, timeZone,
						CommonContext.getDateFormat().getDAY_SECOND())),
				new Pair(NoticeParamEnum.USER.getCode(), user.getUsername()));
		try{
			ServiceTool.noticeService().publish(noticeVo);
		}catch (Exception ex){
			LOG.error(ex,"发布消息不成功");
		}
	}

	//***************************************************end银行卡************************************************************//

	//***************************************************begin设置真实姓名************************************************************//

	/**
	 * 跳转到真实姓名设置窗口
	 */
	@RequestMapping("/toSettingRealName")
	public String toSettingRealName(Model model) {
		model.addAttribute("settingRealNameRule", JsRuleCreator.create(SettingRealNameForm.class));
		return ACCOUNT_MANAGEMENT_SETTING_REAL_NAME;
	}

	/**
	 * 更新真实姓名
	 *
	 * @param sysUserVo
	 * @param model
	 * @return
	 */
	@RequestMapping("/updateRealName")
	@ResponseBody
	public Map updateRealName(SysUserVo sysUserVo, Model model) {
		Map map = new HashMap(2);
		sysUserVo.getResult().setId(SessionManager.getUserId());
		sysUserVo.setProperties(SysUser.PROP_REAL_NAME);
		boolean success = ServiceTool.sysUserService().updateOnly(sysUserVo).isSuccess();
		SessionManager.getUser().setRealName(sysUserVo.getResult().getRealName());
		map.put("state", success);
		if (success) {
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.realName.success")));
			SessionManager.clearPrivilegeStatus();
			SessionManager.refreshUser();
		} else {
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.realName.failed")));
		}
		return map;
	}

	//***************************************************end设置真实姓名************************************************************//

	//***************************************************begin清楚联系方式后的处理************************************************************//

	/**
	 * 联系方式清楚：选择跳转到安全密码
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping("/toSecurityPwd")
	public String toSecurityPwd(String contactWayType, String isSet, Model model) {
		model.addAttribute("rule", JsRuleCreator.create(SecurityPasswordForm.class));
		model.addAttribute("type", contactWayType);
		model.addAttribute("isSet", isSet);
		return "/accountManagement/account.include/ToSecurityPwd";
	}

	/**
	 * 联系方式清楚：选择跳转到安全问题
	 *
	 * @param model
	 * @return
	 */
	@RequestMapping("/toConfirmAnswers")
	public String toConfirmAnswers(String contactWayType, String isSet, Model model) {
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		model.addAttribute("sysUserProtectionVo", sysUserProtectionVo);
		model.addAttribute("type", contactWayType);
		model.addAttribute("isSet", isSet);
		model.addAttribute("rule", JsRuleCreator.create(SysUserProtectionForm4.class));
		return "/accountManagement/account.include/ToConfirmAnswers";
	}

	//***************************************************end清楚联系方式后的处理************************************************************//

	//***************************************************begin绑定手机************************************************************//

	/**
	 * 绑定手机号
	 *
	 * @param updateNoticeContactWayVo
	 * @param sysUserVo
	 * @param userPlayerVo
	 * @return
	 */
	@RequestMapping(value = "/updatePhone")
	@ResponseBody
	public Map updatePhone(UpdateNoticeContactWayVo updateNoticeContactWayVo, SysUserVo sysUserVo, UserPlayerVo userPlayerVo) {
		Map map = new HashMap(2);

//        String emailCode = updatePhoneVo.getVerificationCode();
//        if (isCodeAvailable(map, emailCode)) return map;

		boolean regSettingMailVerifcation = getRegSettingMailVerifcation() == null ? Boolean.FALSE : getRegSettingMailVerifcation().getActive();

		sysUserVo.getSearch().setId(SessionManager.getUserId());
		UserPlayer userPlayer = new UserPlayer();
		userPlayer.setId(SessionManager.getUserId());
		userPlayer.setPhoneCode(userPlayerVo.getPhoneCode());
		userPlayerVo.setResult(userPlayer);
		if (regSettingMailVerifcation) {
			userPlayerVo.setIsNormal(true);
		}

		boolean success = ServiceTool.userPlayerService().updatePhone(updateNoticeContactWayVo, sysUserVo, userPlayerVo);
		map.put("state", success);
		if (success) {
			if (regSettingMailVerifcation) {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.phone.success")));
			} else {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.COMMON, "operation.success")));
			}
			SessionManager.clearPrivilegeStatus();
		} else {
			if (regSettingMailVerifcation) {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.phone.failed")));
			} else {
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.COMMON, "operation.failed")));
			}
		}
		return map;
	}

	/**
	 * 跳转到修改页面
	 *
	 * @param model
	 * @param isClear 　是否清楚联系方式
	 * @return
	 */
	@RequestMapping("/toUpdatePhone")
	public String toUpdatePhone(Model model, String isClear, String status) {

		String str = "";
		Integer userId = SessionManager.getUserId();
		if (isClear != null && ContactWayStatus.CLEAR.getCode().equals(isClear)) {

			//1.安全密码是否设置
			SysUserVo sysUserVo = getPlayerInfo();
			model.addAttribute("permissionPwd", sysUserVo.getResult().getPermissionPwd());
			//2.安全问题是否设置
			SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(userId);
			model.addAttribute("sysUserProtectionVo", sysUserProtectionVo);
			//3.多没有设置 显示联系客服代表
			model.addAttribute("type", PHONE);
			str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_VERIFY_MODE;
		} else {
//            SysParam sysParam = getRegSettingMailVerifcation();
//            if (sysParam.getActive()) {
//                model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailCodeForm.class));//需要邮箱验证码
//                str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CODE;
//            } else {
//                model.addAttribute("playerEmailRule", JsRuleCreator.create(PlayerEmailCaptchaForm.class));//图形验证码
//                str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_EMAIL_CAPTCHA;
//            }
			SysUserVo sysUserVo = getPlayerInfo();
//            Map<String,Serializable> phoneCode = DictTool.get(DictEnum.REGION_CALLING_CODE);
			List<PhoneCodeVo> phoneCodeList = getPhoneCodeI18N(sysUserVo, model);
			model.addAttribute("phoneCodeList", phoneCodeList);
			model.addAttribute("playerPhoneRule", JsRuleCreator.create(PlayerPhoneCaptchaForm.class));//图形验证码
			NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
			model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
			str = ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_PHONE_CAPTCHA;
		}
		return str;
	}

	@RequestMapping("/toClearPhone")
	public String toClearPhone(Model model) {

		Integer userId = SessionManager.getUserId();
		SysUserVo sysUserVo = getPlayerInfo();
		List<PhoneCodeVo> phoneCodeList = getPhoneCodeI18N(sysUserVo, model);
		model.addAttribute("phoneCodeList", phoneCodeList);
		model.addAttribute("playerPhoneRule", JsRuleCreator.create(PlayerPhoneCaptchaForm2.class));//图形验证码
		NoticeContactWayVo noticeContactWayVo = getContactWayByType(userId, ContactWayType.CELLPHONE.getCode());
		model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
		return ACCOUNT_MANAGEMENT_ACCOUNT_INCLUDE_UPDATE_PHONE_CAPTCHA2;
	}

	//***************************************************end绑定手机************************************************************//

	//***************************************************begin远程验证************************************************************//

	/**
	 * 检查答案1
	 *
	 * @param answer1
	 * @return
	 */
	@RequestMapping(value = "/yzAnswer1")
	@ResponseBody
	public String yzAnswer1(@RequestParam("answer1") String answer1) {
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		if (sysUserProtectionVo != null && sysUserProtectionVo.getResult() != null) {
			SysUserProtection sysUserProtection = sysUserProtectionVo.getResult();
			return sysUserProtection.getAnswer1().equals(answer1) ? "true" : "false";
		}
		return "false";
	}

	/**
	 * 检查答案2
	 *
	 * @param answer2
	 * @return
	 */
	@RequestMapping(value = "/yzAnswer2")
	@ResponseBody
	public String yzAnswer2(@RequestParam("answer2") String answer2) {

		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		if (sysUserProtectionVo != null && sysUserProtectionVo.getResult() != null) {
			SysUserProtection sysUserProtection = sysUserProtectionVo.getResult();
			return sysUserProtection.getAnswer2().equals(answer2) ? "true" : "false";
		}
		return "false";
	}

	/**
	 * 检查答案3
	 *
	 * @param answer3
	 * @return
	 */
	@RequestMapping(value = "/yzAnswer3")
	@ResponseBody
	public String yzAnswer3(@RequestParam("answer3") String answer3) {
		SysUserProtectionVo sysUserProtectionVo = getSysUserProtectionVo(SessionManager.getUserId());
		if (sysUserProtectionVo != null && sysUserProtectionVo.getResult() != null) {
			SysUserProtection sysUserProtection = sysUserProtectionVo.getResult();
			return sysUserProtection.getAnswer3().equals(answer3) ? "true" : "false";
		}
		return "false";
	}

	/**
	 * 修改账户密码--检查密码
	 *
	 * @param password
	 * @return
	 */
	@RequestMapping(value = "/checkPassword")
	@ResponseBody
	public String checkPassword(@RequestParam("password") String password) {
		return pwdAuthentication(password);
	}

	/**
	 * 修改账户密码--检查密码规则是否弱密码
	 *
	 * @param password
	 * @return
	 */
	@RequestMapping(value = "/checkWeakPassword")
	@ResponseBody
	public String checkWeakPassword(@RequestParam("newPassword") String password) {
		// 弱密码过滤
		if (PasswordRule.isWeak(password)) {
			return "false";
		}
		return "true";
	}

	/**
	 * 修改权限密码--检查登录密码
	 *
	 * @param password
	 * @return
	 */
	@RequestMapping(value = "/checkLoginPassword")
	@ResponseBody
	public String checkLoginPassword(@RequestParam("loginPwd") String password) {
		return pwdAuthentication(password);
	}

	/**
	 * 修改权限密码--检查密码
	 *
	 * @param password
	 * @return
	 */
	@RequestMapping(value = "/checkPrivilegePassword")
	@ResponseBody
	public String checkPrivilegePassword(@RequestParam("oldPrivilegePwd") String password) {
		return permissionPwdAuthentication(password);
	}

	/**
	 * 检测安全密码
	 *
	 * @param password
	 * @return
	 */
	@RequestMapping(value = "/checkPermissionPwd")
	@ResponseBody
	public String checkPermissionPwd(@RequestParam("permissionPwd") String password) {
		return permissionPwdAuthentication(password);
	}

	@RequestMapping(value = "/checkPrivilegePwd")
	@ResponseBody
	public String checkPrivilegePwd(@RequestParam("privilegePwd") String password) {

		// 弱密码过滤
		if (PasswordRule.isWeak(password)) {
			return "false";
		}
		return "true";
	}

	/**
	 * 检查密码
	 *
	 * @param loginPassword
	 * @return
	 */
	@RequestMapping(value = "/yzPassword")
	@ResponseBody
	public String yzPassword(@RequestParam("loginPassword") String loginPassword) {
		return pwdAuthentication(loginPassword);
	}

	/**
	 * 手机号码远程验证
	 *
	 * @param phone
	 * @return
	 */
	@RequestMapping(value = "/checkPhone")
	@ResponseBody
	public String verifyPhone(@RequestParam("oldContactValue") String phone) {
		NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
		if (noticeContactWayVo.getResult() == null) {
			return "false";
		}
		return noticeContactWayVo.getResult().getContactValue().equals(phone) ? "true" : "false";
	}

	/**
	 * 邮箱远程验证
	 *
	 * @param email
	 * @return
	 */
	@RequestMapping(value = "/checkEmail")
	@ResponseBody
	public String verifyEmail(@RequestParam("oldContactValue") String email) {
		NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.EMAIL.getCode());
		if (noticeContactWayVo.getResult() == null) {
			return "false";
		}
		return noticeContactWayVo.getResult().getContactValue().equals(email) ? "true" : "false";
	}

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
	 * 验证码远程验证
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
		if (SessionManager.getEmailCode() != null) {
			isExpired = DateTool.secondsBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailCode().get(1)) > 100;
			isError = verificationCode.equals(SessionManager.getEmailCode().get(0));
            flag = !isExpired && isError;
		}
		return flag ? "true" : "false";
	}

	/**
	 * 验证卡号类型
	 *
	 * @param bankcardNumber
	 * @return
	 */
	@RequestMapping(value = "/checkBankCardType")
	@ResponseBody
	public String checkBankCardType(@RequestParam("bankcardNumber") String bankcardNumber) {
		Map<String, BankExtend> bankExtendMap = Cache.getBankExtend();
		BankExtend bankExtend = bankExtendMap.get(bankcardNumber.substring(0, 6));
		boolean flag = true;
		if (bankExtend != null) {
            flag = BankCardTypeEnum.DEBIT_CARD.getCode().equals(bankExtend.getCardType());
		}
		return flag ? "true" : "false";
	}

	//***************************************************end远程验证************************************************************//

	private String pwdAuthentication(String password) {

		SysUser user = SessionManager.getUser();
		String inputPassword = AuthTool.md5SysUserPassword(password, user.getUsername());
		return user.getPassword().equals(inputPassword) ? "true" : "false";
	}

	private String permissionPwdAuthentication(String password) {

		String privilegeCode = SessionManager.getPrivilegeCode();
		SysUser user = SessionManager.getUser();
		String inputPassword = AuthTool.md5SysUserPermission(password, user.getUsername());
		return privilegeCode.equals(inputPassword) ? "true" : "false";
	}

    /*private SysUserProtection yzAnswer() {
        SysUserProtectionVo userProtectionVo = new SysUserProtectionVo();
        userProtectionVo.getSearch().setId(SessionManager.getUserId());
        userProtectionVo = ServiceTool.sysUserProtectionService().get(userProtectionVo);
        return userProtectionVo.getResult();
    }*/

	/**
	 * 获取邮箱设置：注册前验证after，注册后验证before
	 *
	 * @return
	 */
	private SysParam getRegSettingMailVerifcation() {
		SysParam sysParam = ParamTool.getSysParam(SiteParamEnum.SETTING_REG_SETTING_MAIL_VERIFCATION);
		return sysParam;
	}

	/**
	 * 获取安全问题下拉列表数据
	 *
	 * @param model
	 */
	private void getQuestions(Model model) {
		Map<String, Serializable> questions1 = DictTool.get(DictEnum.SETTING_MASTER_QUESTION1);
		Map<String, Serializable> questions2 = DictTool.get(DictEnum.SETTING_MASTER_QUESTION2);
		Map<String, Serializable> questions3 = DictTool.get(DictEnum.SETTING_MASTER_QUESTION3);
		model.addAttribute("questions1", questions1);
		model.addAttribute("questions2", questions2);
		model.addAttribute("questions3", questions3);
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
	 * 获取玩家信息
	 *
	 * @return
	 */
	private SysUserVo getPlayerInfo() {
		SysUserVo sysUserVo = new SysUserVo();
		sysUserVo.setResult(SessionManager.getUser());
		return sysUserVo;
	}

	/**
	 * 获取站点支持的银行列表
	 */
	private BankListVo getBankList() {
		List<String> areaList = getOperatorArea();
		BankListVo bankListVo = new BankListVo();
		if(areaList!=null&&areaList.size()>0){
			bankListVo.getSearch().setType(BankEnum.TYPE_BANK.getCode());
			bankListVo.getSearch().setIsUse(true);
			bankListVo.getSearch().setBankDistrictList(getOperatorArea());
			bankListVo.getQuery().addOrder(Bank.PROP_ORDER_NUM, Direction.ASC);
			bankListVo.setPaging(null);
			bankListVo = ServiceTool.bankService().search(bankListVo);
		}
		return bankListVo;
	}

	/**
	 * 获取玩家银行卡信息
	 *
	 * @param userId
	 * @return
	 */
	private UserBankcardVo getUserBankcardVo(Integer userId) {
		UserBankcardVo userBankcardVo = new UserBankcardVo();
		userBankcardVo.getSearch().setUserId(userId);
		userBankcardVo.getSearch().setIsDefault(Boolean.TRUE);
		UserBankcard userBankcard = ServiceTool.userBankcardService().findByUserId(userBankcardVo);
		userBankcardVo.setResult(userBankcard);
		return userBankcardVo;
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

		if (SessionManager.getEmailCode() != null) {
			if (email.equals(SessionManager.getEmailCode().get(2))) {
				if (DateTool.secondsBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailCode().get(1)) > 100) {
					map.put("state", false);
					map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.captcha.due")));
					flag = true;
				} else if (!emailCode.equals(SessionManager.getEmailCode().get(0))) {
					map.put("state", false);
					map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.captcha.error")));
					flag = true;
				}
			} else {//验证获取验证码后邮箱是否更改
				map.put("state", false);
				map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.error")));
				flag = true;
			}
		} else {
			map.put("state", false);
			map.put("msg", LocaleTool.tranMessage("player", LocaleTool.tranMessage(Module.MASTER_SETTING, "binding.email.captcha.error")));
			flag = true;
		}
		return flag;
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
				//TODO eagle 此处需求要求通过ip来判断地区填充默认国际电话区号，目前没有ip相关接口
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
	 * 获取站点信息
	 *
	 * @param sysUserVo
	 * @return
	 */
	private SysSiteVo getSysSite(SysUserVo sysUserVo) {
		SysSiteVo sysSiteVo = new SysSiteVo();
		sysSiteVo.getSearch().setId(sysUserVo.getResult().getSiteId());
		sysSiteVo = ServiceTool.sysSiteService().get(sysSiteVo);
		return sysSiteVo;
	}

	/**
	 * 生成token
	 * @param model
	 *//*
	private void generatorToken(Model model) {
		String token = UUID.randomUUID().toString();
		SessionManager.setToken(token);
		model.addAttribute("token",token);
	}*/
	//endregion your codes 3
}
