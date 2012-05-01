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

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [FlurryAnalytics startSession:@"E9PRSX4H85K89P33LPRB"];
    
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

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return [[_viewController facebook] handleOpenURL:url];
}



@end
