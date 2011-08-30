//
//  TagesschauAppAppDelegate.m
//  TagesschauApp
//
//  Created by Lars Schneider on 18.04.10.
//  Copyright Lars Schneider 2010. All rights reserved.
//

#import "TagesschauAppAppDelegate.h"
#import "TagesschauAppViewController.h"
#import "ASIHTTPRequest.h"


@implementation TagesschauAppAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
	application.statusBarHidden = YES;
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	NSURL *url = [NSURL URLWithString:@"feed://www.tagesschau.de/export/video-podcast/tagesschau/"];
	ASIHTTPRequest *mainPageRequest = [ASIHTTPRequest requestWithURL:url];
	[mainPageRequest setDidFinishSelector:@selector(readVideoURL:)];
	[mainPageRequest setDidFailSelector:@selector(networkFail:)];
	[mainPageRequest setDelegate:self];
	[mainPageRequest startAsynchronous];
   
	return YES;
}


- (void)dealloc
{
    [viewController release];
    [window release];
    [super dealloc];
}


- (void)showErrorMessage
{
	[viewController moviePlayBackDidFinish:nil];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fehler" 
		message:@"Video konnte nicht geladen werden."	
		delegate:self 
		cancelButtonTitle:@"OK"
		otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}


- (void)readVideoURL:(ASIHTTPRequest *)request
{
	NSString *videoHTML = [request responseString];
	
	if (videoHTML != nil)
	{
		// Get position of video url
		NSRange videoPageRange = [videoHTML rangeOfString:@"http://tagesschau.vo.llnwd.net/"];
		
		// Extend range
		videoPageRange.length = videoHTML.length - videoPageRange.location;
		
		// Search in extended range for link end
		NSRange videoPageRangeEnd = [videoHTML
			rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\""] 
			options:NSLiteralSearch
			range:videoPageRange];	
		
		// Calc video url string length
		videoPageRange.length = videoPageRangeEnd.location - videoPageRange.location;
		
		// Extract video url
		NSString *videoPage = [videoHTML substringWithRange:videoPageRange];
		
		// Extract date
		NSRange dateRange = [videoPage rangeOfString:@"/TV-20"];
		dateRange.location = dateRange.location + 4;
		dateRange.length = 8;
		NSString *rawDateString = [videoPage substringWithRange:dateRange];
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyyMMdd"];
		NSDate *date = [dateFormatter dateFromString:rawDateString];
		[dateFormatter setDateStyle:NSDateFormatterFullStyle];
		NSString *videoDescription = [NSString stringWithFormat:@"tagesschau vom %@", 
			[dateFormatter stringFromDate:date]];
		[dateFormatter release];
	
		if (videoPage != nil)
		{
			// Start video
			log(@"Video URL found: %@", videoPage);
			log(@"Video date: %@", videoDescription);
			[viewController setVideoDescription:videoDescription];
			[viewController startVideoWithURL:[NSURL URLWithString:videoPage]];
			return;
		}
	}
	
	[self showErrorMessage];
}


- (void)networkFail:(ASIHTTPRequest *)request
{
	[self showErrorMessage];
}


@end
