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
@synthesize productBrandString;
@synthesize productDescription;
@synthesize productDescriptionString;
@synthesize ingredientsLabel;
@synthesize tempBarcode;
@synthesize userAllergyText;
@synthesize ingredientsProcessorObject;
@synthesize key;
//@synthesize success;
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
    dismissResults.frame = CGRectMake((320 - doneImage.size.width)/2, 350, doneImage.size.width, doneImage.size.height);
    [dismissResults setImage:doneImage forState:UIControlStateNormal];
    dismissResults.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:dismissResults];   
    
    //IMAGE VIEWS 
    UIImage* resultsImageFile = [UIImage imageNamed:@"scanning_results_title.png"];    
    UIImageView *resultsImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - resultsImageFile.size.width)/2, 25, resultsImageFile.size.width, resultsImageFile.size.height)]; 
    resultsImage.image = resultsImageFile;
    [self.view addSubview: resultsImage];

    UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
    UIImageView *barImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - barImageFile.size.width)/2, 160, barImageFile.size.width, barImageFile.size.height)]; 
    barImage.image = [UIImage imageNamed:@"brown_bar.png"];
    [self.view addSubview: barImage];
    
    //LABELS AREA
    description = [[UILabel alloc] initWithFrame:CGRectMake(20, 60, 120, 40)];
    description.text = @"Product:";
	description.backgroundColor = [UIColor clearColor];
    description.textColor = [UIColor whiteColor];
    description.font = [UIFont boldSystemFontOfSize:20];
    description.numberOfLines = 0;
    description.lineBreakMode = UILineBreakModeWordWrap;
    description.shadowColor = [UIColor blackColor];
    description.shadowOffset = CGSizeMake(0.5, 1);
    [self.view addSubview:description];

    productDescription = [[UILabel alloc] initWithFrame:CGRectMake(110, 60, 190, 40)];   
    productDescription.text = productDescriptionString;//@"";
    productDescription.backgroundColor = [UIColor clearColor]; 
    productDescription.textColor = [UIColor whiteColor];
    productDescription.font = [UIFont systemFontOfSize:16];
    productDescription.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:productDescription];

    brand = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, 120, 40)];
    brand.text = @"Brand:";
	brand.backgroundColor = [UIColor clearColor]; 
    brand.textColor = [UIColor whiteColor];
    brand.font = [UIFont boldSystemFontOfSize:20];
    brand.shadowColor = [UIColor blackColor];
    brand.shadowOffset = CGSizeMake(0.5, 1);
    [self.view addSubview:brand];

    productBrand = [[UILabel alloc] initWithFrame:CGRectMake(110, 100, 190, 40)];
    productBrand.text = productBrandString;//@"";
    productBrand.backgroundColor = [UIColor clearColor]; 
    productBrand.textColor = [UIColor whiteColor];
    productBrand.font = [UIFont systemFontOfSize:16];
    productBrand.adjustsFontSizeToFitWidth = YES;
    [self.view addSubview:productBrand];

    ingredientsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 280, 120)];   
    ingredientsLabel.text = @"";
    ingredientsLabel.backgroundColor = [UIColor clearColor]; 
    ingredientsLabel.textColor = [UIColor whiteColor];
    ingredientsLabel.numberOfLines = 0;
    ingredientsLabel.font = [UIFont boldSystemFontOfSize:16];
    [ingredientsLabel setTextAlignment:UITextAlignmentCenter];
    ingredientsLabel.adjustsFontSizeToFitWidth = YES;
    ingredientsLabel.lineBreakMode =  UILineBreakModeWordWrap; //UILineBreakModeCharacterWrap;
    [self.view addSubview:ingredientsLabel];

    [self processIngredients:ingredientsListForProcessing];

//    success = [[NSString alloc] init];
    
//    [self lookupAlergie:tempBarcode withMethod:@"FetchProductByUPC" withAlergy:userAllergyText];
//    [self lookupAlergie:tempBarcode withMethod:@"FetchNutritionFactsByUPC" withAlergy:userAllergyText];
}

- (void) processIngredients:(NSString *) listOfIngredients {
    
    NSLog(@"listOfIngredients array %@", listOfIngredients);
    
    //PROCESSING INGREDIENTS - SEARCH
    [ingredientsProcessorObject ingredientsEngine:userAllergyText withIngreients:listOfIngredients];
    
    if ([ingredientsProcessorObject.badIngredients count] == 0) 
    {
        [FlurryAnalytics logEvent:@"PRODUCT DOESN'T CONTAIN USER ALLERGY"];
        ingredientsLabel.text = [NSString stringWithFormat:@"%@ %@ %@", @"Allergy Scanner did not find", userAllergyText, @"in this product. Please verify product ingredients."];
        UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
        UIImage* upImageFile = [UIImage imageNamed:@"up.png"];    
        UIImageView *upImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - upImageFile.size.width)/2, 160 + (barImageFile.size.height-upImageFile.size.height)/2, upImageFile.size.width, upImageFile.size.height)]; 
        upImage.image = [UIImage imageNamed:@"up.png"];
        [self.view addSubview: upImage];
    }
    else
    {
        NSString *tempOutputText = [[ingredientsProcessorObject.badIngredients valueForKey:@"description"] componentsJoinedByString:@", "];
        ingredientsLabel.text = [NSString stringWithFormat:@"%@ %@", @"This product may contain some form of: ", tempOutputText];
        UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
        UIImage* downImageFile = [UIImage imageNamed:@"down.png"];    
        UIImageView *downImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - downImageFile.size.width)/2, 160 + (barImageFile.size.height-downImageFile.size.height)/2, downImageFile.size.width, downImageFile.size.height)]; 
        downImage.image = [UIImage imageNamed:@"down.png"];
        [self.view addSubview: downImage];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:ingredientsLabel.text, @"ingredients.text", nil];
        [FlurryAnalytics logEvent:@"SAVING THE BAD INGRESIENTS STRING" withParameters:dictionary];
    }
}


//- (void) lookupAlergie:(NSString *)barcodeLabel withMethod:(NSString *) method withAlergy:(NSString *)allergyText{
//    
//    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:allergyText, @"allergyText", nil];
//    [FlurryAnalytics logEvent:@"ENTERING LOOKUPALLERGY METHOD" withParameters:dictionary];
//    
////    //POSTING JSON OBJECT TO WEBSERVER  
////    ProductDataBaseEngine *dbEngine = [[ProductDataBaseEngine alloc] init];
////    dbEngine.engineKey = key;
////    dbEngine.engineMethod = method;
////    dbEngine.engineBarcode = barcodeLabel;
////    
////    [dbEngine productDataBaseEngine];
//    
//    //FETCHING BASIC PRODUCT INFO
//    if ([method isEqualToString:@"FetchProductByUPC"])
//    {        
//        //LOADING NSUserDefaults
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];            
//        NSArray *brandsArray = [defaults arrayForKey:@"brands"]; 
//        NSArray *productNamesArray = [defaults arrayForKey:@"productNames"]; 
//        
//        //LOCAL DB IS EMPTY - ADDING THE CURRENT PRODUCT BEING SCANNED 
//        if ([brandsArray count] == 0) 
//        {            
//            NSArray *brandsArrayTemp = [[ NSArray alloc] initWithObjects:productBrand.text, nil];  
//            NSArray *productNamesArrayTemp = [[ NSArray alloc] initWithObjects:productDescription.text, nil];  
//            [defaults setObject:brandsArrayTemp forKey:@"brands"];  //set the prev Array for key value "favourites"
//            [defaults setObject:productNamesArrayTemp forKey:@"productNames"];  //set the prev Array for key value "favourites"
//            brandsArray = [defaults arrayForKey:@"brands"]; 
//           // NSLog(@"favorites array %@", brandsArray);
//        }
//        //LOCAL DB IS NOT EMPTY - READINIG IT, ADDING THE CURRENT PRODUCT, AND WRITING BACK
//        else
//        {
//                        
//            NSMutableArray *brandsArrayTemp = [[NSMutableArray alloc] initWithArray:brandsArray]; 
//            //[brandsArrayTemp addObject:productBrand.text];
//            [brandsArrayTemp insertObject:productBrand.text atIndex:0]; 
//            NSMutableArray *productNamesArrayTemp = [[NSMutableArray alloc] initWithArray:productNamesArray];  
//            //[productNamesArrayTemp addObject:productDescription.text];
//            [productNamesArrayTemp insertObject:productDescription.text atIndex:0];
//             [defaults setObject:brandsArrayTemp forKey:@"brands"];  //set the prev Array for key value "favourites"
//            [defaults setObject:productNamesArrayTemp forKey:@"productNames"];  //set the prev Array for key value "favourites"
//            
//        }
//    }
//    //FETCHING INGREDIENTS INFO
//    else if ([method isEqualToString:@"FetchNutritionFactsByUPC"])
//    {
//            [self processIngredients:ingredientsListForProcessing];
//    
//    }
//    //OTHER API CALL METHOD
//    else 
//    {
//    }
//}


- (IBAction) dismissScreen : (id)sender
{
    ViewController *aboutViewController = [[ViewController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    aboutNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    
    [self presentModalViewController:aboutNavigationController animated:YES];    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
        return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}

@end
