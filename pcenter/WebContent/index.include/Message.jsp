<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<label class="line-after info-down-btn">
    <span class="new">
        <i class="new-ico select"></i>
        <a href="javascript:void(0)">${views.home['index.newMessage']}</a>
        <c:if test="${unReadCount>0}">
            <i class="ci-count menutwo" style="">
                <a href="javascript:void(0)" id="unReadCount">${unReadCount}</a>
            </i>
        </c:if>
    </span>
</label>
