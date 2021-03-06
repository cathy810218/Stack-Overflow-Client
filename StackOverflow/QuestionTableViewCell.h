//
//  QuestionTableViewCell.h
//  StackOverflow
//
//  Created by Cathy Oun on 9/17/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
