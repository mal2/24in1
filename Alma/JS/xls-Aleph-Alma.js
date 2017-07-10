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
        if (canvas && ($('.listActions').size() == 1)) {
            console.log("goto single item");
            $("#ROW_ACTION_list_0_c\\.button\\.edit").children("input").trigger("click")
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
            $('#cresource_editornotes').click();
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
            if (canvas) {
                var modal = document.getElementById('modal700g');
                if (!modal) {
                    $('<div id="modal700g"></div>').appendTo('body')
                        .html('<div><h6>700g entfernen?</h6></div>')
                        .dialog({
                        create: function (event, ui) {
                            $(".ui-widget-header").hide();
                        },
                        modal: true, zIndex: 10000, autoOpen: true, dialogClass: "no-titlebar",
                        width: 'auto', resizable: false,
                        buttons: {
                            Yes: function () {
                                var node = $('#pageBeanitemMddnxphysicalItemTableinternalNote_1');
                                node.val(function(i,v){return v.replace("; 700g","");})
                                node.val(function(i,v){return v.replace("700g","");})
                                $(this).dialog("close");
                            },
                            No: function () {
                                $(this).dialog("close");
                            }
                        },
                        close: function (event, ui) {
                            $(this).remove();
                            $('#PAGE_BUTTONS_cbuttonsaveConfirmation').trigger("click");
                            observerNotSearch.observe(document, {
                                childList: true,
                                subtree: true
                            });
                            me.disconnect(); // stop observing
                            return;
                        }
                    });
                }
            }
    });
    
    observerSearch.observe(document, {
        childList: true,
        subtree: true
    });
})();