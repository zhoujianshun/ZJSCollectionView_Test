//
//  UIImage+Extend.h
//  huashida_home
//
//  Created by Mac on 15-5-16.
//  Copyright (c) 2015年 mxrcorp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage(Extend)
//+(UIImage *)MXRImageNamed:(NSString *)name;
/**
 * 根据颜色生成图片
 */
+(UIImage*)imageWithColor:(UIColor*)color;

/**
 绘制指定大小的图片
 */
- (UIImage *)scaleToSize:(CGSize)size;
/**
 获取图片指定区域内的内容
 */
- (UIImage *)clipImageInRect:(CGRect)rect;
/*
 * 截取view中的图片
 */
+(UIImage *)getImageFromView:(UIView *)orgView;

+(UIImage *)getImageFromView:(UIView *)orgView withSize:(CGSize )size;
@end
