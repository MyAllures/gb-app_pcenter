<%@ include file="include.base.js.common.jsp" %>
<script src="${resRoot}/js/common/main.js"></script>
<script data-curl-run="" src="${resComRoot}/js/curl/curl.js"></script>
<script type="text/javascript" language="JavaScript" src="${resComRoot}/js/gamebox/common/urlencode.js"></script>
<script type="text/javascript">
    curl(['gb/components/selectPure'], function(Page) {
        select = new Page();
    });
    curl(['zeroClipboard'], function (zeroClipboard) {
        window.ZeroClipboard=zeroClipboard;
    });
</script>