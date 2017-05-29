// ==UserScript==
// @name         Add Month/Year To Internal Note
// @namespace    http://tampermonkey.net/
// @version      0.2
// @description  try to take over the world!
// @author       Kenny
// @match        https://fu-berlin.alma.exlibrisgroup.com/mng/action/home.do?mode=ajax
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
            var add = d.getMonth()+1 + '/' + d.getFullYear();
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