<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-5
  Time: 下午4:19
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div class="poptable">

        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tbody>
            <tr>
                <th width="27%">${views.fund['FundRecord.record.transactionNo']}</th>
                <th width="24%">${views.fund['FundRecord.record.createTime']}</th>
                <th width="13%">${views.fund['FundRecord.record.transactionMoney']}</th>
                <th width="13%">${views.fund['FundRecord.record.transferOut']}</th>
                <th width="13%">${views.fund['FundRecord.record.transferIn']}</th>
                <th width="10%">${views.fund['FundRecord.record.transactionStatus']}</th>
            </tr>
            <c:forEach items="${command.result}" var="pt">
                <tr>
                    <td>${pt.transactionNo} </td>
                    <td> ${soulFn:formatDateTz(pt.createTime, DateFormat.DAY_SECOND, timeZone )}&nbsp;</td>
                    <td><span class="orange">${pt.transactionMoney}</span></td>
                    <c:choose>
                        <c:when test="${pt.fundType eq 'transfer_into'}">
                            <td>${gbFn:getSiteApiName(pt._describe['API'].toString())}</td>
                            <td>
                                    ${views.fund['FundRecord.record.playerWallet']}
                            </td>
                            <%--转入--%>
                        </c:when>
                        <c:when test="${pt.fundType eq 'transfer_out'}">
                            <td>
                                    ${views.fund['FundRecord.record.playerWallet']}
                            </td>
                            <td>${gbFn:getSiteApiName(pt._describe['API'].toString())}</td>
                            <%--转出--%>
                        </c:when>
                    </c:choose>
                    <td><span class="green">${dicts.common.status[pt.status]}</span></td>
                </tr>
            </c:forEach>

            </tbody>
        </table>

</div>
<soul:pagination cssClass="row bdtop3"/>

