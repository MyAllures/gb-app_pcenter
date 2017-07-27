package so.wwb.gamebox.pcenter.share.controller;

import org.soul.commons.init.context.CommonContext;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleDateTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.support._Module;
import org.soul.model.security.privilege.po.SysUser;
import org.soul.model.security.privilege.vo.SysUserVo;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.company.site.po.SiteCustomerService;
import so.wwb.gamebox.model.master.player.po.UserPlayer;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.share.form.RealNameConfirmForm;
import so.wwb.gamebox.pcenter.share.form.RealNameForm;
import so.wwb.gamebox.pcenter.tools.BankTool;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.cache.Cache;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by cheery on 15-6-16.
 */
@Controller
@RequestMapping(value = "/share")
public class ShareController {


    private static final Log LOG = LogFactory.getLog(ShareController.class);
    private static String BALANCE_FREEZE_URI = "share/BalanceFreeze";
    //玩家填写真实姓名
    private static final String REAL_NAME_URI = "/share/RealName";
    //确认填写玩家真实姓名
    private static final String CONFIRM_REAL_NAME_URI = "/share/ConfirmRealName";

    @RequestMapping(value = "/bank/checkBankNumber")
    @ResponseBody
    public Map checkBankNumber(@RequestParam("bankcardNumber") String bankcardNumber, HttpServletRequest reqeust) {
        return BankTool.getBankInfo(bankcardNumber);
    }

    /**
     * 跳转余额冻结页面
     *
     * @param model
     * @return
     */
    @RequestMapping("/balanceFreeze")
    public String balanceFreeze(Model model) {
        UserPlayerVo userPlayerVo = new UserPlayerVo();
        userPlayerVo.getSearch().setId(SessionManager.getUserId());
        userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);
        UserPlayer player = userPlayerVo.getResult();
        if (player.isBalanceFreeze()) {
            model.addAttribute("balanceType", player.getBalanceType());
            model.addAttribute("customerService", getCustomerService());
            model.addAttribute("content", player.getBalanceFreezeContent().replace("${unfreezetime}",
                    LocaleDateTool.formatDate(player.getBalanceFreezeEndTime(), CommonContext.getDateFormat().getDAY_SECOND(), SessionManager.getTimeZone())));
            model.addAttribute("balanceFreezeEndTime", player.getBalanceFreezeEndTime());
        }
        return BALANCE_FREEZE_URI;
    }

    private String getCustomerService() {
        SiteCustomerService siteCustomerService = Cache.getDefaultCustomerService();
        String url = siteCustomerService.getParameter();
        if (StringTool.isNotBlank(url) && !url.contains("http")) {
            url = "http://" + url;
        }
        return url;
    }

    @RequestMapping("/realName")
    public String realName(Model model, String type) {
        SysUser sysUser = SessionManager.getUser();
        if (StringTool.isBlank(sysUser.getRealName())) {
            model.addAttribute("validateRule", JsRuleCreator.create(RealNameForm.class));
        }
        return REAL_NAME_URI;
    }

    /**
     * 确认真实姓名
     *
     * @param confirmRealName
     * @return
     */
    @RequestMapping("/compareRealName")
    @ResponseBody
    public String compareRealName(@RequestParam("confirmRealName") String confirmRealName) {
        String realName = SessionManager.getRealName();
        if (StringTool.isNotBlank(confirmRealName) && confirmRealName.equals(realName)) {
            return "true";
        }
        return "false";
    }

    @RequestMapping("/confirmRealName")
    public String confirmRealName(Model model, @FormModel @Valid RealNameForm form, BindingResult result) {
        if (result.hasErrors()) {
            return null;
        }
        SessionManager.setRealName(form.get$realName());
        model.addAttribute("validateRule", JsRuleCreator.create(RealNameConfirmForm.class));
        return CONFIRM_REAL_NAME_URI;
    }

    @RequestMapping("/saveRealName")
    @ResponseBody
    public Map saveRealName(@FormModel @Valid RealNameConfirmForm form, BindingResult result) {
        Map<String, Object> map = new HashMap<>(2,1f);
        if (result.hasErrors()) {
            map.put("state", false);
            map.put("msg", LocaleTool.tranMessage(_Module.COMMON, "save.failed"));
            return map;
        }
        SysUserVo vo = new SysUserVo();
        SysUser sysUser = SessionManager.getUser();
        sysUser.setRealName(form.get$confirmRealName());
        vo.setResult(sysUser);
        vo.setProperties(SysUser.PROP_REAL_NAME, SysUser.PROP_UPDATE_TIME, SysUser.PROP_UPDATE_USER);
        vo = ServiceTool.sysUserService().updateOnly(vo);
        vo.getSearch().setId(SessionManager.getUserId());
        vo = ServiceTool.sysUserService().get(vo);
        SessionManager.setUser(vo.getResult());
        map.put("state", vo.isSuccess());
        if (vo.isSuccess()) {
            map.put("msg", LocaleTool.tranMessage(_Module.COMMON, "save.success"));
        } else {
            map.put("msg", LocaleTool.tranMessage(_Module.COMMON, "save.failed"));
        }

        return map;
    }

}
