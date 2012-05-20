//
//  ViewController.h
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>
//#import <ScannerKit/ScannerKit.h>
#import "Results.h"
#import "ZBarSDK.h"
#import "Facebook.h"

#import "MBProgressHUD.h"

@interface ViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, ResultsDelegate, ZBarReaderDelegate, FBSessionDelegate, FBRequestDelegate, UIActionSheetDelegate, MBProgressHUDDelegate> {
    
    UILabel *_codeInfoLabel;
    UILabel *userAllergy;
    UIButton *signin;
    UIButton *scanner;
    UIPickerView *pickerView;
    NSMutableArray *listOfItems;
    NSMutableArray *pickerList;
    NSInteger *status;
    UILabel *inputBarcode;
    NSString *keyAccess;
    UISwitch *enableLocalKey;
    NSArray *keyAccessArray;
    UIImageView *allergyImage;
    UIImageView *allergyTextImage;
    NSString *productDesc;
    NSString *productBrand;
    
    Facebook *facebook;
    MBProgressHUD *hudtemp;
    
}

@property (nonatomic, retain) IBOutlet UIButton *signin;
@property (nonatomic, retain) IBOutlet UIButton *scanner;
@property (nonatomic, retain) IBOutlet UIPickerView *pickerView;
@property (nonatomic, retain) NSMutableArray *listOfItems;
@property (nonatomic, retain) NSMutableArray *pickerList;
@property (nonatomic, retain) UILabel *userAllergy;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UILabel *inputBarcode; 
@property (nonatomic, retain) NSString *keyAccess;
@property (nonatomic, retain) UISwitch *enableLocalKey;
@property (nonatomic, retain) NSArray *keyAccessArray;
@property (nonatomic, retain) UIImageView *allergyImage;
@property (nonatomic, retain) UIImageView *allergyTextImage;
@property (nonatomic, retain) NSString *productDesc;
@property (nonatomic, retain) NSString *productBrand;

@property (nonatomic, retain) Facebook *facebook;
//@property (nonatomic, retain) MBProgressHUD *hudtemp;

- (IBAction)selectAllergy:(id)sender;
- (IBAction)scan:(id)sender;
- (void) showResults: (NSString *) barcode; 
- (void)myTask: (NSString *) dumbString;

@end
