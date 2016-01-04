//
//  MyQuestionsViewController.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/14/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "MyQuestionsViewController.h"
#import "MyQuestionTableViewCell.h"
//#import "MyQuestion.h"
#import "Question.h"
#import "StackOverflowService.h"

@interface MyQuestionsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myQuestions;
@end

@implementation MyQuestionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  self.tableView.dataSource = self;
  
  [StackOverflowService questionsForUser:^(NSArray *questions, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error.localizedDescription);
    } else {
      self.myQuestions = questions;
      [self.tableView reloadData];
    }
  }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [self.myQuestions count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  MyQuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyQuestionCell" forIndexPath:indexPath];
  Question *que = [self.myQuestions objectAtIndex:indexPath.row];
//  cell.tag++;
//  NSInteger tag = cell.tag;
//  if (cell.tag == tag) {
  cell.question.text = que.title;
//    cell.content.text = que.content;
//  }
  return cell;

}

@end
