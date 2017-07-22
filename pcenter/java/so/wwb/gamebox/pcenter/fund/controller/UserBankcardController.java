package so.wwb.gamebox.pcenter.fund.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.model.master.player.po.UserBankcard;
import so.wwb.gamebox.model.master.player.vo.UserBankcardVo;

import java.util.HashMap;
import java.util.Map;

/**
 * Created by cherry on 17-7-22.
 */
@RequestMapping("/fund/userBankcard")
@Controller
public class UserBankcardController {

    @RequestMapping("/bindBtc")
    @ResponseBody
    public Map bindBtc(UserBankcardVo userBankcardVo) {
        UserBankcard userBankcard = userBankcardVo.getResult();
        Map<String,Object> map = new HashMap<>();
        return map;
    }
}
