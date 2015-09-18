//
//  WebViewController.m
//  StackOverflow
//
//  Created by Cathy Oun on 9/14/15.
//  Copyright (c) 2015 Cathy Oun. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController () <WKNavigationDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  WKWebView *webView = [[WKWebView alloc]initWithFrame:self.view.frame];
  [self.view addSubview: webView];
  webView.navigationDelegate = self;
  
  NSString *baseURL = @"https://stackexchange.com/oauth/dialog";
  NSString *clientID = @"5560";
  NSString *redirectURI  = @"https://stackexchange.com/oauth/login_success";
  
  NSString *finalURL = [NSString stringWithFormat:@"%@?client_id=%@&redirect_uri=%@", baseURL, clientID, redirectURI];
  
  [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:finalURL]]];
  
}


-(void)webView:(WKWebView *)webView decidePolicyForNavigationAction: (WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  NSLog(@"url: %@", navigationAction.request.URL);
  NSLog(@"request.url.path: %@", navigationAction.request.URL.path);
//  NSLog(@"request.url.pathExtension: %@", navigationAction.request.URL.pathExtension);
//  NSLog(@"fragmentString: %@", navigationAction.request.URL.fragment);

  if ([navigationAction.request.URL.path isEqualToString:@"/oauth/login_success"]) {
    NSLog(@"got correct base url");
    NSString *fragmentString = navigationAction.request.URL.fragment;
    NSArray *components = [fragmentString componentsSeparatedByString:@"&"];
    NSString *fullTokenParameter = components.firstObject;
    NSString *token = [fullTokenParameter componentsSeparatedByString:@"="].lastObject;
    NSLog(@"%@",token);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:@"token"];
    [defaults synchronize];
    
    [self dismissViewControllerAnimated:true completion: nil];

  }
  
  decisionHandler(WKNavigationActionPolicyAllow);

}

@end
