//
//  AppDelegate.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "FlurryAnalytics.h"
#import "TapjoyConnect.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //FLURRY SUPPORT 
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:@"E9PRSX4H85K89P33LPRB"];
    
    //TAPJOB INTEGRATION
    [TapjoyConnect requestTapjoyConnect:@"c8252da2-e73e-413b-b785-38e6f2b165f8" secretKey:@"uwFLSrYaduiVvGqrNCLA"];
    
    //CHECK IF THE APP IS UP TO DATE
    NSDate *lastStartDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"lastStartDate"];
    
    NSLog(@"lastStartDate is %@", lastStartDate);
    
    
    if (!lastStartDate) 
    {
        // Never launched -- do nothing
        NSLog(@"app launches for the first time");
    } 
    else if ([[NSDate date] timeIntervalSinceDate:lastStartDate] > (60. * 60. * 24. * 7.)) //(60. * 60. * 24. * 7.)
    {
        NSLog(@"[lastStartDate timeIntervalSinceNow] is %f", [[NSDate date] timeIntervalSinceDate:lastStartDate]);
        
        //CHECK AND SHOW VERION ALERT IF THE APP HASN'T BEEN VISITED FOR OVER A WEEK
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.delengo.com/allergyscannerlatestversion.php"]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *request, NSData *data, NSError *error) 
         {
             if (!error) 
             {
                 NSString *lastestVersion = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];            
                 float yourVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]floatValue];
                 NSLog(@"lastestVersion is %f and your version is %f", [lastestVersion floatValue], yourVersion);
                 
                 if (yourVersion < [lastestVersion floatValue])
                 {
                     UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"Allergy Scanner"
                                                                   message:@"An update for this app is available on the App Store. Would you like to download it?"
                                                                  delegate:self
                                                         cancelButtonTitle:@"No"
                                                         otherButtonTitles:@"Yes", nil];
                     [alert show];
                 }
                 else 
                 {
                     NSLog(@"Application version is up to date");
                 }
             }
         }];
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"lastStartDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else 
    {
        NSLog(@"Not enough time has elapsed for the update notification to show up");
    }
    

    
    //WINDOW CALL
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    UINavigationController *navCntrl1 = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    NSString* versionNumber = [[UIDevice currentDevice] systemVersion];
    //NSLog(@"versionNumber %@", versionNumber);
    
    int version;
    version = [versionNumber intValue];
    //NSLog(@"versionNumber %d", version);
    
    //IF iOS VERIONS IS HIGER THAN 5 - USE NEW APPEARANCE API
    if (version >= 5)
    {
        [[UINavigationBar appearance] setTintColor:[UIColor blackColor] ];
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor brownColor] ];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorWithRed:170/255.f green:140/255.f blue:90/255.f alpha:1] ];
//        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:[UIColor colorWithRed:191/255.f green:176/255.f blue:137/255.f alpha:1] ];
    }
    
    self.window.rootViewController = navCntrl1;
    [self.window makeKeyAndVisible];
    return YES;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL* appStoreURL=[NSURL URLWithString:@"http://itunes.apple.com/us/app/allergy-scanner/id519416166?mt=8"];
        if ([[UIApplication sharedApplication] canOpenURL:appStoreURL]) {
            [[UIApplication sharedApplication] openURL:appStoreURL];
        }
    }
}


//FLURRY METHOD
void uncaughtExceptionHandler(NSException *exception) {
    
    NSArray *backtrace = [exception callStackSymbols];
    NSString *version = [[UIDevice currentDevice] systemVersion];
    NSString *message = [NSString stringWithFormat:@"CRASH! OS: %@. Backtrace:\n%@",version, backtrace];
    
    [FlurryAnalytics logError:@"Uncaught" message:message exception:exception];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[_viewController facebook] handleOpenURL:url];
}



@end
