//
//  ServerConnectionController.h
//  AllergyScanner
//
//  Created by Itai Ram on 11/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnectionController : UIViewController {
    
    NSString *accessKey;
    NSArray *accessKeyArray;
}

@property (nonatomic, retain) NSString *accessKey;
@property (nonatomic, retain) NSArray *accessKeyArray;

- (void) retreiveAccessKey:(id)sender;

@end
