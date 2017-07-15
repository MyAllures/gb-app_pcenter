package so.wwb.gamebox.pcenter.personInfo.controller;

import org.soul.model.sys.po.SysAuditLog;
import org.soul.model.sys.vo.SysAuditLogListVo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import so.wwb.gamebox.pcenter.session.SessionManager;
import so.wwb.gamebox.pcenter.tools.ServiceTool;

import java.util.List;

/**
 * Created by eagle on 15-10-28.
 * 玩家中心-个人资料-登录日志
 */
@Controller
//region your codes 1
@RequestMapping("personInfo/loginLog")
public class LoginLogController {

    //endregion your codes 1

    //region your codes 3
    private static final String PERSON_INFO_LOGIN_LOG = "personInfo/LoginLog";

    /**
     * 登录日志列表
     *
     * @param model
     * @return
     */
    @RequestMapping("/list")
    public String loginLog(Model model) {
        SysAuditLogListVo sysAuditLogListVo= new SysAuditLogListVo();
        sysAuditLogListVo.getSearch().setOperatorId(SessionManager.getUserId());
        List<SysAuditLog> sysAuditLogs = ServiceTool.customSysAuditLogService().searchPlayerLoginLog(sysAuditLogListVo);
        model.addAttribute("sysAuditLogs",sysAuditLogs);
        return  PERSON_INFO_LOGIN_LOG;
    }
    //endregion your codes 3
}

