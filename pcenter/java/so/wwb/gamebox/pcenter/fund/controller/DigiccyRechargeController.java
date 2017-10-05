package so.wwb.gamebox.pcenter.fund.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.master.digiccy.po.UserDigiccy;
import so.wwb.gamebox.model.master.digiccy.vo.UserDigiccyListVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;

import java.util.List;
import java.util.Map;

/**
 * Created by cherry on 17-10-3.
 */
@Controller
@RequestMapping("/fund/recharge/digiccy")
public class DigiccyRechargeController extends RechargeBaseController {
    private static final String DIGICCY_PAY_URI = "/fund/recharge/DigiccyPay";

    @RequestMapping("/digiccyPay")
    public String digiccyPay(Model model) {
        UserDigiccyListVo userDigiccyListVo = new UserDigiccyListVo();
        userDigiccyListVo.getSearch().setUserId(SessionManager.getUserId());
        List<UserDigiccy> userDigiccyList = ServiceTool.userDigiccyService().getUserDigiccis(userDigiccyListVo);
        model.addAttribute("userDigiccyList", userDigiccyList);
        return DIGICCY_PAY_URI;
    }

    @RequestMapping("/newAddress")
    @ResponseBody
    public Map<String, Object> newAddress(String currency) {
        return null;
    }
}
