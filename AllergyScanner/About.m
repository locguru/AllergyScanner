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
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //NAV TITLE
    self.navigationItem.title = @"About";
    
    //BACKGROUND COLOR 
    self.view.backgroundColor = [UIColor brownColor];
    
    //NAV ITEMS
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(done:)];      
    self.navigationItem.rightBarButtonItem = rightButton;
    
    //ADDING FEEDBACK BUTTON
    feedback = [[UIButton alloc] init];
    feedback = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [feedback addTarget:self action:@selector(sendFeedback:) forControlEvents:UIControlEventTouchUpInside];
    feedback.frame = CGRectMake(40, 350, 240, 40);
    //   feedback.titleLabel.text = @"Click here to scan ingredients";
    [feedback setTitle:@"Send us feedback!" forState: UIControlStateNormal];
    //    feedback.titleLabel.font = [UIFont systemFontOfSize:18];
    feedback.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    [self.view addSubview:feedback];    
    
    
    //TITLE LABEL
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 300, 40)];
	titleLabel.text = @"Welcome to AllergyScanner!";
	titleLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    titleLabel.font = [UIFont systemFontOfSize:18];
	[self.view addSubview:titleLabel];
    
    //DISCLAIMER LABEL
    UILabel *disclaimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 285, 380)];
	disclaimerLabel.text = @"AllergyScanner was created with the purpose of educating and providing information to our users. Though our data is frequently updated, users of this application should not rely exclusively on the information provided. Users are advised to consult with their own healthcare professional and understand that this information should not be interpreted as a medical warning, advice or opinion. \n\nOur application is supported by a third-party database including over 100,000 products. AllergyScanner is not and cannot be held responsible and accountable for the accuracy or content of this database information. Food manufacturers may also change the content of their products at any given time without notice and therefore AllergyScanner cannot be liable for these changes. \n\nAllergyScanner will not be liable for any damage resulting directly or indirectly from the use of this application. The information in this application is presented without any guarantee, expressed or implied.";
    
    disclaimerLabel.backgroundColor = [UIColor clearColor]; // [UIColor brownColor];
    disclaimerLabel.font = [UIFont systemFontOfSize:12];
    disclaimerLabel.numberOfLines = 0;
    disclaimerLabel.lineBreakMode = UILineBreakModeWordWrap;
    
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
    [controller setSubject:@"Feedback Re: AllergyScanner"];
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
