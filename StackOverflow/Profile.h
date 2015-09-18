//
//  Profile.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/17/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Profile : NSObject
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPic;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *accID;
@property (strong, nonatomic) NSString *reputation;

@end
