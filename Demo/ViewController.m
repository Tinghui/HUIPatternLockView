//
//  ViewController.m
//  Demo
//
//  Created by ZhangTinghui on 13-7-17.
//  Copyright (c) 2013年 ZhangTinghui. All rights reserved.
//

#import "ViewController.h"
#import "HUIPatternLockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //lockView
    HUIPatternLockView *lockView = [[HUIPatternLockView alloc] initWithFrame:self.view.bounds];
    lockView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    lockView.numberOfRows = 3;
//    lockView.numberOfColumns = 4;
//    lockView.dotWidth = 50.00;
    lockView.contentInset = UIEdgeInsetsMake(150, 20, 60, 20);
    lockView.backgroundColor = [UIColor clearColor];
    lockView.backgroundImage = [UIImage imageNamed:@"bg.png"];
    lockView.normalDotImage = [UIImage imageNamed:@"patternlock_dot_normal.png"];
    lockView.highlightedDotImage = [UIImage imageNamed:@"patternlock_dot_normal_highlighted.png"];
    [self.view addSubview:lockView];
    
    //lable
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(lockView.bounds) - 40, 60)];
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [lockView addSubview:label];
    __weak UILabel *weakLabel = label;
    [lockView setDidDrawPatternWithPassword:
     ^(HUIPatternLockView *lock, NSUInteger dotCount, NSString *password) {
         
         [weakLabel setText:[NSString stringWithFormat:
                             @"%lu dots, password is:%@", (unsigned long)dotCount, password]];
         
     }];
    
    
    //button
    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setFrame:CGRectMake(CGRectGetWidth(lockView.bounds) - 160,
                                    CGRectGetHeight(lockView.bounds) - 40,
                                    140,
                                    30)];
    [testButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin];
    [testButton setTitle:@"Forgot Password" forState:UIControlStateNormal];
    [testButton addTarget:self action:@selector(_testButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [lockView addSubview:testButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_testButtonPressed:(UIButton *)button
{
    [[[UIAlertView alloc] initWithTitle:nil
                               message:@"You press Forgot Password Button"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
