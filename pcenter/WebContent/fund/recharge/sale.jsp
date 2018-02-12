<%--@elvariable id="sales" type="java.util.List<so.wwb.gamebox.model.master.operation.po.VActivityMessage>"--%>
<%--@elvariable id="playerRechargeVo" type="so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<div id="applysale" class="applysale">
<c:if test="${fn:length(sales)>0}">
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
        <tr>
            <td width="72" class="al-right" style="width: 202px">${views.fund_auto['申请优惠']}：</td>
            <td width="500">
                <span class="radiotwo">
                    <input name="activityId" type="radio" value="" checked>
                </span>
                    ${views.fund_auto['不参与优惠']}&nbsp;&nbsp;
                <c:if test="${fn:length(sales)>2}">
                    <soul:button target="expendSale" text="" opType="function">
                        ${views.fund_auto['展示其他优惠']}<i class="bank-arrico down"></i>
                    </soul:button>
                </c:if>
            </td>
        </tr>
        <c:forEach items="${sales}" varStatus="vs" var="i">
            <c:if test="${fn:length(sales)>2&&vs.index==2}">
                <div name="expendSales" style="display: none;">
            </c:if>
            <tr style="${vs.index>=2?'display: none':''}" class="${vs.index>=2?'expendSales':''}">
                <td>&nbsp;</td>
                <td>
                    <span class="radiotwo">
                        <input name="activityId" type="radio" value="${i.id}"/>
                    </span>
                    <i class="item-title-ico ${i.code=='first_deposit'?'goryorange':'gorylightblue'}">
                       ${i.classifyKeyName}
                    </i>
                    <a href="/promo.html#cos_${i.id}" style="color: #999;" target="_blank">${i.activityName}&nbsp;&nbsp;</a>
                </td>
            </tr>
            <c:if test="${fn:length(sales)>2&&vs.index==fn:length(sales)-1}">
                </div>
            </c:if>
        </c:forEach>
        </tbody>
    </table>
</c:if>
</div>
<script id="rechargeSale" type="text/x-jsrender">
{{if len>0}}
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tbody>
        <tr>
            <td width="72" class="al-right" style="width: 202px">${views.fund_auto['申请优惠']}：</td>
            <td width="500">
                <span class="radiotwo">
                    <input name="activityId" type="radio" value="" checked>
                </span>
                ${views.fund_auto['不参与优惠']}&nbsp;&nbsp;
                {{if len>2}}
                    <soul:button target="expendSale" text="" opType="function">
                        ${views.fund_auto['展示其他优惠']}<i class="bank-arrico down"></i>
                    </soul:button>
                {{/if}}
            </td>
        </tr>
        {{for sales}}
            <tr {{if #index>=2}}style="display: none" class="expendSales"{{/if}}>
                <td>&nbsp;</td>
                <td>
                    <span class="radiotwo">
                        <input name="activityId" {{if #data.preferential!=true}}disabled{{/if}} type="radio" value="{{:#data.id}}"/>
                    </span>
                    <i class="item-title-ico {{if #data.code=='first_deposit'}}goryorange{{else}}gorylightblue{{/if}}">
                        {{:#data.classifyKeyName}}
                    </i>
                    <a href="/promo.html#cos_{{:#data.id}}" style="color: #999;" target="_blank"> {{:#data.activityName}}&nbsp;&nbsp;</a>
                </td>
            </tr>

        {{/for}}
        </tbody>
    </table>
{{/if}}
</script>