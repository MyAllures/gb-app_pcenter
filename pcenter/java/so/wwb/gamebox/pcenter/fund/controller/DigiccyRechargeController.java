package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.master.digiccy.po.UserDigiccy;
import so.wwb.gamebox.model.master.digiccy.vo.UserDigiccyListVo;
import so.wwb.gamebox.model.master.digiccy.vo.UserDigiccyVo;
import so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by cherry on 17-10-3.
 */
@Controller
@RequestMapping("/fund/recharge/digiccy")
public class DigiccyRechargeController extends RechargeBaseController {
    private static final String DIGICCY_PAY_URI = "/fund/recharge/DigiccyPay";
    private static final Log LOG = LogFactory.getLog(DigiccyRechargeController.class);

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
        UserDigiccyVo userDigiccyVo = new UserDigiccyVo();
        userDigiccyVo.setSysUser(SessionManager.getUser());
        userDigiccyVo.getSearch().setCurrency(currency);
        userDigiccyVo.getSearch().setUserId(SessionManager.getUserId());
        userDigiccyVo = ServiceTool.userDigiccyService().getDepositAddress(userDigiccyVo);
        Map<String, Object> map = new HashMap<>(3, 1f);
        if (userDigiccyVo.isSuccess() && userDigiccyVo.getResult() != null) {
            UserDigiccy userDigiccy = userDigiccyVo.getResult();
            map.put("address", userDigiccy.getAddress());
            map.put("addressQrcodeUrl", userDigiccy.getAddressQrcodeUrl());
            map.put("state", true);
        } else {
            map.put("state", "false");
            map.put("msg", userDigiccyVo.getErrMsg());
        }
        return map;
    }

    @RequestMapping("/exchange")
    @ResponseBody
    public Map<String, Object> exchange(String currency) {
        UserDigiccyVo userDigiccyVo = new UserDigiccyVo();
        userDigiccyVo.setSysUser(SessionManager.getUser());
        userDigiccyVo.getSearch().setCurrency(currency);
        userDigiccyVo.getSearch().setUserId(SessionManager.getUserId());
        PlayerRechargeVo playerRechargeVo = new PlayerRechargeVo();
        try {
            playerRechargeVo = ServiceTool.playerRechargeService().digiccyExchange(playerRechargeVo, userDigiccyVo);
        } catch (Exception e) {
            LOG.error(e);
            playerRechargeVo.setSuccess(false);
        }
        Map<String, Object> map = new HashMap<>(3, 1f);
        map.put("state", playerRechargeVo.isSuccess());
        map.put("msg", playerRechargeVo.getErrMsg());
        map.put("rechargeAmount", playerRechargeVo.getResult().getRechargeAmount());
        return map;
    }

    @RequestMapping("/refresh")
    @ResponseBody
    public Map<String, Object> refresh(String currency) {
        UserDigiccyVo userDigiccyVo = new UserDigiccyVo();
        userDigiccyVo.getSearch().setCurrency(currency);
        userDigiccyVo.getSearch().setUserId(SessionManager.getUserId());
        userDigiccyVo = ServiceTool.userDigiccyService().fetchBalance(userDigiccyVo);
        UserDigiccy userDigiccy = userDigiccyVo.getResult();
        Map<String, Object> map = new HashMap<>(1, 1f);
        if (userDigiccy != null) {
            map.put("amount", userDigiccy.getAmount());
        } else {
            map.put("amount", 0);
        }
        return map;
    }
}
