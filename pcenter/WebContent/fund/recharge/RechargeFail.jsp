<%--@elvariable id="bankNotices" type="java.util.List<so.wwb.gamebox.model.master.content.po.CttAnnouncement>"--%>
<%--@elvariable id="map" type="java.util.Map<java.lang.string,java.lang.Long>"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<form name="rechargeForm">
    <div class="notice">
        <div class="notice-left"><em class="path"></em>
        </div>
        <div class="path-right">
            <a href="javascript:;">${views.sysResource['存款专区']}</a>
        </div>
    </div>
    <div class="withdraw-not">
        <h1><i class="tipbig fail"></i></h1>
        <div class="tiptext">
            <p>参数错误，存款失败</p>
        </div>
    </div>
</form>