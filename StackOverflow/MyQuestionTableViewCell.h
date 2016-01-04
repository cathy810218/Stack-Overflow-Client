//
//  MyQuestionTableViewCell.h
//  StackOverflow
//
//  Created by Cathy Oun on 1/4/16.
//  Copyright © 2016 Cathy Oun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyQuestionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *question;
@property (weak, nonatomic) IBOutlet UILabel *content;

@end
