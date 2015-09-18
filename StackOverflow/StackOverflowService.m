//
//  StackOverflowService.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/15/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "StackOverflowService.h"
#import <AFNetworking/AFNetworking.h>
#import "Errors.h"
#import "Question.h"
#import "QuestionJSONParser.h"
#import "ProfileJSONParser.h"

@implementation StackOverflowService

+ (void)questionsForSearchTerm: (NSString *)searchTerm completionHandler:(void(^)(NSArray *, NSError *))completionHandler {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSLog(@"Key: %@, Token: %@, Search Term: %@",[defaults objectForKey:@"key"],[defaults objectForKey:@"token"],searchTerm);
  
  NSString *url = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/search?key=%@&access_token=%@&order=desc&sort=activity&intitle=%@&site=stackoverflow", [defaults objectForKey:@"key"],[defaults objectForKey:@"token"],searchTerm];
  
  
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:url parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
    
//    NSLog(@"status code: %ld", operation.response.statusCode);

    NSArray *questions = [QuestionJSONParser questionsResultsFromJSON:responseObject];
    completionHandler(questions,nil);

  } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
    
    if (operation.response) {
      NSError *stackOverFlowError = [self errorForStatusCode:operation.response.statusCode];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil, stackOverFlowError);
      });
      
    } else {
      NSError *reachAbilityError = [self checkReachAbility];
      if (reachAbilityError) {
        completionHandler(nil, reachAbilityError);
      }
    }
    
  }];

}

+ (void)myProfileCompletionHandler:(void(^)(NSArray *, NSError *))completionHandler {
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSString *myUrl = [NSString stringWithFormat:@"https://api.stackexchange.com/2.2/me?key=%@&access_token=%@&order=desc&sort=reputation&site=stackoverflow", [defaults objectForKey:@"key"],[defaults objectForKey:@"token"]];
  AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
  
  [manager GET:myUrl parameters:nil success:^(AFHTTPRequestOperation * __nonnull operation, id __nonnull responseObject) {
    
    NSLog(@"status code: %ld", operation.response.statusCode);
    
    NSArray *profiles = [ProfileJSONParser profilesFromJSON:responseObject];
    completionHandler(profiles,nil);
    
  } failure:^(AFHTTPRequestOperation * __nonnull operation, NSError * __nonnull error) {
    
    if (operation.response) {
      NSError *stackOverFlowError = [self errorForStatusCode:operation.response.statusCode];
      
      dispatch_async(dispatch_get_main_queue(), ^{
        completionHandler(nil, stackOverFlowError);
      });
      
    } else {
      NSError *reachAbilityError = [self checkReachAbility];
      if (reachAbilityError) {
        completionHandler(nil, reachAbilityError);
      }
    }
    
  }];

}


+ (NSError *)checkReachAbility {
  if (![AFNetworkReachabilityManager sharedManager].reachable) {
    // not reachable
    NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowConnectionDown userInfo:@{NSLocalizedDescriptionKey : @"Could not connect to servers, please try again when you have a connection"}];
    return error;
  }
  return nil;
}

+ (NSError *)errorForStatusCode: (NSInteger)statusCode {
  
  NSInteger errorCode;
  NSString *localizedDescription;
  
  switch (statusCode) {
    case 502:
      localizedDescription = @"Too many requests";
      errorCode = StackOverFlowTooManyAttempts;
      break;
    case 400:
      localizedDescription = @"Invalid search term";
      errorCode = StackOverFlowInvalidParameter;
      break;
    case 401:
      localizedDescription = @"You must sign in to access this feature";
      errorCode = StackOverFlowNeedAuthentication;
      break;
    default:
      localizedDescription = @"I dont want why this is happening";
      errorCode = StackOverFlowGeneralError;
      break;
  }
  NSError *error = [NSError errorWithDomain:kStackOverFlowErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : localizedDescription}];
  return error;
}



@end
