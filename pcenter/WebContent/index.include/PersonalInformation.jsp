
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="sidebar-item">
  <h2><span class="_hours"></span>
      <c:if test="${sysUserVo.result.nickname !='' && sysUserVo.result.nickname !=null}"><span class="orange name">${sysUserVo.result.nickname}</span></c:if></h2>

  <div class="safe">
    <ul>
      <li>
        <a href="javascript:;" class="ToolTips ToolTipCol shows1" data-html="true"
           data-text="
           <c:if test="${sysUserVo.result.realName==null}">${views.home['index.account.message0']}<br>【<a href='javascript:personalInfomation.editRealName()' class='realName'>${views.home['index.account.setUp']}</a>】</c:if>
           <c:if test="${sysUserVo.result.realName!=null}">${views.home['index.account.message1']}<br>【<a href='javascript:personalInfomation.viewRealName()' class='realName'>${views.home['index.account.see']}</a>】</c:if>
           ">
        <span class="safeico realname<c:if test="${sysUserVo.result.realName!=null}">-select</c:if>" sname></span></a>
      </li>
      <li><a href="javascript:;" class="ToolTips ToolTipCol shows2" data-html="true"
             data-text="
             <c:if test="${userBankcardVo.result==null}">${views.home['index.account.message2']}<br>【<a href='javascript:personalInfomation.bankInfo()' class='bankInfo'>${views.home['index.account.bind']}</a>】</c:if>
             <c:if test="${userBankcardVo.result!=null}">${views.home['index.account.message3']}<br>【<a href='javascript:personalInfomation.bankInfo()' class='bankInfo'>${views.home['index.account.change']}</a>】</c:if>
            ">
        <span class="safeico banka<c:if test="${userBankcardVo.result!=null}">-select</c:if>"></span></a></li>
      <li><a href="javascript:;" class="ToolTips ToolTipCol shows3" data-html="true"
             data-text="
             <c:if test="${email==null}">${views.home['index.account.message4']}<br>【<a href='javascript:personalInfomation.email()' class='email'>${views.home['index.account.bind']}</a>】</c:if>
             <c:if test="${email!=null}">${views.home['index.account.message5']}${soulFn:overlayEmaill(email.contactValue)}，${views.home['index.account.message6']}<br>【<a href='javascript:personalInfomation.email()' class='email'>${views.home['index.account.change']}</a>】</c:if>
             ">
        <span class="safeico email<c:if test="${email!=null}">-select</c:if>"></span></a></li>
      <li>
          <a href="javascript:;" class="ToolTips ToolTipCol shows4" data-html="true" data-text="
             <%--<c:if test="${cellphone==null}">${views.home['index.account.message7']}<br>【<a href='javascript:personalInfomation.phone()' class='phone'>${views.home['index.account.bind']}</a>】</c:if>
             <c:if test="${cellphone!=null}">${views.home['index.account.message8']}${soulFn:overlayTel(cellphone.contactValue)}，${views.home['index.account.message9']}<br>【<a href='javascript:personalInfomation.phone()' class='phone'>${views.home['index.account.change']}</a>】</c:if>
--%>
             <c:choose>
                 <c:when test="${cellphone!=null && cellphone.status eq '11'}">
                    ${views.home['index.account.message8']}${soulFn:overlayTel(cellphone.contactValue)}，${views.home['index.account.message9']}<br>【<a href='javascript:personalInfomation.phone()' class='phone'>${views.home['index.account.change']}</a>】
                </c:when>
                <c:otherwise>
                    ${views.home['index.account.message7']}<br>【<a href='javascript:personalInfomation.phone()' class='phone'>${views.home['index.account.bind']}</a>】
                </c:otherwise>
             </c:choose>
             ">
        <span class="safeico phone<c:if test="${cellphone!=null && cellphone.status eq '11'}">-select</c:if>"></span></a></li>
    </ul>
  </div>
  <div class="auth-total">
    <div class="auth-rate">
      <div class="progress" style="width:${accountSecurityLevel.score}%"></div>
    </div>
    <div class="auth-level">${views.home['index.account.securityLevel']}：
      <span class="green">${views.common[accountSecurityLevel.grade]}</span>
        <c:if test="${accountSecurityLevel.grade != 'high'}">
            <a class="accountSet" href="javascript:void(0)">&nbsp;[${views.home['index.account.promote']}]</a>
        </c:if>
    </div>
  </div>
</div>
<script>
    curl(['site/home/PersonalInfomation'], function(PersonalInfomation) {
        personalInfomation= new PersonalInfomation();
    });
</script>