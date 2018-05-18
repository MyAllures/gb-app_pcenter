package so.wwb.gamebox.pcenter.fund.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.model.master.enums.TransactionOriginEnum;
import so.wwb.gamebox.model.master.player.vo.PlayerApiAccountVo;
import so.wwb.gamebox.model.master.player.vo.PlayerApiVo;

import javax.servlet.http.HttpServletRequest;
import java.util.Map;

/**
 * Created by cherry on 17-3-6.
 */
@Controller
@RequestMapping("/transfer/auto")
public class AutoTransferController extends so.wwb.gamebox.web.fund.controller.AutoTransferController {
    @Override
    public PlayerApiAccountVo doLogin(PlayerApiAccountVo playerApiAccountVo, HttpServletRequest request) {
        return null;
    }

    @Override
    public Map doRecovery(PlayerApiVo playerApiVo, HttpServletRequest request) {
        playerApiVo.setOrigin(TransactionOriginEnum.PC.getCode());
        return super.doRecovery(playerApiVo, request);
    }
}
