<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>

<div id="page-content" class="wrapper" style="min-height: 800px;">
    <!--left-->
    <div class="sidebar">
        <!--左边菜单栏-->
        <div class="sidebar-nav _nav_title">
            <c:forEach items="${command}" var="obj" varStatus="status">
                <c:if test="${empty obj.object.resourceUrl}">
                    <div class="left-nav-title">${views.sysResource[obj.object.resourceRName]}</div>
                    <c:if test="${obj.children.size()>0}">
                        <c:forEach items="${obj.children}" var="child" varStatus="vs">
                            <c:if test="${isLottery.paramValue=='false' || (isLottery.paramValue=='true' && child.object.resourceUrl!='fund/playerTransfer/transfers.html')}">
                                <dl>
                                    <dt class="${status.index==0 && vs.index == 0?'select':''}">
                                        <a <c:if test="${child.children.size()>0}">href="javascript:void(0);"</c:if>
                                                <c:if test="${child.children.size()==0}"> nav-target='mainFrame'
                                                    data="/${child.object.resourceUrl}?t=${random}"  href="javascript:void(0);"</c:if>>
                                            <i class="navico ${child.object.resourceIcon}"></i>
                                                ${views.sysResource[child.object.resourceRName]}
                                        </a>
                                    </dt>
                                </dl>
                            </c:if>
                        </c:forEach>
                    </c:if>
                </c:if>
            </c:forEach>

            <%--<c:forEach items="${command}" var="obj" varStatus="status">
                <c:if test="${isLottery.paramValue=='true'}">
                    <c:if test="${obj.object.resourceUrl!='fund/playerTransfer/transfers.html'}">
                        <dl>
                            <dt class="${status.index==0?'select':''}">
                                <a <c:if test="${obj.children.size()>0}">href="javascript:void(0);"</c:if>

                                        <c:if test="${obj.children.size()==0}"> nav-target='mainFrame'  data="/${obj.object.resourceUrl}?t=${random}"  href="javascript:void(0);"</c:if>>
                                    <i class="navico ${obj.object.resourceIcon}"></i>${views.sysResource[obj.object.resourceRName]}
                                </a>
                            </dt>
                        </dl>
                    </c:if>
                </c:if>
                <c:if test="${isLottery.paramValue!='true'}">
                    <dl>
                        <dt class="${status.index==0?'select':''}">
                            <a <c:if test="${obj.children.size()>0}">href="javascript:void(0);"</c:if>

                                    <c:if test="${obj.children.size()==0}"> nav-target='mainFrame'  data="/${obj.object.resourceUrl}?t=${random}"  href="javascript:void(0);"</c:if>>
                                <i class="navico ${obj.object.resourceIcon}"></i>${views.sysResource[obj.object.resourceRName]}
                            </a>
                        </dt>
                    </dl>
                </c:if>

            </c:forEach>--%>
        </div>
    </div>
    <!--right-->
    <div id="mainFrame" class="main-wrap">

    </div>
</div>
<div class="preloader"></div>

<div class="real-time-inform">
    <div class="clearfix"><span class="unfold">
        <i class="fa fa-angle-double-up m-r-xs pull-left"></i>
        <a href="javascript:;" class="unfold-z"></a>
        <a href="javascript:;" class="unfold-s"></a></span>
    </div>
    <div class="max-ccc">
    </div>
</div>


