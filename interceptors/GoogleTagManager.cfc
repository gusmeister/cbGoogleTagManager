component extends="coldbox.system.Interceptor"{

    // DI
    property name="settingService"  inject="id:settingService@cb";

    /**
    * Configure
    */
    function configure(){}

    /**
     * add to head - async load
     */
	public void function cbui_beforeHeadEnd(event, interceptData,buffer) {
		// we don't track preview events
		if(reFindNoCase( "contentbox-ui:.*preview", event.getCurrentEvent() )){
			arguments.buffer.append( "<!-- No Google Tag Manager For Preview -->" );	
			return;			
		}		
		// No Google Tag Manager  For Admin Users				
		// the interceptor is called with prc in arguments	
		if(	prc.oCurrentAuthor.isLoggedIn() 
			and prc.oCurrentAuthor.checkPermission( "CONTENTBOX_ADMIN,PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR" )
		) {
			arguments.buffer.append( "<!-- No Google Tag Manager For Admin Users -->" );	
			return;			
		}		
		var toBuffer = '';
		// settings
		var settingStruct = settingService.getSetting( "cb_GoogleTagManager","" );
		// if settings not valid return
		if(!isJson(settingStruct))
			return;
		var gtm=deserializeJson(settingStruct);
		// if containerID is empty makes no sense to proceed
		if(trim(gtm.containerID) eq '') 
			return;
		// add the tag code	
		savecontent variable="toBuffer" {
			writeOutput("<script>
				(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
				new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
				j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
				'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
				})(window,document,'script','dataLayer','#gtm.containerID#);
				</script>");					
		  }	  
   		arguments.buffer.append( toBuffer );		
	}
	
    /**
     * add to body - backup if javascript disabled 
     */
	public void function cbui_afterBodyStart(event, interceptData,buffer) {
		// we don't track preview events
		if(reFindNoCase( "contentbox-ui:.*preview", event.getCurrentEvent() )){
			arguments.buffer.append( "<!-- No Google Tag Manager For Preview -->" );	
			return;			
		}		
		// No Google Tag Manager  For Admin Users				
		// the interceptor is called with prc in arguments	
		if(	prc.oCurrentAuthor.isLoggedIn() 
			and prc.oCurrentAuthor.checkPermission( "CONTENTBOX_ADMIN,PAGES_ADMIN,PAGES_EDITOR,ENTRIES_ADMIN,ENTRIES_EDITOR" )
		) {
			arguments.buffer.append( "<!-- No Google Tag Manager For Admin Users -->" );	
			return;			
		}		
		var toBuffer = '';
		// settings
		var settingStruct = settingService.getSetting( "cb_GoogleTagManager","" );
		// if settings not valid return
		if(!isJson(settingStruct))
			return;
		var gtm=deserializeJson(settingStruct);
		// if tracking id is empty makes no sense to proceed
		if(trim(gtm.containerID) eq '') 
			return;
		// add the tag code	
		savecontent variable="toBuffer" {
			writeOutput("<noscript><iframe src='https://www.googletagmanager.com/ns.html?id=#gtm.containerID#' 'height='0' width='0' style='display:none;visibility:hidden'></iframe></noscript>");				
		  }	  
   		arguments.buffer.append( toBuffer );		
	}	
	
}