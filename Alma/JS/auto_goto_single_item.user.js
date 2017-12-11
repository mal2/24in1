// ==UserScript==
// @name         Auto Goto Single Item
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  auto edit if just single item
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    var observerNoSingleItem = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        console.log("Running NotSingleItem");
        var canvastitle= document.getElementById('PAGE_BUTTONS_csearchbuttonssaveQuery_up');
        if (canvastitle) {
            observerSingleItem.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect(); // stop observing
            return;
        }
    });

    var observerSingleItem = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('ADD_HIDERADIO_up_list_cresource_editoritems_listchangeHoldings');
        var length = document.getElementsByClassName('listActions').length;
        if (canvas && (length == 1)) {
            console.log("goto single item");
            $("#ROW_ACTION_list_0_c\\.button\\.edit").children("input").trigger("click");
            observerNoSingleItem.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    observerSingleItem.observe(document, {
        childList: true,
        subtree: true
    });
})();