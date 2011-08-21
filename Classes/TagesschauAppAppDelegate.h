//
//  TagesschauAppAppDelegate.h
//  TagesschauApp
//
//  Created by Lars Schneider on 18.04.10.
//  Copyright Lars Schneider 2010. All rights reserved.
//

#import <UIKit/UIKit.h>


@class TagesschauAppViewController;
	   

@interface TagesschauAppAppDelegate : NSObject <UIApplicationDelegate>
{
    UIWindow					*window;
    TagesschauAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TagesschauAppViewController *viewController;

@end

