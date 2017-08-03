//
//  ViewController.m
//  fb_login
//
//  Created by Pipl-10 on 31/07/17.
//  Copyright © 2017 Pipl-10. All rights reserved.
//

#import "ViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface ViewController ()
{
    
    UIView *blurView;
    UIActivityIndicatorView *spinner;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnfbLogin:(id)sender {
    
    NSString *str1=@"yes";
    
    
    NSUserDefaults *prefs =[NSUserDefaults standardUserDefaults];
    [prefs setObject:str1 forKey:@"facebook"];
    
    if ([FBSession activeSession].state != FBSessionStateOpen &&
        [FBSession activeSession].state != FBSessionStateOpenTokenExtended) {
        
        [self.appDelegate  openActiveSessionWithPermissions:@[@"public_profile", @"email"]  allowLoginUI:YES];
        
    }
    else{
        // Close an existing session.
        [[FBSession activeSession] closeAndClearTokenInformation];
        
        // Update the UI.
        
    }
}
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification{
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    blurView=[[UIView  alloc]initWithFrame:CGRectMake(self.view.frame.origin.x,0,self.view.frame.size.width,self.view.frame.size.height+50)];
    blurView.backgroundColor=[UIColor colorWithRed:0/255.0f  green:0/255.0f blue:0/255.0f alpha:0.5f];
    [self.view addSubview:blurView];
    
    spinner = [[UIActivityIndicatorView alloc]  initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.frame = CGRectMake(blurView.frame.size.width/2-20,  blurView.frame.size.height/2, 40.0, 40.0);
    //  spinner.center = self.view.center;
    [blurView addSubview:spinner];
    [spinner startAnimating];
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen) {
            // The session is open. Get the user information and update the UI.
            
            [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                if (!error) {
                    NSLog(@"%@", result);
                }
                
            }];
            
            
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          facebookfirstname = [NSString stringWithFormat:@"%@",[result objectForKey:@"first_name"]];
                                          facebooklastname = [NSString stringWithFormat:@"%@",
                                                              [result objectForKey:@"last_name"]];
                                          facebookid= [NSString stringWithFormat:@"%@",  [result objectForKey:@"id"]];
                                          facebookemail = [NSString stringWithFormat:@"%@",  [result objectForKey:@"email"]];
                                          
                                          
//                                          
//                                          [self socialFacebookLogin];
                                          
                                          
                                      }
                                      else{
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
            [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
            //            self.lblStatus.text = @"You are not logged in.";
            //            self.activityIndicator.hidden = YES;
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
        
        //        [self hideUserInfo:YES];
        //        [self.btnToggleLoginState setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    
    
}
//-(void)socialFacebookLogin
//{
//    
//    
//    NSUserDefaults *userDefaultObj=[NSUserDefaults standardUserDefaults];
//    NSString *parameter;
//    parameter=[NSString stringWithFormat:@"first_name=%@&last_name=%@&social_id=%@&social_type=%@&email=%@&device_id=%@&device_token_id=%@",facebookfirstname,facebooklastname,facebookid,@"facebook",facebookemail,@"1",
//               @"123456"];
//    //    parameter=[NSString stringWithFormat:@"first_name=%@&last_name=%@&user_email=%@&user_type=%@&fb_id=%@&google_id=%@",facebookfirstname,facebooklastname,facebookemail,[userDefaultObj objectForKey:@"usertype"],facebookid,@""];
//    
//    //first_name,last_name,social_id,social_type,email,device_id,device_token_id
//    BaseViewController *obj=[[BaseViewController alloc]init];
//    
//    NSString *strWebservice = @"ws-social-login";
//    
//    NSString *strWebserviceCompleteURL = [NSString stringWithFormat:@"%@%@",str_global_domain,strWebservice] ;
//    
//    NSDictionary *dict=[obj WebParsingMethod:strWebserviceCompleteURL:parameter];
//    
//    //NSString *message=[NSString stringWithFormat:@"%@",[dict valueForKey:@"msg"]];
//    NSString *strErrorCode=[NSString stringWithFormat:@"%@",[dict valueForKey:@"error_code"]];
//    NSString *mssg=[NSString stringWithFormat:@"%@",[dict valueForKey:@"msg"]];
//    NSLog(@"dic=%@",dict);
//    //  NSDictionary *responseData=[dict objectForKey:@"Response"];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        [spinner stopAnimating];
//        [blurView removeFromSuperview];
//        @try {
//            
//            if([strErrorCode isEqualToString:@"0"])
//            {
//                
//                
//                //
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"You have logged in successfully." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//                
//                NSDictionary *User_Data=[dict valueForKey:@"data"];
//                
//                NSString *strLoginUserID = [NSString stringWithFormat:@"%@",[User_Data valueForKey:@"user_id"]];
//                NSString *strEmail = [NSString stringWithFormat:@"%@",_txtEmailaddress.text];
//                NSString *strFirstNmae = [NSString stringWithFormat:@"%@",[User_Data valueForKey:@"first_name"]];
//                NSString *strLastName = [NSString stringWithFormat:@"%@",[User_Data valueForKey:@"last_name"]];
//                
//                
//                
//                
//                NSString *strComapanyName = [NSString stringWithFormat:@"%@",[User_Data valueForKey:@"company_name"]];
//                NSString *strUserProfile=[NSString stringWithFormat:@"%@",[User_Data valueForKey:@"profile_picture"]];
//                NSString *strParent_id=[NSString stringWithFormat:@"%@",[User_Data valueForKey:@"parent_id"]];
//                
//                NSString *str_pinnumber=[NSString stringWithFormat:@"%@",[User_Data valueForKey:@"pincode"]];
//                NSString *gender=[NSString stringWithFormat:@"%@",[User_Data valueForKey:@"gender"]];
//                NSString *strPassword=[NSString stringWithFormat:@"%@",[User_Data valueForKey:@"password"]];
//                NSString *strUserType;
//                if ([strParent_id isEqualToString:@"0"]) {
//                    strUserType = [NSString stringWithFormat:@"%@",[User_Data valueForKey:@"user_type"]];
//                }else{
//                    strUserType=@"7";
//                    
//                    
//                }
//                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
//                [defaults setObject:@"login" forKey:@"status"];
//                [defaults setObject:strLoginUserID forKey:@"user_id"];
//                [defaults setObject:strEmail forKey:@"user_email"];
//                [defaults setObject:strFirstNmae forKey:@"first_name"];
//                [defaults setObject:strUserType forKey:@"user_type"];
//                [defaults setObject:strComapanyName forKey:@"company_name"];
//                [defaults setObject:strLastName forKey:@"last_name"];
//                [defaults setObject:strUserProfile  forKey:@"profile_picture"];
//                [defaults setObject:strParent_id  forKey:@"parent_id"];
//                [defaults setObject:str_pinnumber  forKey:@"pincode"];
//                [defaults setObject:gender  forKey:@"gender"];
//                [defaults setObject:strPassword  forKey:@"password"];
//                [defaults synchronize];
//                
//                //
//                
//                DashBoardViewController *obj=[[DashBoardViewController alloc]initWithNibName:@"DashBoardViewController" bundle:nil];
//                self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//                
//                
//                
//                [self.navigationController pushViewController:obj animated:YES];
//
//            }
//            
//            
//            else if ([strErrorCode isEqualToString:@"2"])
//            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:mssg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil , nil];
//                [alert show];
//                
//                LoginViewController1 *obj=[[LoginViewController1 alloc]initWithNibName:@"LoginViewController1" bundle:nil];
//                [self.navigationController pushViewController:obj animated:YES];
//            }else if([strErrorCode isEqualToString:@"4"]){
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"User data not available"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                [alert show];
//                
//            }
//            
//            
//        }
//        @catch (NSException *exception) {
//            
//            
//        }
//        @finally {
//            
//            
//        }
//    });
//    
//}


@end
