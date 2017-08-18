<%--@elvariable id="gameTypes" type="java.util.Map<java.lang.Integer, java.util.Map<java.lang.String,java.lang.Integer>>"--%>
<%--@elvariable id="apiTypes" type="java.util.Map<java.lang.Integer,java.util.String>"--%>
<%@page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body class="body-b-none">
<c:set var="apiTypeI18n" value="<%=Cache.getSiteApiTypeI18n()%>"/>
<!--选择字段-->
<form:form method="post">
    <div class="modal-body">
        <div class="m-sm">
            <soul:button target="checkAll" text="${views.common_report['全选']}" opType="function" tag="button" cssClass="btn btn-filter btn-xs"/>
            <soul:button target="clearAll" text="${views.gameOrder_auto['清空']}" opType="function" tag="button" cssClass="btn btn-outline btn-filter btn-xs m-l-xs m-r"/>
            <c:forEach items="${gameTypes}" var="i">
                <soul:button target="choseApi" text="${gbFn:getApiName(i.key.toString())}" cssClass="btn btn-outline btn-filter btn-xs" opType="function" data="${i.key}"/>
            </c:forEach>
            <span class="dividing-line m-r-xs m-l-xs">|</span>
            <c:forEach items="${apiTypes}" var="i">
                <soul:button target="choseGameType" cssClass="btn btn-outline btn-filter btn-xs" text="${i.value}" opType="function" data="${i.key}"/>
            </c:forEach>
        </div>
        <div class="table-responsive">
            <table id="game" class="table table-bordered m-b-xxs" style="border:0; border-top: 1px solid #d3d3d3; width: 100%;" border="0" cellpadding="0" cellspacing="0">
                <tbody>
                    <c:forEach items="${gameTypes}" var="i" varStatus="vs">
                        <tr id="api${i.key}">
                            <td class="bg-gray al-left">
                                <label>
                                    <input type="checkbox" name="api" class="i-checks" api="${i.key}" value="${i.key}">
                                    <span class="m-l-xs">
                                        <b>${gbFn:getApiName(i.key.toString())}</b>
                                    </span>
                                </label>
                            </td>
                            <td class="al-left">
                                <c:forEach items="${i.value}" var="j">
                                    <c:set var="gameType" value="${j.key}"/>
                                    <label class="fwn m-r-sm">
                                        <input type="checkbox" name="gameType" class="i-checks" api="${i.key}" apiname="${gbFn:getApiName(i.key.toString())}" data="${j.value}" typename="${gbFn:getGameTypeName(gameType)}" value="${gameType}"/>
                                        <span class="m-l-xs">${gbFn:getGameTypeName(gameType)}</span>
                                    </label>
                                </c:forEach>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <div class="modal-footer">
        <soul:button cssClass="btn btn-filter" text="${views.common['ok']}" opType="function" target="choose" tag="button"/>
        <soul:button target="closePage" text="${views.common['cancel']}" cssClass="btn btn-gray" opType="function" tag="button"/>
    </div>
</form:form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="site/gameOrder/Game"/>
</html>