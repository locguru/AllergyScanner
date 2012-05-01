//
//  ProductDataBaseEngine.m
//  AllergyScanner
//
//  Created by Itai Ram on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDataBaseEngine.h"
#import "JSON.h"

@implementation ProductDataBaseEngine

@synthesize engineKey;
@synthesize engineMethod;
@synthesize success;
@synthesize engineBarcode;
@synthesize engingJsonDict;


- (void) productDataBaseEngine {
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];    
    
    [jsonDict setObject:engineKey forKey:@"auth"];
    [jsonDict setObject:engineMethod forKey:@"method"];
    [paramsDict setObject:engineBarcode forKey:@"upc"];    
    [jsonDict setObject:paramsDict forKey:@"params"];
    
    //POSTING REQUEST DATA
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *jsonString = [jsonWriter stringWithObject:jsonDict];
    NSData *myJSONData =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://api.simpleupc.com/v1.php"]];
    
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: myJSONData];
    
    //ANALYZING JSON RESPONSE 
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding];
    
    //GETTING THE JSON TO AN NSDICTIONARY 
//    NSDictionary *json_dict = [theResponseString JSONValue];
    engingJsonDict = [theResponseString JSONValue];

    NSLog(@"response json_dict\n%@",engingJsonDict);
    
  //  NSString *success = [[NSString alloc] init];
    success = [engingJsonDict valueForKey:@"success"];

}

@end
