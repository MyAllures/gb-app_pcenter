<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/include/include.inc.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <title>${views.home['index.title']} - ${views.home['index.name']} - ${siteName}
    </title>
    <%
        System.out.printf(MessageFormat.format(BaseConfigManager.getConfigration().getResComRoot(),request.getServerName()));
    %>
    <%@ include file="/include/include.head.jsp" %>
    <link rel="icon" type="image/png" href="../ftl/${siteDomain.templateCode}/zh_TW/images/favicon.png" sizes="32x32">
    <script type="text/javascript" src="${root}/message_<%=SessionManagerCommon.getLocale().toString()%>.js?v=${rcVersion}"></script>
    <script type="text/javascript">
        var language = '${language.replace('_','-')}';
    </script>
    <%@ include file="/include/include.js.jsp" %>
    <!-- 提示弹出框 -->
    <script type="text/javascript">
        var environment = {
            userCash: ''
        };
    </script>
    <script type="text/javascript">
        curl(['site/common/TopPage', 'site/home/TopNav', 'site/home/LeftNav',
            'site/index/Comet', "site/index/Index","backgroundBlur",
            'jqmetisMenu', 'jqnouislider'], function (TopPage, TopNav, LeftNav, Comet, Index,BackgroundBlur) {
            topPage = new TopPage();
            topNav = new TopNav();
            leftNav = new LeftNav();
            //msgManager = new MsgManager();
            //shortcutMenu = new ShortcutMenu()
            comet = new Comet();
            index = new Index();
            backgroundBlur = new BackgroundBlur();

        });
    </script>
    <%-- <script id="topMenuTmpl" type="text/x-jsrender">
         {{for m}}
             <li id="menuItem{{:object.id}}"　class="dropdown">
                 <a aria-expanded="false" role="button" nav-top='page-content' {{if object.resourceUrl == ''}} href='/index/content.html?parentId={{:object.id}}' {{else}} href='{{: object.resourceUrl}}' {{/if}} ><div class="icon"><i class="icon iconfont">{{:object.resourceIcon}}</i></div><span>{{:object.resourceName}}</span></a>
             </li>
         {{/for}}
     </script>--%>
</head>
<body>
<%
    if(request.getHeader("User-Agent")==null || !request.getHeader("User-Agent").contains("HTBrowser")){
%>
<div class="hint-box" style="display: none" >
    <span class="hint-content">
        <i class="fa fa-exclamation-circle">${views.common['WarmPrompt']}</i>
        <soul:button target="hideBrowserTip" cssClass="close" text=" × " title="${views.common['close']}" opType="function" />
    </span>
</div>
<%}%>
<!--头部-->
<div class="top-wrap">
    <div class="top-top">
        <!--顶部右边-->
        <div class="top-right">
            <div class="member">
                <div id="site-nav">
                    <%@include file="index.include/loadPlayerInfo.jsp"%>
                </div>
                <a href="${root}/passport/logout.html" target="_top" class="logout">[${views.home['index.exit']}]</a>
                <label id="playerUnread">
                    <%@include file="index.include/Message.jsp"%>
                </label>
            </div>
        </div>
        <!--顶部左边-->
        <div class="top-left">
            <div class="select-lang" id="divLanguage">
                <p></p>
                <ul style="display: none;">
                </ul>
            </div>
            <label class="time line-after">
                <span id="userTime"><%= SessionManager.getTimeZone().getID() %></span>
                <span id="index-clock" class="nav-shadow clock-show"> </span>
            </label>

        </div>
    </div>
</div>
<!--banner-->
<div class="banner" <c:if test="${isLotterySite}">style="background-image: url(../ftl/${siteDomain.templateCode}/images/bannerbg.jpg);"</c:if> >
    <a href="/">
        <div class="logo" style="background-image:url(${soulFn:getThumbPath(domain, logo,220,90)});width:220px;height: 90px;"></div>
    </a>
    <div class="right">
        <c:if test="${isLottery.paramValue=='false'}">
        <ul class="nav-menu">
            <li>
                <a href="/">
                    <i class="nav-menu-ico home-ico"></i>
                    <span>
    	  	  	   	  	网站首页
    	  	  	   	  	<font>HOME</font>
    	  	  	   	  </span>
                </a>
            </li>
            <c:forEach var="at" items="${apiTypeI18ns}" varStatus="vs">
                <li>
                    <a href="#">
                        <i class="nav-menu-ico casino-ico"></i>
                        <span>
    	  	  	   	  	${at.name}
    	  	  	   	  	<font>CASINO</font>
    	  	  	   	  </span>
                    </a>
                </li>
            </c:forEach>
            <li>
                <a href="#">
                    <i class="nav-menu-ico promo-ico"></i>
                    <span>
    	  	  	   	  	优惠活动
    	  	  	   	  	<font>PROMO</font>
    	  	  	   	  </span>
                </a>
            </li>
        </ul>
        </c:if>
    </div>
    <c:if test="${!isLotterySite}">
        <div class="banner-bg-t"></div>
        <div class="banner-bg">
            <img src="../ftl/${siteDomain.templateCode}/images/bannerbg.jpg">
        </div>
    </c:if>

    <%--<div class="right"></div>--%>
</div>

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
<!-- 右边客服服务-->
<%-- 新需求要求删除这块
<div id="moquu_wmaps"><a>${views.home['index.playGame']}</a></div>
--%>


<div class="real-time-inform">
    <div class="clearfix"><span class="unfold">
        <i class="fa fa-angle-double-up m-r-xs pull-left"></i>
        <a href="javascript:;" class="unfold-z"></a>
        <a href="javascript:;" class="unfold-s"></a></span>
    </div>
    <div class="max-ccc">
    </div>
</div>

</body>

</html>

