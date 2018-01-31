<%--
  Created by IntelliJ IDEA.
  User: jeff
  Date: 15-11-25
  Time: 上午11:35
--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>

<div class="allactice clearfix">
    <a data-toggle="button" class="ud-condition pull-right">${views.fund_auto['更多条件']} <i class="fa fa-angle-double-down m-r-sm"></i></a>
     <span class="pull-right al-left">
     <span class="ud-condition pull-right">${views.fund_auto['近7天']}</span>
     </span>
</div>
<div class="history sh-condition m-t-xs">
    <input type="hidden" value=' ${command.all}' id="all"/>
    <input type="hidden" value='${command.status4Type}' id="status4Type"/>
    <input type="hidden" value="" name="search.transactionTypes" id="transactionTypes"/>
    <input type="hidden" value="${command.search.transactionType}" name="search.transactionType">
    <input type="hidden" value="${command.search.status}" name="search.status">

    <div class="capital transactionType_type" data-selector="[name='search.transactionType']"><span>${views.fund['FundRecord.record.transactionType']}：</span>
        <soul:button tag="a" target="changeType" cssClass="_" text="" opType="function">
            <span>${views.fund['FundRecord.record.all']}</span>
        </soul:button>
        <c:forEach items="${command.dictCommonTransactionType}" var="transactionType">
            <soul:button target="changeType" cssClass="_${transactionType.key}" tag="a" post="${transactionType.key}" text="" opType="function">
                <span>${dicts.common.transaction_type[transactionType.key]}</span>
            </soul:button>
        </c:forEach>
    </div>
    <div class="capital transactionType_status" data-selector="[name='search.status']"><span>${views.fund['FundRecord.record.transactionStatus']}：</span>
        <soul:button tag="a" target="changeSearchValue" cssClass="_ status_all" text="" opType="function">
           <span> ${views.fund['FundRecord.record.all']}</span>
        </soul:button>
        <c:forEach items="${command.dictCommonStatus}" var="commonStatus">
            <soul:button target="changeSearchValue" cssClass="_${commonStatus.key}" tag="a" post="${commonStatus.key}" text="" opType="function">
                ${dicts.common.status[commonStatus.key]}
            </soul:button>
        </c:forEach>
    </div>
    <div class="btnalign">
        <span class="pull-left">${views.fund['FundRecord.record.timeRange']}：</span>
        <gb:dateRange format="${DateFormat.DAY}" style="width:100px;" inputStyle="width:80px" useToday="true" useRange="true" position="down" lastMonth="false"
                      startDate="${command.search.beginCreateTime}" endDate="${command.search.endCreateTime}" minDate="${command.minDate}" startName="search.beginCreateTime" endName="search.endCreateTime" thisMonth="true"/>
        <div class="pull-right">
            <input type="text" id="input" placeholder="${views.fund['FundRecord.record.transactionNo']}"  class="form-control search" name="search.transactionNo" value="${command.search.transactionNo}">
            <soul:button target="query" text="" tag="button" opType="function" cssClass="btn btn-filter">
                <i class="fa fa-search"></i>
                <span class="hd">&nbsp;</span>
            </soul:button>
        </div>
    </div>
</div>