<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/include/include.inc.jsp" %>

<html>
<head>
    <title></title>
    <%@ include file="/include/include.head.jsp" %>
</head>
<body class="body-b-none">

<form>
    <input id="7f1a3d0c-f15e-4e7a-8836-fc7182298af9" type="hidden" value="${leftTimes}"/>
    <div id="validateRule" style="display: none">${rule}</div>
    <div class="modal-body">
        <table width="100%" style="border: 0px solid #cccccc;">
            <tr>
                <td colspan="2" style="padding: 15px">${views.share['privilege.tip']}</td>
            </tr>
            <tr>
                <td width="100px" class="popalignr" style="padding: 15px">${views.share['privilege.password']}：</td>
                <td id="privilegePWD">
                    <input id="privilegeCode" class="form-control" name="code"
                           style="width: 150px;border:1px solid #ccc" maxlength="6"
                           type="password" placeholder="${views.share['privilege.password.please']}"
                           autocomplete="off" showSuccMsg="false"/>
                </td>
            </tr>
            <tr id="privilegeTipDiv" style="display: none">
                <td style="padding: 15px">
                    ${views.share['privilege.valicode']}：
                </td>
                <td>
                    <div class="col-sm-6 p-x">
                        <div style="float: left;line-height: 33px;">
                            <input class="form-control" type="text" name="valiCode"
                                   placeholder="${views.share['privilege.valicode.please']}"
                                   style="width: 150px;float: left;border:1px solid #ccc">
                            <span class="verify-img"><img class="captcha-code" src="${root}/captcha/privilege.html?t=${random}" reloadable
                                 style="float: left;height: 32px;padding-left: 10px;"></span>

                        </div>
                        <div style="float:left;margin-top: 8px;"><soul:button cssClass="co-gray6 m-l" target="refreshCode"
                                                              opType="function" text="${views.share['privilege.refresh']}"
                                                              style="padding-top: 10px;">
                            <i class="fa fa-refresh"></i></soul:button></div>
                    </div>
                    <br>
                    <div style="float: left;">
                            <span class="help-block m-b-none"><i class="fa fa-times-circle co-red3"></i>
                            ${fn:replace(views.share['privilege.password.prefix'],"{0}","<span class=\"co-red3\">0</span>")}
                        </span>
                    </div>
                    <input type="hidden" name="requiedValiCode" value="">
                </td>
            </tr>

        </table>

    </div>
    <div class="modal-footer">
        <soul:button cssClass="btn btn-filter confirm btn-check-ok" precall="validateForm" target="${root}/privilege/valiPrivilege.html"
                     opType="ajax" post="getCurrentFormData" dataType="json" text="${views.common.ok}" tag="button"
                     callback="showTips"/>
        <soul:button cssClass="btn btn-filter" target="closePage" opType="function" text="${views.common.cancel}"/>

    </div>
    <%--<input id="7f1a3d0c-f15e-4e7a-8836-fc7182298af9" type="hidden" value="${leftTimes}"/>
    <div id="validateRule" style="display: none">${rule}</div>
    <div class="modal-body theme-popcon">
        <div class="poptable">
            <table width="100%" style="border: 0px solid #cccccc;">
                <tr>
                    <td colspan="2">${views.share['privilege.tip']}</td>
                </tr>
                <tr>
                    <td width="100px" class="popalignr">${views.share['privilege.password']}：</td>
                    <td >
                        <input id="privilegeCode" class="form-control" name="code" style="width: 150px;border:1px solid #ccc"
                               type="password" placeholder="${views.share['privilege.password.please']}"/>
                    </td>
                </tr>
                <tr id="privilegeTipDiv" class="hide">
                    <td >
                        ${views.share['privilege.valicode']}：
                    </td>
                    <td>
                        <div class="col-sm-6 p-x">
                            <div style="float: left;">
                                <input class="form-control" type="text" name="valiCode"
                                       placeholder="${views.share['privilege.valicode.please']}" style="width: 150px;float: left;border:1px solid #ccc">
                                <img class="captcha-code" src="${root}/captcha/privilege.html?t=${random}" reloadable style="float: left;height: 34px;">

                            </div>
                            <div style="float:left;"><soul:button cssClass="co-gray6 m-l" target="refreshCode" opType="function" text="refresh" style="padding-top: 10px;">
                                <i class="fa fa-refresh"></i></soul:button></div>
                        </div>
                        <br>
                        <div style="float: left">
                            <span class="help-block m-b-none"><i class="fa fa-times-circle co-red3"></i>
                            ${fn:replace(views.share['privilege.password.prefix'],"{0}","<span class=\"co-red3\">0</span>")}
                        </span>
                        </div>
                        <input type="hidden" name="requiedValiCode" value="">
                    </td>
                </tr>

            </table>
        </div>

    </div>
    <div class="modal-footer">

        <soul:button cssClass="btn btn-filter" precall="validateForm" target="${root}/privilege/valiPrivilege.html" opType="ajax" post="getCurrentFormData" dataType="json" text="${views.common.ok}" callback="showTips"/>
        <soul:button cssClass="btn btn-filter" target="closePage" opType="function" text="${views.common.cancel}"/>

    </div>--%>
</form>
</body>
<%@ include file="/include/include.js.jsp" %>
<soul:import res="gb/common/Privilege"/>
</html>
