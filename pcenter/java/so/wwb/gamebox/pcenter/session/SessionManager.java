package so.wwb.gamebox.pcenter.session;

import org.soul.model.security.privilege.po.SysUser;
import so.wwb.gamebox.web.SessionManagerCommon;

import java.util.Date;
import java.util.List;

/**
 * Created by tony on 15-4-29.
 */
public class SessionManager extends SessionManagerCommon {

    public static final String SESSION_MASTER_INFO = "SESSION_MASTER_INFO";
    //玩家中心-填写真实姓名的值,以确认真实姓名是否一致
    private static final String S_REAL_NAME = "S_REAL_NAME";

    //玩家中心-消息-追问提交时间
    private static final String S_ADVISORY_MESSAGE_TIME = "S_ADVISORY_MESSAGE_TIME";

    //玩家中心-转账-转账提交时间
    private static final String S_TRANSFER_TIME = "S_TRANSFER_TIME";
    //玩家中心－存款－可用渠道


    public static void setMasterInfo(SysUser user) {
        setAttribute(SESSION_MASTER_INFO, user);
    }

    public static SysUser getMasterInfo() {
        return (SysUser) getAttribute(SESSION_MASTER_INFO);
    }

    // begin 待删除
    private static final String SESSION_EMAIL_CODE = "SESSION_EMAIL_CODE";

    public static void setEmailCode(List emailParam) {
        setAttribute(SESSION_EMAIL_CODE, emailParam);
    }

    public static List getEmailCode() {
        return (List) getAttribute(SESSION_EMAIL_CODE);
    }

    /**
     * 移出玩家中心获取邮箱验证码
     * <p/>
     * add by eagel on 20160121
     */
    public static void removeSessionEmailCodeKey() {
        removeAttribute(SESSION_EMAIL_CODE);
    }
    // end 待删除

    //玩家中心个人资料手机和邮箱验证码
    private static final String SESSION_VERIFICATIONCODE_ = "SESSION_VERIFICATIONCODE_";

    public static void setEmailOrPhoneCode(List emailOrPhoneParam,String type) {
        setAttribute(SESSION_VERIFICATIONCODE_+type, emailOrPhoneParam);
    }

    public static List getEmailOrPhoneCode(String type) {
        return (List)getAttribute(SESSION_VERIFICATIONCODE_+type);
    }

    public static void removeEmailOrPhoneSession(String type) {
        removeAttribute(SESSION_VERIFICATIONCODE_+type);
    }

    private static final String SESSION_LAST_SEND_TIME_ = "SESSION_LAST_SEND_TIME_";
    public static void setLastSendTime(Date lastTime,String type) {
        setAttribute(SESSION_LAST_SEND_TIME_+type,lastTime);
    }
    public static Date getLastSendTime(String type) {
        return (Date)getAttribute(SESSION_LAST_SEND_TIME_+type);
    }

    /**
     * 填写真实姓名，以便第二步确认真实姓名
     *
     * @param realName
     */
    public static void setRealName(String realName) {
        setAttribute(S_REAL_NAME, realName);
    }

    public static String getRealName() {
        return (String) getAttribute(S_REAL_NAME);
    }

    private static final String SESSION_TOKEN = "SESSION_TOKEN_";

    /**
     * 玩家中心-消息-追问提交时间
     *
     * @param date
     */
    public static void setAdvisoryMessageTime(Date date) {
        setAttribute(S_ADVISORY_MESSAGE_TIME, date);
    }

    public static Date getAdvisoryMessageTime() {
        return (Date) getAttribute(S_ADVISORY_MESSAGE_TIME);
    }

    /**
     * 玩家中心-转账-转账提交时间
     *
     * @param date
     */
    public static void setTransferTime(Date date) {
        setAttribute(S_TRANSFER_TIME, date);
    }

    public static Date getTransferTime() {
        return (Date) getAttribute(S_TRANSFER_TIME);
    }
}
