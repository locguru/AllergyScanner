//
//  About.h
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface About : UIViewController <MFMailComposeViewControllerDelegate, UIScrollViewDelegate>{
    
    UIButton *feedback;
    IBOutlet UIScrollView *scrollview;
}

@property (nonatomic, retain) UIButton *feedback;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollview;

- (void)done:(id)sender;
- (IBAction)sendFeedback:(id)sender;

@end
