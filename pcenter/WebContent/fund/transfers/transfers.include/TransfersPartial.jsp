<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<%--@elvariable id="apiList" type="java.util.List<so.wwb.gamebox.model.company.setting.po.Api>"--%>
<c:set var="siteApis" value="<%=Cache.getSiteApi() %>"/>
<div id="validateRule" style="display: none">${validateRule}</div>
<div class="control-group">
    <label class="control-label">${views.fund['Transfer.transfer.transferOut']}</label>
    <div class="controls ">
        <select class="selectwidth m-bigr" name="transferOut">
            <option value="wallet">${views.fund['Transfer.transfer.myWallet']}</option>
            <c:forEach items="${apiList}" var="i">
                <c:choose>
                    <c:when test="${i.systemStatus eq 'maintain'||siteApis[i.id.toString()].systemStatus eq 'maintain'}">
                        <option disabled name="maintain" style="background: #E8ECEF">${gbFn:getApiName(i.id.toString())}${views.fund['fund.transfer.api.maintain']}</option>
                    </c:when>
                    <c:when test="${i.transferable==false}">
                        <option disabled style="background: #E8ECEF">${gbFn:getApiName(i.id.toString())}${views.fund['transfer.api.maintain.transferable']}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${i.id}">${gbFn:getApiName(i.id.toString())}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>
    </div>
</div>
<div class="control-group">
    <label class="control-label">${views.fund['Transfer.transfer.transferInto']}</label>
    <div class="controls">
        <select class="selectwidth m-bigr" name="transferInto">
            <c:forEach items="${apiList}" var="i">
                <c:choose>
                    <c:when test="${i.systemStatus eq 'maintain'||siteApis[i.id.toString()].systemStatus eq 'maintain'}">
                        <option disabled name="maintain">${gbFn:getApiName(i.id.toString())}${views.fund['fund.transfer.api.maintain']}</option>
                    </c:when>
                    <c:when test="${i.transferable==false}">
                        <option disabled style="background: #E8ECEF">${gbFn:getApiName(i.id.toString())}${views.fund['transfer.api.maintain.transferable']}</option>
                    </c:when>
                    <c:otherwise>
                        <option value="${i.id}">${gbFn:getApiName(i.id.toString())}</option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            <option value="wallet">${views.fund['Transfer.transfer.myWallet']}</option>
        </select>
    </div>
</div>
<div class="s-d-exchange">
    <span class="b-tr"></span>
    <span class="btn-exchange change"></span>
    <span class="b-rb"></span>
</div>
<div class="control-group">
    <label class="control-label" for="result.transferAmount">${views.fund['Transfer.transfer.transferAmount']}</label>
    <div class="controls">
        <input type="text" name="result.transferAmount" id="result.transferAmount" class="input input-money" placeholder="${views.fund['Transfer.transfer.tips']}"/>
    </div>
</div>
<div>
    <gb:token/>
    <soul:button precall="validateForm" target="transfers" text="${views.fund['Transfer.transfer.confirmTransfer']}" opType="function" tag="button" cssClass="btn-blue btn large-big lar-l">${views.fund['Transfer.transfer.confirmTransfer']}</soul:button>
</div>