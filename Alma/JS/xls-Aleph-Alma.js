// ==UserScript==
// @name         xls-Aleph-Alma
// @namespace    http://tampermonkey.net/
// @version      0.2.5
// @description  after scanning barcode a search containing title of the first entry is done
// @author       Kenny <k.b@fu-berlin.de>
// @match        https://fu-berlin.alma.exlibrisgroup.com/*
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
    var observerNotSearch = new MutationObserver(function (mutations, men) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle');
        if (!canvas) {
            observerSearch.observe(document, {
                childList: true,
                subtree: true
            });
            men.disconnect(); // stop observing
            return;
        }
    });

    var observerSearch = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('HREF_INPUT_RECORD_VIEW_results_ROW_ID_0_LABEL_titletitle');
        if (canvas) {
            console.log("click item");
            $('#INPUT_ROW_ACTION_0_results_csearchPIE_resultsitems').trigger("click");
            observerEx.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });

    var observerEx = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('ADD_HIDERADIO_up_list_cresource_editoritems_listchangeHoldings');
        var length = document.getElementsByClassName('listActions').length;
        if (canvas && (length == 1)) {
            console.log("goto single item");
            $("#ROW_ACTION_list_0_c\\.button\\.edit").children("input").trigger("click");
            observerInternalNote.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });
    
    var observerInternalNote = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('cresource_editornotes_span');
        if (canvas) {
            canvas.click();
            observerInternalNoteEdit.observe(document, {
                childList: true,
                subtree: true
            });
            me.disconnect(); // stop observing
            return;
        }
    });
    
        var observerInternalNoteEdit = new MutationObserver(function (mutations, me) {
        // `mutations` is an array of mutations that occurred
        // `me` is the MutationObserver instance
        var canvas = document.getElementById('pageBeanitemMddnxphysicalItemTableinternalNote_1');
        var conf = true;
        var node = $('#pageBeanitemMddnxphysicalItemTableinternalNote_1');
        var nodeval = node.val();
            if (canvas && confirm && nodeval.indexOf("700g")>=0) {
                
                node.val(function(i,v){return v.replace("; 700g","");})
                node.val(function(i,v){return v.replace("700g","");})
                var nodenew = node.val();
                node.val(nodeval);
                if (window.confirm("Interne Notiz von '"+nodeval+"' zu '"+nodenew+"' ändern?")) {
                    conf = false
                    node.val(nodenew)
                    $('#PAGE_BUTTONS_cbuttonsaveConfirmation').trigger("click");
                    observerSearch.observe(document, {
                        childList: true,
                        subtree: true
                    });
                } else {
                    observerSearch.observe(document, {
                        childList: true,
                        subtree: true
                    });
                }
                
            
            }
    });
    
    observerSearch.observe(document, {
        childList: true,
        subtree: true
    });
})();