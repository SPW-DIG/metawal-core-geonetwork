
function newmetadata() {
    if (catalogue.isIdentified()) {
        var actionCtn = Ext.getCmp('resultsPanel').getTopToolbar();
        actionCtn.createMetadataAction.handler.apply(actionCtn);
    }
}

function importmetadata() {
    if (catalogue.isIdentified()) {
        var actionCtn = Ext.getCmp('resultsPanel').getTopToolbar();
        actionCtn.mdImportAction.handler.apply(actionCtn);
    }
}