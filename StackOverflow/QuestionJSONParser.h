//
//  QuestionJSONParser.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/16/15.
//  Copyright © 2015 Cathy Oun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionJSONParser : NSObject
+(NSArray *)questionsResultsFromJSON:(NSDictionary *)jsonInfo;

@end
