//
//  Note.h
//  wheely-test
//
//  Created by Admin on 14.01.14.
//  Copyright (c) 2014 kuchumovn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject

@property(nonatomic) NSNumber* id;
@property(nonatomic) NSString* title;
@property(nonatomic) NSString* text;

- (id) initWithJSON: (NSDictionary*) data;

@end
