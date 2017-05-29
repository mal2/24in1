// ==UserScript==
// @name         Primus Iframe
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  try to take over the world!
// @author       Kenny
// @downloadURL  https://pastebin.com/wHgkNzC5
// @updateURL    https://pastebin.com/wHgkNzC5
// @match        https://fu-berlin.alma.exlibrisgroup.com/mng/action/home.do?mode=ajax
// @grant        none
// ==/UserScript==

(function() {

    var observerNotTit = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('ADD_HIDERADIO_up_list_cresource_editorholdings_listdelete_holdings');
        if (!canvas) {
            observerTit.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect();
            return;
        }
    });

    var observerTit = new MutationObserver(function (mutations, me) {
        console.log("iframe ready!");
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeantitle');
        var canvashold = document.getElementById('ADD_HIDERADIO_up_list_cresource_editorholdings_listdelete_holdings');
        if (canvas && canvashold) {
            console.log("Iframes werden eingebettet");

            var hulink = "https://hu-berlin.hosted.exlibrisgroup.com/primo_library/libweb/action/search.do?fn=search&ct=search&vl(freeText0)="+$('#pageBeantitle').val().replace(/ /g, '+')+"&fn=search&ct=search&initialSearch=true&mode=Basic&tab=default_tab&indx=1&dum=true&srt=rank&vid=hub_ub&frbg=390969109&fctN=facet_frbrgroupid&fctV=390969109";
            var rvklink = "https://rvk.uni-regensburg.de/regensburger-verbundklassifikation-online";

            $(".mainContainer").append("<div><iframe  id='HUContainer' src='"+hulink+"' frameborder='0' scrolling='yes' width='500' height='1024' align='left' sandbox='allow-scripts allow-same-origin'></iframe><iframe id='RVKContainer' src='"+rvklink+"' frameborder='0' scrolling='no' width='1055' height='1024' align='right' sandbox='allow-scripts allow-same-origin'></iframe></div>");
            observerNotTit.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    observerTit.observe(document, {
        childList: true,
        subtree: true
    });
})();