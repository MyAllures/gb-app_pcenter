<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--VR真人投注详细--%>
<c:set var="p" value="${command.result}"/>
<c:set var="resultVo" value="${p.resultVo}"/>
<table class="table table-bordered">
    <c:forEach items="${resultArray}" var="array">
        <tr>
            <td class="bg-gray al-right" width="30%">
                    ${views.gameOrder_auto['彩种']}
            </td>
            <td class="al-left">
                    ${array['channelName']}
            </td>
        </tr>
        <tr>
            <td class="bg-gray al-right" width="30%">
                    ${views.gameOrder_auto['期号']}
            </td>
            <td class="al-left">
                    ${array['issueNumber']}
            </td>
        </tr>
        <tr>
            <td class="bg-gray al-right" width="30%">
                    ${views.gameOrder_auto['赔率']}
            </td>
            <td class="al-left">
                    ${array['odds']}
            </td>
        </tr>
        <tr>
            <td class="bg-gray al-right" width="30%">
                    ${views.gameOrder_auto['下注内容']}
            </td>
            <td class="al-left">
                    ${array['betTypeName']}&nbsp;&nbsp;&nbsp;[<span class="co-blue">${array['number']}</span>]
            </td>
        </tr>
        <tr>
            <td class="bg-gray al-right" width="30%">
                    ${views.gameOrder_auto['开奖号码']}
            </td>
            <td class="al-left">
                <span class="co-red">${array['winningNumber']}</span>
            </td>
        </tr>
    </c:forEach>
</table>