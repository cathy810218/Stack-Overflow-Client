//
//  Errors.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/14/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import <Foundation/Foundation.h>
extern NSString *const kStackOverFlowErrorDomain;

typedef enum: NSUInteger {
  StackOverFlowBADJSON,
  StackOverFlowConnectionDown,
  StackOverFlowTooManyAttempts,
  StackOverFlowInvalidParameter,
  StackOverFlowNeedAuthentication,
  StackOverFlowGeneralError
} StackOverFlowErrorCodes;