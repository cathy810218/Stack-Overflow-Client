//
//  BurgerMenuViewController.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/14/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "BurgerMenuViewController.h"
#import "QuestionSearchViewController.h"
#import "MyQuestionsViewController.h"
#import "MyProfileViewController.h"
#import "WebViewController.h"
#import "Errors.h"
NSTimeInterval const kTimeToSlideMenuOpen = 0.3;

CGFloat const kburgerOpenScreenDivider = 3.0;
CGFloat const kburgerOpenScreenMultiplier = 2.0;
CGFloat const kburgerButtonWidth = 50.0;
CGFloat const kburgerButtonHeight = 50.0;

@interface BurgerMenuViewController () <UITableViewDelegate>
@property (strong, nonatomic) UIViewController *topViewController;
@property (strong, nonatomic) UIButton *burgerButton;
@property (strong, nonatomic) NSArray *viewControllers;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;

@end

@implementation BurgerMenuViewController

- (void)viewDidLoad {
  [super viewDidLoad];
//  NSError *error;
//  NSString *path = [[NSBundle mainBundle] pathForResource:@"Test" ofType:@"json"];
//  NSData *data = [NSData dataWithContentsOfFile:path];
//  
//  id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
//  if (error) {
//    NSError *myError = [NSError errorWithDomain:kStackOverFlowErrorDomain code:StackOverFlowBADJSON userInfo:nil];
//  }
  
  
  // creating a child
  UITableViewController *mainMenuVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MainMenuVC"];
  mainMenuVC.tableView.delegate = self;
  
  //turn the object into dictionary
  [mainMenuVC setValue:@"Menu" forKey:@"title"]; // same as mainMenuVC.title = @"Menu";
  
  
  
  // adding a child
  [self addChildViewController:mainMenuVC];
  mainMenuVC.view.frame = self.view.frame;
  [self.view addSubview: mainMenuVC.view];
  [mainMenuVC didMoveToParentViewController:self];
  
  //
  UIStoryboard *myQuestionStroyboard = [UIStoryboard storyboardWithName:@"MyQuestions" bundle:[NSBundle mainBundle]];
  
  // creating new children
  QuestionSearchViewController *questionSearchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionSearch"];
  MyQuestionsViewController *myQVC = [myQuestionStroyboard instantiateViewControllerWithIdentifier:@"MyQuestions"];
  MyProfileViewController *myProfileVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyProfile"];
  self.viewControllers = @[questionSearchVC, myQVC, myProfileVC]; // array of VCs
  
  // add observer
  [self addObserver:questionSearchVC forKeyPath:@"isDownloading" options:NSKeyValueObservingOptionNew context:nil];
  
  // adding question search child view
  [self addChildViewController:questionSearchVC];
  questionSearchVC.view.frame = self.view.frame;
  [self.view addSubview:questionSearchVC.view];
  [questionSearchVC didMoveToParentViewController:self];
  self.topViewController = questionSearchVC;
  
  // add a button
  UIButton *burgerButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 40, 40)];
  [burgerButton setImage:[UIImage imageNamed:@"burger"] forState:UIControlStateNormal];
  [self.topViewController.view addSubview:burgerButton];
  [burgerButton addTarget:self action:@selector(burgerButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
  self.burgerButton = burgerButton;
  
  // adding pan gesture
  UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(topViewControllerPanned:)];
  [self.topViewController.view addGestureRecognizer:pan];
  self.pan = pan;

}

-(void)topViewControllerPanned:(UIPanGestureRecognizer*)sender {
  
  CGPoint velocity = [sender velocityInView:self.topViewController.view];
  CGPoint translation = [sender translationInView:self.topViewController.view];
  
//  NSLog(@"velocity x: %f  y: %f", velocity.x, velocity.y);
//  NSLog(@"translation x: %f  y: %f", translation.x, translation.y); // total pts you move

  if (sender.state == UIGestureRecognizerStateChanged) {
    if (velocity.x > 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x, self.topViewController.view.center.y);
      
      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    } else if (velocity.x < 0) {
      self.topViewController.view.center = CGPointMake(self.topViewController.view.center.x + translation.x , self.topViewController.view.center.y);
      
      // dont allow the view to go off screen
      if (self.topViewController.view.frame.origin.x < 0) {
          self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      }

      [sender setTranslation:CGPointZero inView:self.topViewController.view];
    }
  }
  
  if (sender.state == UIGestureRecognizerStateEnded) {
    // when the user let go
    if (self.topViewController.view.frame.origin.x > self.topViewController.view.frame.size.width/kburgerOpenScreenDivider) {
//      NSLog(@"here");
      [UIView animateWithDuration:kTimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x * 2, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
        // add tap recognizer
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
        [self.topViewController.view addGestureRecognizer:tap];
        self.burgerButton.userInteractionEnabled = false;
      }];
    } else {
      [UIView animateWithDuration:kTimeToSlideMenuOpen animations:^{
        self.topViewController.view.center = CGPointMake(self.view.center.x, self.topViewController.view.center.y);
      } completion:^(BOOL finished) {
        
      }];

    }
  }
}
-(void)tapToCloseMenu:(UITapGestureRecognizer *)tap {
  [self.topViewController.view removeGestureRecognizer:tap];
  [UIView animateWithDuration:0.3 animations:^{
    self.topViewController.view.center = self.view.center;
  } completion:^(BOOL finished) {
    self.burgerButton.userInteractionEnabled = true;
  }];
}

-(void)burgerButtonPressed: (UIButton *)sender {
  [UIView animateWithDuration:kTimeToSlideMenuOpen animations:^{
    self.topViewController.view.center = CGPointMake(self.view.center.x * 2, self.topViewController.view.center.y);
  } completion:^(BOOL finished) {
    
    // add tap recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToCloseMenu:)];
    [self.topViewController.view addGestureRecognizer:tap];
    sender.userInteractionEnabled = false;
    
  }];
}

-(void)switchToViewController:(UIViewController *)newVC {
  [UIView animateWithDuration:0.3 animations:^{
    // goes away
    self.topViewController.view.frame = CGRectMake(self.view.frame.size.width, self.topViewController.view.frame.origin.y, self.topViewController.view.frame.size.width, self.topViewController.view.frame.size.height);
  } completion:^(BOOL finished) {
    // now once the view goes away, remove the child
    CGRect oldFrame = self.topViewController.view.frame;
    
    [self.topViewController willMoveToParentViewController:nil]; // ??
    [self.topViewController.view removeFromSuperview]; // its gone now
    [self.topViewController removeFromParentViewController];
    
    // add new child
    [self addChildViewController:newVC];
    newVC.view.frame = oldFrame;
    [self.view addSubview:newVC.view];
    [newVC didMoveToParentViewController:self];
    self.topViewController = newVC;
    
    // remove the burger button and re-add it
    [self.burgerButton removeFromSuperview];
    [self.topViewController.view addSubview:self.burgerButton];
    
    [UIView animateWithDuration:0.3 animations:^{
      self.topViewController.view.center = self.view.center;
    } completion:^(BOOL finished) {
      [self.topViewController.view addGestureRecognizer:self.pan];
      self.burgerButton.userInteractionEnabled = true;
    }];
  }];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"%ld", (long)indexPath.row);
  
  UIViewController *newVC = self.viewControllers[indexPath.row];
  if (![newVC isEqual:self.topViewController]) {
    [self switchToViewController:newVC];
  }
}

-(void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSLog(@"token: %@", [defaults objectForKey:@"token"]);
  
  if ([defaults objectForKey:@"token"] == nil) {
//   check if you alread yhave the token
    WebViewController *webVC = [[WebViewController alloc]init];
    [self presentViewController:webVC animated:true completion:^{
      
    }];
  }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  BOOL *newValue = [(NSNumber *)change [NSKeyValueChangeNewKey] boolValue];
  
}

@end
