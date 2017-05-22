// ==UserScript==
// @name         add date to internal note
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/mng/action/home.do?mode=ajax
// @grant        none
// ==/UserScript==

(function() {
    var observerInternalNote = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanitemMddnxphysicalItemTableinternalNote_1');
        if (canvas) {
            var d = new Date();
            var add = d.getMonth()+1 + '/' + d.getFullYear();
            console.log("Interne Notiz -> "+add);
            var note = $("#pageBeanitemMddnxphysicalItemTableinternalNote_1").val();
            if (note){
                $("#pageBeanitemMddnxphysicalItemTableinternalNote_1").val(note + "; " + add);
            } else {
                $("#pageBeanitemMddnxphysicalItemTableinternalNote_1").val(add);
            }
            me.disconnect(); // stop observing
            return;
        }
    });

    observerInternalNote.observe(document, {
        childList: true,
        subtree: true
    });
})();