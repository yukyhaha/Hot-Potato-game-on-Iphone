//
//  HotPotAppDelegate.h
//  HotPot
//
//  Created by Yun on 12/11/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HotPotViewController;

@interface HotPotAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HotPotViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HotPotViewController *viewController;

@end

