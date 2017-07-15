package so.wwb.gamebox.pcenter.preferential.controller;

import org.soul.commons.net.ServletTool;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.model.master.operation.vo.VPreferentialRecodeListVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;

import javax.servlet.http.HttpServletRequest;

/**
 * Created by bruce on 16-6-15.
 */
@Controller
@RequestMapping("/preferential")
public class PreferentialController {

    /**
     * 优惠记录列表
     * @param vPreferentialRecodeListVo
     * @param model
     * @param request
     * @return
     */
    @RequestMapping("/list")
    public String list(VPreferentialRecodeListVo vPreferentialRecodeListVo,Model model,HttpServletRequest request) {
        vPreferentialRecodeListVo.getSearch().setActivityVersion(SessionManager.getLocale().toString());
        vPreferentialRecodeListVo.getSearch().setUserId(SessionManager.getUserId());
        vPreferentialRecodeListVo.getSearch().setCurrentDate(SessionManager.getDate().getNow());
        vPreferentialRecodeListVo  = ServiceTool.vPreferentialRecodeService().search(vPreferentialRecodeListVo);
        model.addAttribute("command",vPreferentialRecodeListVo);
        return ServletTool.isAjaxSoulRequest(request)? "/preferential/IndexPartial" : "/preferential/Index";
    }
}
