package so.wwb.gamebox.pcenter.customer.controller;

import org.soul.commons.net.ServletTool;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.servlet.http.HttpServletRequest;


/**
 * 客服控制器
 *
 * @author River
 * @time 2015-12-2 17:08:13
 */
@Controller
@RequestMapping("/customer")
public class CustomerController {


    protected String getViewBasePath() {
        return "/customer/";
    }

    @RequestMapping({"/view"})
    public String view(HttpServletRequest request) {
        return ServletTool.isAjaxSoulRequest(request) ? getViewBasePath() + "view" : getViewBasePath()+"view";
    }

}