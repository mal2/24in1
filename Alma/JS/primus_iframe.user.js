// ==UserScript==
// @name         Primus Iframe
// @namespace    http://tampermonkey.net/
// @version      0.4.1
// @description  insert HU Primus and RVK-online iframe at bottom of list of holdings
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    var oldTit = "";
    var observerNotTit = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('ADD_HIDERADIO_up_listWithFilters_cresource_editorholdings_listdelete_holdings');
        if (!canvas) {
            canvas = document.getElementById('Record_Simple_View_Header_title');
        }        
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
        var canvashold = document.getElementById('ADD_HIDERADIO_up_listWithFilters_cresource_editorholdings_listdelete_holdings');
        
        var huSearch = $('#pageBeantitle').val().replace(/ /g, '+')
        if (!canvashold) {
            canvashold = document.getElementById('Record_Simple_View_Header_title');
            huSearch = $('#pageBeantitle').text().replace(/ /g, '+')
        }
        if (canvas && canvashold && huSearch != oldTit) {
            console.log("Iframes werden eingebettet");

            var hulink = "https://hu-berlin.hosted.exlibrisgroup.com/primo_library/libweb/action/search.do?fn=search&ct=search&vl(freeText0)="+huSearch+"&fn=search&ct=search&initialSearch=true&mode=Basic&tab=default_tab&indx=1&dum=true&srt=rank&vid=hub_ub&frbg=390969109&fctN=facet_frbrgroupid&fctV=390969109";
            var rvklink = "https://rvk.uni-regensburg.de/regensburger-verbundklassifikation-online";

            $("#fullPageContent").append("<div><iframe  id='HUContainer' src='"+hulink+"' frameborder='0' scrolling='yes' width='500' height='1024' align='left' sandbox='allow-scripts allow-same-origin'></iframe><iframe id='RVKContainer' src='"+rvklink+"' frameborder='0' scrolling='no' width='1080' height='1024' align='right' sandbox='allow-scripts allow-same-origin'></iframe></div>");
            oldTit = huSearch
            
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