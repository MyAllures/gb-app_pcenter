package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.lang.DateTool;
import org.soul.commons.net.ServletTool;
import org.soul.web.controller.NoMappingCrudController;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.iservice.master.player.IPlayerTransactionService;
import so.wwb.gamebox.model.master.fund.enums.TransactionTypeEnum;
import so.wwb.gamebox.model.master.player.po.PlayerTransaction;
import so.wwb.gamebox.model.master.player.vo.PlayerTransactionListVo;
import so.wwb.gamebox.model.master.player.vo.PlayerTransactionVo;
import so.wwb.gamebox.pcenter.fund.form.PlayerTransactionForm;
import so.wwb.gamebox.pcenter.fund.form.PlayerTransactionSearchForm;
import so.wwb.gamebox.pcenter.session.SessionManager;

import javax.servlet.http.HttpServletRequest;


/**
 * 玩家交易表控制器
 *
 * @author jeff
 * @time 2015-10-30 15:43:35
 */
@Controller
//region your codes 1
@RequestMapping("/fund/transaction/transfers/")
public class PlayerTransfersController extends NoMappingCrudController<IPlayerTransactionService, PlayerTransactionListVo, PlayerTransactionVo, PlayerTransactionSearchForm, PlayerTransactionForm, PlayerTransaction, Integer> {
//endregion your codes 1

    @Override
    protected String getViewBasePath() {
        //region your codes 2 transfers
        return "/fund/transaction/transfers/";
        //endregion your codes 2
    }

    //region your codes 3

    @Override
    protected PlayerTransactionListVo doList(PlayerTransactionListVo listVo, PlayerTransactionSearchForm form, BindingResult result, Model model) {
//        SessionManager.getUser().getId();
        /*查询当前登录玩家的资金记录*/
        listVo.getSearch().setTransactionType(TransactionTypeEnum.TRANSFERS.getCode());
//        DateTool.addDays() 2015
        listVo.getSearch().setEndCreateTime(DateTool.addDays(listVo.getSearch().getBeginCreateTime(), 1));
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        listVo = getService().search(listVo);
        /*字典*/
        return listVo;

    }
    @RequestMapping("/playerTransfersList")
    public String playerTransfersList(PlayerTransactionListVo listVo, BindingResult result, Model model, HttpServletRequest request){
        listVo.getSearch().setTransactionType(TransactionTypeEnum.TRANSFERS.getCode());
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        listVo.getSearch().setEndCreateTime(DateTool.addDays(listVo.getSearch().getBeginCreateTime(), 1));
        listVo = getService().search(listVo);
        model.addAttribute("command", listVo);
        if (ServletTool.isAjaxSoulRequest(request)) {
            return getViewBasePath() + "IndexPartial";
        } else {
            return getViewBasePath()+"Index";
        }
    }


    //endregion your codes 3

}