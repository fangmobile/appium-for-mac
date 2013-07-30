//
//  AppiumMacHTTPConnection.m
//  AppiumAppleScriptProxy
//
//  Created by Dan Cuellar on 7/28/13.
//  Copyright (c) 2013 Appium. All rights reserved.
//

#import "AppiumMacHTTPConnection.h"
#import "AppiumAppleScriptProxyAppDelegate.h"
#import "HTTPDataResponse.h"
#import "HTTPLogging.h"


// Log levels: off, error, warn, info, verbose
// Other flags: trace
static const int httpLogLevel = HTTP_LOG_LEVEL_VERBOSE;

@implementation AppiumMacHTTPConnection

- (BOOL)supportsMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
    
	// Add support for POST
	if ([method isEqualToString:@"POST"])
	{
		return YES;
	}
    if ([method isEqualToString:@"DELETE"])
	{
		return YES;
	}
    
	return [super supportsMethod:method atPath:path];
}

- (BOOL)expectsRequestBodyFromMethod:(NSString *)method atPath:(NSString *)path
{
	HTTPLogTrace();
    
	// Inform HTTP server that we expect a body to accompany a POST request
	if([method isEqualToString:@"POST"])
		return YES;
    
	return [super expectsRequestBodyFromMethod:method atPath:path];
}

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    path = [path stringByReplacingOccurrencesOfString:@"/wd/hub/" withString:@"/"];
    NSArray *pathComponents = [[path substringFromIndex:1] componentsSeparatedByString:@"/"];
    
    // GET /status
	if ([path isEqualToString:@"/status"] && [method isEqualToString:@"GET"])
	{
        return [SERVER.handler getStatus:path];
	}
    
    // POST /session
    if ([path isEqualToString:@"/session"] && [method isEqualToString:@"POST"])
	{
        return [SERVER.handler postSession:path];
	}
    
    // GET /sessions
    if ([path isEqualToString:@"/sessions"] && [method isEqualToString:@"GET"])
    {
        return [SERVER.handler getSessions:path];
    }
    
    // GET /session/:sessionId
    if (pathComponents.count == 2 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [method isEqualToString:@"GET"])
    {
        return [SERVER.handler getSession:path];
    }
    
    // DELETE /session/:sessionId
    if (pathComponents.count == 2 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [method isEqualToString:@"DELETE"])
    {
        return [SERVER.handler deleteSession:path];
    }
    
    // /session/:sessionId/timeouts
    // /session/:sessionId/timeouts/async_script
    // /session/:sessionId/timeouts/implicit_wait
    
    // GET /session/:sessionId/window_handle
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"window_handle"] && [method isEqualToString:@"GET"])
	{
        return [SERVER.handler getWindowHandle:path];
	}
    
    // GET /session/:sessionId/window_handles
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"window_handles"] && [method isEqualToString:@"GET"])
	{
        return [SERVER.handler getWindowHandles:path];
	}
    
    // GET /session/:sessionId/url
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"url"] && [method isEqualToString:@"GET"])
	{
        return [SERVER.handler getUrl:path];
	}
    
    // POST /session/:sessionId/url
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"url"] && [method isEqualToString:@"POST"])
	{
        return [SERVER.handler postUrl:path];
	}
    
    // /session/:sessionId/forward
    // /session/:sessionId/back
    // /session/:sessionId/refresh
    // /session/:sessionId/execute
    // /session/:sessionId/execute_async
    
    // GET /session/:sessionId/screenshot
    if ([path isEqualToString:@"/screenshot"] && [method isEqualToString:@"GET"])
	{
        
        return [SERVER.handler getScreenshot:path];
	}

    // /session/:sessionId/ime/available_engines
    // /session/:sessionId/ime/active_engine
    // /session/:sessionId/ime/activated
    // /session/:sessionId/ime/deactivate
    // /session/:sessionId/ime/activate
    // /session/:sessionId/frame
    
    // POST /session/:sessionId/window
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"window"] && [method isEqualToString:@"POST"])
	{
        return [SERVER.handler postWindow:path];
	}
    
    // DELETE /session/:sessionId/window
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"window"] && [method isEqualToString:@"DELETE"])
	{
        return [SERVER.handler deleteWindow:path];
	}
    
    // /session/:sessionId/window/:windowHandle/size
    // /session/:sessionId/window/:windowHandle/position
    // /session/:sessionId/window/:windowHandle/maximize
    // /session/:sessionId/cookie
    // /session/:sessionId/cookie/:name
    
    // GET /session/:sessionId/source
    if (pathComponents.count == 3 && [[pathComponents objectAtIndex:0] isEqualToString:@"session"] && [[pathComponents objectAtIndex:2] isEqualToString:@"source"] && [method isEqualToString:@"GET"])
	{
        return [SERVER.handler getSource:path];
	}
    
    // /session/:sessionId/title
    // /session/:sessionId/element
    // /session/:sessionId/elements
    // /session/:sessionId/element/active
    // /session/:sessionId/element/:id
    // /session/:sessionId/element/:id/element
    // /session/:sessionId/element/:id/elements
    // /session/:sessionId/element/:id/click
    // /session/:sessionId/element/:id/submit
    // /session/:sessionId/element/:id/text
    // /session/:sessionId/element/:id/value
    // /session/:sessionId/keys
    // /session/:sessionId/element/:id/name
    // /session/:sessionId/element/:id/clear
    // /session/:sessionId/element/:id/selected
    // /session/:sessionId/element/:id/enabled
    // /session/:sessionId/element/:id/attribute/:name
    // /session/:sessionId/element/:id/equals/:other
    // /session/:sessionId/element/:id/displayed
    // /session/:sessionId/element/:id/location
    // /session/:sessionId/element/:id/location_in_view
    // /session/:sessionId/element/:id/size
    // /session/:sessionId/element/:id/css/:propertyName
    // /session/:sessionId/orientation
    // /session/:sessionId/alert_text
    // /session/:sessionId/accept_alert
    // /session/:sessionId/dismiss_alert
    // /session/:sessionId/moveto
    // /session/:sessionId/click
    // /session/:sessionId/buttondown
    // /session/:sessionId/buttonup
    // /session/:sessionId/doubleclick
    // /session/:sessionId/touch/click
    // /session/:sessionId/touch/down
    // /session/:sessionId/touch/up
    // /session/:sessionId/touch/move
    // /session/:sessionId/touch/scroll
    // /session/:sessionId/touch/scroll
    // /session/:sessionId/touch/doubleclick
    // /session/:sessionId/touch/longclick
    // /session/:sessionId/touch/flick
    // /session/:sessionId/touch/flick
    // /session/:sessionId/location
    // /session/:sessionId/local_storage
    // /session/:sessionId/local_storage/key/:key
    // /session/:sessionId/local_storage/size
    // /session/:sessionId/session_storage
    // /session/:sessionId/session_storage/key/:key
    // /session/:sessionId/session_storage/size
    // /session/:sessionId/log
    // /session/:sessionId/log/types
    // /session/:sessionId/application_cache/status
    
	return [super httpResponseForMethod:method URI:path];
}

@end