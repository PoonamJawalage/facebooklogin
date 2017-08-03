//
//  AppDelegate.h
//  fb_login
//
//  Created by Pipl-10 on 31/07/17.
//  Copyright © 2017 Pipl-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
-(void)openActiveSessionWithPermissions:(NSArray *)permissions  allowLoginUI:(BOOL)allowLoginUI;//for facebook integration


@end

