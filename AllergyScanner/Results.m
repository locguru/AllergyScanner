//
//  Results.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Results.h"
#import "JSON.h"
#import "IngredientsProcessor.h"
//#import "History.h"
#import "ServerConnectionController.h"
#import "ViewController.h"
#import "FlurryAnalytics.h"

@implementation Results

@synthesize description;
@synthesize brand;
@synthesize dismissResults;
@synthesize productBrand;
@synthesize productDescription;
@synthesize ingredients;
@synthesize tempBarcode;
@synthesize userAllergyText;
@synthesize ingredientsProcessorObject;
@synthesize key;
@synthesize success;
@synthesize alert;

@synthesize HistoryMgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tempBarcode = [[NSString alloc] init];
        userAllergyText = [[NSString alloc] init];
        key = [[NSString alloc] init];
        ingredientsProcessorObject = [[IngredientsProcessor alloc] init];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"Results";
    
    //BACKGROUND COLOR 
    //   self.view.backgroundColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown_back.png"]];
    
    //ADDING DISMISS BUTTON
    dismissResults = [[UIButton alloc] init];
    dismissResults = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissResults addTarget:self action:@selector(dismissScreen:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* doneImage = [UIImage imageNamed:@"done_button.png"];    
    dismissResults.frame = CGRectMake((320 - doneImage.size.width/2)/2, 340, doneImage.size.width/2, doneImage.size.height/2);
    [dismissResults setImage:doneImage forState:UIControlStateNormal];
    dismissResults.contentMode = UIViewContentModeScaleToFill;
//    dismissResults.frame = CGRectMake(70, 340, 180, 40.0);
//    [dismissResults setTitle: @"Done" forState: UIControlStateNormal];
    [self.view addSubview:dismissResults];   
    
    //IMAGE VIEWS 
    UIImageView *resultsImage = [[UIImageView alloc] initWithFrame:CGRectMake((320-340*0.75)/2, 25, 340*0.75, 45*0.75)]; 
    resultsImage.image = [UIImage imageNamed:@"scanning_results_title.png"];
    [self.view addSubview: resultsImage];

    
    
    //LABELS AREA
    description = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 120, 40)];
    description.text = @"Product:";
	description.backgroundColor = [UIColor clearColor];
    description.font = [UIFont boldSystemFontOfSize:16];
    description.numberOfLines = 0;
    description.lineBreakMode = UILineBreakModeWordWrap;
    //	[self.view addSubview:description];
    
    productDescription = [[UILabel alloc] initWithFrame:CGRectMake(160, 20, 160, 40)];   
    productDescription.text = @"";
    productDescription.backgroundColor = [UIColor clearColor]; 
    productDescription.font = [UIFont systemFontOfSize:16];
    productDescription.numberOfLines = 0;
    productDescription.lineBreakMode = UILineBreakModeWordWrap;
    //	[self.view addSubview:productDescription];
    
    brand = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 120, 40)];
    brand.text = @"Brand:";
	brand.backgroundColor = [UIColor clearColor]; 
    brand.font = [UIFont boldSystemFontOfSize:16];
    //	[self.view addSubview:brand];
    
    productBrand = [[UILabel alloc] initWithFrame:CGRectMake(160, 60, 160, 40)];
    productBrand.text = @"";
    productBrand.backgroundColor = [UIColor clearColor]; 
    productBrand.font = [UIFont systemFontOfSize:16];
    //	[self.view addSubview:productBrand];
    
    ingredients = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 280, 120)];   
    ingredients.text = @"Ingredients";
    ingredients.backgroundColor = [UIColor clearColor]; 
    ingredients.numberOfLines = 0;
    ingredients.font = [UIFont systemFontOfSize:14];
    ingredients.lineBreakMode =  UILineBreakModeWordWrap; //UILineBreakModeCharacterWrap;
    
    success = [[NSString alloc] init];
    alert = [[UIAlertView alloc] init];
    HistoryMgr = [[History alloc] init];
    HistoryMgr.delegate = self;
    [HistoryMgr blabla];
    [HistoryMgr addNewItem:@"new pro" withNewBrand:@"new brand"];
    [self getProductInfo:nil];
    
}

- (void) getProductInfo:(id)sender {
    
    //API CALLS
    //    NSLog(@"BARCODE IS: %@", tempBarcode);
    //    NSLog(@"USER ALERGY IS: %@", userAlergy);

    [self lookupAlergie:tempBarcode withMethod:@"FetchProductByUPC" withAlergy:userAllergyText];
    
    NSLog(@"productDescription.text IS: %@", productDescription.text);
    NSLog(@"productDescription IS: %d", [productDescription.text length]);
    NSLog(@"success IS %@",success);

    
    int version;
    version = [success intValue];
    NSLog(@"versionNumber %d", version);
    
    if (version == 0)
        NSLog(@"SUVVESSS");
    
    
    //ERROR API CALL BACK
 //   if (version == 0){
         if (0){

        alert = [[UIAlertView alloc] initWithTitle:@"AllergyScanner" 
                                           message:@"Service unavailable. Please try again later."
                                          delegate:self 
                                 cancelButtonTitle:nil 
                                 otherButtonTitles:@"Ok", nil];
        [alert show];
        [self.parentViewController.view removeFromSuperview];
    }
    //PRODUCT DOESNT EXIST 
//    else if ([productDescription.text length] == 0){
        else if (0){
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:productDescription.text, @"productDescription.text", nil];
        [FlurryAnalytics logEvent:@"GETPRODUCTINFO METHOD: PRODUCT WAS NOT FOUND IN DB" withParameters:dictionary];

            
        alert = [[UIAlertView alloc] initWithTitle:@"Item Not Found" 
                                                        message:@"This product was not found in the database"
                                                       delegate:self 
                                              cancelButtonTitle:nil 
                                              otherButtonTitles:@"Ok", nil];
        [alert show];
        [self.parentViewController.view removeFromSuperview];

    }
    //ALL GOOD
    else{
        [self lookupAlergie:tempBarcode withMethod:@"FetchNutritionFactsByUPC" withAlergy:userAllergyText];
    }
  
//     if ([productDescription.text length] != 0 && version == 1){
//         
//         [self lookupAlergie:tempBarcode withMethod:@"FetchNutritionFactsByUPC" withAlergy:userAllergyText];
//     }

}

- (void) lookupAlergie:(NSString *)barcodeLabel withMethod:(NSString *) method withAlergy:(NSString *)allergyText{
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:allergyText, @"allergyText", nil];
    [FlurryAnalytics logEvent:@"ENTERING LOOKUPALLERGY METHOD" withParameters:dictionary];

    
    
//    HistoryMgr = [[History alloc] init];
//    HistoryMgr.delegate = self;
//    [HistoryMgr blabla];
//    
    
    
    
    NSLog(@"BARCODE IS: %@", barcodeLabel);
    
    //POSTING JSON OBJECT TO WEBSERVER  
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];    
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];    
    
    
    //    //RETREIVING ACCESS KEY FROM THE WEB SERVER 
    //    ServerConnectionController *serverConnectionObject = [[ServerConnectionController alloc] init];
    //    [serverConnectionObject retreiveAccessKey:nil];
    //    NSString *keyAccess = [[NSString alloc] initWithFormat:serverConnectionObject.accessKey];
    //    //key = serverConnectionObject.accessKey;
    //    NSLog(@"KEY IS %@", keyAccess);
    //    
    //    
    //    NSLog(@"KEY LENGTH IS %d", [keyAccess length]);
    //
    //    
    
    NSLog(@"KEY IS %@", key);
    
    [jsonDict setObject:key forKey:@"auth"];
    // [jsonDict setObject:@"vaovqQqM4MHEXviNlTt5qp7ZBLva3lM" forKey:@"auth"];
    //    NSLog(@"jsonDict is %@", jsonDict);
    [jsonDict setObject:method forKey:@"method"];
    [jsonDict setObject:paramsDict forKey:@"params"];
    [paramsDict setObject:barcodeLabel forKey:@"upc"];    
    
    
    //   NSLog(@"JSON STRING: %@", jsonDict);
    
    SBJsonWriter *jsonWriter = [SBJsonWriter new];
    NSString *jsonString = [jsonWriter stringWithObject:jsonDict];
    NSData *myJSONData =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    //POSTING REQUEST DATA
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://api.simpleupc.com/v1.php"]];
    [request setHTTPMethod: @"POST"];
    [request setHTTPBody: myJSONData];
    
    //ANALYZING JSON RESPONSE 
    NSURLResponse *theResponse = NULL;
    NSError *theError = NULL;
    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
    NSString *theResponseString = [[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding];
    
    //GETTING THE JSON TO AN NSDICTIONARY 
    NSDictionary *json_dict = [theResponseString JSONValue];
    NSLog(@"response json_dict\n%@",json_dict);
    
    success = [json_dict valueForKey:@"success"];
    
    //FETCHING BASIC PRODUCT INFO
    if ([method isEqualToString:@"FetchProductByUPC"])
    {
        NSDictionary *myDict = [[NSDictionary alloc] init];
        myDict = [json_dict valueForKey:@"result"];
        
        productBrand.text = [myDict valueForKey:@"brand"];
        productDescription.text = [myDict valueForKey:@"description"];
        
        NSLog(@"string: %@, length %d", productDescription.text, [productDescription.text length]);
        
        if ([productDescription.text length] != 0){
            [self.view addSubview:description];
            [self.view addSubview:productDescription];
            [self.view addSubview:brand];
            [self.view addSubview:productBrand];
            
            //LOADING NSUserDefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];            
            NSArray *brandsArray = [defaults arrayForKey:@"brands"]; 
            NSArray *productNamesArray = [defaults arrayForKey:@"productNames"]; 
            
            //LOCAL DB IS EMPTY - ADDING THE CURRENT PRODUCT BEING SCANNED 
            if ([brandsArray count] == 0) {
                
                NSArray *brandsArrayTemp = [[ NSArray alloc] initWithObjects:productBrand.text, nil];  
                NSArray *productNamesArrayTemp = [[ NSArray alloc] initWithObjects:productDescription.text, nil];  
                
                NSLog(@"brandsArrayTemp array %@", brandsArrayTemp);
                NSLog(@"productNamesArrayTemp array %@", productNamesArrayTemp);
                
                [defaults setObject:brandsArrayTemp forKey:@"brands"];  //set the prev Array for key value "favourites"
                [defaults setObject:productNamesArrayTemp forKey:@"productNames"];  //set the prev Array for key value "favourites"
                
                brandsArray = [defaults arrayForKey:@"brands"]; 
                NSLog(@"favorites array %@", brandsArray);
                
            }
            //LOCAL DB IS NOT EMPTY - READINIG IT, ADDING THE CURRENT PRODUCT, AND WRITING BACK
            else
            {
                
                NSLog(@"favorites array %@ %@", brandsArray, productNamesArray);
                
                NSMutableArray *brandsArrayTemp = [[NSMutableArray alloc] initWithArray:brandsArray]; 
                //[brandsArrayTemp addObject:productBrand.text];
                [brandsArrayTemp insertObject:productBrand.text atIndex:0]; 
                NSMutableArray *productNamesArrayTemp = [[NSMutableArray alloc] initWithArray:productNamesArray];  
                //[productNamesArrayTemp addObject:productDescription.text];
                [productNamesArrayTemp insertObject:productDescription.text atIndex:0];
                
                NSLog(@"brandsArrayTemp array %@", brandsArrayTemp);
                NSLog(@"productNamesArrayTemp array %@", productNamesArrayTemp);
                
                [defaults setObject:brandsArrayTemp forKey:@"brands"];  //set the prev Array for key value "favourites"
                [defaults setObject:productNamesArrayTemp forKey:@"productNames"];  //set the prev Array for key value "favourites"
                
            }
            
        }
        else
        {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Not Found" 
//                                                            message:@"This product was not found in the database"
//                                                           delegate:self 
//                                                  cancelButtonTitle:nil 
//                                                  otherButtonTitles:@"Ok", nil];
//            [alert show];
//            [self.parentViewController.view removeFromSuperview];
        }
    }
    
    //FETCHING INGREDIENTS INFO
    else if ([method isEqualToString:@"FetchNutritionFactsByUPC"])
    {
        NSDictionary *myDict = [[NSDictionary alloc] init];
        myDict = [json_dict valueForKey:@"result"]; 
        //NSLog(@"SIZE %@", myDict);
        NSString *myArray = [json_dict valueForKeyPath:@"result.ingredients"];
        //NSLog(@"SIZE %@", myArray);
        
        if ([myArray length] == 0)
        {
            
            NSLog(@"SIZE of myArray %d", [myArray length]);
            
            UIAlertView *ingredientsAlert = [[UIAlertView alloc] initWithTitle:@"Missing Ingredients" 
                                                                       message:@"We could not determine if you may be allergic to this product since the ingredients are not available"
                                                                      delegate:self 
                                                             cancelButtonTitle:nil 
                                                             otherButtonTitles:@"Ok", nil];
            [ingredientsAlert show];
        }
        else
        {
            

            [self.view addSubview:ingredients];
            [self processIngredients:myArray];
        }
        
    }
    //OTHER API CALL METHOD
    else 
    {
        
    }
    
}


- (void) processIngredients:(NSString *) listOfIngredients {
    
    [ingredientsProcessorObject ingredientsEngine:userAllergyText withIngreients:listOfIngredients];
    
    if ([ingredientsProcessorObject.badIngredients count] == 0) 
    {
        [FlurryAnalytics logEvent:@"ENTERING PROCESSINGREDIENTS METHOD - PRODUCT DOESN'T CONTAIN USER ALLERGY"];

        ingredients.text = [NSString stringWithFormat:@"%@ %@", @"This product does not contain", userAllergyText];
        
    }
    else
    {
        //        ingredients.text = [ingredientsProcessorObject.badIngredients description]; //converting an NSArray to an NSString
        NSString *tempOutputText = [[ingredientsProcessorObject.badIngredients valueForKey:@"description"] componentsJoinedByString:@", "];
        ingredients.text = [NSString stringWithFormat:@"%@ %@ %@ %@", @"This product may not be good for", userAllergyText, @"allergy since it containts the following ingredients:", tempOutputText];
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:ingredients.text, @"ingredients.text", nil];
        [FlurryAnalytics logEvent:@"ENTERING PROCESSINGREDIENTS METHOD - SAVING THE BAD INGRESIENTS STRING" withParameters:dictionary];

    }
    
}

- (IBAction) dismissScreen : (id)sender
{
    
    //     [self.parentViewController.view removeFromSuperview];
    //    [self.view removeFromSuperview];
    ////    [self dismissModalViewControllerAnimated:YES];
    
    ViewController *aboutViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    aboutNavigationController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;    
    [self presentModalViewController:aboutNavigationController animated:YES];
     
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}

@end
