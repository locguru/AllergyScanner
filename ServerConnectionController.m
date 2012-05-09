//
//  ServerConnectionController.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerConnectionController.h"
#import "JSON.h"
#import "FlurryAnalytics.h"

@implementation ServerConnectionController

@synthesize accessKey;
@synthesize accessKeyArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        accessKey = [[NSString alloc] init];
        accessKeyArray = [[NSArray alloc]init];
    }
    return self;
}

- (void) retreiveAccessKey:(id)sender {
    
    
    //    NSString *urlString = @"http://localhost/getkey.php";
    //    NSString *urlString =  @"http://192.168.1.112/getkey.php"; //macbook air
    //    NSString *urlString =  @"http://192.168.1.130/getkey.php"; //macbook 15"
    //    NSString *urlString =  @"http://192.168.1.102/getkey.php"; //macbook 13" (home)
    //    NSString *urlString =  @"http://67.243.61.161/getkey.php"; //macbook air external IP
    
    
    NSString *urlString =  @"http://www.delengo.com/getkey.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setTimeoutInterval:180.0];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    accessKey = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSArray *myArray = [accessKey componentsSeparatedByString:@"\n"];
    accessKeyArray = [accessKey componentsSeparatedByString:@"\n"];
    
    
    NSLog(@"accessKey IS %@", accessKey);
    NSLog(@"accessKeyArray IS %@", accessKeyArray);
    
    NSLog(@"[myArray objectAtIndex:0] IS %@", [myArray objectAtIndex:0]);
    
    accessKey = [myArray objectAtIndex:0];
   
    //FLURRY ZONE
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:accessKey, @"Access Key from server", nil];
    [FlurryAnalytics logEvent:@"RETREIVED ACCESS KEY" withParameters:dictionary];

}


@end
