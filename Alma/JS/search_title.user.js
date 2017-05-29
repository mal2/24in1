// ==UserScript==
// @name         Search Title
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  try to take over the world!
// @author       Kenny
// @match        https://fu-berlin.alma.exlibrisgroup.com/mng/action/home.do?mode=ajax
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    var observerNotSearch = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle');
        if (!canvas) {
            observerSearch.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect(); // stop observing
            return;
        }
    });

    var observerSearch = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle');
        if (canvas) {
            console.log("Suche nach Titel");
            var searchtext = $("#HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle").text();
            $("#pageBeansearchText").val(searchtext);
            $("#cbuttongo").trigger("click");
            observerNotSearch.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    observerSearch.observe(document, {
        childList: true,
        subtree: true
    });
})();