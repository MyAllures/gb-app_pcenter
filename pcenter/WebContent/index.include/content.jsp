<%--@elvariable id="command" type="List<TreeNode<VSysUserResource>>"--%>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!--left-->
<div class="sidebar">

    <!--玩家首页-左侧-个人信息-->
    <%--<%@include file="PersonalInformation.jsp"%>--%>
    <!--左边菜单栏-->
    <div class="sidebar-nav">
        <c:forEach items="${command}" var="obj" varStatus="status">
            <dl>
                <dt>
                    <a <c:if test="${obj.children.size()>0}">href="javascript:void(0);"</c:if>
                       <c:if test="${obj.children.size()==0}"> nav-target='mainFrame'  data="/${obj.object.resourceUrl}"  href="/${obj.object.resourceUrl}?t=${random}"</c:if>>
                        <i class="navico ${obj.object.resourceIcon}"></i>${views.sysResource[obj.object.resourceRName]}
                    </a>
                </dt>
                <c:forEach items="${obj.children}" var="cobj">
                    <dd style="display:none">
                        <a nav-target='mainFrame' data="/${cobj.object.resourceUrl}" href="/${cobj.object.resourceUrl}?t=${random}">
                            <i class="navico arrow"></i>${views.sysResource[cobj.object.resourceRName]}
                        </a>
                    </dd>
                </c:forEach>
            </dl>
        </c:forEach>
    </div>


</div>
<!--right-->
<div id="mainFrame" class="main-wrap">

</div>
<script type="text/javascript" language="JavaScript">
    $('#side-menu').metisMenu();
</script>
