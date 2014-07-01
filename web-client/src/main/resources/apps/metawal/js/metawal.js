function enterFunction(event){
    var Key = event.keyCode ? event.keyCode : event.which ? event.which : event.charCode;
	if(event.keyCode == 13){
		catalogue.login(document.getElementById('login').value,document.getElementById('password').value);
		location.href='#close';
	}
};
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