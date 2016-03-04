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

@interface HUIPatternLockView : UIView <NSCoding>

#pragma mark Layouts Related Properties
/*!
 *  The rows of the dots.
 *  
 *  Default is 3. Should not be less or equal to 0, otherwise there will be an exception.
 */
@property (nonatomic, assign) NSInteger numberOfRows;

/*!
 *  The columns of the dots. 
 *
 *  Default is 3. Should not be less or equal to 0, otherwise there will be an exception.
 */
@property (nonatomic, assign) NSInteger numberOfColumns;

/*!
 *  The distance that the dots view is inset from the enclosing pattern lock view.
 *
 *  Default is UIEdgeInsetsZero.
 */
@property (nonatomic, assign) UIEdgeInsets contentInset;

/*!
 *  The width of the dot. 
 *  
 *  Default is 60pt. Should not be less or equal to 10pt, otherwise there will be an exception.
 *
 *  And if (numberOfRows * dotWidth) or (numberOfColumns * dotWidth) is bigger than the content size. There also will be an exception.
 */
@property (nonatomic, assign) CGFloat dotWidth;


#pragma mark Appearance Related Properties

/*!
 *  The color of the line. 
 *  
 *  Default is RGBA(248, 200, 79, 1.0)
 */
@property (nonatomic, strong) UIColor *lineColor;

/*!
 *  The width of the line. 
 *  
 *  Default is 5pt.
 */
@property (nonatomic, assign) CGFloat lineWidth;

/*!
 *  Dot image for the normal state
 */
@property (nonatomic, strong) UIImage *normalDotImage;

/*!
 *  Dot image for the highlighted state
 */
@property (nonatomic, strong) UIImage *highlightedDotImage;

/*!
 *  Reset dots, clean the drawn pattern.
 */
- (void)resetDotsState;


#pragma mark Delegate

/*!
 *  The delegate for the lock view.
 *
 *  @see <HUIPatternLockViewDelegate> protocol
 */
@property (nonatomic, weak) IBOutlet id<HUIPatternLockViewDelegate> delegate;


/*!
 *  Block style delegate methods
 *
 *  @see -patternLockView:didDrawPatternWithDotCounts:password: method in <HUIPatternLockViewDelegate> protocol.
 */
@property (nonatomic, copy) void(^didDrawPatternWithPassword)(HUIPatternLockView *lockView, NSUInteger dotCounts, NSString *password);

@end




@protocol HUIPatternLockViewDelegate <NSObject>

@optional

/*!
 *  Tells the delegate a lock pattern has been drawn.
 *
 *  @param lockView  The HUIPatternLockView object which is informing the delegate about the drawing is done.
 *  @param dotCounts The count of the dots which has been drawn in the pattern.
 *  @param password  The password complies with the drawn pattern.
 */
- (void)patternLockView:(HUIPatternLockView *)lockView didDrawPatternWithDotCounts:(NSUInteger)dotCounts password:(NSString *)password;

@end


