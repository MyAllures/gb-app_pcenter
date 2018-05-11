package so.wwb.gamebox.pcenter.personInfo.controller;

import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.DateQuickPicker;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.validation.form.PasswordRule;
import org.soul.model.log.audit.enums.OpMode;
import org.soul.model.msg.notice.po.NoticeContactWay;
import org.soul.model.msg.notice.vo.NoticeContactWayListVo;
import org.soul.model.msg.notice.vo.NoticeContactWayVo;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.model.session.SessionKey;
import org.soul.model.sys.po.SysParam;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.common.dubbo.ServiceTool;
import so.wwb.gamebox.common.security.AuthTool;
import so.wwb.gamebox.model.Module;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.PrivilegeStatusEnum;
import so.wwb.gamebox.model.common.notice.enums.ContactWayType;
import so.wwb.gamebox.model.master.enums.ContactWayStatusEnum;
import so.wwb.gamebox.model.master.player.vo.UpdatePasswordVo;
import so.wwb.gamebox.pcenter.personInfo.form.BindPhoneForm;
import so.wwb.gamebox.pcenter.personInfo.form.SecurityPasswordForm;
import so.wwb.gamebox.pcenter.personInfo.form.UpdatePasswordForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.SessionManagerCommon;
import so.wwb.gamebox.web.common.SiteCustomerServiceHelper;
import so.wwb.gamebox.web.passport.captcha.CaptchaUrlEnum;
import so.wwb.gamebox.web.privilege.form.ForgetPasswordForm;
import so.wwb.gamebox.web.shiro.common.filter.KickoutFilter;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.*;

/**
 * Created by bruce on 16-7-14.
 */
@Controller
@RequestMapping("/personInfo/password")
public class UpdatePasswordController {

    private static final String PERSON_INFO_UPDATE_PASSWORD = "personInfo/UpdatePassword";
    private static final String PERSON_INFO_INDEX = "personInfo/updatePassword/Index";
    private static final String PERSON_INFO_FORGETPWD = "personInfo/updatePassword/ForgetPwd";
    private static final String PERSON_INFO_FORGETPWD2 = "personInfo/updatePassword/ForgetPwd2";
    private static final String PERSON_INFO_FORGETPWD3 = "personInfo/updatePassword/ForgetPwd3";

    /*默认5次机会*/
    private static final int ERROR_TIMES = 5;

    @RequestMapping("/index")
    public String index(Model model) {
        model.addAttribute("validateRule", JsRuleCreator.create(UpdatePasswordForm.class));
        model.addAttribute("remainTimes", remainTimes());
        return PERSON_INFO_INDEX;
    }

    /**
     * 忘记安全密码
     * @param model
     * @return
     */
    @RequestMapping("/forgetPwd")
    public String forgetPwd(Model model) {
        model.addAttribute("validateRule", JsRuleCreator.create(ForgetPasswordForm.class));
        String customerService = SiteCustomerServiceHelper.getPCCustomerServiceUrl();
        model.addAttribute("customerService",customerService);

        SysParam smsSwitch = ParamTool.getSysParam(SiteParamEnum.SETTING_REG_SETTING_SMS_SWITCH);
        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
        if(smsSwitch!=null && smsSwitch.getActive() && noticeContactWayVo.getResult()!=null && ContactWayStatusEnum.CONTENT_STATUS_USING.getCode().equals(noticeContactWayVo.getResult().getStatus())){
            model.addAttribute("phone",true);
        }else{
            model.addAttribute("phone",false);
        }
        return PERSON_INFO_FORGETPWD;
    }

    /**
     * 手机验证
     * @param model
     * @return
     */
    @RequestMapping("/forgetPwd2")
    public String forgetPwd2(Model model){
        model.addAttribute("validateRule", JsRuleCreator.create(BindPhoneForm.class));
        NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
        model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
        return PERSON_INFO_FORGETPWD2;
    }

    @RequestMapping("/forgetPwd3")
    public String forgetPwd3(String code,Model model){
        Boolean bool = verifyPhoneVerificationCode(code);
        if(bool){
            model.addAttribute("validateRule", JsRuleCreator.create(SecurityPasswordForm.class));
            NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
            model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
            return PERSON_INFO_FORGETPWD3;
        }else{
            model.addAttribute("validateRule", JsRuleCreator.create(BindPhoneForm.class));
            NoticeContactWayVo noticeContactWayVo = getContactWayByType(SessionManager.getUserId(), ContactWayType.CELLPHONE.getCode());
            model.addAttribute("noticeContactWay", noticeContactWayVo.getResult());
            return PERSON_INFO_FORGETPWD2;
        }
    }

    public boolean verifyPhoneVerificationCode(String phoneVerificationCode) {
        boolean flag = false;
        boolean isExpired = false;
        boolean isError = false;
        if (SessionManager.getEmailOrPhoneCode("phone") != null) {
            isExpired = DateTool.minutesBetween(SessionManager.getDate().getNow(), (Date) SessionManager.getEmailOrPhoneCode("phone").get(1)) > 30;
            isError = phoneVerificationCode.equals(SessionManager.getEmailOrPhoneCode("phone").get(0));
            flag = !isExpired && isError;
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
     * 跳转到修改密码页面
     *
     * @param model
     * @return
     */
    @RequestMapping("/editPassword")
    public String editPassword(Model model) {
        model.addAttribute("validateRule", JsRuleCreator.create(UpdatePasswordForm.class));
        model.addAttribute("remainTimes", remainTimes());
        return PERSON_INFO_UPDATE_PASSWORD;
    }

    /**
     * 修改密码
     *
     * @param updatePasswordVo
     * @param result
     * @return
     */
    @RequestMapping(value = "/updatePassword")
    @ResponseBody
    public Map updatePassword(UpdatePasswordVo updatePasswordVo, String code, @Valid UpdatePasswordForm form,
                              BindingResult result,HttpServletRequest request) {
        Map<String,Object> map = new HashMap<>(2,1f);
        //有错误直接返回
        if (result.hasErrors()) {
            map.put("state", false);
            map.put("msg",  LocaleTool.tranMessage(Module.PRIVILEGE, "password.update.failed"));
            return map;
        }

        //密码相同验证新密码不能和旧密码一样
        String newPwd = AuthTool.md5SysUserPassword(updatePasswordVo.getNewPassword(), SessionManager.getUserName());
        if (newPwd.equals(SessionManager.getUser().getPassword())) {
            map.put("state", false);
            map.put("msg",  LocaleTool.tranMessage(Module.PRIVILEGE, "password.update.same"));
            return map;
        }

        //验证旧密码
        String oldPwd = AuthTool.md5SysUserPassword(updatePasswordVo.getPassword(),SessionManager.getUserName());
        if (!oldPwd.equals(SessionManager.getUser().getPassword())) {
            return inputFault(request);
        }

        int errTimes = getErrorTimes();
        //第二次以上重试时，判断图片验证码
        if (!isLock() && errTimes >= ERROR_TIMES) {
            errTimes = 0;
        }
        if (errTimes >= 2) {
            map = validateCheckCode(code);
            if (!map.get("stateCode").equals(PrivilegeStatusEnum.CODE_100.getCode())) {
                return map;
            }
        }

        SysUserVo sysUserVo = new SysUserVo();
        SysUser sysUser = new SysUser();
        sysUser.setId(SessionManager.getUserId());
        sysUser.setPassword(newPwd);
        sysUser.setPasswordLevel(updatePasswordVo.getPasswordLevel());
        sysUserVo.setResult(sysUser);
        sysUserVo.setProperties(SysUser.PROP_PASSWORD, SysUser.PROP_PASSWORD_LEVEL);
        boolean success = ServiceTool.sysUserService().updateOnly(sysUserVo).isSuccess();
        map.put("state", success);
        if (success) {
            SessionManager.refreshUser();
            map.put("msg",  LocaleTool.tranMessage(Module.PRIVILEGE, "password.update.success"));
            map.put("stateCode", PrivilegeStatusEnum.CODE_100.getCode());
        } else {
            map.put("msg",  LocaleTool.tranMessage(Module.PRIVILEGE, "password.update.failed"));
        }
        return map;
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
     * 修改账户密码--检查密码
     *
     * @param password
     * @return
     */
    @RequestMapping(value = "/checkPassword")
    @ResponseBody
    public String checkPassword(@RequestParam("password") String password) {
        SysUser user = SessionManager.getUser();
        String inputPassword = AuthTool.md5SysUserPassword(password, user.getUsername());
        return user.getPassword().equals(inputPassword) ? "true" : "false";
    }

    /**
     * 验证吗remote验证
     *
     * @param code
     * @return
     */
    @RequestMapping("/checkCode")
    @ResponseBody
    public boolean checkCode(@RequestParam("code") String code) {
        String sessionCode = SessionManagerCommon.getCaptcha(SessionKey.S_CAPTCHA_PREFIX + CaptchaUrlEnum.CODE_LOGIN.getSuffix());
        return StringTool.isNotBlank(sessionCode) && sessionCode.equalsIgnoreCase(code);
    }

    private HashMap<String,Object> validateCheckCode(String validCode) {
        HashMap<String,Object> map = new HashMap<>(3,1f);
        String msg;
        if (StringTool.isBlank(validCode)) {
            msg = LocaleTool.tranMessage("privilege", "captcha.input");
            map.put("msg", msg);
            map.put("stateCode", PrivilegeStatusEnum.CODE_98.getCode());
            map.put("state", false);
        } else {
            if (!checkCode(validCode)) {
                msg = LocaleTool.tranMessage("privilege", "captcha.wrong");
                map.put("msg", msg);
                map.put("stateCode", PrivilegeStatusEnum.CODE_97.getCode());
                map.put("state", false);
            } else {
                map.put("stateCode", PrivilegeStatusEnum.CODE_100.getCode());
                map.put("state", true);
            }
        }
        return map;
    }

    //错误次数,错误次数达到直接踢出
    private int getErrorTimes() {
        SysUser curUser = SessionManagerCommon.getUser();
        if (curUser != null) {
            return curUser.getLoginErrorTimes() == null ? -1 : curUser.getLoginErrorTimes();
        }
        //判断不出来默认需要权限
        return 1;
    }

    //剩余次数
    private int remainTimes() {
        return ERROR_TIMES - getErrorTimes();
    }

    //是否被冻结
    private boolean isLock() {
        SysUser curUser = SessionManagerCommon.getUser();
        Date now = DateQuickPicker.getInstance().getNow();
        if (curUser != null) {
            if (curUser.getFreezeEndTime() == null) {
                return false;
            }
            if (now.before(curUser.getFreezeEndTime())) {
                return true;
            }
        }
        return false;
    }

    private HashMap<String,Object> inputFault(HttpServletRequest request) {
        HashMap<String,Object> map = new HashMap<>(3,1f);
        Date now = DateQuickPicker.getInstance().getNow();
        int errTimes = getErrorTimes();
        if (errTimes == 0) {
            map = firstInputFalut();
            updateSysUserErrorTimes(1, now, null);
        } else {
            if (errTimes == -1) {
                errTimes = 0;
            }
            int times = errTimes;
            times++;
            if (times >= ERROR_TIMES) {
                map = inputMaxFalut();
                updateSysUserErrorTimes(ERROR_TIMES, now, DateTool.addHours(now, 3));
                KickoutFilter.loginKickoutAll(SessionManager.getUserId(), OpMode.AUTO,"PC修改密码错误踢出用户");
            } else {
                map = inputFalutNoAtMax(times);
                updateSysUserErrorTimes(times, null, null);
            }
        }
        return map;
    }

    /**
     * 更新冻结开始,结束,错误次数
     * @param times
     * @param startTime
     * @param endTime
     */
    private void updateSysUserErrorTimes(int times, Date startTime, Date endTime) {
        SysUserVo sysUserVo = new SysUserVo();
        SysUser sysUser = SessionManagerCommon.getUser();
        sysUser.setFreezeStartTime(startTime);
        sysUser.setFreezeEndTime(endTime);
        sysUser.setLoginErrorTimes(times);
        sysUserVo.setResult(sysUser);
        sysUserVo.setProperties(SysUser.PROP_FREEZE_START_TIME, SysUser.PROP_FREEZE_END_TIME,SysUser.PROP_LOGIN_ERROR_TIMES);
        ServiceTool.sysUserService().updateOnly(sysUserVo);
        SessionManagerCommon.refreshUser();
    }

    private HashMap<String,Object> inputFalutNoAtMax(int times) {
        //返回页面消息
        HashMap<String,Object> map = new HashMap<>(3,1f);
        map.put("msg", LocaleTool.tranMessage("privilege", "input.wrong"));
        map.put("state", false);
        map.put("remainTimes", ERROR_TIMES - times);
        return map;
    }

    private HashMap<String,Object> inputMaxFalut() {
        HashMap<String,Object> map = new HashMap<>(3,1f);
        //返回页面消息
        map.put("msg", LocaleTool.tranMessage("privilege", "input.freeze"));
        map.put("stateCode", PrivilegeStatusEnum.CODE_99.getCode());
        map.put("state", false);
        return map;
    }

    private HashMap<String,Object> firstInputFalut() {
        HashMap<String,Object> map = new HashMap<>(3,1f);
        //返回页面消息
        map.put("msg", LocaleTool.tranMessage("privilege", "input.wrong"));
        map.put("state", false);
        map.put("remainTimes", ERROR_TIMES - 1);
        return map;
    }

}
