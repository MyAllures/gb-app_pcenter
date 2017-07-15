<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<!--//region your codes １-->
<form:form>
    <div class="notice"><div class="notice-left"><em class="path"></em></div>
        <div class="path-right"><a class="cursor">${views.sysResource['个人资料']}</a></div>
    </div>
    <!--头像上传-->
    <div class="accout-infomation">
            <div class="edit-faceleft">
                <h2>${views.account['AccountSetting.personal.pic']}：</h2>
                <div class="edit-facetext">
                    <p class="edit-bg">
                        <img class="picturePreview2" style="display: none"/>
                        <img class="picturePreview" src="${soulFn:getImagePathWithDefault(domain, url, resRoot.concat('/images/default_portrait.png'))}" width="85" height="85">
                    </p>
                    <input class="file file-po" type="file" target="result.avatarUrl" accept="image/*">
                    <input type="hidden" name="result.avatarUrl" value="${url}">
                    <div class="file-po-b">${views.account['AccountSetting.personal.updatePic']}</div>
                </div>
                <p class="edit-facetext gray">${views.account['AccountSetting.personal.message1']}</p>
            </div>
            <div class="edit-faceright">
                <span class="edit-bg">
                    <img id="bbb" class="picturePreview" src="${soulFn:getImagePathWithDefault(domain, url, resRoot.concat('/images/default_portrait.png'))}" width="60" height="60">
                </span>
                <span class="edit-align  m-b">60*60</span>
                <span class="edit-bg"> <img class="picturePreview" src="${soulFn:getImagePathWithDefault(domain, url, resRoot.concat('/images/default_portrait.png'))}" width="85" height="85"></span>
                <span class="edit-align">85*85</span>
            </div>
            <div class="clear"></div>
        <div class="control-group">
            <soul:button cssClass="btn-blue btn large-big" text="${views.common.OK}" opType="ajax" precall="uploadFile" target="${root}/personalInfo/uploadHeadPortrait.html" dataType="json" post="getCurrentFormData">${views.account['AccountSetting.personal.save']}</soul:button>
        </div>
    </div>
</form:form>
<soul:import res="site/accountManagement/AccountLogoEdit"/>
<!--//endregion your codes １-->
