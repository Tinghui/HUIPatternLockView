//
//  HUIPatternLockView.m
//  HUIPatternLockView
//
//  Created by ZhangTinghui on 13-7-17.
//  Copyright (c) 2013年 ZhangTinghui. All rights reserved.
//

#if !__has_feature(objc_arc)
#error This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

#import "HUIPatternLockView.h"

#pragma mark - @class HUIPatternLockViewDot
@interface HUIPatternLockViewDot : NSObject
@property (nonatomic, assign) NSUInteger    number;
@property (nonatomic, assign) CGRect        frame;
@property (nonatomic, assign) CGPoint       center;

+ (instancetype)dotWithNumber:(NSUInteger)number frame:(CGRect)frame;
@end


@implementation HUIPatternLockViewDot

+ (instancetype)dotWithNumber:(NSUInteger)number frame:(CGRect)frame {
    HUIPatternLockViewDot *dot = [[self alloc] init];
    dot.number  = number;
    dot.frame   = frame;
    dot.center  = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    return dot;
}
@end




#pragma mark - @class HUIPatternLockView
static const NSInteger  kDefaultNumberOfRowsOrColumns   = 3;
static const CGFloat    kDefaultDotWidth                = 60.00f;
static const CGFloat    kDefaultLineWidth               = 8.0f;
#define kDefaultLineColor   [UIColor colorWithRed:248.00/255.00 green:200.0/255.00 blue:79.0/255.00 alpha:1.0]

@interface HUIPatternLockView ()
@property (nonatomic, strong) NSMutableArray *normalDots;
@property (nonatomic, strong) NSMutableArray *highlightedDots;
@property (nonatomic, strong) NSMutableArray *linePath;

@property (nonatomic, assign) BOOL needRecalculateDotsFrame;
@end


@implementation HUIPatternLockView

- (void)dealloc {
    [self _removeKVOObserverOnSelfPropertiesWhichEffectsDotsFrames];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    [self _loadDefaultConfiguration];
    [self _addKVOObserverOnSelfPropertiesWhichEffectsDotsFrames];
    [self setNeedsDisplay];
    
    return self;
}

#pragma mark - Draw Rect
- (void)_loadDefaultConfiguration {
    self.numberOfRows               = kDefaultNumberOfRowsOrColumns;
    self.numberOfColumns            = kDefaultNumberOfRowsOrColumns;
    self.lineColor                  = kDefaultLineColor;
    self.lineWidth                  = kDefaultLineWidth;
    self.dotWidth                   = kDefaultDotWidth;
    self.contentInset               = UIEdgeInsetsZero;
    self.needRecalculateDotsFrame   = YES;
}

- (void)_resetDotsStateWithBounds:(CGRect)bounds {
    self.normalDots = [NSMutableArray array];
    self.highlightedDots = [NSMutableArray array];
    self.linePath   = [NSMutableArray array];
    
    //calculate dot width with bounds
    CGFloat dotsAreaWidth = CGRectGetWidth(self.bounds) - self.contentInset.left - self.contentInset.right;
    CGFloat dotsAreaHeight = CGRectGetHeight(self.bounds) - self.contentInset.top - self.contentInset.bottom;
    //throw exception if dots is too big
    if (self.dotWidth * self.numberOfColumns > dotsAreaWidth
        || self.dotWidth * self.numberOfRows > dotsAreaHeight) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"The dot is too big to be layout in content area"
                                     userInfo:nil];
        return;
    }
    
    CGFloat widthPerDots = dotsAreaWidth / self.numberOfColumns;
    CGFloat heightPerDots = dotsAreaHeight / self.numberOfRows;
    
    NSInteger number = 0;
    for (NSInteger i = 0; i < self.numberOfRows; i++) {
        for (NSInteger j = 0; j < self.numberOfColumns; j++) {
            
            CGPoint dotCenter = CGPointMake(self.contentInset.left + (j + 0.5) * widthPerDots,
                                          self.contentInset.top + (i + 0.5) * heightPerDots);
            
            CGRect dotFrame = CGRectMake(dotCenter.x - self.dotWidth * 0.5,
                                         dotCenter.y - self.dotWidth * 0.5,
                                         self.dotWidth,
                                         self.dotWidth);
            [self.normalDots addObject:[HUIPatternLockViewDot dotWithNumber:(number++) frame:dotFrame]];
        }
    }
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //recalculate dots' frame if needed
    if (self.needRecalculateDotsFrame) {
        [self _resetDotsStateWithBounds:self.bounds];
    }
    self.needRecalculateDotsFrame = NO;
    
    //draw background image
    if (self.backgroundImage != nil) {
        CGPoint point = CGPointMake((CGRectGetWidth(rect) - self.backgroundImage.size.width) * 0.5f,
                                    (CGRectGetHeight(rect) - self.backgroundImage.size.height) * 0.5f);
        [self.backgroundImage drawAtPoint:point
                                blendMode:kCGBlendModeNormal
                                    alpha:1.0];
    }
    
    //draw line
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    if ([self.linePath count] > 0) {
        NSValue *firstValue = self.linePath[0];
        for (NSValue *pointValue in self.linePath) {
            CGPoint point = [pointValue CGPointValue];
            if (pointValue == firstValue) {
                CGContextMoveToPoint(context, point.x, point.y);
            }
            else {
                CGContextAddLineToPoint(context, point.x, point.y);
            }
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    //draw dot images
    if (self.normalDotImage != nil) {
        for (HUIPatternLockViewDot *dot in self.normalDots) {
            [self.normalDotImage drawInRect:dot.frame];
        }
    }
    
    if (self.highlightedDotImage != nil) {
        for (HUIPatternLockViewDot *dot in self.highlightedDots) {
            [self.highlightedDotImage drawInRect:dot.frame];
        }
    }
}


#pragma mark - Properties
- (void)setNumberOfRows:(NSInteger)numberOfRows {
    if (numberOfRows <= 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"numberOfRows should not less or equal to Zero"
                                     userInfo:nil];
        return;
    }
    
    _numberOfRows = numberOfRows;
}

- (void)setNumberOfColumns:(NSInteger)numberOfColumns {
    if (numberOfColumns <= 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"numberOfColumns should not less or equal to Zero"
                                     userInfo:nil];
        return;
    }
    
    _numberOfColumns = numberOfColumns;
}

- (void)setDotWidth:(CGFloat)dotWidth {
    if (dotWidth <= 10.00) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"dotWidth should not less or equal to 10pt, too small make\
                it hard to been touch"
                                     userInfo:nil];
        return;
    }
    
    _dotWidth = dotWidth;
}

- (void)setLineColor:(UIColor *)lineColor {
    if (_lineColor == lineColor) {
        return;
    }
    
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

#pragma mark - KVO
- (NSArray *)_propertyKeyPathesWhichEffectsDotsFrames {
    return @[NSStringFromSelector(@selector(frame)),
             NSStringFromSelector(@selector(numberOfRows)),
             NSStringFromSelector(@selector(numberOfColumns)),
             NSStringFromSelector(@selector(dotWidth)),
             NSStringFromSelector(@selector(contentInset))];
}

- (BOOL)_isKVOKeyPathIsThePropertyWhichEffectsDotsFrames:(NSString *)KVOKeyPath {
    return [[self _propertyKeyPathesWhichEffectsDotsFrames] containsObject:KVOKeyPath];
}

- (void)_removeKVOObserverOnSelfPropertiesWhichEffectsDotsFrames {
    NSArray *keyPathes = [self _propertyKeyPathesWhichEffectsDotsFrames];
    for (NSString *keyPath in keyPathes) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (void)_addKVOObserverOnSelfPropertiesWhichEffectsDotsFrames {
    NSArray *keyPathes = [self _propertyKeyPathesWhichEffectsDotsFrames];
    for (NSString *keyPath in keyPathes) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (object != self || ![self _isKVOKeyPathIsThePropertyWhichEffectsDotsFrames:keyPath]) {
        return;
    }
    
    self.needRecalculateDotsFrame = YES;
    [self setNeedsDisplay];
}

#pragma mark - Record Line Path
- (HUIPatternLockViewDot *)_normalDotContainsPoint:(CGPoint)point {
    for (HUIPatternLockViewDot * dot in self.normalDots){
        if (CGRectContainsPoint(dot.frame, point)) {
            return dot;
        }
    }
    return nil;
}

- (void)_updateLinePathWithPoint:(CGPoint)point {
    HUIPatternLockViewDot *dot = [self _normalDotContainsPoint:point];
    NSInteger linePathPointsCount = [self.linePath count];
    
    if (dot != nil) {
        NSValue *pointValue = [NSValue valueWithCGPoint:dot.center];
        if (linePathPointsCount <= 0) {
            //if no any points in linePath. use this dot's center to be the linePath start and end point
            [self.linePath addObject:pointValue];
            [self.linePath addObject:pointValue];
        }
        else {
            //else insert a new point into the path
            [self.linePath insertObject:pointValue atIndex:linePathPointsCount-1];
        }
        
        //mark this dot as highlighted
        [self.normalDots removeObject:dot];
        [self.highlightedDots addObject:dot];
    }
    else {
        
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        if (linePathPointsCount == 0) {
            //linePath must start with a dot's center
            return;
        }
        else if (linePathPointsCount == 1) {
            //if linePath has a start point, this point is treat as end point
            [self.linePath addObject:pointValue];
        }
        else {
            //else if line path has at least two points. always use this point to update the end point
            self.linePath[linePathPointsCount-1] = pointValue;
        }
    }
}

- (void)_endLinePathWithPoint:(CGPoint)point {
    HUIPatternLockViewDot *dot = [self _normalDotContainsPoint:point];
    if (dot != nil) {
        [self.normalDots removeObject:dot];
        [self.highlightedDots addObject:dot];
    }
    
    //finally linePath is the center of all highlighted dots.
    NSMutableArray *array = [NSMutableArray array];
    for (HUIPatternLockViewDot *dot in self.highlightedDots) {
        [array addObject:[NSValue valueWithCGPoint:dot.center]];
    }
    self.linePath = array;
}

#pragma mark Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _resetDotsStateWithBounds:self.bounds];
    [self _updateLinePathWithPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _updateLinePathWithPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    /*  end the line path and get the password
     */
    [self _endLinePathWithPoint:[[touches anyObject] locationInView:self]];
    
    /*  get the pattern info
     */
    NSUInteger dotCounts = [self.highlightedDots count];
    NSMutableString *password = [NSMutableString string];
    for (HUIPatternLockViewDot *dot in self.highlightedDots)
        [password appendFormat:@"[%lu]", (unsigned long)dot.number];
    
    /*  reset dots state after 0.5. Make the line display 0.5 seconds
     */
    double delayInSeconds = 0.5;
    __weak __typeof(&*self)weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf _resetDotsStateWithBounds:weakSelf.bounds];
        [weakSelf setNeedsDisplay];
    });
    
    
    /*  Notify the delegate
     */
    if (dotCounts <= 0) {
        return;
    }
    
    if (self.didDrawPatternWithPassword) {
        self.didDrawPatternWithPassword(self, dotCounts, password);
    }
    
    if ([self.delegate respondsToSelector:@selector(patternLockView:didDrawPatternWithDotCounts:password:)]) {
        [self.delegate patternLockView:self didDrawPatternWithDotCounts:dotCounts password:password];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self _resetDotsStateWithBounds:self.bounds];
    [self setNeedsDisplay];
}

@end


