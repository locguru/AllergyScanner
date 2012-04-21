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
   
//    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//    [UIColor blackColor], UITextAttributeTextColor, 
//    nil, UITextAttributeTextShadowColor, 
//    nil, UITextAttributeTextShadowOffset,
//    nil, UITextAttributeFont, nil] forState:UIControlStateNormal];
    
     //VIEW TITLE
    //self.navigationItem.title = @"AllergyScanner";
    self.navigationItem.title= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    //BACKGROUND COLOR 
//    self.view.backgroundColor = [UIColor brownColor];
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"allergyscannermainpage.png"]];
    
    //NAV ITEMS
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(about:)];      
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //NAV ITEMS
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(history:)];      
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Share" style:UIBarButtonItemStylePlain target:self action:@selector(sharingOption:)];      
    self.navigationItem.leftBarButtonItem = leftButton;

    //IMAGE VIEWS 
    UIImageView *searchingImage = [[UIImageView alloc] initWithFrame:CGRectMake((320-233)/2, 115, 233, 55)]; 
    searchingImage.image = [UIImage imageNamed:@"searching_for.png"];
    [self.view addSubview: searchingImage];

    UIImageView *barImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 180, 320, 76)]; 
    barImage.image = [UIImage imageNamed:@"brown_bar.png"];
    [self.view addSubview: barImage];

    
    //LABELS
//    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 120, 40)];
//	myLabel.text = @"Searching for:";
//	myLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
//    myLabel.font = [UIFont systemFontOfSize:18];
//	[self.view addSubview:myLabel];
    
    //INPUT USER LABEL
    userAllergy = [[UILabel alloc] initWithFrame:CGRectMake(170, 40, 120, 40)];
    userAllergy.backgroundColor = [UIColor clearColor]; 
    userAllergy.font = [UIFont systemFontOfSize:18];
//    userAllergy.text = @"Placeholder";
    userAllergy.text = @"";

    [self.view addSubview:userAllergy];
    
    //BARCODE LABEL
//    inputBarcode = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 240, 40)];
//    inputBarcode.backgroundColor = [UIColor clearColor]; 
//    inputBarcode.font = [UIFont systemFontOfSize:18];
//    inputBarcode.text = @"Barcode";
//    [self.view addSubview:inputBarcode];
    
    
    //ADDING ALLERGY BUTTON
    signin = [[UIButton alloc] init];
    signin = [UIButton buttonWithType:UIButtonTypeCustom];
    [signin addTarget:self action:@selector(selectAllergy:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* myButtonImage1 = [UIImage imageNamed:@"select_your_allergy.png"];    
    signin.frame = CGRectMake((320 - myButtonImage1.size.width/2)/2, 30, myButtonImage1.size.width/2, myButtonImage1.size.height/2);
//    signin.frame = CGRectMake((320-270.5)/2, 50, 270.5, 48.5);
//    signin.titleLabel.text = @"Click here to scan ingredients";
//    [signin setTitle: @"1. Select Your Allergy" forState: UIControlStateNormal];
    //signin.backgroundColor = [UIColor blackColor];
    // signin.titleLabel.textColor = [UIColor colorWithRed:30/255.f green:34/255.f blue:47/255.f alpha:1];
    [signin setBackgroundImage:myButtonImage1 forState:UIControlStateNormal];
    signin.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:signin];    
    
    //ADDING SCANNER BUTTON
    scanner = [[UIButton alloc] init];
    scanner = [UIButton buttonWithType:UIButtonTypeCustom];
    [scanner addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* myButtonImage2 = [UIImage imageNamed:@"scan.png"];    
    scanner.frame = CGRectMake((320 - myButtonImage2.size.width/2)/2, 310, myButtonImage2.size.width/2, myButtonImage2.size.height/2);
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
    
    //DEBUG SWITCH 
    enableLocalKey = [[UISwitch alloc] initWithFrame:CGRectMake(220, 360, 0, 40)];
//    [self.view addSubview:enableLocalKey]; 
    
    UILabel *debugText = [[UILabel alloc] initWithFrame:CGRectMake(40, 360, 260, 40)];
	debugText.text = @"Enable local key:";
	debugText.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    debugText.font = [UIFont systemFontOfSize:16];
//	[self.view addSubview:debugText];
    
    //SERVER SANITY CHECK
//    NSString *urlString =  @"http://www.delengo.com/getkey.php";
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
//    [request setTimeoutInterval:60.0];
//    [request setURL:[NSURL URLWithString:urlString]];
//    [request setHTTPMethod:@"POST"];
//
//    NSString *accessKey = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
//    NSLog(@"string from server is: %@", accessKey);
//    NSString *alertKey = [NSString stringWithFormat:@"accessKey is %@", accessKey];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" message:alertKey delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
    
        
    //Facebook
    facebook = [[Facebook alloc] initWithAppId:@"210437135727485" andDelegate:self];

    //ADDING ALLERGIES UI
//    allergyImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 188, 60, 60)]; 
//    allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(140, 208, 99, 20.5)]; 
//    [self.view addSubview: allergyImage];
//    [self.view addSubview: allergyTextImage];
    
    allergyImage = [[UIImageView alloc] initWithFrame:CGRectMake(70, 188, 60, 60)]; //(60, 188, 60, 60)
    allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(140, 208, 99, 20.5)]; //(140, 208, 99, 20.5)


}


- (IBAction)sharingOption:(id)sender {  
    
    NSLog(@"entering sharingOption");
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
        NSLog(@"versionNumber %d", version);
        
        if (version < 5)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Smart Phone" message:@"Youd OS version doesn't support Twitter on this app. Please upgrade your OS an try again" delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [alert show];
        }
        else    
        {
            TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
            [twitter setInitialText:@"Enjoying using @Delengo recent app - AllergyScanner, what a great application! #iphone #appstore"];
            [self presentModalViewController:twitter animated:YES];
            
            // Called when the tweet dialog has been closed
            twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
            {
                NSString *title = @"Smart Phone";
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
        
        [FlurryAnalytics logEvent:@"POSTING ON FACEBOOK"];
        
        NSLog(@"entering POSTING ON FACEBOOK");
        [facebook authorize:[NSArray arrayWithObjects:@"publish_stream", nil]];
        
        return;
    } 
    
    [FlurryAnalytics logEvent:@"CANCELING ACTION SHEET"];
    
}

//- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    
//}
//
//- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex {
//
//}
//
//- (void)actionSheetCancel:(UIActionSheet *)actionSheet {
//    
//}
//
//- (void)didPresentActionSheet:(UIActionSheet *)actionSheet {
//    
//}
//
//- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
//    
//}

//FACEBOOK API
- (void)fbDidLogin {

    NSLog(@"entering fbDidLogin");
    
    NSString *link = @"http://itunes.apple.com/us/app/smart-phone/id511179270?ls=1&mt=8";
    NSString *linkName = @"AllergyScanner app By Delengo";
    NSString *linkCaption = @"Check it out on the App Store!";
    NSString *linkDescription = @"";
    NSString *message = @"AllergyScanner app for the iPhone has made my life so much easier!";
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   kAppId, @"api_key",
                                   message, @"message",
                                   linkName, @"name",
                                   linkDescription, @"description",
                                   link, @"link",
                                   linkCaption, @"caption",
                                   nil];
    
    [facebook requestWithGraphPath: @"me/feed" andParams: params andHttpMethod: @"POST" andDelegate: self];


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
    NSLog(@"didFailWithError: %@", [error description]);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share on Facebook" 
                                                    message:@"An error occured" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//CUSTOME METHODS 
- (IBAction)about:(id)sender {  

    NSLog(@"entering about");
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

     NSLog(@"userAllergy.text is %@", userAllergy.text);
    
    //First check if the user selected an allergy to scan for
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
            NSLog(@"switch is on - using local key");
            keyAccess = @"vaovqQqM4MHEXviNlTt5qp7ZBLva3lM";
        }
        else
        {
            NSLog(@"switch is off - using key from server");
            ServerConnectionController *serverConnectionObject = [[ServerConnectionController alloc] init];
            [serverConnectionObject retreiveAccessKey:nil];
            keyAccess = [[NSString alloc] initWithFormat:serverConnectionObject.accessKey];
            keyAccessArray = [[NSArray alloc] initWithArray:serverConnectionObject.accessKeyArray];
            
            NSLog(@"keyAccess is %@", keyAccess);
            NSLog(@"keyAccessArray is %@", keyAccessArray);
        }
        
        NSLog(@"[keyAccess length] is %d", [keyAccess length]);
        
        //    NSString *sub = [[NSString alloc] initWithFormat:@"ERR"];
        //    NSString *results = [[NSString alloc] init];
        //    results = [keyAccess substringWithRange:[keyAccess rangeOfString:sub]];
        //    NSLog(@"results is %@", results);
        
        
        
        
        //CHECKING IF THE KEY IS VALID
        if ([keyAccess length] < 5 )
        {
            [FlurryAnalytics logEvent:@"KEY IS NOT VALID, LESS THAN 5 CHARATECTERS"];

            UIAlertView *selectAlert = [[UIAlertView alloc] initWithTitle:@"AllergyScanner" 
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
                
                UIImageView *overlayImageSymbol = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"symbol2.png"]];
                [overlayImageSymbol setFrame:CGRectMake((320-95)/2, 220, 95, 95)];
                [navCntrl1.view addSubview:overlayImageSymbol];

                
                // present and release the controller
                [self presentModalViewController:navCntrl1 animated:YES];
                
            } 
            else //for debug and if there isnt a camera
            {  
                [FlurryAnalytics logEvent:@"DEBUG MODE - CAMERA IS NOT AVAILABLE IN THE DEVICE"];

                NSString *temp = [[NSString alloc] init];
                //temp = @"073731001059";
                //temp = @"036632026071"; //missing ingredients 
                temp = @"041196891072"; //bread crumps - full info
                inputBarcode.text = temp;
                [self showResults:temp];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" message:@"This device doesn't support barcode recognition (camera is not available). The application will be using a test barcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
            }
        }
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
    
    // EXAMPLE: do something useful with the barcode data
    //resultText.text = symbol.data;
    NSLog(@"symbol.data is %@", symbol.data);
    
    // EXAMPLE: do something useful with the barcode image
 //   resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
    
    [self showResults:symbol.data];
    
}


- (void) cancelTapped {
	[self dismissModalViewControllerAnimated:YES];
}


- (void) showResults: (NSString *) barcode {
    
    NSLog(@"SHOW ME BARCODE %@", barcode);
    
    Results *resultsViewController = [[Results alloc] initWithNibName:nil bundle:nil];
    resultsViewController.tempBarcode = barcode;
    resultsViewController.userAllergyText = userAllergy.text;
    resultsViewController.key = keyAccess;
    
    UINavigationController *resultsNavigationController = [[UINavigationController alloc] initWithRootViewController:resultsViewController];
    resultsNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [[[UIApplication sharedApplication]delegate].window setRootViewController:resultsNavigationController];
    
    //[self presentModalViewController:resultsViewController animated:YES];
}


- (IBAction)dismissActionSheet:(id)sender {  
    

    allergyImage.image = nil; 
    allergyTextImage.image = nil; 
    
    float scalefactor = 0.5;
    float shiftx = 145.0;
    
//    NSLog(@"allergyImage is %@", allergyImage);
//    NSLog(@"allergyTextImage is %@", allergyTextImage);

    NSInteger row = [pickerView selectedRowInComponent:0]; 
    userAllergy.text = [pickerList objectAtIndex:row];
    
    //SAVE USER ALLERGY 
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:userAllergy.text, @"user input allergy", nil];
    
    //SHOW IMAGE BASED ON THE ALLERGY SELECTED
  //  allergyImage = [[UIImageView alloc] initWithFrame:CGRectMake(60, 188, 60, 60)]; 
 //   UIImage *tempUIImage = [[UIImage alloc] init];
    
    if (userAllergy.text == @"Milk"){
        allergyImage.image = [UIImage imageNamed:@"icon_milk.png"];
        
        UIImage *image1 = [UIImage imageNamed:@"milk.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"milk.png"];
    }
    else if (userAllergy.text == @"Eggs"){
        allergyImage.image = [UIImage imageNamed:@"icon_eggs.png"];
        UIImage *image1 = [UIImage imageNamed:@"eggs.png"];
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"eggs.png"];
    }
    else if (userAllergy.text == @"Peanuts"){
        allergyImage.image = [UIImage imageNamed:@"icon_peanut.png"];
        UIImage *image1 = [UIImage imageNamed:@"peanuts.png"];

        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"peanuts.png"];
    }
    else if (userAllergy.text == @"Wheat"){
        allergyImage.image = [UIImage imageNamed:@"icon_wheat.png"];
        UIImage *image1 = [UIImage imageNamed:@"wheat.png"];
        
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"wheat.png"];
    }
    else if (userAllergy.text == @"Shellfish"){
        allergyImage.image = [UIImage imageNamed:@"icon_shellfish.png"];
        UIImage *image1 = [UIImage imageNamed:@"shellfish.png"];
        
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"shellfish.png"];
    }
    else if (userAllergy.text == @"Tree Nut"){
        allergyImage.image = [UIImage imageNamed:@"icon_treenut.png"];
        UIImage *image1 = [UIImage imageNamed:@"tree_nut.png"];
        
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"tree_nut.png"];
    }
    else if (userAllergy.text == @"Corn"){
        allergyImage.image = [UIImage imageNamed:@"icon_corn.png"];
        UIImage *image1 = [UIImage imageNamed:@"corn.png"];
        
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"corn.png"];
    }
    else if (userAllergy.text == @"Soy"){
        allergyImage.image = [UIImage imageNamed:@"icon_soy.png"];
        UIImage *image1 = [UIImage imageNamed:@"soy.png"];
        
        allergyTextImage = [[UIImageView alloc] initWithFrame:CGRectMake(shiftx, 180 + (76-scalefactor*image1.size.height)/2, scalefactor*image1.size.width, scalefactor*image1.size.height)]; //(140, 208, 99, 20.5)
        allergyTextImage.image = [UIImage imageNamed:@"soy.png"];
    }
    else
        NSLog (@"No image provided");
    
 //   allergyTextImage.image = tempUIImage;

    [self.view addSubview: allergyImage];
    [self.view addSubview: allergyTextImage];
    
    //FLURRY ZOME
    [FlurryAnalytics logEvent:@"DISMISS ALLERGIES ACTION SHEET AND SEND USER ALLERGY" withParameters:dictionary];
//    allergyImage.image = nil;
//    allergyTextImage.image = nil;
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
//    NSLog(@"allergyImage is %@", allergyImage);
//    NSLog(@"allergyTextImage is %@", allergyTextImage);

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
    NSLog(@"Selected item: %@ index of selected item: %i", [pickerList objectAtIndex:row], row);
//    allergyImage.image = nil;
//    allergyTextImage.image = nil;

}


//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

@end
