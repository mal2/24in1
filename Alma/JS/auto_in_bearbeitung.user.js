// ==UserScript==
// @name         Auto in Bearbeitung
// @namespace    http://tampermonkey.net/
// @version      0.1
// @description  try to take over the world!
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/mng/action/home.do?mode=ajax
// @grant        none
// ==/UserScript==

(function() {
    var observerGG = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanselectedProcessType');
        if (canvas) {
            //console.log("Exists!");
            $("#pageBeanselectedProcessType>option:eq(1)").attr("selected", true).change();
            me.disconnect(); // stop observing
            return;
        }
    });
    var observerDep = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanselectedRequestDepartment');
        if (canvas) {
            console.log("Prozesstyp -> In Bearbeitung (Medienbearbeitung)");
            $("#pageBeanselectedRequestDepartment_textbox").val("Medienbearbeitung");
            $("#pageBeanselectedRequestDepartment>option:eq(3)").attr("selected", true).change();
            me.disconnect(); // stop observing
            return;
        }
    });

    observerGG.observe(document, {
        childList: true,
        subtree: true
    });

    observerDep.observe(document, {
        childList: true,
        subtree: true
    });
})();