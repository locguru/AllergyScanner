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
    UILabel *ingredients; 
    NSString *userAllergyText;
    IngredientsProcessor *ingredientsProcessorObject; 
    NSString *key;
    NSString *success;
    UIAlertView *alert;
    
}
@property (nonatomic, retain) UILabel *brand;
@property (nonatomic, retain) UILabel *description;
@property (nonatomic, retain) UIButton *dismissResults; 
@property (nonatomic, retain) NSString *tempBarcode;
@property (nonatomic, retain) UILabel *productBrand; 
@property (nonatomic, retain) UILabel *productDescription;
@property (nonatomic, retain) UILabel *ingredients; 
@property (nonatomic, retain) NSString *userAllergyText;
@property (nonatomic, retain) IngredientsProcessor *ingredientsProcessorObject;
@property (nonatomic, retain) NSString *key;
@property (nonatomic, retain) NSString *success;
@property (nonatomic, retain) UIAlertView *alert;

- (void) getProductInfo:(id)sender;
- (void) lookupAlergie:(NSString *)barcodeLabel withMethod:(NSString *) method withAlergy:(NSString *)allergyText;
- (void) processIngredients:(NSString *) listOfIngredients;

@end
