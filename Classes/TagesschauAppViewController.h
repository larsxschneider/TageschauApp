//
//  TagesschauAppViewController.h
//  TagesschauApp
//
//  Created by Lars Schneider on 18.04.10.
//  Copyright Lars Schneider 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>


@interface TagesschauAppViewController : UIViewController
{
	MPMoviePlayerController		*_movieController;
	UILabel						*_headerLabel;
	IBOutlet UIView				*_loadView;
}

- (void)setVideoDescription:(NSString*)description;
- (void)startVideoWithURL:(NSURL*)url;
- (void)moviePlayBackDidFinish:(NSNotification*)aNotification;

@end

