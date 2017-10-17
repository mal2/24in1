// ==UserScript==
// @name         Auto "In Bearbeitung"
// @namespace    http://tampermonkey.net/
// @version      0.4.5
// @description  automatically set process type to AcqWorkOrder and reqest department to Medienbearbeitung in physical Item Editor
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    var observerNotEditor = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('FORM_ID_SECTION_itemContextSection_FORM_itemContext_INPUT_pageBeanitemMddnxphysicalItemTablebarcode');
        var canvas2 = document.getElementById('pageBeanitemMddnxcontrolCharacteristicspId');
        if (!canvas && (canvas == canvas2)) {
            internalNote = false;
            internal = true;
            observerGG.observe(document, {
                childList: true,
                subtree: true
            });
            observerDep.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect(); // stop observing
            return;
        }
    });

    var observerGG = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanselectedProcessType');
        if (canvas && $("#pageBeanselectedProcessType").val() != "AcqWorkOrder") {
            //console.log("Exists!");
            $("#pageBeanselectedProcessType>option:eq(1)").attr("selected", true).change();
            me.disconnect(); // stop observing
            return;
        }
    });

    var observerDep = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanselectedRequestDepartment_textbox');
        if (canvas) {
            console.log("Prozesstyp -> In Bearbeitung (Medienbearbeitung)");
            $("#pageBeanselectedRequestDepartment_textbox").val("Medienbearbeitung");
            $("#pageBeanselectedRequestDepartment>option:eq(3)").attr("selected", true).change();
            var input = $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumber');
            input.on('change keydown paste input', function(){
                $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumberType_textbox').val("In Unterfeld $2 angegebene Quelle");
                $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumberType').val('7');
                $('#pageBeanitemMddnxphysicalItemTablealtNumberSource').val('rvk');
                //$('#pageBeanitemMddnxphysicalItemTablealternativeCallNumberType:eq(7)').attr("selected", true).change();
            });
            //if (!internalNote){
            //    internalNote = true;
            //    $('#cresource_editornotes').click();
            //}
            observerNotEditor.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    var internalNote = true;
    observerNotEditor.observe(document, {
        childList: true,
        subtree: true
    });
})();