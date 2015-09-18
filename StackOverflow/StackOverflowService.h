//
//  StackOverflowService.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/15/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StackOverflowService : NSObject
+ (void)questionsForSearchTerm: (NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler;
+ (void)myProfileCompletionHandler:(void(^)(NSArray *, NSError *))completionHandler;
@end
