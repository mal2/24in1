// ==UserScript==
// @name         Search Title
// @namespace    http://tampermonkey.net/
// @version      0.3
// @description  after scanning barcode a search containing title of the first entry is done
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    var observerNotSearch = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('INITIAL_SPAN_RECORD_VIEW_results_ROW_ID_0_LABEL_title');
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
        var canvas = document.getElementById('INITIAL_SPAN_RECORD_VIEW_results_ROW_ID_0_LABEL_title');
        if (canvas) {
            console.log("Suche nach Titel");
            var searchtext = $("#INITIAL_SPAN_RECORD_VIEW_results_ROW_ID_0_LABEL_title").text();
            $("#ALMA_MENU_TOP_NAV_Search_Text").val(searchtext);
            $("#simpleSearchBtn").trigger("click");
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