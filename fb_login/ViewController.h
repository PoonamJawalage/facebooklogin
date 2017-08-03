//
//  ViewController.h
//  fb_login
//
//  Created by Pipl-10 on 31/07/17.
//  Copyright © 2017 Pipl-10. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface ViewController : UIViewController

{
    
    NSString    *facebookfirstname ;
    NSString     *facebooklastname ;
    NSString     *facebookid;
    NSString     *facebookemail;
    
    NSArray *fbresult;

}
@property (weak, nonatomic) IBOutlet UIButton *btnToggleLoginState;

@property (nonatomic, strong) AppDelegate *appDelegate;
@end

