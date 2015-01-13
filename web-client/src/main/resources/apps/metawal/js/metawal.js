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

function displayLoginModalScreen(){
    document.getElementById('transparentHider').style.display = 'block';
    document.getElementById('login_form_div').style.visibility = 'visible';
    document.getElementById('login_form_div').style.opacity = 1;
    document.getElementById('login_form_div').style.top = 150;;
    document.getElementById('login_form_div').style.left = '50%';
    document.getElementById('login_form_div').style.display = 'block';
}
function hideLoginModalScreen(){
    document.getElementById('transparentHider').style.display = 'none';
    document.getElementById('login_form_div').style.visibility = 'hidden';
    document.getElementById('login_form_div').style.opacity = 0;
}