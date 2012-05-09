//
//  ProductDataBaseEngine.h
//  AllergyScanner
//
//  Created by Itai Ram on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductDataBaseEngine : NSObject{
    
    NSString *engineKey;
    NSString *engineMethod;
    NSString *success;
    NSString *engineBarcode;
    NSDictionary *engingJsonDict;

}

@property (nonatomic, retain) NSString *engineKey;
@property (nonatomic, retain) NSString *engineMethod;
@property (nonatomic, retain) NSString *success;
@property (nonatomic, retain) NSString *engineBarcode;
@property (nonatomic, retain) NSDictionary *engingJsonDict;

- (void) productDataBaseEngine;


@end
