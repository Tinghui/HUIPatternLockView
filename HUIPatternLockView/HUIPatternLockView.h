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
 *  The rows of the dots. Default is 3, should not be less or equal to 0.
 */
@property (nonatomic, assign) NSInteger numberOfRows;

/**
 *  The columns of the dots. Default is 3, should not be less or equal to 0.
 */
@property (nonatomic, assign) NSInteger numberOfColumns;

/**
 *  The distance that the dots view is inset from the enclosing pattern lock view.
 *  Default is UIEdgeInsetsZero.
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/**
 *  The width of the dot. Default is 60pt, should not be less or equal to 10pt
 *  if (numberOfRows * dotWidth) or (numberOfColumns * dotWidth) is bigger than the content size. There will be an exception.
 */
@property (nonatomic, assign) CGFloat dotWidth;

/**
 * The color of the line. Default is RGBA(248, 200, 79, 1.0)
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 * The width of the line. Default is 5pt
 */
@property (nonatomic, assign) CGFloat lineWidth;


/**
 *  background Image for the pattern lock view
 */
@property (nonatomic, strong) UIImage *backgroundImage;

/**
 * Dot image for normal state
 */
@property (nonatomic, strong) UIImage *normalDotImage;

/**
 * Dot image for highlighted state
 */
@property (nonatomic, strong) UIImage *highlightedDotImage;



/**
 * Delegate
 * See also <HUIPatternLockViewDelegate>
 */
@property (nonatomic, weak) id<HUIPatternLockViewDelegate> delegate;


/**
 * Block style delegate methods
 *
 * See also -patternLockView:didDrawPatternWithDotCounts:password: method in <HUIPatternLockViewDelegate> protocol.
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