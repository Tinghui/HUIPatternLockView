//
//  ViewController.m
//  Demo
//
//  Created by ZhangTinghui on 13-7-17.
//  Copyright (c) 2013年 ZhangTinghui. All rights reserved.
//

#import "ViewController.h"
#import "HUIPatternLockView.h"

@interface ViewController () <HUIPatternLockViewDelegate>
@property (nonatomic, weak) IBOutlet HUIPatternLockView *lockView;
@property (nonatomic, weak) IBOutlet UILabel            *topLabel;
@property (nonatomic, weak) IBOutlet UIButton           *bottomButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak __typeof(&*self)weakSelf = self;
    self.lockView.contentInset = UIEdgeInsetsMake(150, 20, 150, 20);
    self.lockView.dotWidth = 50;
    self.lockView.normalDotImage = [UIImage imageNamed:@"patternlock_dot_normal"];
    self.lockView.highlightedDotImage = [UIImage imageNamed:@"patternlock_dot_normal_highlighted"];
    [self.lockView setDidDrawPatternWithPassword:^(HUIPatternLockView *lockView, NSUInteger dotCount, NSString *password) {
        [weakSelf.topLabel setText:[NSString stringWithFormat:@"%lu dots, password is:%@", (unsigned long)dotCount, password]];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)_testButtonPressed:(UIButton *)button {
    [[[UIAlertView alloc] initWithTitle:nil
                               message:@"You press Forgot Password Button"
                              delegate:nil
                     cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)patternLockView:(HUIPatternLockView *)lockView didDrawPatternWithDotCounts:(NSUInteger)dotCounts password:(NSString *)password {
    NSLog(@"Delegate Method also works: %lu dots, password is:%@ ", (unsigned long)dotCounts, password);
}

@end


