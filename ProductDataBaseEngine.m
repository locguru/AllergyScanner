//
//  ProductDataBaseEngine.m
//  AllergyScanner
//
//  Created by Itai Ram on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProductDataBaseEngine.h"
#import "JSON.h"
#import "FlurryAnalytics.h"

@implementation ProductDataBaseEngine

@synthesize engineKey;
@synthesize engineMethod;
@synthesize success;
@synthesize engineBarcode;
@synthesize engingJsonDict;

- (void) productDataBaseEngine {
    
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];    
    
    //BUILDING DATA OBJECT FOR SIMPLEUPC API POST CALL
    [jsonDict setObject:engineKey forKey:@"auth"];
    [jsonDict setObject:engineMethod forKey:@"method"];
    [paramsDict setObject:engineBarcode forKey:@"upc"];    
    [jsonDict setObject:paramsDict forKey:@"params"];
    
   // NSLog(@"jsonDict %@", jsonDict);
    
    //POSTING REQUEST DATA
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *jsonString = [jsonWriter stringWithObject:jsonDict];
    NSData *myJSONData =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://api.simpleupc.com/v1.php"]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:myJSONData];
    
    //ANALYZING JSON RESPONSE 
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding];
    
    //GETTING THE JSON TO AN NSDICTIONARY 
    engingJsonDict = [theResponseString JSONValue];
    success = [engingJsonDict valueForKey:@"success"];
    
//    NSLog(@"engingJsonDict %@", ingredientsArray);

    //FLURRY ZONE
    if (engineMethod == @"FetchNutritionFactsByUPC")
    {
        NSDictionary *myDict = [[NSDictionary alloc] init];
        myDict = [engingJsonDict valueForKey:@"result"];
        NSString *ingredientsArray = [myDict valueForKeyPath:@"ingredients"];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:ingredientsArray, @"Ingredients from API call", nil];
        [FlurryAnalytics logEvent:@"DATA FROM SIMPLEUPC API CALL - INGREDIENTS" withParameters:dictionary];
    }
    else 
    {
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:engingJsonDict, @"engingJsonDict from API call", nil];
        [FlurryAnalytics logEvent:@"DATA FROM SIMPLEUPC API CALL" withParameters:dictionary];    
    }
}

@end
