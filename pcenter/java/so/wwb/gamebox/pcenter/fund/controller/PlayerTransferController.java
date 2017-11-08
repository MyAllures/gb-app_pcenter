package so.wwb.gamebox.pcenter.fund.controller;

import org.soul.commons.collections.MapTool;
import org.soul.commons.currency.CurrencyTool;
import org.soul.commons.data.json.JsonTool;
import org.soul.commons.init.context.CommonContext;
import org.soul.commons.lang.DateTool;
import org.soul.commons.lang.string.StringTool;
import org.soul.commons.locale.LocaleDateTool;
import org.soul.commons.locale.LocaleTool;
import org.soul.commons.log.Log;
import org.soul.commons.log.LogFactory;
import org.soul.commons.math.NumberTool;
import org.soul.commons.net.ServletTool;
import org.soul.commons.spring.utils.SpringTool;
import org.soul.model.gameapi.result.ResultStatus;
import org.soul.model.sys.po.SysParam;
import org.soul.web.validation.form.annotation.FormModel;
import org.soul.web.validation.form.js.JsRuleCreator;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import so.wwb.gamebox.iservice.master.fund.IPlayerTransferService;
import so.wwb.gamebox.iservice.master.player.IPlayerApiService;
import so.wwb.gamebox.model.CacheBase;
import so.wwb.gamebox.model.Module;
import so.wwb.gamebox.model.ParamTool;
import so.wwb.gamebox.model.SiteParamEnum;
import so.wwb.gamebox.model.common.MessageI18nConst;
import so.wwb.gamebox.model.company.enums.GameStatusEnum;
import so.wwb.gamebox.model.company.setting.po.Api;
import so.wwb.gamebox.model.company.site.po.SiteApi;
import so.wwb.gamebox.model.enums.DemoModelEnum;
import so.wwb.gamebox.model.gameapi.enums.ApiProviderEnum;
import so.wwb.gamebox.model.master.enums.TransactionOriginEnum;
import so.wwb.gamebox.model.master.fund.enums.FundTypeEnum;
import so.wwb.gamebox.model.master.fund.enums.TransferResultStatusEnum;
import so.wwb.gamebox.model.master.fund.enums.TransferSourceEnum;
import so.wwb.gamebox.model.master.fund.vo.PlayerTransferVo;
import so.wwb.gamebox.model.master.fund.vo.PlayerWithdrawVo;
import so.wwb.gamebox.model.master.player.po.PlayerApi;
import so.wwb.gamebox.model.master.player.po.PlayerApiAccount;
import so.wwb.gamebox.model.master.player.vo.PlayerApiAccountVo;
import so.wwb.gamebox.model.master.player.vo.PlayerApiListVo;
import so.wwb.gamebox.model.master.player.vo.PlayerApiVo;
import so.wwb.gamebox.model.master.player.vo.UserPlayerVo;
import so.wwb.gamebox.pcenter.fund.form.PlayerTransferForm;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;
import so.wwb.gamebox.web.SessionManagerCommon;
import so.wwb.gamebox.web.api.IApiBalanceService;
import so.wwb.gamebox.web.cache.Cache;
import so.wwb.gamebox.web.common.demomodel.DemoMenuEnum;
import so.wwb.gamebox.web.common.demomodel.DemoModel;
import so.wwb.gamebox.web.common.token.Token;
import so.wwb.gamebox.web.common.token.TokenHandler;

import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.*;


/**
 * 玩家转账表-susu控制器
 *
 * @author cheery
 * @time 2015-11-2 20:09:37
 */
@Controller
//region your codes 1
@RequestMapping("/fund/playerTransfer")
public class PlayerTransferController {
    private static final String TRANSFER_WALLET = "wallet";//转入转出选择我的钱包
    //免转-转帐主页
    private static final String AUTO_TRANSFER_INDEX_URL = "/fund/transfers/auto/Index";
    //记录日志
    private static final Log LOG = LogFactory.getLog(PlayerTransferController.class);


    private IPlayerTransferService playerTransferService;

    //endregion your codes 1
    private String getViewBasePath() {
        //region your codes 2
        return "/fund/transfers/";
        //endregion your codes 2
    }

    //region your codes 3
    private IPlayerTransferService playerTransferService() {
        if (playerTransferService == null)
            playerTransferService = ServiceTool.playerTransferService();
        return playerTransferService;
    }

    @RequestMapping("/transfers")
    @Token(generate = true)
    @DemoModel(menuCode = DemoMenuEnum.EDZH)
    public String transfers(Model model, String isRefresh, HttpServletRequest request) {
        if (SessionManagerCommon.isAutoPay()) {
            searchAssets(model, new PlayerApiListVo());
            return "/fund/transfers/auto/Index";
        } else {
            if(SessionManager.isMockAccountModel()){
                model.addAttribute("apiList", searchTransferApiByMock());
            }else{
                model.addAttribute("apiList", searchTransferApis());
            }

            //验证规则
            model.addAttribute("validateRule", JsRuleCreator.create(PlayerTransferForm.class));
            model.addAttribute("isRefresh", isRefresh);
            return ServletTool.isAjaxSoulRequest(request) ? getViewBasePath() + "/transfers.include/TransfersPartial" : getViewBasePath() + "Transfers";
        }

    }

    /**
     * 查询可转账的api(包含未注册和维护中的api)
     *
     * @return
     */
    private List<Api> searchTransferApis() {
        List<Api> transableApis = new ArrayList<>();
        Map<String, Api> apis = Cache.getApi();
        Map<String, SiteApi> siteApis = Cache.getSiteApi();
        Api api;
        SiteApi siteApi;
        for (String id : siteApis.keySet()) {
            if(ApiProviderEnum.BSG.getCode().equals(id)){
                continue;
            }
            api = apis.get(id);
            siteApi = siteApis.get(id);
            if (api != null && siteApi != null && !GameStatusEnum.DISABLE.getCode().equals(api.getSystemStatus()) && !GameStatusEnum.DISABLE.getCode().equals(siteApi.getStatus())) {
                transableApis.add(api);
            }
        }
        return transableApis;
    }

    private List<Api> searchTransferApiByMock(){
        List<Api> transableApis = new ArrayList<>();
        Map<String, Api> apis = Cache.getApi();
        Map<String, SiteApi> siteApis = Cache.getSiteApi();
        Api api;
        SiteApi siteApi;
        for (String id : siteApis.keySet()) {
            if(ApiProviderEnum.PL.getCode().equals(id) || ApiProviderEnum.DWT.getCode().equals(id)){
                api = apis.get(id);
                siteApi = siteApis.get(id);
                if (api != null && siteApi != null && !GameStatusEnum.DISABLE.getCode().equals(api.getSystemStatus()) && !GameStatusEnum.DISABLE.getCode().equals(siteApi.getStatus())) {
                    transableApis.add(api);
                }
            }

        }
        return transableApis;
    }

    /**
     * 查询玩家总资产和各api占比
     *
     * @param model
     * @param listVo
     */
    private void searchAssets(Model model, PlayerApiListVo listVo) {
        listVo.getSearch().setPlayerId(SessionManager.getUserId());
        listVo = ServiceTool.playerApiService().fundRecord(listVo);
        model.addAttribute("player", listVo.getUserPlayer());
        //模拟账号过滤不要的API
        if(SessionManager.isMockAccountModel()){
            listVo = filterPlayerApiByMock(listVo);
        }
        model.addAttribute("playerApiListVo", listVo);

        //正在处理中取款金额
        PlayerWithdrawVo playerWithdrawVo = new PlayerWithdrawVo();
        playerWithdrawVo.getSearch().setPlayerId(SessionManager.getUserId());
        model.addAttribute("withdraw", ServiceTool.playerWithdrawService().getDealWithdraw(playerWithdrawVo));

        //正在转账中金额
        PlayerTransferVo playerTransferVo = new PlayerTransferVo();
        playerTransferVo.getSearch().setUserId(SessionManager.getUserId());
        model.addAttribute("transfer", playerTransferService().queryProcessAmount(playerTransferVo));
    }

    private PlayerApiListVo filterPlayerApiByMock(PlayerApiListVo listVo){
        if(listVo.getResult()==null){
            return listVo;
        }
        List<PlayerApi> resList = new ArrayList<>();
        for(PlayerApi playerApi : listVo.getResult()){
            Integer apiId = playerApi.getApiId();
            if(ApiProviderEnum.PL.getCode().equals(apiId.toString()) || ApiProviderEnum.DWT.getCode().equals(apiId.toString())){
                resList.add(playerApi);
            }
        }
        listVo.setResult(resList);
        return listVo;
    }


    /**
     * 验证金额
     *
     * @param transferAmount
     * @param transferOut
     * @return
     */
    @RequestMapping("/checkTransferAmount")
    @ResponseBody
    public String checkTransferAmount(@RequestParam("result.transferAmount") String transferAmount, @RequestParam("transferOut") String transferOut) {
        double amount = NumberTool.toDouble(transferAmount);
        if (TRANSFER_WALLET.equals(transferOut)) {
            UserPlayerVo playerVo = new UserPlayerVo();
            playerVo.getSearch().setId(SessionManager.getUserId());
            playerVo = ServiceTool.userPlayerService().get(playerVo);
            if (playerVo.getResult().getWalletBalance() != null && playerVo.getResult().getWalletBalance() >= amount) {
                return "true";
            }
        } else if (StringTool.isNotBlank(transferOut)) {
            Integer apiId = NumberTool.toInt(transferOut);
            PlayerApiVo playerApiVo = new PlayerApiVo();
            playerApiVo.getSearch().setApiId(apiId);
            playerApiVo.getSearch().setPlayerId(SessionManager.getUserId());
            playerApiVo = ServiceTool.playerApiService().search(playerApiVo);
            if (playerApiVo.getResult() != null && playerApiVo.getResult().getMoney() != null && playerApiVo.getResult().getMoney() >= amount) {
                return "true";
            }
        }
        return "false";
    }

    /**
     * 确认转账
     *
     * @param playerTransferVo
     * @param form
     * @param result
     * @return
     */
    @RequestMapping(value = "/transfersMoney", method = RequestMethod.POST)
    @ResponseBody
    @Token(valid = true)
    public Map transfersMoney(PlayerTransferVo playerTransferVo, @FormModel @Valid PlayerTransferForm form, BindingResult result) {
        LOG.info("【玩家[{0}]转账】:从[{1}]转到[{2}]", SessionManager.getUserName(), playerTransferVo.getTransferOut(), playerTransferVo.getTransferInto());
        if (result.hasErrors()) {
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_INTERFACE_BUSY.getCode(), playerTransferVo.getResult().getApiId());
        }
        if (!isTimeToTransfer()) {//是否已经过了允许转账的间隔
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_TIME_INTERVAL.getCode(), playerTransferVo.getResult().getApiId());
        }
        loadTransferInfo(playerTransferVo);
        Map<String, Object> resultMap = isAbleToTransfer(playerTransferVo);
        if (MapTool.isNotEmpty(resultMap) && !MapTool.getBoolean(resultMap, "state")) {
            return resultMap;
        }

        try {
            PlayerApiAccountVo playerApiAccountVo = createVoByTransfer(playerTransferVo);
            PlayerApiAccount playerApiAccount = ServiceTool.playerApiAccountService().queryApiAccountForTransfer(playerApiAccountVo);
            if (playerApiAccount == null) {
                return getErrorMessage(TransferResultStatusEnum.API_ACCOUNT_NOT_FOUND.getCode(), playerTransferVo.getResult().getApiId());
            }
            //防止游戏账号重复注册
            playerApiAccount = ServiceTool.playerApiAccountService().queryPlayerApiAccount(playerApiAccountVo);
            playerTransferVo.setPlayerApiAccount(playerApiAccount);
        } catch (Exception e) {
            LOG.error(e, "【玩家[{0}]转账】:API账号注册超时。", playerTransferVo.getResult().getUserName());
            return getErrorMessage(TransferResultStatusEnum.API_ACCOUNT_NOT_FOUND.getCode(), playerTransferVo.getResult().getApiId());
        }

        try {
            TransferResultStatusEnum transferResultStatusEnum = playerTransferService().isBalanceEnough(playerTransferVo);
            if (transferResultStatusEnum != null) {
                resultMap = getErrorMessage(transferResultStatusEnum.getCode(), playerTransferVo.getResult().getApiId());
                //余额冻结需弹窗
                if (TransferResultStatusEnum.WALLET_BALANCE_FREEZED == transferResultStatusEnum) {
                    resultMap.put("isFree", true);
                }
                return resultMap;
            }
        } catch (Exception e) {
            LOG.error(e, "【玩家[{0}]转账】:账户余额验证出现异常!", playerTransferVo.getResult().getUserName());
            return getErrorMessage(TransferResultStatusEnum.API_INTERFACE_BUSY.getCode(), playerTransferVo.getResult().getApiId());
        }

        return doTransfer(playerTransferVo);
    }

    /**
     * 封装playerTransferVo
     *
     * @param playerTransferVo
     * @return
     */
    public PlayerApiAccountVo createVoByTransfer(PlayerTransferVo playerTransferVo) {
        PlayerApiAccountVo playerApiAccountVo = new PlayerApiAccountVo();
        playerApiAccountVo.setSysUser(playerTransferVo.getSysUser());
        playerApiAccountVo.setApiId(playerTransferVo.getResult().getApiId());
        playerApiAccountVo.getSearch().setApiId(playerTransferVo.getResult().getApiId());
        playerApiAccountVo.getSearch().setUserId(SessionManager.getUserId());
        return playerApiAccountVo;
    }


    /**
     * 封装当前转账的基本信息
     *
     * @param playerTransferVo
     */
    private void loadTransferInfo(PlayerTransferVo playerTransferVo) {
        if (TRANSFER_WALLET.equals(playerTransferVo.getTransferInto())) {//转入钱包
            playerTransferVo.getResult().setTransferType(FundTypeEnum.TRANSFER_INTO.getCode());
            playerTransferVo.getResult().setApiId(NumberTool.toInt(playerTransferVo.getTransferOut()));
        } else if (TRANSFER_WALLET.equals(playerTransferVo.getTransferOut())) {//转出钱包
            playerTransferVo.getResult().setTransferType(FundTypeEnum.TRANSFER_OUT.getCode());
            playerTransferVo.getResult().setApiId(NumberTool.toInt(playerTransferVo.getTransferInto()));
        }
        playerTransferVo.setSysUser(SessionManager.getUser());
        playerTransferVo.setOrigin(TransactionOriginEnum.PC.getCode());
        playerTransferVo.getResult().setUserId(SessionManager.getUserId());
        playerTransferVo.getResult().setUserName(SessionManager.getUserName());
        playerTransferVo.getResult().setIp(SessionManager.getIpDb().getIp());
        playerTransferVo.getResult().setTransferSource(TransferSourceEnum.PLAYER.getCode());
    }

    /**
     * 当前请求是否可以转账
     *
     * @param playerTransferVo
     * @return 为空则本次转账请求正常
     */
    private Map<String, Object> isAbleToTransfer(PlayerTransferVo playerTransferVo) {
        if (playerTransferVo.getResult().getTransferAmount() <= 0) {
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_ERROR_AMOUNT.getCode(), playerTransferVo.getResult().getApiId());
        }
        if (!ParamTool.isAllowTransfer(SessionManager.getSiteId())) {//如果是demo，不让转账
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_SWITCH_CLOSE.getCode(), playerTransferVo.getResult().getApiId());
        }
        Integer apiId = playerTransferVo.getResult().getApiId();
        if (NumberTool.toInt(ApiProviderEnum.BSG.getCode()) == apiId) {
            return getErrorMessage(TransferResultStatusEnum.API_TRANSFER_UNSUPPORTED.getCode(), playerTransferVo.getResult().getApiId());
        }
        Api api = CacheBase.getApi().get(String.valueOf(apiId));
        SiteApi siteApi = CacheBase.getSiteApi().get(String.valueOf(apiId));
        //无api
        if (api == null || siteApi == null) {
            return getErrorMessage(TransferResultStatusEnum.API_INTERFACE_BUSY.getCode(), playerTransferVo.getResult().getApiId());
        }
        //api维护
        if (isMaintain(api, siteApi))
            return getErrorMessage(TransferResultStatusEnum.API_STATUS_MAINTAIN.getCode(), playerTransferVo.getResult().getApiId());
        //api转账功能关闭
        if (api.getTransferable() == null || !api.getTransferable())
            return getErrorMessage(TransferResultStatusEnum.API_TRANSFER_SWITCH_COLSE.getCode(), playerTransferVo.getResult().getApiId());
        //模拟账号且是自主api可用,其他试玩模式下不支持转账
        if (SessionManagerCommon.getDemoModelEnum() != null) {
                if (DemoModelEnum.MODEL_4_MOCK_ACCOUNT.equals(SessionManagerCommon.getDemoModelEnum()) && (apiId == Integer.valueOf(ApiProviderEnum.PL.getCode()) || apiId == Integer.valueOf(ApiProviderEnum.DWT.getCode()))) {
                    //模拟账号且是自主体育可用
                }else{
                    return getErrorMessage(TransferResultStatusEnum.TRANSFER_DEMO_UNSUPPORTED.getCode(), playerTransferVo.getResult().getApiId());
                }
        }
        return null;
    }

    /**
     * api是否维护中，包含禁用
     *
     * @param api
     * @param siteApi
     * @return
     */
    private boolean isMaintain(Api api, SiteApi siteApi) {
        return GameStatusEnum.DISABLE.getCode().equals(api.getSystemStatus()) || GameStatusEnum.MAINTAIN.getCode().equals(api.getSystemStatus()) || GameStatusEnum.DISABLE.getCode().equals(siteApi.getSystemStatus()) || GameStatusEnum.MAINTAIN.getCode().equals(siteApi.getSystemStatus());
    }

    /**
     * 是否满足允许转账间隔（3秒）
     *
     * @return
     */
    private boolean isTimeToTransfer() {
        Date transferTime = SessionManager.getTransferTime();
        Date nowTime = SessionManager.getDate().getNow();
        SessionManager.setTransferTime(SessionManager.getDate().getNow());
        return transferTime == null || DateTool.secondsBetween(nowTime, transferTime) > 3;
    }

    /**
     * 开始进行转账
     *
     * @param playerTransferVo
     * @return
     */
    private Map<String, Object> doTransfer(PlayerTransferVo playerTransferVo) {
        LOG.info("【玩家[{0}]转账】:开始处理,当前时间【{1}】", playerTransferVo.getResult().getUserName(), SessionManager.getTransferTime());
        try {
            playerTransferVo = playerTransferService().saveTransferAndTransaction(playerTransferVo);
        } catch (Exception e) {
            LOG.error(e, "【玩家[{0}]转账】:生成额度转换记录失败。", playerTransferVo.getResult().getUserName());
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_INTERFACE_BUSY.getCode(), playerTransferVo.getResult().getApiId());
        }
        if (!playerTransferVo.isSuccess()) {
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_INTERFACE_BUSY.getCode(), playerTransferVo.getResult().getApiId());
        }

        try {
            playerTransferVo = playerTransferService().handleTransferResult(playerTransferVo);
        } catch (Exception e) {
            LOG.error("【玩家[{0}]转账】:额度转换处理超时。", playerTransferVo.getResult().getUserName());
            return getErrorMessage(TransferResultStatusEnum.TRANSFER_TIME_OUT.getCode(), playerTransferVo.getResult().getApiId());
        }
        ResultStatus resultStatus = ResultStatus.PROCCESSING;
        if (playerTransferVo.getTransferResult() != null && playerTransferVo.getTransferResult().getStatus() != null) {
            resultStatus = playerTransferVo.getTransferResult().getStatus();
        }
        Map<String, Object> resultMap;
        if (playerTransferVo.isSuccess()) {
            //转账后更新player_api_account表的登录时间，以判断余额是否更新
            updatePlayerApiAccountLoginTime(playerTransferVo);
            resultMap = getSuccessMessage(playerTransferVo.getResult().getApiId());
        } else {
            resultMap = getErrorMessage(TransferResultStatusEnum.TRANSFER_INTERFACE_BUSY.getCode(), playerTransferVo.getResult().getApiId());
        }
        resultMap.put("resultStatus", resultStatus.name());
        resultMap.put("orderId", playerTransferVo.getResult().getTransactionNo());
        resultMap.put("resultCode", resultStatus.getCode());
        resultMap.put("transferOut", playerTransferVo.getTransferOut());
        return resultMap;
    }

    private void updatePlayerApiAccountLoginTime(PlayerTransferVo playerTransferVo) {
        PlayerApiAccountVo playerApiAccountVo = new PlayerApiAccountVo();
        PlayerApiAccount playerApiAccount = playerTransferVo.getPlayerApiAccount();
        playerApiAccount.setLastLoginIp(SessionManager.getIpDb().getIp());
        playerApiAccount.setLastLoginTime(SessionManager.getDate().getNow());
        playerApiAccountVo.setProperties(PlayerApiAccount.PROP_LAST_LOGIN_TIME, PlayerApiAccount.PROP_LAST_LOGIN_IP);
        playerApiAccountVo.setResult(playerApiAccount);
        ServiceTool.playerApiAccountService().updateOnly(playerApiAccountVo);
    }

    /**
     * 获取成功提示信息
     *
     * @param apiId
     * @return
     */
    private Map<String, Object> getSuccessMessage(Integer apiId) {
        Map<String, Object> resultMap = new HashMap<>(5,1f);
        resultMap.put("state", true);
        //用于站点站进入API前的转账窗口
        resultMap.put("api", apiId);
        return resultMap;
    }

    /**
     * 获取失败提示信息
     *
     * @param messageCode
     * @param apiId
     * @return
     */
    private Map<String, Object> getErrorMessage(String messageCode, Integer apiId) {
        Map<String, Object> resultMap = new HashMap<>(5,1f);
        resultMap.put("state", false);
        resultMap.put("msg", LocaleTool.tranMessage(Module.FUND.getCode(), messageCode));
        //用于站点站进入API前的转账窗口
        resultMap.put("api", apiId);
        resultMap.put(TokenHandler.TOKEN_VALUE, TokenHandler.generateGUID());
        return resultMap;
    }

    /**
     * 转账结果页面
     *
     * @param resultStatus
     * @param resultCode
     * @param transactionNo
     * @param transferOut
     * @param model
     * @return
     */
    @RequestMapping("/transferResult")
    public String transferResult(String resultStatus, int resultCode, String transactionNo, String transferOut, Model model) {
        model.addAttribute("resultStatus", resultStatus);
        model.addAttribute("resultCode", resultCode);
        model.addAttribute("transactionNo", transactionNo);
        model.addAttribute("transferOut", transferOut);
        return getViewBasePath() + "TransferResult";
    }

    /**
     * 再试一次
     *
     * @param playerTransferVo
     * @return
     */
    @RequestMapping("/reconnectTransfer")
    @ResponseBody
    public Map reconnectTransfer(PlayerTransferVo playerTransferVo) {
        Map<String, Object> map = new HashMap<>(4,1f);
        if (StringTool.isBlank(playerTransferVo.getSearch().getTransactionNo())) {
            map.put("state", false);
            return map;
        }
        try {
            playerTransferVo.setResult(ServiceTool.playerTransferService().queryTransfer(playerTransferVo));
            playerTransferVo = ServiceTool.playerTransferService().checkTransferByPlayerTransfer(playerTransferVo);
            String transferType = playerTransferVo.getResult().getTransferType();
            if (FundTypeEnum.TRANSFER_INTO.getCode().equals(transferType)) {
                map.put("transferOut", playerTransferVo.getResult().getApiId());
            } else if (FundTypeEnum.TRANSFER_OUT.getCode().equals(transferType)) {
                map.put("transferOut", TRANSFER_WALLET);
            }
        } catch (Exception e) {
            LOG.error(e);
        }

        map.put("state", playerTransferVo.isSuccess());
        map.put("resultStatus", playerTransferVo.getResultStatus());
        map.put("orderId", playerTransferVo.getSearch().getTransactionNo());
        map.put("resultCode", playerTransferVo.getResultCode());
        return map;
    }


    /**
     * 刷新
     *
     * @param model
     * @param listVo
     * @return
     */
    @RequestMapping("/refresh")
    public String refresh(Model model, PlayerApiListVo listVo, String isRefresh) {
        if (StringTool.isBlank(isRefresh)) {
            //同步玩家api余额
            fetchPlayerAllApiBalance(listVo);
        }
        //查询玩家api记录
        searchAssets(model, listVo);
        return getViewBasePath() + "/transfers.include/Assets";
    }

    public void fetchPlayerAllApiBalance(PlayerApiListVo listVo) {
        IApiBalanceService apiBalanceService = (IApiBalanceService) SpringTool.getBean("apiBalanceService");
        if (listVo.getSearch().getApiId() != null) {
            apiBalanceService.fetchPlayerApiBalance(listVo);
        } else {
            apiBalanceService.fetchPlayerAllApiBalance();
        }
    }

    @RequestMapping("refreshApi")
    @ResponseBody
    public String refreshApi(PlayerApiListVo listVo, String isRefresh) {
        Map<String, String> map = new HashMap<>(4,1f);
        if (StringTool.isBlank(isRefresh)) {
            //同步玩家api余额
            fetchPlayerAllApiBalance(listVo);
        } else {
            UserPlayerVo userPlayerVo = new UserPlayerVo();
            userPlayerVo.getSearch().setId(SessionManager.getUserId());
            userPlayerVo = ServiceTool.userPlayerService().get(userPlayerVo);
            map.put("wallet", CurrencyTool.formatCurrency(userPlayerVo.getResult().getWalletBalance()));
        }
        PlayerApiVo playerApiVo = new PlayerApiVo();
        playerApiVo.getSearch().setPlayerId(SessionManager.getUserId());
        IPlayerApiService playerApiService = ServiceTool.playerApiService();
        Integer apiId = listVo.getSearch().getApiId();
        playerApiVo.getSearch().setApiId(apiId);
        playerApiVo = playerApiService.search(playerApiVo);
        PlayerApi playerApi = playerApiVo.getResult();
        map.put("totalAssets", CurrencyTool.formatCurrency(queryPlayerAssets()));
        if (playerApi != null) {
            map.put("apiMoney", CurrencyTool.formatCurrency(playerApi.getMoney()));
            map.put("apiSynTime", LocaleDateTool.formatDate(playerApi.getSynchronizationTime(),
                    CommonContext.getDateFormat().getDAY_SECOND(), SessionManager.getTimeZone()));
        }
        return JsonTool.toJson(map);
    }

    /**
     * 查询玩家总资产
     *
     * @return
     */
    private double queryPlayerAssets() {
        PlayerApiListVo playerApiListVo = new PlayerApiListVo();
        playerApiListVo.getSearch().setPlayerId(SessionManager.getUserId());
        playerApiListVo.setApis(Cache.getApi());
        playerApiListVo.setSiteApis(Cache.getSiteApi());
        return ServiceTool.playerApiService().queryPlayerAssets(playerApiListVo);
    }
    //endregion your codes 3

}