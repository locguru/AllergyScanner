//
//  About.m
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "About.h"

@implementation About

@synthesize feedback;
@synthesize scrollview;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // this will appear as the title in the navigation bar
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:20.0];
        label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:170/255.f green:140/255.f blue:90/255.f alpha:1];
        //        label.textColor = [UIColor colorWithRed:191/255.f green:176/255.f blue:137/255.f alpha:1];
        self.navigationItem.titleView = label;
        label.text = @"About";
        [label sizeToFit];

    }
    return self;
}


#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NAV TITLE
   // self.navigationItem.title = @"About";

    //BACKGROUND COLOR 
    self.view.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back2.png"]];

    //NAV ITEMS
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];      
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //ADDING FEEDBACK BUTTON
    feedback = [[UIButton alloc] init];
    feedback = [UIButton buttonWithType:UIButtonTypeCustom];
    [feedback addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];
    UIImage* myButtonImage3 = [UIImage imageNamed:@"send_feedback_button.png"];    
    feedback.frame = CGRectMake((320 - 0.8*myButtonImage3.size.width)/2, 350, 0.8*myButtonImage3.size.width, 0.8*myButtonImage3.size.height);
    [feedback setImage:myButtonImage3 forState:UIControlStateNormal];
    feedback.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:feedback];    
        
    //IMAGE VIEWS 
    UIImage* welcomImageFile = [UIImage imageNamed:@"welcome_title.png"];    
    UIImageView *welcomImage = [[UIImageView alloc] initWithFrame:CGRectMake((320-welcomImageFile.size.width)/2, 25, welcomImageFile.size.width, welcomImageFile.size.height)]; 
    welcomImage.image = [UIImage imageNamed:@"welcome_title.png"];
    [self.view addSubview: welcomImage];

    //DISCLAIMER LABEL
    UILabel *disclaimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 285, 380)];
	disclaimerLabel.text = @"Allergy Scanner by Delengo LLC was created with the purpose of educating and providing information to our users. Though our data is frequently updated, users of this application should not rely exclusively on the information provided. Users are advised to consult with their own healthcare professional and understand that this information should not be interpreted as a medical warning, advice or opinion. \n\nOur application is supported by a third-party database including over 100,000 products. Delengo LLC and Allergy Scanner are not and cannot be held responsible and accountable for the accuracy or content of this database information. Food manufacturers may also change the content of their products at any given time without notice and therefore Delengo LLC and Allergy Scanner cannot be liable for these changes. \n\nDelengo LLC and Allergy Scanner will not be liable for any damage resulting directly or indirectly from the use of this application. The information in this application is presented without any guarantee, expressed or implied.";
    
    disclaimerLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    disclaimerLabel.font = [UIFont systemFontOfSize:12];
    disclaimerLabel.numberOfLines = 0;
    disclaimerLabel.lineBreakMode = UILineBreakModeWordWrap;
    disclaimerLabel.textColor = [UIColor whiteColor];
    
    //ADDING SCROLL VIEW
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 50, 285, 275)];   
    [self.view addSubview:scrollview];    
    CGSize scrollViewContentSize = CGSizeMake(280, 380);
    [scrollview setContentSize:scrollViewContentSize];
    //scrollview.bounces = NO;
    [scrollview addSubview:disclaimerLabel];    
    
}

- (void)done:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)sendFeedback:(id)sender {  
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setToRecipients:[NSArray arrayWithObject:@"support@delengo.com"]];
    [controller setSubject:@"Feedback Re: Allergy Scanner"];
    [controller setMessageBody:nil isHTML:NO]; 
    if (controller) [self presentModalViewController:controller animated:YES];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{ 
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            break;
            
        default:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email" message:@"Sending Failed - Unknown Error :-("
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
            
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ;
}


@end
