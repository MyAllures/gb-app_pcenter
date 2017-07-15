<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/include/include.inc.jsp" %>
<%--主题展示--%>
<div class="themes_list">
  <div class="custom_wrap skin-box">
    <div class="theme_type">
      <ul>
        <li class="type"><a name="themeTypeId" tt="1" class="current" href="javascript:void(0)">${views.index_auto['最新']}</a></li>
        <li class="type"><a name="themeTypeId" tt="2" href="javascript:void(0)">${views.index_auto['热门']}</a></li>
        <li class="type"><a name="themeTypeId" tt="3" href="javascript:void(0)">${views.index_auto['酷炫']}</a></li>
        <li class="type"><a href="javascript:void(0)">${views.index_auto['自定义']}</a></li>
        <li class="clearfix trans"><span class="pull-left">${views.index_auto['透明度']}：</span><div id="basic_slider"></div></li>
        <li class="not_use"><a id="notUseTheme" href="javascript:void(0)"><i class="fa fa-times"></i>${views.index_auto['不使用当前主题']}</a></li>
        <li class="pack_up"><a href="javascript:void(0)">${views.index_auto['收起']}</a></li>
      </ul>
    </div>
    <div class="fixed-bar" id="themeDiv">
      <!-- Elastislide Carousel -->
      <ul id="carousel" class="elastislide-list">
      </ul>
    </div>
  </div>
</div>