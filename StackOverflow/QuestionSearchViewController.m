//
//  QuestionSearchViewController.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/14/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "QuestionSearchViewController.h"
#import "StackOverflowService.h"
#import "Question.h"
#import <UIKit/UIKit.h>
#import "QuestionTableViewCell.h"
#import "Keys.h"
@interface QuestionSearchViewController () <UISearchBarDelegate, UITabBarControllerDelegate, UITableViewDataSource>
@property (strong,nonatomic) NSArray *questions;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation QuestionSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.isDownloading = true;
//  UISearchBar *searchBar = [[UISearchBar alloc]init];
  self.tableView.dataSource = self;
//  self.tableView.delegate = self;
//  self.searchBar = searchBar;
  self.searchBar.delegate = self;
  
  // add the KEY
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  [defaults setObject:key forKey:@"key"];
  [defaults synchronize];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [searchBar resignFirstResponder]; // ?
  [StackOverflowService questionsForSearchTerm:searchBar.text completionHandler:^(NSArray *results, NSError *error) {
    if (error) {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [alertController dismissViewControllerAnimated:true completion:nil];
      }];
      [alertController addAction:action];
      
      [self presentViewController:alertController animated:true completion:nil];
    } else {
      self.questions = results;
      dispatch_group_t group = dispatch_group_create();
      dispatch_queue_t imageQueue = dispatch_queue_create("com.cathyoun.stackoverflows", DISPATCH_QUEUE_CONCURRENT);
      for (Question *question in results) {
        dispatch_group_async(group, imageQueue, ^{
          NSString *avatarURL = question.avatarURL;
          NSURL *imageURL = [NSURL URLWithString:avatarURL];
          NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
          UIImage *image = [UIImage imageWithData:imageData];
          question.avatarPic = image;
        });
      }
      
      dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Images Downloaded" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
          [alertController dismissViewControllerAnimated:true completion:nil];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:true completion:nil];
        self.isDownloading = false;
        [self.tableView reloadData];
      });
     

    }
  }];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell" forIndexPath:indexPath];
  Question *question = self.questions[indexPath.row];
  cell.tag++;
  NSInteger tag = cell.tag;
  if (cell.tag == tag) {
    cell.profileImage.image = question.avatarPic;
    cell.titleLabel.text = question.title;
    cell.nameLabel.text = question.ownerName;
  }
  return cell;
}


@end
