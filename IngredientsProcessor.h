//
//  IngredientsProcessor.h
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IngredientsProcessor : NSObject  {
    
    BOOL response; 
    NSMutableArray *badIngredients;     
}

@property (nonatomic, retain) NSMutableArray *badIngredients; 

- (void) ingredientsEngine:(NSString *)allergyName withIngreients:(NSString *)ingredientsString;


@end
