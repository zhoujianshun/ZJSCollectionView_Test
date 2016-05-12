//
//  UIImage+Extend.m
//  huashida_home
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import "UIImage+Extend.h"

@implementation UIImage(Extend)

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 * 根据颜色生成图片
 */
+(UIImage*)imageWithColor:(UIColor*)color{
    CGRect rect = CGRectMake(0, 0, 1.f, 1.f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
   // image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 0, 0) resizingMode:UIImageResizingModeTile];
    return image;
}


/**
 绘制指定大小的图片
 */
- (UIImage *)scaleToSize:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

/**
 获取图片指定区域内的内容
 */
- (UIImage *)clipImageInRect:(CGRect)rect
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], rect);
    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return thumbScale;
}

/*
 * 截取view中的图片
 */
+(UIImage *)getImageFromView:(UIView *)orgView{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(orgView.frame.size,YES,scale);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 * 截取view中的图片
 */
+(UIImage *)getImageFromView:(UIView *)orgView withSize:(CGSize )size{
    CGFloat scale = [UIScreen mainScreen].scale;
    UIGraphicsBeginImageContextWithOptions(size,YES,scale);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//+(UIImage *)MXRImageNamed:(NSString *)name{
//    if (IOS9_OR_LATER) {
//        return [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",[[NSBundle mainBundle]bundlePath],name]];
//    }else{
//        return [UIImage imageNamed:name];
//    }
//}

@end
