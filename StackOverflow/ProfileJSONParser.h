//
//  ProfileJSONParser.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/17/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProfileJSONParser : NSObject
+(NSArray *)profilesFromJSON:(NSDictionary *)jsonInfo;
@end
