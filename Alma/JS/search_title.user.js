// ==UserScript==
// @name         search title
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/mng/action/home.do?mode=ajax
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    var observerSearch = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle');
        if (canvas) {
            console.log("Suche nach Titel");
            var searchtext = $("#HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle").text();
            $("#pageBeansearchText").val(searchtext);
            $("#cbuttongo").trigger("click");
            me.disconnect(); // stop observing
            return;
        }
    });

    observerSearch.observe(document, {
        childList: true,
        subtree: true
    });
})();