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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

+ (void) initialize {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSMutableDictionary *defaultsDict = [NSMutableDictionary dictionary];
    
	[defaultsDict setObject:[NSNumber numberWithBool:YES] forKey:@"shouldLookForEAN13AndUPCACodes"];
	[defaultsDict setObject:[NSNumber numberWithBool:YES] forKey:@"shouldLookForEAN8Codes"];
	[defaultsDict setObject:[NSNumber numberWithBool:YES] forKey:@"shouldLookForUPCECodes"];
	[defaultsDict setObject:[NSNumber numberWithBool:NO] forKey:@"shouldLookForQRCodes"];
    
	[defaults registerDefaults:defaultsDict];	
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //VIEW TITLE
    self.navigationItem.title = @"AllergyScanner";
    
    //BACKGROUND COLOR 
    self.view.backgroundColor = [UIColor brownColor];
    
    //NAV ITEMS
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"About" style:UIBarButtonItemStylePlain target:self action:@selector(about:)];      
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //NAV ITEMS
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"History" style:UIBarButtonItemStylePlain target:self action:@selector(history:)];      
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //LABELS
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 40, 120, 40)];
	myLabel.text = @"Searching for:";
	myLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    myLabel.font = [UIFont systemFontOfSize:18];
	[self.view addSubview:myLabel];
    
    //INPUT USER LABEL
    userAllergy = [[UILabel alloc] initWithFrame:CGRectMake(170, 40, 120, 40)];
    userAllergy.backgroundColor = [UIColor clearColor]; 
    userAllergy.font = [UIFont systemFontOfSize:18];
    userAllergy.text = @"Placeholder";
    [self.view addSubview:userAllergy];
    
    //BARCODE LABEL
    inputBarcode = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 240, 40)];
    inputBarcode.backgroundColor = [UIColor clearColor]; 
    inputBarcode.font = [UIFont systemFontOfSize:18];
    inputBarcode.text = @"Barcode";
    [self.view addSubview:inputBarcode];
    
    
    //ADDING ALLERGY BUTTON
    signin = [[UIButton alloc] init];
    signin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [signin addTarget:self action:@selector(selectAllergy:) forControlEvents:UIControlEventTouchUpInside];
    signin.frame = CGRectMake(40, 210, 240, 50);
    signin.titleLabel.text = @"Click here to scan ingredients";
    [signin setTitle: @"1. Select Your Allergy" forState: UIControlStateNormal];
    //signin.backgroundColor = [UIColor blackColor];
    // signin.titleLabel.textColor = [UIColor colorWithRed:30/255.f green:34/255.f blue:47/255.f alpha:1];
    //    UIImage* myButtonImage1 = [UIImage imageNamed:@"untitled-3.png"];    
    //   [signin setBackgroundImage:myButtonImage1 forState:UIControlStateNormal];
    //  signin.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:signin];    
    
    //ADDING SCANNER BUTTON
    scanner = [[UIButton alloc] init];
    scanner = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanner addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    scanner.frame = CGRectMake(40, 290, 240, 50);
    scanner.titleLabel.text = @"Click here to scan ingredients";
    [scanner setTitle: @"2. Scan Product's Barcode" forState: UIControlStateNormal];
    [self.view addSubview:scanner];    
    
    //PICKER AREA
    pickerList = [[NSMutableArray alloc] init];
    [pickerList addObject:@"Milk"];
    [pickerList addObject:@"Eggs"];
    [pickerList addObject:@"Peanut"];
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
    NSString *urlString =  @"http://www.delengo.com/getkey.php";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setTimeoutInterval:60.0];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];

    NSString *accessKey = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] encoding:NSUTF8StringEncoding];
    NSLog(@"string from server is: %@", accessKey);
    NSString *alertKey = [NSString stringWithFormat:@"accessKey is %@", accessKey];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Allergy Scanner" message:alertKey delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


- (IBAction)about:(id)sender {  
    
    About *aboutViewController = [[About alloc] initWithNibName:nil bundle:nil];
    UINavigationController *aboutNavigationController = [[UINavigationController alloc] initWithRootViewController:aboutViewController];
    aboutNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    
    [self presentModalViewController:aboutNavigationController animated:YES];
}


- (IBAction)history:(id)sender {  
    
    History *historyViewController = [[History alloc] initWithNibName:nil bundle:nil];
    UINavigationController *historyNavigationController = [[UINavigationController alloc] initWithRootViewController:historyViewController];
    historyNavigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;    
    [self presentModalViewController:historyNavigationController animated:YES];
}


- (IBAction)selectAllergy:(id)sender {  
    
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
    
    //First check if the user selected an allergy to scan for
    if (userAllergy.text == @"Placeholder")
    {        
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
                
                // ADD: present a barcode reader that scans from the camera feed
                ZBarReaderViewController *reader = [ZBarReaderViewController new];
                UINavigationController *navCntrl1 = [[UINavigationController alloc] initWithRootViewController:reader];
                
                reader.readerDelegate = self;
                reader.title = @"Scan a Barcode";
                //    reader.navigationItem.backBarButt  backgroundColor = [UIColor brownColor];
                reader.supportedOrientationsMask = ZBarOrientationMaskAll;
                
                ZBarImageScanner *scanner1 = reader.scanner;
                // TODO: (optional) additional reader configuration here
                
                // EXAMPLE: disable rarely used I2/5 to improve performance
                [scanner1 setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
                
                // present and release the controller
                [self presentModalViewController: navCntrl1 animated: YES];
                
                
                //SHOPSAVVY - SCANNER ACTION
                //            if([SKScannerViewController canRecognizeBarcodes]) { //Make sure we can even attempt barcode recognition, (i.e. on a device without a camera, you wouldn't be able to scan anything).
                //                
                //                SKScannerViewController *scannerVC = [[SKScannerViewController alloc] init]; //Insantiate a new SKScannerViewController
                //                
                //                scannerVC.delegate = self;
                //                scannerVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTapped)];
                //                scannerVC.title = @"Scan a Barcode";
                //                
                //                _codeInfoLabel.text = @""; =//Reset our info text label.
                //                
                //                scannerVC.shouldLookForEAN13AndUPCACodes = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldLookForEAN13AndUPCACodes"];
                //                scannerVC.shouldLookForEAN8Codes = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldLookForEAN8Codes"];
                //                scannerVC.shouldLookForQRCodes = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldLookForQRCodes"];
                //                scannerVC.shouldLookForUPCECodes = [[NSUserDefaults standardUserDefaults] boolForKey:@"shouldLookForUPCECodes"];
                //                
                //                UINavigationController *_nc = [[UINavigationController alloc] initWithRootViewController:scannerVC]; //Put our SKScannerViewController into a UINavigationController. (So it looks nice).
                //                
                //                [self presentModalViewController:_nc animated:YES]; //Slide it up onto the screen.
                
                
            } 
            else //for debug and if there isnt a camera
            {  
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

//#pragma mark SKScannerViewControllerDelegate Methods
//
//- (void) scannerViewController:(SKScannerViewController *)scanner didRecognizeCode:(SKCode *)code {
//	NSLog(@"didRecognizeCode = %@", code.rawContent);
//    
//	AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
//    
//	[self dismissModalViewControllerAnimated:YES]; //We're done scanning barcodes so we should dismiss our modal view controller.
//    
//	_codeInfoLabel.text = code.rawContent; //Grab the nice pretty description of our "Code" object and set it as our label's text so users will know what they've scanned.
//    
//    inputBarcode.text = code.rawContent;
//    
//    //   NSLog(@"SHOW ME %@", code.rawContent);
//    [self showResults:code.rawContent];
//    
//    
//    //userInput.text = code.rawContent;
//    
//    //    NSLog(@"SHOW ME %@", code.rawContent);
//    
//    //   [lookupAlergie userInput.text];
//    //  UILabel *temp = [[UILabel alloc] init];
//    //   [self lookupAlergie:userInput.text withMethod:@"FetchProductByUPC"];
//    //  [self lookupAlergie:userInput.text withMethod:@"FetchNutritionFactsByUPC"];
//}


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


//- (void) scannerViewController:(SKScannerViewController *)scanner didStopLookingForCodesWithError:(NSError *)error {
//	[self dismissModalViewControllerAnimated:YES];
//    
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[[error userInfo] objectForKey:@"Reason"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    
//	[alert show];
//}


- (IBAction)dismissActionSheet:(id)sender {  
    
    NSInteger row = [pickerView selectedRowInComponent:0]; 
    userAllergy.text = [pickerList objectAtIndex:row];
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView
{
    return 1;
}


-(NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    return [pickerList count];
}


-(NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [pickerList objectAtIndex:row];
}


-(void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Selected item: %@ index of selected item: %i", [pickerList objectAtIndex:row], row);
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    _codeInfoLabel = nil;
    
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    // Return YES for supported orientations
//    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

@end
