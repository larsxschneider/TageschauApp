//
//  TagesschauAppViewController.m
//  TagesschauApp
//
//  Created by Lars Schneider on 18.04.10.
//  Copyright Lars Schneider 2010. All rights reserved.
//

#import "TagesschauAppViewController.h"


@implementation TagesschauAppViewController


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc
{
	[_movieController release];
    [super dealloc];
}


- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
		selector:@selector(moviePreloadDidFinish:) 
		name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification 
		object:nil];
		
	[[NSNotificationCenter defaultCenter] addObserver:self 
			selector:@selector(moviePlayBackDidFinish:) 
			name:MPMoviePlayerPlaybackDidFinishNotification 
			object:nil];
		
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_headerLabel.transform = CGAffineTransformMakeRotation(M_PI/2.0);
	_headerLabel.frame = CGRectMake(300,20,20,440);
	_headerLabel.backgroundColor = [UIColor clearColor];
	_headerLabel.textColor = [UIColor darkGrayColor];
	_headerLabel.font = [UIFont systemFontOfSize:13];
	_headerLabel.textAlignment = UITextAlignmentRight;
	_headerLabel.text = @"Bitte warten...";
}


- (void)viewDidUnload
{
	[super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self
		name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
		object:nil];
		
	[[NSNotificationCenter defaultCenter] removeObserver:self
		name:MPMoviePlayerPlaybackDidFinishNotification
		object:nil];
		
	[_headerLabel release];
}


- (void)setVideoDescription:(NSString*)description
{
	_headerLabel.text = description;
}


- (void)startVideoWithURL:(NSURL*)url
{
	_movieController = [[MPMoviePlayerController alloc]
		initWithContentURL:url];
	_movieController.controlStyle = MPMovieControlStyleFullscreen;
	//_movieController.initialPlaybackTime = 12.0f * 60.0f + 30.0f;
	[_movieController play];
	
	[NSTimer scheduledTimerWithTimeInterval:0.1f 
		target:self
		selector:@selector(showOverlay:)
		userInfo:nil
		repeats:NO];
}


- (void)showOverlay:(NSTimer *)timer
{
	UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	footerLabel.transform = CGAffineTransformMakeRotation(M_PI/2.0);
	footerLabel.frame = CGRectMake(0,20,20,440);
	footerLabel.backgroundColor = [UIColor clearColor];
	footerLabel.textColor = [UIColor darkGrayColor];
	footerLabel.font = [UIFont systemFontOfSize:13];
	footerLabel.textAlignment = UITextAlignmentRight;
	footerLabel.text = @"Quelle: www.tagesschau.de";
	
	[[[UIApplication sharedApplication] keyWindow] addSubview:_loadView];
	[[[UIApplication sharedApplication] keyWindow] addSubview:_headerLabel];
	[[[UIApplication sharedApplication] keyWindow] addSubview:footerLabel];
	
	[footerLabel release];
}


- (void)moviePreloadDidFinish:(NSNotification*)aNotification
{
	// Switch to fullscreen
	[_movieController setScalingMode:MPMovieScalingModeAspectFill];
	
	// Blend out loading screen
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:0.5];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	_loadView.alpha = 0.0f;
	[UIView commitAnimations];
}


- (void)moviePlayBackDidFinish:(NSNotification*)aNotification
{
	if ([self.view.subviews containsObject:_loadView]) [_loadView removeFromSuperview];

	UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	endLabel.transform = CGAffineTransformMakeRotation(M_PI/2.0);
	endLabel.frame = CGRectMake(160,20,20,440);
	endLabel.backgroundColor = [UIColor clearColor];
	endLabel.textColor = [UIColor darkGrayColor];
	endLabel.font = [UIFont systemFontOfSize:14];
	endLabel.textAlignment = UITextAlignmentCenter;
	endLabel.text = @"Ende";
	[self.view addSubview:endLabel];
	[endLabel release];
}

@end
