// ==UserScript==
// @name         countLend
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  add sum of lendings to breadcrumbs
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    var observerNotSumLend = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('RECORD_VIEW_SPAN_results_ROW_ID_0_LABEL_inventoryNumber');
        if (!canvas) {
            observerSumLend.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect();
            return;
        }
    });

  var observerSumLend = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('RECORD_VIEW_SPAN_results_ROW_ID_0_LABEL_inventoryNumber');
        if (canvas) {
            var d = new Date();
            var sum = 0;
            $.ajaxSetup({ async: false });
            $("li.tab").each(function(){
                $.ajax({ async: false })
                $(this).children().click()
                $.ajax({ async: false })
                sum += parseInt($("#SPAN_FORM_ID_popup_info_form_id_INPUT_pageBeanmoreInfoloansCount").text());
                console.log(parseInt($("#SPAN_FORM_ID_popup_info_form_id_INPUT_pageBeanmoreInfoloansCount").text()));
            });
            $("#breadcrumbs").append("<div>Gesamte Ausleihen: "+sum+"</div>");
            $.ajax({ async: true })
            observerNotSumLend.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    observerSumLend.observe(document, {
        childList: true,
        subtree: true
    });
})();


