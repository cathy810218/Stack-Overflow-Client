//
//  Question.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/16/15.
//  Copyright © 2015 Cathy Oun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Question : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *avatarURL;
@property (strong, nonatomic) UIImage *avatarPic;
@property (strong, nonatomic) NSString *ownerName;
@property (strong, nonatomic) NSString *questionLabel;
@property (strong, nonatomic) NSString *contentLabel;

@end
