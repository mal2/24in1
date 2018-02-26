// ==UserScript==
// @name         Auto "In Bearbeitung"
// @namespace    http://tampermonkey.net/
// @version      0.5.1
// @description  automatically set process type to AcqWorkOrder and reqest department to Medienbearbeitung in physical Item Editor
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    var observerNotEditor = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('SPAN_FORM_ID_SECTION_itemContextSection_FORM_itemContext_INPUT_pageBeanitemMddnxphysicalItemTablebarcode');
        var canvas2 = document.getElementById('SPAN_FORM_ID_SECTION_itemContextSection_FORM_itemContext_INPUT_pageBeanitemMddnxcontrolCharacteristicspId');
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
        console.log("observerGG")
        var canvas = document.getElementById('pageBeanselectedProcessType');
        if (canvas && $("#pageBeanselectedProcessType").val() != "AcqWorkOrder") {
            //console.log("Exists!");
            $("#pageBeanselectedProcessType_hiddenSelect").val("AcqWorkOrder").change();
            //$("#pageBeanselectedProcessType_hiddenSelect>option:eq(0)").attr("selected", true).change();
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
            $("#pageBeanselectedRequestDepartment_hiddenSelect").val("398792670002883").change();
            $("#pageBeanselectedRequestDepartment").val("Medienbearbeitung");
            $("#pageBeanselectedRequestDepartment").css('color','red');
            $("#pageBeanselectedProcessType").css('color','red');
            //$("#pageBeanselectedRequestDepartment_hiddenSelect>option:eq(0)").attr("selected", true).change();
            var input = $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumber');
            input.on('change keydown paste input', function(){
                $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumberType').val("In Unterfeld $2 angegebene Quelle");
                $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumberType_hiddenSelect').val('7');
                $('#pageBeanitemMddnxphysicalItemTablealternativeCallNumberType').css('color','red');
                $('#pageBeanitemMddnxphysicalItemTablealtNumberSource').val('rvk');
                $('#pageBeanitemMddnxphysicalItemTablealtNumberSource').css('color','red');
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