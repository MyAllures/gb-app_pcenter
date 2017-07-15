<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>
<!--//region your codes １-->
<form:form>
    <div class="notice">
        <div class="notice-left"><em class="path"></em></div>
        <div class="path-right">${views.preferential_auto['优惠记录']}</div>
    </div>
    <div class="rgeechar">
        <div class="btnalign m-r-lg">
            <div class="pull-right">
                <input class="form-control search" type="text" name="search.activityName" placeholder="${views.preferential_auto['活动名称']}">
                <soul:button target="query" opType="function" tag="button" text="${views.common['search']}" cssClass="btn btn-filter"><i class="fa fa-search"></i><span class="hd">&nbsp;${views.common['search']}</span></soul:button>
            </div>
        </div>
    </div>
    <div class="search-list-container">
        <%@include file="IndexPartial.jsp" %>
    </div>
</form:form>
<soul:import type="list"/>
<!--//endregion your codes １-->
