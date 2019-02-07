/**
* The handler is just used for admin
* ---
*/
component{

	// DI
	property name="settingService" 	inject="settingService@cb";
	property name="cb" 					inject="cbHelper@cb";

	function settings( event, rc, prc ){
		prc.xehSave = cb.buildModuleLink( "cbGoogleTagManager", "home.saveSettings" );

		event.paramValue( "containerID", "" );
				
		var args 	= { name="cb_GoogleTagManager" };
		var allsettings = settingService.findWhere( criteria=args );

		if(!isNull(allsettings)){
			var pairs=deserializeJSON(allsettings.getValue());
			for( var key in pairs ){
				event.setValue(key,pairs[key] );
			}
		}
		// view
		event.setView( "home/settings" );
	}

	function saveSettings( event, rc, prc ){
		// Get settings
		prc.settings = {containerID=''
			};

		// iterate over settings
		for( var key in prc.settings ){
			// save only sent in setting keys
			if( structKeyExists( rc, key ) ){
				prc.settings[ key ] = rc[ key ];
			}
		}
		// Save settings
		var args 	= { name="cb_GoogleTagManager" };
		var setting = settingService.findWhere( criteria=args );
		if( isNull( setting ) ){
			setting = settingService.new( properties=args );
		}
		
		setting.setValue( serializeJSON( prc.settings ) );
		settingService.save( setting );
		settingService.flushSettingsCache();
		
		// Messagebox
		getModel( "messagebox@cbMessagebox" ).info( "Settings Saved & Updated!" );
		// Relocate via CB Helper
		cb.setNextModuleEvent( "cbGoogleTagManager", "home.settings" );
	}

}