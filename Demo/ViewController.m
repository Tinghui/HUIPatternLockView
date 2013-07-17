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
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    [self.view addSubview:label];
    
    
    HUIPatternLockView *lockView = [[HUIPatternLockView alloc] initWithFrame:
                                    CGRectMake(20, 70, 280, 280)];
    
    [lockView setDotNormalImage:[UIImage imageNamed:@"patternlock_dot_normal.png"]];
    [lockView setDotHighlightedImage:[UIImage imageNamed:@"patternlock_dot_normal_highlighted.png"]];
    [lockView setBackgroundColor:[UIColor clearColor]];
    
    __weak UILabel *weakLabel = label;
    [lockView setDidDrawPatternWithPassword:
     ^(HUIPatternLockView *lock, NSUInteger dotCount, NSString *password) {
        
        [weakLabel setText:[NSString stringWithFormat:
                            @"%d dots, password is:%@", dotCount, password]];
        
    }];
    [self.view addSubview:lockView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
