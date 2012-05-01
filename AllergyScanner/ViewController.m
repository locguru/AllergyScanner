//
//  ViewController.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "JSON.h"
#import "Results.h"
#import "About.h"
#import "History.h"
#import "ServerConnectionController.h"
#import "FlurryAnalytics.h"
#import <Twitter/Twitter.h>
#import "ProductDataBaseEngine.h"

static NSString* kAppId = @"210437135727485";

@implementation ViewController

@synthesize signin;
@synthesize scanner;
@synthesize pickerView;
@synthesize listOfItems;
@synthesize pickerList;
@synthesize actionSheet;
@synthesize userAllergy;
@synthesize inputBarcode;
@synthesize keyAccess;
@synthesize enableLocalKey;
@synthesize keyAccessArray;
@synthesize allergyImage;
@synthesize allergyTextImage;
@synthesize facebook;


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
       
     //VIEW TITLE
    //self.navigationItem.title = @"Allergy Scanner";
    self.navigationItem.title= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"brown_back.png"]];
    
    //NAV ITEMS
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(about:)];      
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //NAV ITEMS
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(history:)];      
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(sharingOption:)];      
    self.navigationItem.leftBarButtonItem = leftButton;

    //IMAGE VIEWS 
    
    UIImage* searchingImageFile = [UIImage imageNamed:@"searching_for.png"];    
    UIImageView *searchingImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - searchingImageFile.size.width)/2, 115, searchingImageFile.size.width, searchingImageFile.size.height)]; 
    searchingImage.image = [UIImage imageNamed:@"searching_for.png"];
    [self.view addSubview: searchingImage];
    
    UIImage* barImageFile = [UIImage imageNamed:@"brown_bar.png"];    
    UIImageView *barImage = [[UIImageView alloc] initWithFrame:CGRectMake((320 - barImageFile.size.width)/2, 180, barImageFile.size.width, barImageFile.size.height)]; 
    barImage.image = [UIImage imageNamed:@"brown_bar.png"];
    [self.view addSubview: barImage];

    
    //INPUT USER LABEL
    userAllergy = [[UILabel alloc] initWithFrame:CGRectMake(170, 40, 120, 40)];
    userAllergy.backgroundColor = [UIColor clearColor]; 
    userAllergy.font = [UIFont systemFontOfSize:18];
//    userAllergy.text = @"Placeholder";
    userAllergy.text = @"";

//    [self.view addSubview:userAllergy];
    
    
    //ADDING ALLERGY BUTTON
    signin = [[UIButton alloc] init];
    signin = [UIButton buttonWithType:UIButtonTypeCustom];
    [signin addTarget:self action:@selector(selectAllergy:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* myButtonImage1 = [UIImage imageNamed:@"select_your_allergy.png"];    
    signin.frame = CGRectMake((320 - myButtonImage1.size.width)/2, 30, myButtonImage1.size.width, myButtonImage1.size.height);
    [signin setBackgroundImage:myButtonImage1 forState:UIControlStateNormal];
    signin.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:signin];    
    
    //ADDING SCANNER BUTTON
    scanner = [[UIButton alloc] init];
    scanner = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanner addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* myButtonImage2 = [UIImage imageNamed:@"scan.png"];    
    scanner.frame = CGRectMake((320 - myButtonImage2.size.width)/2, 310, myButtonImage2.size.width, myButtonImage2.size.height);
    [scanner setImage:myButtonImage2 forState:UIControlStateNormal];
    scanner.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:scanner];    
    
    //PICKER AREA
    pickerList = [[NSMutableArray alloc] init];
    [pickerList addObject:@"Milk"];
    [pickerList addObject:@"Eggs"];
    [pickerList addObject:@"Peanuts"];
    [pickerList addObject:@"Wheat"];
    [pickerList addObject:@"Shellfish"];
    [pickerList addObject:@"Tree Nut"];
    [pickerList addObject:@"Corn"];
    [pickerList addObject:@"Soy"];
    [pickerList addObject:@"Fish"];
    
    //DEBUG SWITCH 
    enableLocalKey = [[UISwitch alloc] initWithFrame:CGRectMake(220, 360, 0, 40)];
//    [self.view addSubview:enableLocalKey]; 
    
    UILabel *debugText = [[UILabel alloc] initWithFrame:CGRectMake(40, 360, 260, 40)];
	debugText.text = @"Enable local key:";
	debugText.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    debugText.font = [UIFont systemFontOfSize:16];
//	[self.view addSubview:debugText];
        
        
    //Facebook
    facebook = [[Facebook alloc] initWithAppId:@"210437135727485" andDelegate:self];

    allergyImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 188, 60, 60)]; //(60, 188, 60, 60)
    allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(140, 208, 99, 20.5)]; //(140, 208, 99, 20.5)
}


- (IBAction)sharingOption:(id)sender {  
    
    //NSLog(@"entering sharingOption");
    [FlurryAnalytics logEvent:@"SELECTING OPTIONS"];
    
    //ACTION SHEET
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Share Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Post to Twitter", nil];  
    
    popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [popupQuery showInView:self.view];    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    

    if (buttonIndex == 1) //Twitter 
    {
        [FlurryAnalytics logEvent:@"CLICK ON SHARE ON TWITTER"];
        
        NSString* versionNumber = [[UIDevice currentDevice] systemVersion];
        int version;
        version = [versionNumber intValue];
    //    NSLog(@"versionNumber %d", version);
        
        if (version < 5)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" message:@"Youd OS version doesn't support Twitter on this app. Please upgrade your OS an try again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert show];
        }
        else    
        {
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            [twitter setInitialText:@"Enjoying using @Delengo recent great app - Allergy Scanner. Check it out! http://itunes.apple.com/us/app/allergy-scanner/id519416166?ls=1&mt=8 #iphone #appstore"];
            [self presentModalViewController:twitter animated:YES];
            
            // Called when the tweet dialog has been closed
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
            {
                NSString *title = @"Allergy Scanner";
                NSString *msg; 
                
                if (result == TWTweetComposeViewControllerResultCancelled)
                    msg = @"Tweet compostion was canceled";
                else if (result == TWTweetComposeViewControllerResultDone)
                    msg = @"Your tweet has been posted!";
                
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alertView show];
                
                [self dismissModalViewControllerAnimated:YES];
            };
            
            return;
            
        }
        
    } 
    else if (buttonIndex == 0) //Facebook
    {
        
        [FlurryAnalytics logEvent:@"CLICKING ON 'POST ON FACEBOOK'"];
   //     NSLog(@"entering POSTING ON FACEBOOK");
        [facebook authorize:[NSArray arrayWithObjects:@"publish_stream", nil]];
        
        return;
    } 
    
    [FlurryAnalytics logEvent:@"CANCELING ACTION SHEET"];
    
}

//FACEBOOK API
- (void)fbDidLogin {

    NSLog(@"entering fbDidLogin");
    [FlurryAnalytics logEvent:@"POSTING ON FACEBOOK"];

    NSString *link = @"http://itunes.apple.com/us/app/allergy-scanner/id519416166?ls=1&mt=8";
    NSString *linkName = @"Allergy Scanner app By Delengo";
    NSString *linkCaption = @"Check it out on the App Store!";
    NSString *linkDescription = @"";
    NSString *message = @"Allergy Scanner app for the iPhone has made my life so much easier!";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"api_key",
                                   message, @"message",
                                   linkName, @"name",
                                   linkDescription, @"description",
                                   link, @"link",
                                   linkCaption, @"caption",
                                   nil];
    
    [facebook requestWithGraphPath: @"me/feed" andParams: params andHttpMethod: @"POST" andDelegate: self];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" 
                                                    message:@"You successfully shared Allergy Scanner on Facebook" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];

}

-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	NSLog(@"Result of API call: %@", result);
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error{

    [FlurryAnalytics logEvent:@"ERROR SHARING ON FACEBOOK"];
    NSLog(@"didFailWithError: %@", [error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share on Facebook" 
                                                    message:@"An error occured" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"Dismiss"
                                          otherButtonTitles:nil];
    [alert show];
}

//CUSTOME METHODS 
- (IBAction)about:(id)sender {  

    //NSLog(@"entering about");
    [FlurryAnalytics logEvent:@"CLICKING 'ABOUT' SECTION"];

    About *aboutViewController = [[About alloc] initWithNibName:nil bundle:nil];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    aboutNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    
    [self presentModalViewController:aboutNavigationController animated:YES];
}


- (IBAction)history:(id)sender {  
    
    [FlurryAnalytics logEvent:@"CLICKING 'HISTORY' SECTION"];

    History *historyViewController = [[History alloc] initWithNibName:nil bundle:nil];
    UINavigationController *historyNavigationController = [[UINavigationController alloc] initWithRootViewController:historyViewController];
    historyNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    
    [self presentModalViewController:historyNavigationController animated:YES];
}


- (IBAction)selectAllergy:(id)sender {  
    
    [FlurryAnalytics logEvent:@"CLICKING 'SELECT ALLERGY' BUTTON"];

    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleDefault];
        
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 40, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    [actionSheet addSubview:pickerView];
    
    //DEFINING TOOL BAR 
    UIToolbar *pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet:)];
    [barItems addObject:doneBtn];
    [pickerToolbar setItems:barItems animated:YES];
    [actionSheet addSubview:pickerToolbar];
    
    //ACTION SHEET LABEL
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 200, 44)];
	myLabel.text = @"Please select your allergy";
	myLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    myLabel.textColor = [UIColor whiteColor];
    [actionSheet addSubview:myLabel];    
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 440)];

}



//Called when the user taps on our "Scan A Barcode" button
- (IBAction)scan:(id)sender {  
    
    [FlurryAnalytics logEvent:@"CLICKING 'SCAN BARCODE' BUTTON"];

//     NSLog(@"userAllergy.text is %@", userAllergy.text);
    
    //First check if the device has a camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        //Check if the user selected an allergy to scan for
        if (userAllergy.text == @"")
        {        
            [FlurryAnalytics logEvent:@"'ENTER ALLERGY FIRST' ALERT"];

            UIAlertView *selectAlert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                                                  message:@"Please select an allergy first"
                                                                 delegate:self 
                                                        cancelButtonTitle:nil 
                                                        otherButtonTitles:@"Ok", nil];
            
            [selectAlert show];
            
        }
        else
        {
            
            //RETREIVING ACCESS KEY FROM THE WEB SERVER / LOCALLY 
            //if (enableLocalKey.on)
            if(0)
            {
            //    NSLog(@"switch is on - using local key");
                keyAccess = @"FEW9sSVjaHhZux2oRuQ7wlK4xt1D3d0e";
            }
            else
            {
//                NSLog(@"switch is off - using key from server");
                ServerConnectionController *serverConnectionObject = [[ServerConnectionController alloc] init];
                [serverConnectionObject retreiveAccessKey:nil];
                keyAccess = [[NSString alloc] initWithFormat:serverConnectionObject.accessKey];
                keyAccessArray = [[NSArray alloc] initWithArray:serverConnectionObject.accessKeyArray];
                
//                NSLog(@"keyAccess is %@", keyAccess);
//                NSLog(@"keyAccessArray is %@", keyAccessArray);
            }
            
            
            //CHECKING IF THE KEY IS VALID
            if ([keyAccess length] < 5 )
            {
                [FlurryAnalytics logEvent:@"KEY IS NOT VALID, LESS THAN 5 CHARATECTERS"];

                UIAlertView *selectAlert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" 
                                                                      message:@"Service unavailable. Please try again later."
                                                                     delegate:self 
                                                            cancelButtonTitle:nil 
                                                            otherButtonTitles:@"Ok", nil];
                
                [selectAlert show];
                
            }
            else //Key is valid
            {
                
                if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) 
                {
                    [FlurryAnalytics logEvent:@"SCANNING PROPERLY"];

                    
                    
        //                ZBarReaderViewController *reader = [ZBarReaderViewController new];
        //                reader.readerDelegate = self;
        //                reader.supportedOrientationsMask = ZBarOrientationMaskAll;
        //                
        //                ZBarImageScanner *scanner3 = reader.scanner;
        //                // TODO: (optional) additional reader configuration here
        //                
        //                // EXAMPLE: disable rarely used I2/5 to improve performance
        //                [scanner3 setSymbology: ZBAR_I25
        //                               config: ZBAR_CFG_ENABLE
        //                                   to: 0];
        //                
        //                // present and release the controller
        //                [self presentModalViewController: reader animated: YES];

                    
                    
                    
                    // ADD: present a barcode reader that scans from the camera feed
                    ZBarReaderViewController *reader = [ZBarReaderViewController new];
                    UINavigationController *navCntrl1 = [[UINavigationController alloc] initWithRootViewController:reader];
                    
                    reader.readerDelegate = self;
                    reader.title = @"Scan Barcode";
                    //    reader.navigationItem.backBarButt  backgroundColor = [UIColor brownColor];
                    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
                    
                    ZBarImageScanner *scanner1 = reader.scanner;
                    // TODO: (optional) additional reader configuration here
                    
                    // EXAMPLE: disable rarely used I2/5 to improve performance
                    [scanner1 setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
                  //  [scanner1 setSymbology: 0 config: ZBAR_CFG_ENABLE to: 0];
                    [scanner1 setSymbology: ZBAR_QRCODE config: ZBAR_CFG_ENABLE to: 0];
                    
//                UIImageView *overlayImageSymbol = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"symbol2.png"]];
//                [overlayImageSymbol setFrame:CGRectMake((320-95)/2, 220, 95, 95)];
//                [navCntrl1.view addSubview:overlayImageSymbol];
//

                    UIImageView *overlayImageSymbol = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"symbol4.png"]];
                    [overlayImageSymbol setFrame:CGRectMake((320-0.75*overlayImageSymbol.image.size.width)/2, 120, 0.75*overlayImageSymbol.image.size.width, 0.75*overlayImageSymbol.image.size.height)];
                    [navCntrl1.view addSubview:overlayImageSymbol];
                    
                    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 140, 240, 40)];
                    myLabel.text = @"Center the barcode between the two lines to achieve quicker scanning";
                    myLabel.textColor = [UIColor redColor];
                    myLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
                    myLabel.font = [UIFont systemFontOfSize:14];
                    myLabel.numberOfLines = 0;
                    myLabel.lineBreakMode = UILineBreakModeWordWrap;
                    [myLabel setTextAlignment:UITextAlignmentCenter];
                    [navCntrl1.view addSubview:myLabel];

                    //HIDE INFO BUTTON
                    UIButton *blackRect = [[UIButton alloc] init];
                    blackRect = [UIButton buttonWithType:UIButtonTypeCustom];
                    //[blackRect addTarget:self action:@selector(selectAllergy:) forControlEvents:UIControlEventTouchUpInside];
                    UIImage* myButtonImage2 = [UIImage imageNamed:@"piece.png"];    
                    [blackRect setImage:myButtonImage2 forState:UIControlStateNormal];
                    blackRect.contentMode = UIViewContentModeScaleToFill;
                    blackRect.frame = CGRectMake(280, 440.0, 40, 40.0);
                    blackRect.adjustsImageWhenHighlighted = NO;
                    [navCntrl1.view addSubview:blackRect];    

                    // present and release the controller
                    //[self removeFromParentViewController];
                    [self presentModalViewController:navCntrl1 animated:YES];

                    
                } 
                else //for debug and if there isnt a camera
                {  
                    [FlurryAnalytics logEvent:@"DEBUG MODE - CAMERA IS NOT AVAILABLE IN THE DEVICE"];

                    NSString *temp = [[NSString alloc] init];
                    //temp = @"073731001059";
                    //temp = @"036632026071"; //missing ingredients 
                    temp = @"02100061223"; //bread crumps - full info
                    NSLog(@"barcode is %@", temp);

                    inputBarcode.text = temp;
                    [self showResults:temp];
                    
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" message:@"This device doesn't support barcode recognition (camera is not available). The application will be using a test barcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    [alertView show];
                }
            }
        }
    }
    //NO CAMERA AND SIMULATOR CASE
    else 
    {

        NSString *temp = [[NSString alloc] init];
        keyAccess = @"FEW9sSVjaHhZux2oRuQ7wlK4xt1D3d0e";
        temp = @"073731001059"; //041196891072 //9314458008732 //646422101002 //76770700168 //02100061223 // gum: 012546617529
        NSLog(@"barcode simulator is %@", temp);
        inputBarcode.text = temp;
        [self showResults:temp];

        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" 
                                                        message:@"Your device doesn't have a camera and can't be used to scan barcodes"
                                                       delegate:self 
                                              cancelButtonTitle:@"Dismiss" 
                                              otherButtonTitles:nil ,nil];
        [alert show];
        
    }

}


//ZBarSDK Finish Scanning
- (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    //resultText.text = symbol.data;
//    NSLog(@"symbol.data is %@", symbol.data);
    
    //charind - character index
	//sourceString - your source string
	
	NSString *newString = [[NSString alloc] init];
    
    newString = [symbol.data stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];

//    NSLog(@"sourceString is %@", newString);

    
    [self dismissModalViewControllerAnimated: YES];
    
   // [self showResults:symbol.data];
     [self showResults:newString];
    
}


- (void) cancelTapped {
	[self dismissModalViewControllerAnimated:YES];
}


- (void) showResults: (NSString *) barcode {
    
//    NSLog(@"SHOW ME BARCODE %@", barcode);
//    NSLog(@"SHOW ME keyAccess %@", keyAccess);

    
    ProductDataBaseEngine *dbEngine = [[ProductDataBaseEngine alloc] init];
    dbEngine.engineKey = keyAccess;
    dbEngine.engineMethod = @"FetchNutritionFactsByUPC"; 
    dbEngine.engineBarcode = barcode;

    //CALLING FetchNutritionFactsByUPC TO RETREIVE INGREDIENTS
    [dbEngine productDataBaseEngine];
    
    NSDictionary *myDict = [[NSDictionary alloc] init];
    myDict = [dbEngine.engingJsonDict valueForKey:@"result"];
    NSString *ingredientsArray = [myDict valueForKeyPath:@"ingredients"];

    dbEngine.engineMethod = @"FetchProductByUPC"; 

    //CALLING FetchProductByUPC TO RETREIVE GENERAL INFO
    [dbEngine productDataBaseEngine];

    myDict = [dbEngine.engingJsonDict valueForKey:@"result"];
    NSString *tempProductDescription = [[NSString alloc] init];
    tempProductDescription= [myDict valueForKey:@"description"];

    
//    NSLog(@"dbEngine.json_dict is %@", dbEngine.engingJsonDict);
//    NSLog(@"tempProductDescription is %@", tempProductDescription);
//    NSLog(@"[tempProductDescription length] is %d", [tempProductDescription length]);
//    NSLog(@"success is %@", [dbEngine.engingJsonDict valueForKey:@"success"]);
//    NSLog(@"ingredients is %@", ingredientsArray);
//    NSLog(@"ingredients is %d", [ingredientsArray length]);

    int num; // = [[NSString alloc] init];
    num = [[dbEngine.engingJsonDict valueForKey:@"success"] intValue];
//    NSLog(@"numbeer is %d", num);
    NSString *errorDict = [[NSString alloc] init];
    NSString *errorCode = [[NSString alloc] init];
    errorDict = [dbEngine.engingJsonDict valueForKey:@"error"];
    errorCode = [errorDict valueForKey:@"code"];
  //  errorCode = [errorCode valueForKey:@"code"];
//    NSLog(@"errorDict is %@", errorDict);
//   NSLog(@"errorCode is %@", errorCode);

    //ERROR CASES
    if (num == 0) 
    {
         if ([errorCode isEqualToString:@"4002"])
         {
             [FlurryAnalytics logEvent:@"ERROR 4002 - UPC NOT VALID"];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" 
                                                             message:@"The barcode you scanned is not valid"
                                                            delegate:self 
                                                   cancelButtonTitle:nil 
                                                   otherButtonTitles:@"Ok", nil];
             [alert show];

         }
         else if ([errorCode isEqualToString:@"4004"])
         {
             [FlurryAnalytics logEvent:@"ERROR 4004 - PRODUCT NOT FOUND IN DB"];
              UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" 
                                                                message:@"This product was not found in our database"
                                                               delegate:self 
                                                      cancelButtonTitle:nil 
                                                      otherButtonTitles:@"Ok", nil];
              [alert show];
                
         }
         else 
         {
             [FlurryAnalytics logEvent:@"ERROR 400X - UNKNOWN ERROR"];
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" 
                                                             message:@"Service unavailable. Please try again later."
                                                            delegate:self 
                                                   cancelButtonTitle:nil 
                                                   otherButtonTitles:@"Ok", nil];
             [alert show];
            
          }
    }
    else if ([ingredientsArray length] == 0) 
    {
        [FlurryAnalytics logEvent:@"ERROR INGREDIENTS ARE NOT AVAILABLE"];
        UIAlertView *ingredientsAlert = [[UIAlertView alloc] initWithTitle:@"Missing Ingredients" 
                                                                   message:@"We could not determine if you may be allergic to this product since the ingredients are not available"
                                                                  delegate:self 
                                                         cancelButtonTitle:nil 
                                                         otherButtonTitles:@"Ok", nil];
        [ingredientsAlert show];
        
    }
    else if ([tempProductDescription length] == 0)
    {
                    
            NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:tempProductDescription, @"productDescription.text", nil];
            [FlurryAnalytics logEvent:@"GETPRODUCTINFO METHOD: PRODUCT WAS NOT FOUND IN DB" withParameters:dictionary];
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Item Not Found" 
                                               message:@"This product was not found in the database"
                                              delegate:self 
                                     cancelButtonTitle:nil 
                                     otherButtonTitles:@"Ok", nil];
            [alert show];
    }
    //SUCCESS
    else 
    {
        
        [FlurryAnalytics logEvent:@"ENTERING RESULTS VIEW"];

        Results *resultsViewController = [[Results alloc] initWithNibName:nil bundle:nil];
        resultsViewController.tempBarcode = barcode;
        resultsViewController.userAllergyText = userAllergy.text;
        resultsViewController.key = keyAccess;
        resultsViewController.ingredientsListForProcessing = ingredientsArray;
       // resultsViewController.json_dict = dbEngine.json_dict;
        
        UINavigationController *resultsNavigationController = [[UINavigationController alloc] initWithRootViewController:resultsViewController];
        resultsNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [[[UIApplication sharedApplication]delegate].window setRootViewController:resultsNavigationController];
        
        // [self presentModalViewController:resultsViewController animated:YES];
    }
    
}


- (IBAction)dismissActionSheet:(id)sender {  
    
    allergyImage.image = nil; 
    allergyTextImage.image = nil; 
    
    float scalefactor = 1;
    float shiftx = 145.0;
    
//    NSLog(@"allergyImage is %@", allergyImage);
//    NSLog(@"allergyTextImage is %@", allergyTextImage);

    NSInteger row = [pickerView selectedRowInComponent:0]; 
    userAllergy.text = [pickerList objectAtIndex:row];
    
    //SAVE USER ALLERGY 
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAllergy.text, @"user input allergy", nil];
        
    NSLog(@"userAllergy.text is %@", userAllergy.text);
    
    if (userAllergy.text == @"Milk"){
        [FlurryAnalytics logEvent:@"USER SELECTED MILK"];
        allergyImage.image = [UIImage imageNamed:@"icon_milk.png"];
        UIImage *image1 = [UIImage imageNamed:@"milk.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"milk.png"];
    }
    else if (userAllergy.text == @"Eggs"){
        [FlurryAnalytics logEvent:@"USER SELECTED EGGS"];
        allergyImage.image = [UIImage imageNamed:@"icon_eggs.png"];
        UIImage *image1 = [UIImage imageNamed:@"eggs.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"eggs.png"];
    }
    else if (userAllergy.text == @"Peanuts"){
        [FlurryAnalytics logEvent:@"USER SELECTED PEANUTS"];
        allergyImage.image = [UIImage imageNamed:@"icon_peanut.png"];
        UIImage *image1 = [UIImage imageNamed:@"peanuts.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"peanuts.png"];
    }
    else if (userAllergy.text == @"Wheat"){
        [FlurryAnalytics logEvent:@"USER SELECTED WHEAT"];
        allergyImage.image = [UIImage imageNamed:@"icon_wheat.png"];
        UIImage *image1 = [UIImage imageNamed:@"wheat.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"wheat.png"];
    }
    else if (userAllergy.text == @"Shellfish"){
        [FlurryAnalytics logEvent:@"USER SELECTED SHELLFISH"];
        allergyImage.image = [UIImage imageNamed:@"icon_shellfish.png"];
        UIImage *image1 = [UIImage imageNamed:@"shellfish.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"shellfish.png"];
    }
    else if (userAllergy.text == @"Tree Nut"){
        [FlurryAnalytics logEvent:@"USER SELECTED TREENUT"];
        allergyImage.image = [UIImage imageNamed:@"icon_treenut.png"];
        UIImage *image1 = [UIImage imageNamed:@"tree_nut.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"tree_nut.png"];
    }
    else if (userAllergy.text == @"Corn"){
        [FlurryAnalytics logEvent:@"USER SELECTED CORN"];
        allergyImage.image = [UIImage imageNamed:@"icon_corn.png"];
        UIImage *image1 = [UIImage imageNamed:@"corn.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"corn.png"];
    }
    else if (userAllergy.text == @"Soy"){
        [FlurryAnalytics logEvent:@"USER SELECTED SOY"];
        allergyImage.image = [UIImage imageNamed:@"icon_soy.png"];
        UIImage *image1 = [UIImage imageNamed:@"soy.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"soy.png"];
    }
    else if (userAllergy.text == @"Fish"){
        [FlurryAnalytics logEvent:@"USER SELECTED FISH"];
        allergyImage.image = [UIImage imageNamed:@"icon_fish.png"];
        UIImage *image1 = [UIImage imageNamed:@"fish.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"fish.png"];
    }
    else
        NSLog (@"No image provided");
    
 //   allergyTextImage.image = tempUIImage;

    [self.view addSubview: allergyImage];
    [self.view addSubview: allergyTextImage];
    
    //FLURRY ZOME
    [FlurryAnalytics logEvent:@"DISMISS ALLERGIES ACTION SHEET AND SEND USER ALLERGY" withParameters:dictionary];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];

}

//PICKERVIEW METHODS 
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 40;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 200;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerList count];
}

-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [pickerList objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //NSLog(@"Selected item: %@ index of selected item: %i", [pickerList objectAtIndex:row], row);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}

@end
