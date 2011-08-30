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
    return (interfaceOrientation == UIDeviceOrientationLandscapeLeft);
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
		
    self.view.backgroundColor = [UIColor blackColor];
    
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_headerLabel.frame = CGRectMake(0, 0, 460, 20);
	_headerLabel.backgroundColor = [UIColor clearColor];
	_headerLabel.textColor = [UIColor darkGrayColor];
	_headerLabel.font = [UIFont systemFontOfSize:13];
	_headerLabel.textAlignment = UITextAlignmentRight;
	_headerLabel.text = @"Bitte warten...";
    
    UIImage *image = [UIImage imageNamed:@"Default"];
    _loadView = [[UIImageView alloc] initWithImage:image];
    _loadView.transform = CGAffineTransformMakeRotation(-M_PI/2.0);
    _loadView.frame = CGRectMake(0,0,480,320);
    
    UIActivityIndicatorView *actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [actView startAnimating];
    actView.frame = CGRectMake(199,92,actView.frame.size.width,actView.frame.size.height);
    [_loadView addSubview:actView];
    [actView release];
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
    [_loadView release];
}


- (void)setVideoDescription:(NSString*)description
{
	_headerLabel.text = description;
}


- (void)startVideoWithURL:(NSURL*)url
{
	_movieController = [[MPMoviePlayerController alloc]
		initWithContentURL:url];
	_movieController.controlStyle = MPMovieControlStyleNone;
    _movieController.view.frame = CGRectMake(0,0,480,320);
    
    [self.view addSubview:[_movieController view]];
    [self.view addSubview:_loadView];

    [_movieController play];
    
	[NSTimer scheduledTimerWithTimeInterval:0.1f 
		target:self
		selector:@selector(showOverlay:)
		userInfo:nil
		repeats:NO];
}


- (void)showOverlay:(NSTimer *)timer
{
	UILabel *footerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,300,460,20)];
	footerLabel.backgroundColor = [UIColor clearColor];
	footerLabel.textColor = [UIColor darkGrayColor];
	footerLabel.font = [UIFont systemFontOfSize:13];
	footerLabel.textAlignment = UITextAlignmentRight;
	footerLabel.text = @"Quelle: www.tagesschau.de";
    
	[self.view addSubview:_headerLabel];
	[self.view addSubview:footerLabel];
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
    if ([self.view.subviews containsObject:[_movieController view]]) [[_movieController view] removeFromSuperview];
    
	UILabel *endLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,160,440,20)];
	endLabel.backgroundColor = [UIColor clearColor];
	endLabel.textColor = [UIColor darkGrayColor];
	endLabel.font = [UIFont systemFontOfSize:14];
	endLabel.textAlignment = UITextAlignmentCenter;
	endLabel.text = @"Ende";
	[self.view addSubview:endLabel];
	[endLabel release];
}

@end
