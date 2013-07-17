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

+ (id)dotWithNumber:(NSUInteger)number frame:(CGRect)frame;
@end


@implementation HUIPatternLockViewDot

+ (id)dotWithNumber:(NSUInteger)number frame:(CGRect)frame
{
    id dot = [[self alloc] init];
    [dot setNumber:number];
    [dot setFrame:frame];
    [dot setCenter:CGPointMake(frame.origin.x + frame.size.width * 0.5,
                               frame.origin.y + frame.size.height * 0.5)];
    return dot;
}
@end


#pragma mark - @class HUIPatternLockView
#define kMinCubeSize        3
#define kDefaultDotWidth    60.00
#define kDefaultLineColor   [UIColor colorWithRed:248.00/255.00 green:200.0/255.00 blue:79.0/255.00 alpha:1.0]
#define kDefaultLineWidth   8.0

#define kKVOKeyPathBounds   @"bounds"

@interface HUIPatternLockView ()
@property (nonatomic, assign) NSUInteger cubeSize;

@property (nonatomic, strong) NSMutableArray *normalDots;
@property (nonatomic, strong) NSMutableArray *highlightedDots;
@property (nonatomic, strong) NSMutableArray *linePath;
@end


@implementation HUIPatternLockView

- (void)dealloc
{
    [self removeObserver:self forKeyPath:kKVOKeyPathBounds];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self _loadDefaultConfiguration];
        [self _resetDotsStateWithBounds:frame];
        [self addObserver:self forKeyPath:kKVOKeyPathBounds options:NSKeyValueObservingOptionNew context:nil];
        [self setNeedsDisplay];
    }
    return self;
}

#pragma mark - Private
- (void)_loadDefaultConfiguration
{
    self.cubeSize = kMinCubeSize;
    self.lineColor  = kDefaultLineColor;
    self.lineWidth  = kDefaultLineWidth;
    self.dotWidth   = kDefaultDotWidth;
}

- (void)_resetDotsStateWithBounds:(CGRect)bounds
{
    self.normalDots = [NSMutableArray array];
    self.highlightedDots = [NSMutableArray array];
    self.linePath   = [NSMutableArray array];
    //calculate dot width with bounds
    CGFloat cubWidth = bounds.size.width / self.cubeSize;
    CGFloat cubHeight = bounds.size.height / self.cubeSize;
    CGFloat dotOffsetXinCub = (cubWidth - self.dotWidth) * 0.5;
    CGFloat dotOffsetYinCub = (cubHeight - self.dotWidth) * 0.5;
    
    int number = 0;
    for (int i = 0; i < self.cubeSize; i++)
    {
        for (int j = 0; j < self.cubeSize; j++)
        {
            CGRect dotFrame = CGRectMake(i * cubWidth + dotOffsetXinCub, j * cubHeight + dotOffsetYinCub,
                                         self.dotWidth, self.dotWidth);
            [self.normalDots addObject:[HUIPatternLockViewDot dotWithNumber:(number++) frame:dotFrame]];
        }
    }
}

- (void)setCubeSize:(NSUInteger)cubeSize
{
    if (cubeSize < kMinCubeSize)
        _cubeSize = kMinCubeSize;
    else
        _cubeSize = cubeSize;
    
    [self setNeedsDisplay];
}

- (void)setDotWidth:(CGFloat)dotWidth
{
    _dotWidth = dotWidth;
    [self _resetDotsStateWithBounds:self.bounds];
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor == lineColor)
        return;
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object != self || ![keyPath isEqualToString:kKVOKeyPathBounds])
        return;
    
    CGRect newBounds = [change[NSKeyValueChangeNewKey] CGRectValue];
    [self _resetDotsStateWithBounds:newBounds];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //draw line
    CGContextSetStrokeColorWithColor(context, [self.lineColor CGColor]);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    if ([self.linePath count] > 0)
    {
        NSValue *firstValue = self.linePath[0];
        
        for (NSValue *pointValue in self.linePath)
        {
            CGPoint point = [pointValue CGPointValue];
            if (pointValue == firstValue)
                CGContextMoveToPoint(context, point.x, point.y);
            else
                CGContextAddLineToPoint(context, point.x, point.y);
        }
    }
    CGContextDrawPath(context, kCGPathStroke);
    
    //draw dot images
    if (self.dotNormalImage)
    {
        for (HUIPatternLockViewDot *dot in self.normalDots)
            [self.dotNormalImage drawInRect:dot.frame];
    }
    if (self.dotHighlightedImage)
    {
        for (HUIPatternLockViewDot *dot in self.highlightedDots)
            [self.dotHighlightedImage drawInRect:dot.frame];
    }
}

#pragma mark - Record Line Path
- (HUIPatternLockViewDot *)_normalDotContainsPoint:(CGPoint)point
{
    for (HUIPatternLockViewDot * dot in self.normalDots)
    {
        if (CGRectContainsPoint(dot.frame, point))
            return dot;
    }
    return nil;
}

- (void)_updateLinePathWithPoint:(CGPoint)point
{
    HUIPatternLockViewDot *dot = [self _normalDotContainsPoint:point];
    
    NSInteger linePathPointCount = [self.linePath count];
    if (dot)
    {
        NSValue *pointValue = [NSValue valueWithCGPoint:dot.center];
        if (linePathPointCount <= 0)
        {
            //if no any points in linePath. use this dot's center to be the linePath start and end point
            [self.linePath addObject:pointValue];
            [self.linePath addObject:pointValue];
        }
        else
        {
            //else insert a new point into the path
            [self.linePath insertObject:pointValue atIndex:linePathPointCount-1];
        }
        
        //this dot has been marked as highlighted
        [self.normalDots removeObject:dot];
        [self.highlightedDots addObject:dot];
    }
    else
    {
        NSValue *pointValue = [NSValue valueWithCGPoint:point];
        if (linePathPointCount == 0)
        {
            //linePath must start with a dot's center
            return;
        }
        else if (linePathPointCount == 1)
        {
            //if linePath has a start point, this point is treat as end point
            [self.linePath addObject:pointValue];
        }
        else
        {
            //else if line path has at least two points. always use this point to update the end point
            self.linePath[linePathPointCount-1] = pointValue;
        }
    }
    
}

- (void)_endLinePathWithPoint:(CGPoint)point
{
    HUIPatternLockViewDot *dot = [self _normalDotContainsPoint:point];
    if (dot)
    {
        [self.normalDots removeObject:dot];
        [self.highlightedDots addObject:dot];
    }
    
    //finally linePath is the center of all highlighted dots.
    NSMutableArray *array = [NSMutableArray array];
    for (HUIPatternLockViewDot *dot in self.highlightedDots)
    {
        [array addObject:[NSValue valueWithCGPoint:dot.center]];
    }
    self.linePath = array;
}

#pragma mark - Touches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self _resetDotsStateWithBounds:self.bounds];
    [self _updateLinePathWithPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self _updateLinePathWithPoint:[[touches anyObject] locationInView:self]];
    [self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    /*  end the line path and get the password
     */
    [self _endLinePathWithPoint:[[touches anyObject] locationInView:self]];
    
    /*  get the pattern info
     */
    NSUInteger dotCounts = [self.highlightedDots count];
    NSMutableString *password = [NSMutableString string];
    for (HUIPatternLockViewDot *dot in self.highlightedDots)
        [password appendFormat:@"%03d", dot.number];
    
    /*  reset dots state after 0.5. Make the line display 0.5 seconds
     */
    double delayInSeconds = 0.5;
    __weak __typeof(&*self)weakSelf = self;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf _resetDotsStateWithBounds:weakSelf.bounds];
        [weakSelf setNeedsDisplay];
    });
    
    [self setNeedsDisplay];
    
    
    /*  Notify the delegate
     */
    if (dotCounts <= 0)
        return;
    if (self.didDrawPatternWithPassword)
        self.didDrawPatternWithPassword(self, dotCounts, password);
    
    if ([self.delegate respondsToSelector:@selector(patternLockView:didDrawPatternWithDotCounts:password:)])
        [self.delegate patternLockView:self didDrawPatternWithDotCounts:dotCounts password:password];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self _resetDotsStateWithBounds:self.bounds];
    [self setNeedsDisplay];
}

@end