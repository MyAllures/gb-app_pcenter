package so.wwb.gamebox.pcenter.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

/**
 * Created by admin on 16-4-14.
 */
@Controller
@RequestMapping("/login")
public class LoginController {

    public static final String LOGIN_URI = "/login";

    @RequestMapping(value = "/commonLogin")
    public String commonLogin() {
        return LOGIN_URI;
    }
}
