<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!-- 银行维护公告 -->
<c:if test="${fn:length(bankNotices.result)>0}">
    <div class="gamenotice">
        <div class="gamenotice-title">
            <h1>${views.fund_auto['银行维护公告']}</h1>
        </div>
        <div class="gamenotice-box">
            <dl class="bank-notice-l">
                <c:forEach items="${bankNotices.result}" var="cttAnnouncement">
                    <dd class="clearfix">
                        <div class="item">
                            <p>
                                ★&nbsp;${cttAnnouncement.content}
                            </p>
                        </div>
                    </dd>
                    <p class="dottline"></p>
                </c:forEach>
            </dl>
        </div>
    </div>
</c:if>
