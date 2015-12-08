//
//  ZJSShelfViewDecorationView.m
//  huashida_home
//
//  Created by 周建顺 on 15/11/27.
//  Copyright © 2015年 mxrcorp. All rights reserved.
//

#import "ZJSShelfViewDecorationView.h"

// 画一像素的线需要用到
#define SINGLE_LINE_WIDTH           (1 / [UIScreen mainScreen].scale)
#define SINGLE_LINE_ADJUST_OFFSET   ((1 / [UIScreen mainScreen].scale) / 2)

#define RGB(r, g, b)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:1.f]
#define RGBA(r, g, b, a)    [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a]

@interface ZJSShelfViewDecorationView()

@property (nonatomic,strong) UIImageView *lineView;
@property (nonatomic,strong) UIView *myContentView;
@property (nonatomic) CGFloat lineHeight;
//@property (nonatomic,strong) CAShapeLayer *lineShapLayer;

@end
//UIImageView * bottom = [[UIImageView alloc] initWithFrame:CGRectMake(10, y+self.CellHeight-2, 300,  0.5)];
//[bottom setBackgroundColor:[UIColor colorWithRed:198.0/255 green:198.0/255 blue:190.0/255 alpha:1]];

@implementation ZJSShelfViewDecorationView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setup{
//    self.lineView = [[UIView alloc] init];
//    self.lineView.backgroundColor = [UIColor blueColor];
//    self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - lineHeight, CGRectGetWidth(self.frame), lineHeight);
//    [self addSubview:self.lineView];

    self.myContentView = [[UIView alloc] init];
    self.myContentView.backgroundColor = [UIColor whiteColor];
    self.myContentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:self.myContentView];
    
    self.backgroundColor = [UIColor whiteColor];
//    self.lineShapLayer = [[CAShapeLayer alloc] init];
//    [self.layer addSublayer:self.lineShapLayer];
    self.lineHeight = SINGLE_LINE_WIDTH;
    
    self.lineView = [[UIImageView alloc] init];
    self.lineView.frame = CGRectMake(10, self.bounds.size.height - self.lineHeight, self.bounds.size.width - 10*2, self.lineHeight);
    self.lineView.backgroundColor = RGB(142, 142, 142);
    [self addSubview:self.lineView];
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    /**
     *  https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html
     * 仅当要绘制的线宽为奇数像素时，绘制位置需要调整
     */
    CGFloat pixelAdjustOffset = 0;
    if (((int)(self.lineHeight * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
    }
    
    //self.lineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - lineHeight*3, CGRectGetWidth(self.frame), lineHeight);
    self.myContentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.lineView.frame = CGRectMake(10, self.bounds.size.height - self.lineHeight + pixelAdjustOffset , self.bounds.size.width - 10*2, self.lineHeight);
    // [self setNeedsDisplay];
}

//-(void)drawRect:(CGRect)rect{
//    
//    self.lineShapLayer.strokeColor = [UIColor lightGrayColor].CGColor;
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    path.lineWidth = lineHeight;
//    [path moveToPoint:CGPointMake(10, CGRectGetHeight(self.frame) - lineHeight)];
//    [path addLineToPoint:CGPointMake(CGRectGetWidth(self.frame)-10, CGRectGetHeight(self.frame) - lineHeight)];
//    
//    self.lineShapLayer.fillColor = [UIColor whiteColor].CGColor;
//    self.lineShapLayer.path = path.CGPath;
//}

@end
