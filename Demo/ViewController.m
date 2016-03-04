//
//  ViewController.m
//  Demo
//
//  Created by ZhangTinghui on 13-7-17.
//  Copyright (c) 2013年 ZhangTinghui. All rights reserved.
//

#import "ViewController.h"
#import "HUIPatternLockView.h"

@interface UIImage (TintImage)

@end

@implementation UIImage (TintImage)

- (UIImage *)tintImageWithColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode {
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    [self drawInRect:bounds blendMode:blendMode alpha:1.0];

    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)tintImageWithColor:(UIColor *)tintColor {
    return [self tintImageWithColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

@end



@interface ViewController () <HUIPatternLockViewDelegate>
@property (nonatomic, weak) IBOutlet HUIPatternLockView *lockView;
@property (nonatomic, weak) IBOutlet UILabel            *topLabel;
@property (nonatomic, weak) IBOutlet UIButton           *bottomButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configureLockViewWithImages];
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

#pragma mark - 
- (void)_configureLockViewWithImages {
    __weak __typeof(&*self)weakSelf = self;
    self.lockView.contentInset = UIEdgeInsetsMake(150, 20, 150, 20);
    self.lockView.dotWidth = 50;
    
    UIColor *wrongLineColor = [UIColor redColor];
    UIColor *rightLineColor = [UIColor greenColor];
    UIColor *defaultLineColor = [UIColor colorWithRed:248.00/255.00 green:200.0/255.00 blue:79.0/255.00 alpha:1.0];
    
    NSString *unlockPassword = @"[0][3][6][7][8]";
    UIImage *defaultDotImage = [UIImage imageNamed:@"patternlock_dot_normal"];
    UIImage *defaultHightlightedDotImage = [UIImage imageNamed:@"patternlock_dot_normal_highlighted"];
    UIImage *wrongDotImage = [defaultHightlightedDotImage tintImageWithColor:wrongLineColor];
    UIImage *rightDotImage = [defaultHightlightedDotImage tintImageWithColor:rightLineColor];
    
    
    self.lockView.lineColor = defaultLineColor;
    self.lockView.normalDotImage = defaultDotImage;
    self.lockView.highlightedDotImage = defaultHightlightedDotImage;
    [self.lockView setDidDrawPatternWithPassword:^(HUIPatternLockView *lockView, NSUInteger dotCount, NSString *password) {
        
        [weakSelf.topLabel setText:[NSString stringWithFormat:@"%lu dots, password is:%@", (unsigned long)dotCount, password]];
        
        if ([password isEqualToString:unlockPassword]) {
            lockView.lineColor = rightLineColor;
            lockView.normalDotImage = rightDotImage;
            lockView.highlightedDotImage = rightDotImage;
        }
        else {
            lockView.lineColor = wrongLineColor;
            lockView.normalDotImage = wrongDotImage;
            lockView.highlightedDotImage = wrongDotImage;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [lockView resetDotsState];
            [lockView setLineColor:defaultLineColor];
            [lockView setNormalDotImage:defaultDotImage];
            [lockView setHighlightedDotImage:defaultHightlightedDotImage];
        });
    }];
}

- (void)patternLockView:(HUIPatternLockView *)lockView didDrawPatternWithDotCounts:(NSUInteger)dotCounts password:(NSString *)password {
    NSLog(@"Delegate Method also works: %lu dots, password is:%@ ", (unsigned long)dotCounts, password);
}

@end






