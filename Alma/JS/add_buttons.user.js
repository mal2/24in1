// ==UserScript==
// @name         Add Buttons
// @namespace    http://tampermonkey.net/
// @version      0.2.6
// @description  show sublinks of Action button under the button
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {

    var state = "none";

    var observerNoButtons = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        console.log("Running NotButtons");
        var canvashold = document.getElementById('ADD_HIDERADIO_up_list_cresource_editorholdings_listdelete_holdings');
        var canvasitem = document.getElementById('ADD_HIDERADIO_up_list_cresource_editoritems_listchangeHoldings');
        if (!canvashold|| !canvasitem) {
            observerButtons.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect(); // stop observing
            return;
        }
    });

    var observerButtons = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        console.log("Running Buttons");
        var canvashold = document.getElementById('ADD_HIDERADIO_up_list_cresource_editorholdings_listdelete_holdings');
        var canvasitems = document.getElementById('ADD_HIDERADIO_up_list_cresource_editoritems_listchangeHoldings');
        //var canvaseditor = document.getElementById('mdeditor_container');
        if (!canvashold && ! canvasitems){
            state = "none";
        }
        if (canvasitems && (state != "items")) {
            console.log("adding item buttons");
            state = "items";
            $("li[id^='ROW_ACTION_LI_list_']").each(function(){
                $(this).append($(this).children("ul").children("li").clone()[1]);
            });
            observerNoButtons.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
        if (canvashold && (state != "holdings")) {
            console.log("adding hold buttons");
            state = "holdings";
            $("li[id^='ROW_ACTION_LI_list_']").each(function(){
                $(this).append($(this).children("ul").children("li").clone()[1]);
                $(this).append($(this).children("ul").children("li").clone()[3]);
            });
            observerNoButtons.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
         }
    });

    observerButtons.observe(document, {
        childList: true,
        subtree: true
    });
})();