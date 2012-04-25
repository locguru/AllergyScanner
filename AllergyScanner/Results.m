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
#import "ProductDataBaseEngine.h"

@implementation Results

@synthesize description;
@synthesize brand;
@synthesize dismissResults;
@synthesize productBrand;
@synthesize productDescription;
@synthesize ingredientsLabel;
@synthesize tempBarcode;
@synthesize userAllergyText;
@synthesize ingredientsProcessorObject;
@synthesize key;
@synthesize success;
@synthesize alert;
@synthesize json_dict;
@synthesize ingredientsListForProcessing;

@synthesize HistoryMgr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        tempBarcode = [[NSString alloc] init];
        userAllergyText = [[NSString alloc] init];
        key = [[NSString alloc] init];
        ingredientsProcessorObject = [[IngredientsProcessor alloc] init];
        ingredientsListForProcessing = [[NSString alloc] init];
        
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:170/255.f green:140/255.f blue:90/255.f alpha:1];
        //        label.textColor = [UIColor colorWithRed:191/255.f green:176/255.f blue:137/255.f alpha:1];
        self.navigationItem.titleView = label;
        label.text = @"Allergy Scanner";
        [label sizeToFit];

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
    
    //self.navigationItem.title = @"Results";
    
    //BACKGROUND COLOR 
    //   self.view.backgroundColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back2.png"]];
    
    //ADDING DISMISS BUTTON
    dismissResults = [[UIButton alloc] init];
    dismissResults = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissResults addTarget:self action:@selector(dismissScreen:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* doneImage = [UIImage imageNamed:@"done_button.png"];    
    dismissResults.frame = CGRectMake((320 - doneImage.size.width)/2, 340, doneImage.size.width, doneImage.size.height);
    [dismissResults setImage:doneImage forState:UIControlStateNormal];
    dismissResults.contentMode = UIViewContentModeScaleToFill;
//    dismissResults.frame = CGRectMake(70, 340, 180, 40.0);
//    [dismissResults setTitle: @"Done" forState: UIControlStateNormal];
    [self.view addSubview:dismissResults];   
    
    //IMAGE VIEWS 
    
    UIImage* resultsImageFile = [UIImage imageNamed:@"scanning_results_title.png"];    
    UIImageView *resultsImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - resultsImageFile.size.width)/2, 25, resultsImageFile.size.width, resultsImageFile.size.height)]; 
    resultsImage.image = resultsImageFile;
    [self.view addSubview: resultsImage];

    UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
    UIImageView *barImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - barImageFile.size.width)/2, 160, barImageFile.size.width, barImageFile.size.height)]; 
    //    UIImageView *barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, 320, 76)]; 
    barImage.image = [UIImage imageNamed:@"brown_bar.png"];
    [self.view addSubview: barImage];
    
//    UIImage* upImageFile = [UIImage imageNamed:@"up.png"];    
//    UIImageView *upImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - upImageFile.size.width)/2, 160 + (barImageFile.size.height-upImageFile.size.height)/2, upImageFile.size.width, upImageFile.size.height)]; 
//    upImage.image = [UIImage imageNamed:@"up.png"];
//    [self.view addSubview: upImage];


    //LABELS AREA
    description = [[UILabel alloc] initWithFrame:CGRectMake(20, 70, 120, 40)];
    description.text = @"Product:";
	description.backgroundColor = [UIColor clearColor];
    description.textColor = [UIColor whiteColor];
    description.font = [UIFont boldSystemFontOfSize:20];
    description.numberOfLines = 0;
    description.lineBreakMode = UILineBreakModeWordWrap;
    description.shadowColor = [UIColor blackColor];
    description.shadowOffset = CGSizeMake(0.5, 1);
    //	[self.view addSubview:description];
    
    productDescription = [[UILabel alloc] initWithFrame:CGRectMake(110, 70, 190, 40)];   
    productDescription.text = @"";
    productDescription.backgroundColor = [UIColor clearColor]; 
    productDescription.textColor = [UIColor whiteColor];
    productDescription.font = [UIFont systemFontOfSize:16];
    productDescription.numberOfLines = 0;
    productDescription.lineBreakMode = UILineBreakModeWordWrap;
    //	[self.view addSubview:productDescription];
    
    brand = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 120, 40)];
    brand.text = @"Brand:";
	brand.backgroundColor = [UIColor clearColor]; 
    brand.textColor = [UIColor whiteColor];
    brand.font = [UIFont boldSystemFontOfSize:20];
    brand.shadowColor = [UIColor blackColor];
    brand.shadowOffset = CGSizeMake(0.5, 1);
    //	[self.view addSubview:brand];
    
    productBrand = [[UILabel alloc] initWithFrame:CGRectMake(110, 110, 190, 40)];
    productBrand.text = @"";
    productBrand.backgroundColor = [UIColor clearColor]; 
    productBrand.textColor = [UIColor whiteColor];
    productBrand.font = [UIFont systemFontOfSize:16];
    //	[self.view addSubview:productBrand];
    
    ingredientsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 210, 280, 120)];   
    ingredientsLabel.text = @"Ingredients";
    ingredientsLabel.backgroundColor = [UIColor clearColor]; 
    ingredientsLabel.textColor = [UIColor whiteColor];
    ingredientsLabel.numberOfLines = 0;
    ingredientsLabel.font = [UIFont boldSystemFontOfSize:16];
    [ingredientsLabel setTextAlignment:UITextAlignmentCenter];
    ingredientsLabel.lineBreakMode =  UILineBreakModeWordWrap; //UILineBreakModeCharacterWrap;
    
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
    [self lookupAlergie:tempBarcode withMethod:@"FetchNutritionFactsByUPC" withAlergy:userAllergyText];
    
//    NSLog(@"productDescription.text IS: %@", productDescription.text);
//    NSLog(@"productDescription IS: %d", [productDescription.text length]);
//    NSLog(@"success IS %@",success);
//
//    int version;
//    version = [success intValue];
//    NSLog(@"versionNumber %d", version);
//    
//    if (version == 0)
//        NSLog(@"SUVVESSS");
//    
//    
//    //ERROR API CALL BACK
//    if (version == 0){
//        // if (0){
//
//        alert = [[UIAlertView alloc] initWithTitle:@"AllergyScanner" 
//                                           message:@"Service unavailable. Please try again later."
//                                          delegate:self 
//                                 cancelButtonTitle:nil 
//                                 otherButtonTitles:@"Ok", nil];
//        [alert show];
//        [self.parentViewController.view removeFromSuperview];
//    }
//PRODUCT DOESNT EXIST 
//    if ([productDescription.text length] == 0){
//    //    else if (0){
//        
//        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:productDescription.text, @"productDescription.text", nil];
//        [FlurryAnalytics logEvent:@"GETPRODUCTINFO METHOD: PRODUCT WAS NOT FOUND IN DB" withParameters:dictionary];
//
//            
//        alert = [[UIAlertView alloc] initWithTitle:@"Item Not Found" 
//                                                        message:@"This product was not found in the database"
//                                                       delegate:self 
//                                              cancelButtonTitle:nil 
//                                              otherButtonTitles:@"Ok", nil];
//        [alert show];
//        [self.parentViewController.view removeFromSuperview];
//
//    }
//    //ALL GOOD
//    else{
//        [self lookupAlergie:tempBarcode withMethod:@"FetchNutritionFactsByUPC" withAlergy:userAllergyText];
//    }
//  
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
    
    //POSTING JSON OBJECT TO WEBSERVER  
    ProductDataBaseEngine *dbEngine = [[ProductDataBaseEngine alloc] init];
    dbEngine.engineKey = key;
    dbEngine.engineMethod = method;
    dbEngine.engineBarcode = barcodeLabel;
    
    [dbEngine productDataBaseEngine];
    
    NSDictionary *myDict = [[NSDictionary alloc] init];
    myDict = [dbEngine.engingJsonDict valueForKey:@"result"];
    NSString *tempProductDescription = [[NSString alloc] init];
    tempProductDescription= [myDict valueForKey:@"description"];
    
    NSLog(@"dbEngine.json_dict is %@", dbEngine.engingJsonDict);
    NSLog(@"tempProductDescription is %@", tempProductDescription);
    NSLog(@"[tempProductDescription length] is %d", [tempProductDescription length]);
    NSLog(@"success is %@", [dbEngine.engingJsonDict valueForKey:@"success"]);

    
    
    
    
//    NSLog(@"BARCODE IS: %@", barcodeLabel);
//    
//    //POSTING JSON OBJECT TO WEBSERVER  
//    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];    
//    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];    
//    
//    
//    //    //RETREIVING ACCESS KEY FROM THE WEB SERVER 
//    //    ServerConnectionController *serverConnectionObject = [[ServerConnectionController alloc] init];
//    //    [serverConnectionObject retreiveAccessKey:nil];
//    //    NSString *keyAccess = [[NSString alloc] initWithFormat:serverConnectionObject.accessKey];
//    //    //key = serverConnectionObject.accessKey;
//    //    NSLog(@"KEY IS %@", keyAccess);
//    //    
//    //    
//    //    NSLog(@"KEY LENGTH IS %d", [keyAccess length]);
//    //
//    //    
//    
//    NSLog(@"KEY IS %@", key);
//    NSLog(@"method IS %@", method);
//    NSLog(@"paramsDict IS %@", paramsDict);
//    NSLog(@"barcodeLabel IS %@", barcodeLabel);
//
//    [jsonDict setObject:key forKey:@"auth"];
//    //[jsonDict setObject:@"FEW9sSVjaHhZux2oRuQ7wlK4xt1D3d0e" forKey:@"auth"];
//    //    NSLog(@"jsonDict is %@", jsonDict);
//    [jsonDict setObject:method forKey:@"method"];
//    [jsonDict setObject:paramsDict forKey:@"params"];
//    [paramsDict setObject:barcodeLabel forKey:@"upc"];    
//    
//    
//    NSLog(@"JSON STRING: %@", jsonDict);
//    
//    SBJsonWriter *jsonWriter = [SBJsonWriter new];
//    NSString *jsonString = [jsonWriter stringWithObject:jsonDict];
//    NSData *myJSONData =[jsonString dataUsingEncoding:NSUTF8StringEncoding];
//    
//    //POSTING REQUEST DATA
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: [NSURL URLWithString: @"http://api.simpleupc.com/v1.php"]];
//    [request setHTTPMethod: @"POST"];
//    [request setHTTPBody: myJSONData];
//    
//    //ANALYZING JSON RESPONSE 
//    NSURLResponse *theResponse = NULL;
//    NSError *theError = NULL;
//    NSData *theResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&theResponse error:&theError];
//    NSString *theResponseString = [[NSString alloc] initWithData:theResponseData encoding:NSUTF8StringEncoding];
//    
//    //GETTING THE JSON TO AN NSDICTIONARY 
//    NSDictionary *json_dict = [theResponseString JSONValue];
//    NSLog(@"response json_dict\n%@",json_dict);
//    
//    success = [json_dict valueForKey:@"success"];
    
    //FETCHING BASIC PRODUCT INFO
    if ([method isEqualToString:@"FetchProductByUPC"])
    {
//        NSDictionary *myDict = [[NSDictionary alloc] init];
//        myDict = [json_dict valueForKey:@"result"];
//        
//        productBrand.text = [myDict valueForKey:@"brand"];
//        productDescription.text = [myDict valueForKey:@"description"];
//        NSLog(@"json_dict is %@",json_dict);
//
//        NSLog(@"myDict is %@",myDict);
//
//        NSLog(@"productBrand.text is %@",productBrand.text);
//        NSLog(@"productDescription.text  is %@",productDescription.text );
//        
//        NSLog(@"string: %@, length %d", productDescription.text, [productDescription.text length]);
        
        NSLog(@"myDict is %@",myDict);
        productBrand.text = [myDict valueForKey:@"brand"];
        productDescription.text = [myDict valueForKey:@"description"];

            [self.view addSubview:description];
            [self.view addSubview:productDescription];
            [self.view addSubview:brand];
            [self.view addSubview:productBrand];
            
            //LOADING NSUserDefaults
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];            
            NSArray *brandsArray = [defaults arrayForKey:@"brands"]; 
            NSArray *productNamesArray = [defaults arrayForKey:@"productNames"]; 
            
            //LOCAL DB IS EMPTY - ADDING THE CURRENT PRODUCT BEING SCANNED 
            if ([brandsArray count] == 0) 
            {
                
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
            
 //       }
//        else
//        {
////            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Not Found" 
////                                                            message:@"This product was not found in the database"
////                                                           delegate:self 
////                                                  cancelButtonTitle:nil 
////                                                  otherButtonTitles:@"Ok", nil];
////            [alert show];
////            [self.parentViewController.view removeFromSuperview];
//        }
    }
    
    //FETCHING INGREDIENTS INFO
    else if ([method isEqualToString:@"FetchNutritionFactsByUPC"])
    {
//        NSLog(@"SIZE %@", myDict);
////        NSString *myArray = [json_dict valueForKeyPath:@"result.ingredients"];
//        NSString *myArray = [myDict valueForKeyPath:@"ingredients"];
//
//        NSLog(@"SIZE %@", myArray);
//        
//        if ([myArray length] == 0)
//        {
//            
//            NSLog(@"SIZE of myArray %d", [myArray length]);
//            
//            UIAlertView *ingredientsAlert = [[UIAlertView alloc] initWithTitle:@"Missing Ingredients" 
//                                                                       message:@"We could not determine if you may be allergic to this product since the ingredients are not available"
//                                                                      delegate:self 
//                                                             cancelButtonTitle:nil 
//                                                             otherButtonTitles:@"Ok", nil];
//            [ingredientsAlert show];
//        }
//        else
//        {
            [self.view addSubview:ingredientsLabel];
            [self processIngredients:ingredientsListForProcessing];
//        }
//        
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

        ingredientsLabel.text = [NSString stringWithFormat:@"%@ %@", @"This product does not contain", userAllergyText];
        
        UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
        UIImage* upImageFile = [UIImage imageNamed:@"up.png"];    
        UIImageView *upImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - upImageFile.size.width)/2, 160 + (barImageFile.size.height-upImageFile.size.height)/2, upImageFile.size.width, upImageFile.size.height)]; 
        upImage.image = [UIImage imageNamed:@"up.png"];
        [self.view addSubview: upImage];

        
    }
    else
    {
        //        ingredients.text = [ingredientsProcessorObject.badIngredients description]; //converting an NSArray to an NSString
        NSString *tempOutputText = [[ingredientsProcessorObject.badIngredients valueForKey:@"description"] componentsJoinedByString:@", "];
        ingredientsLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", @"This product may not be good for", userAllergyText, @"allergy since it containts the following ingredients:", tempOutputText];

        UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
        UIImage* downImageFile = [UIImage imageNamed:@"down.png"];    
        UIImageView *downImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - downImageFile.size.width)/2, 160 + (barImageFile.size.height-downImageFile.size.height)/2, downImageFile.size.width, downImageFile.size.height)]; 
        downImage.image = [UIImage imageNamed:@"down.png"];
        [self.view addSubview: downImage];

        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:ingredientsLabel.text, @"ingredients.text", nil];
        [FlurryAnalytics logEvent:@"ENTERING PROCESSINGREDIENTS METHOD - SAVING THE BAD INGRESIENTS STRING" withParameters:dictionary];

    }
    
}

- (IBAction) dismissScreen : (id)sender
{
    
    //     [self.parentViewController.view removeFromSuperview];
     //   [self.view removeFromSuperview];
  //  [self dismissModalViewControllerAnimated:YES];
    
    
    ViewController *aboutViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    aboutNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    
    [self presentModalViewController:aboutNavigationController animated:YES];    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}

@end
