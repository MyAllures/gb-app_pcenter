package so.wwb.gamebox.pcenter.controller;

import org.soul.commons.enums.YesNot;
import org.soul.commons.lang.BooleanTool;
import org.soul.commons.spring.utils.SpringTool;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.web.shiro.common.delegate.PassportDelegate;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Created by jessie on 16-4-1.
 */
@Controller
@RequestMapping("/logout")
public class LogoutController {

    @RequestMapping(value = "/logoutByExit")
    @ResponseBody
    public String logoutByExit(HttpServletRequest request, HttpServletResponse response) {
        PassportDelegate passportDelegate = SpringTool.getBean(PassportDelegate.class);
        passportDelegate.onLogoutDelegate(request, response);
        return BooleanTool.toStringTrueFalse(YesNot.YES.getBool());
    }

    @RequestMapping(value = "/logoutByTimeOut")
    public String logoutByTimeOut(HttpServletRequest request, HttpServletResponse response) {
        PassportDelegate passportDelegate = SpringTool.getBean(PassportDelegate.class);
        passportDelegate.onLogoutDelegate(request, response);
        return "/timeout";
    }

}
