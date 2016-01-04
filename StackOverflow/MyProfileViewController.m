//
//  MyProfileViewController.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/16/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "MyProfileViewController.h"
#import "StackOverflowService.h"
#import "Profile.h"

@interface MyProfileViewController ()
//@property (retain, nonatomic) NSString *myName; // strong, retain count increases
//@property (assign, nonatomic) NSNumber *myNumber; // weak, retain count dont increase
@property (retain, nonatomic) IBOutlet UIImageView *userImage;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *reputationLabel;

@property (strong, nonatomic) IBOutlet UILabel *accIDLabel;

@end

@implementation MyProfileViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
//  NSString *myString = [NSString stringWithFormat:@"Hi"]; // dont own this string, but autoreleasepool owns it
//  [myString retain]; // retain count increases 1, so now the retain count is 2
//  
//  self.myName = myString; // retain count increases 1
//  [myString release]; // down to 2
  
  [self displayMyProfile];
  
  
  // Do any additional setup after loading the view.
}


- (void) displayMyProfile {
  [StackOverflowService myProfileCompletionHandler:^(NSArray *result, NSError *error) {
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      for (Profile *myProfile in result) {
        NSString *avatarURL = myProfile.avatarURL;
        NSURL *imageURL = [NSURL URLWithString:avatarURL];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        myProfile.avatarPic = image;
        self.userImage.image = image;
        self.nameLabel.text = [NSString stringWithFormat:@"Name: %@", myProfile.ownerName];
        self.reputationLabel.text = [NSString stringWithFormat:@"Reputation: %@", myProfile.reputation];
        self.accIDLabel.text = [NSString stringWithFormat:@"Account ID: %@", myProfile.accID];
      }
      NSLog(@"%@",result);
    }
  }];
}

-(void)dealloc {
//  [_myName release];
  [super dealloc];
}

@end
