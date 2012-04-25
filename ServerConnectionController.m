//
//  ServerConnectionController.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ServerConnectionController.h"
#import "JSON.h"

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
    [request setTimeoutInterval:60.0];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    accessKey = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    
    NSArray *myArray = [accessKey componentsSeparatedByString:@"\n"];
    accessKeyArray = [accessKey componentsSeparatedByString:@"\n"];
    
    
    
    //    //PARSING THE JSON DATA
    //    
    //    
    //    NSLog(@"accessKey IS %@", accessKey);
    //    NSLog(@"accessKeyArray IS %@", accessKeyArray);
    //
    //    //ANALYZING JSON RESPONSE 
    //    NSURLResponse *theResponse = NULL;
    //    NSError *theError = NULL;
    //    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    //    NSString *theResponseString = [[[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding] autorelease];
    //
    //    NSLog(@" theResponseData\n%@",theResponseData);
    //
    //    NSLog(@" theResponseString\n%@",theResponseString);
    //
    //    //GETTING THE JSON TO AN NSDICTIONARY 
    //    //NSDictionary *json_dict = [theResponseString JSONValue];
    //    SBJSON *parser = [[SBJSON alloc] init];
    //    NSArray *statuses = [parser objectWithString:theResponseString error:nil];
    //
    //    NSLog(@"response json_dict\n%@",statuses);
    
    
    
    
    
    
    NSLog(@"accessKey IS %@", accessKey);
    NSLog(@"accessKeyArray IS %@", accessKeyArray);
    
    NSLog(@"[myArray objectAtIndex:0] IS %@", [myArray objectAtIndex:0]);
    
    accessKey = [myArray objectAtIndex:0];
    //accessKey = theResponseString;
    
    //NSLog(@"%@",[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding]);
    
    
}


#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */


@end
