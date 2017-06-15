// ==UserScript==
// @name         Add Month/Year To Internal Note
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  add MM/YYYY of current month and year to internal note 1
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    var observerNotInternalNote = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanitemMddnxphysicalItemTableinternalNote_1');
        if (!canvas) {
            observerInternalNote.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect();
            return;
        }
    });

    var observerInternalNote = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanitemMddnxphysicalItemTableinternalNote_1');
        if (canvas) {
            var d = new Date();
            var month = d.getMonth()+1;
            var add = month + '/' + d.getFullYear();
            console.log("Interne Notiz -> "+add);
            var note = $("#pageBeanitemMddnxphysicalItemTableinternalNote_1").val();
            if (note.indexOf(add) < 0){
                if (note){
                    $("#pageBeanitemMddnxphysicalItemTableinternalNote_1").val(note + "; " + add);
                } else {
                    $("#pageBeanitemMddnxphysicalItemTableinternalNote_1").val(add);
                }
            }
            observerNotInternalNote.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    observerInternalNote.observe(document, {
        childList: true,
        subtree: true
    });
})();