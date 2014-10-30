//
//  AppDelegate.h
//  Test
//
//  Created by Suyuancheng on 14-10-17.
//  Copyright __MyCompanyName__ 2014年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"

// Added only for iOS 6 support
@interface MyNavigationController : UINavigationController <CCDirectorDelegate>
@end

@interface AppController : NSObject <UIApplicationDelegate>
{
	UIWindow *window_;
	MyNavigationController *navController_;

	CCDirectorIOS	*__weak director_;							// weak ref
}

@property (nonatomic) UIWindow *window;
@property (readonly) MyNavigationController *navController;
@property (weak, readonly) CCDirectorIOS *director;

@end
