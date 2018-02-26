// ==UserScript==
// @name         Auto-Daten, -Material, -ExRichtlinie
// @namespace    http://tampermonkey.net/
// @version      0.3.1
// @description  set (if empty) material type to book, item policy to Selbstausleihe (2 Wochen) and receiving- and inventory date to 01.01.1900
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
        var observerNotEditor = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanselectedProcessType');
        if (!canvas) {
            observerDaten.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect(); // stop observing
            return;
        }
    });

    var observerDaten = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanselectedProcessType');
        if (canvas){
            if ($("#pageBeandataObjectarrivalDate").val() === "") { //Receiving date
                console.log("Empfangsdatum eingefügt");
                $("#pageBeandataObjectarrivalDate").datepicker();
                $("#pageBeandataObjectarrivalDate").datepicker("setDate", new Date(1900,0,1));
                $("#pageBeandataObjectarrivalDate").focus().change();
                $("#pageBeandataObjectarrivalDate").css('color','red');
                $("#ui-datepicker-div").hide();
            }
            if ($("#pageBeandataObjectinventoryDate").val() === "") { //Intentory date
                console.log("Inventarisierungsdatum eingefügt");
                $("#pageBeandataObjectinventoryDate").datepicker();
                $("#pageBeandataObjectinventoryDate").datepicker("setDate", new Date(1900,0,1));
                $("#pageBeandataObjectinventoryDate").focus().change();
                $("#pageBeandataObjectinventoryDate").css('color','red');
                $("#ui-datepicker-div").hide();
            }
            if ($("#pageBeanitemMddnxphysicalItemTablematerialType").val() === " ") { //Material type
                console.log("Buch eingefügt");
                $("#pageBeanitemMddnxphysicalItemTablematerialType_hiddenSelect>option:eq(4)").attr("selected", true).change();
                $("#pageBeanitemMddnxphysicalItemTablematerialType").val("Buch", true).change();
                $("#pageBeanitemMddnxphysicalItemTablematerialType").css('color','red');
            }
            //if ($("#pageBeanitemMddnxphysicalItemTableitemPolicy_textbox").val() === " ") { //Item policy
            console.log("Selbstausleihe (2 Wochen) eingefügt");
            $("#pageBeanitemMddnxphysicalItemTableitemPolicy_hiddenSelect>option:eq(10)").attr("selected", true).change();
            $("#pageBeanitemMddnxphysicalItemTableitemPolicy").val("Selbstausleihe (4 Wochen)", true).change();
            $("#pageBeanitemMddnxphysicalItemTableitemPolicy").css('color','red');
            //}
            observerNotEditor.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    observerDaten.observe(document, {
        childList: true,
        subtree: true
    });
})();