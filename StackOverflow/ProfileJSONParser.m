//
//  ProfileJSONParser.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/17/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "ProfileJSONParser.h"
#import "Profile.h"

@implementation ProfileJSONParser
+(NSArray *)profilesFromJSON:(NSDictionary *)jsonInfo {
  
  NSMutableArray *profiles = [[NSMutableArray alloc] init];
  
  NSArray *items = jsonInfo[@"items"];
  for(NSDictionary *item in items) {
    Profile *profile = [[Profile alloc] init];
    profile.ownerName = item[@"display_name"];
    profile.avatarURL = item[@"profile_image"];
    profile.accID = item[@"account_id"];
    profile.reputation = item[@"reputation"];
    [profiles addObject:profile];
    
  }
  return profiles;
}

@end
