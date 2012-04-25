//
//  Results.h
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IngredientsProcessor.h"
#import "History.h"

@protocol ResultsDelegate 
@required
//- (void)setPlacemark:(MKPlacemark *)placemark;
//- (void) getResults:(NSString *)barcode withMethod:(NSString *)method;
@end


@interface Results : UIViewController <HistoryDelegate> {
    
    UILabel *description;
    UILabel *brand;
    UIButton *dismissResults; 
    NSString *tempBarcode;
    UILabel *productBrand; 
    UILabel *productDescription;  
    UILabel *ingredientsLabel; 
    NSString *userAllergyText;
    IngredientsProcessor *ingredientsProcessorObject; 
    NSString *key;
    NSString *success;
    UIAlertView *alert;
    NSDictionary *json_dict;
    NSString *ingredientsListForProcessing;
    
    History *HistoryMgr;
}

@property (nonatomic, retain) UILabel *brand;
@property (nonatomic, retain) UILabel *description;
@property (nonatomic, retain) UIButton *dismissResults; 
@property (nonatomic, retain) NSString *tempBarcode;
@property (nonatomic, retain) UILabel *productBrand; 
@property (nonatomic, retain) UILabel *productDescription;
@property (nonatomic, retain) UILabel *ingredientsLabel; 
@property (nonatomic, retain) NSString *userAllergyText;
@property (nonatomic, retain) IngredientsProcessor *ingredientsProcessorObject;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *success;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSDictionary *json_dict;
@property (nonatomic, retain) NSString *ingredientsListForProcessing; 

@property (nonatomic, retain) History *HistoryMgr;

- (void) getProductInfo:(id)sender;
- (void) lookupAlergie:(NSString *)barcodeLabel withMethod:(NSString *) method withAlergy:(NSString *)allergyText;
- (void) processIngredients:(NSString *) listOfIngredients;

@end
