//
//  HUIPatternLockView.h
//  HUIPatternLockView
//
//  Created by ZhangTinghui on 13-7-17.
//  Copyright (c) 2013年 ZhangTinghui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@protocol HUIPatternLockViewDelegate;
@interface HUIPatternLockView : UIView

/**
 * Dot image for normal state
 */
@property (nonatomic, strong) UIImage *dotNormalImage;


/**
 * Dot image for highlighted state
 */
@property (nonatomic, strong) UIImage *dotHighlightedImage;


/**
 * The width for each dot image. Default is 60 pt.
 */
@property (nonatomic, assign) CGFloat dotWidth;


/**
 * Number of dots in each line/row. !!!The min size and the default size is 3.
 *
 */
@property (nonatomic, assign, readonly) NSUInteger cubeSize;


/**
 * The color of the line. Default is RGBA(248, 200, 79, 1.0)
 */
@property (nonatomic, strong) UIColor *lineColor;


/**
 * The width of the line. Default is 5pt
 */
@property (nonatomic, assign) CGFloat lineWidth;


/**
 * Delegate
 * See also <HUIPatternLockViewDelegate>
 */
@property (nonatomic, weak) id<HUIPatternLockViewDelegate> delegate;


/**
 * Block style delegate methods
 *
 * See also -patternLockView:didDrawPatternWithDotCounts:password: method in <HUIPatternLockViewDelegate>.
 */
@property (nonatomic, copy) void(^didDrawPatternWithPassword)(HUIPatternLockView *lockView, NSUInteger dotCounts, NSString *password);



@end



@protocol HUIPatternLockViewDelegate <NSObject>

@optional

/**
 * Tells the delegate a lock pattern has been drawn.
 *
 * @param lockView  A HUIPatternLockView object informing the delegate about the drawing is done.
 * @param dotCounts The count of the dots which has been drawn in the pattern.
 * @param password  The password complies with the drawn pattern.
 */
- (void)patternLockView:(HUIPatternLockView *)lockView didDrawPatternWithDotCounts:(NSUInteger)dotCounts password:(NSString *)password;

@end