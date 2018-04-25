<%--@elvariable id="command" type="so.wwb.gamebox.model.boss.taskschedule.vo.TaskScheduleVo"--%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--//region your codes 1-->

<!--//endregion your codes 1-->

<html lang="zh-CN">
<head>
    <title>在线客服</title>
    <%@ include file="/include/include.head.jsp" %>

</head>
<body>
<div class="connection-state" id="connection-state-el"></div>
<div class="ivu-modal-body">
    <div class="message-content ivu-scroll-wrapper" style="touch-action: none; text-align: center;">
        <div class="ivu-scroll-container" style="height: 300px;">
            <div class="ivu-scroll-content">
            </div>
        </div>
    </div>
</div>
<div class="ivu-modal-footer">
    <div>
        <form autocomplete="off" class="ivu-form ivu-form-label-left">
            <div class="ivu-row">
                <div class="ivu-col ivu-col-span-20">
                    <div class="ivu-form-item ivu-form-item-required"><label class="ivu-form-item-label"
                                                                             style="width: 75px;">发送消息:</label>
                        <div class="ivu-form-item-content" style="margin-left: 75px;">
                            <div class="ivu-input-wrapper ivu-input-type"><textarea autocomplete="off"
                                                                                    spellcheck="false"
                                                                                    placeholder="输入内容..." rows="2"
                                                                                    class="ivu-input"
                                                                                    style="height: 115px; min-height: 115px; max-height: 325px;" id="messageTextArea"></textarea>
                            </div> <!----></div>
                    </div> <!----></div>
                <div class="ivu-col ivu-col-span-4">
                    <button type="button" class="ivu-btn ivu-btn-primary ivu-btn-large" id="submitMessageBtn"><span>发送</span>
                    </button>
                </div>
            </div>
        </form>
    </div>
</div>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/customer/customer"/>
</html>