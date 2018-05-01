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
    <link rel="icon" type="image/png" href="../ftl/${siteDomain.templateCode}/images/favicon.png" sizes="32x32">
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
                <a class="nav-menu-ico aip-type-home-ico" href="/">
                    <span>网站首页</span>
                </a>
            </li>
            <c:set var="game_page" value=""></c:set>
            <c:forEach var="at" items="${apiTypeI18ns}" varStatus="vs">
                <c:choose>
                    <c:when test="${at.apiTypeId == 1}">
                        <c:set var="game_page" value="/live.html"></c:set>
                    </c:when>
                    <c:when test="${at.apiTypeId == 2}">
                        <c:set var="game_page" value="/casino.html"></c:set>
                    </c:when>
                    <c:when test="${at.apiTypeId == 3}">
                        <c:set var="game_page" value="/sports.html"></c:set>
                    </c:when>
                    <c:when test="${at.apiTypeId == 5}">
                        <c:set var="game_page" value="/commonPage/gamePage/loading.html?apiId=34&apiTypeId=5"></c:set>
                    </c:when>
                    <c:otherwise>
                        <c:set var="game_page" value="/lottery.html"></c:set>
                    </c:otherwise>
                </c:choose>
                <li>
                    <a class="nav-menu-ico aip-type-${at.apiTypeId}-ico" href="${game_page}">
                        <span>${at.name}</span>
                    </a>
                </li>
            </c:forEach>
            <li>
                <a class="nav-menu-ico aip-type-promo-ico" href="/promo.html">
                    <span>优惠活动</span>
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
<%@include file="IndexContent.jsp"%>
<!-- 客服界面开始 -->
<div style="text-align: center;">
    <button type="button" class="customer-affix customer-button" onclick="window.top.topPage.showCustomerWin(null,true)" ><i class="ivu-icon ivu-icon-chatbubbles" style="font-size: 20px;"></i><span class="customer-button-text">联系客服</span></button>
</div>
<!-- 客服界面结束 -->
</body>

</html>

