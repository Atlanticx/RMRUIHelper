//
//  UIImage+RMRHelper.m
//  RMRUIHelper
//
//  Created by Roman Churkin on 26/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import "UIImage+RMRHelper.h"


#pragma mark - Constants

static CGFloat const CGFloatZero = 0.f;


@implementation UIImage (RMRHelper)

+ (UIImage *)RMR_imageNamed:(NSString *)name
          withRenderingMode:(UIImageRenderingMode)renderingMode
{
    return [[UIImage imageNamed:name] imageWithRenderingMode:renderingMode];
}

+ (UIImage *)RMR_templateImageNamed:(NSString *)name
{
    return [self RMR_imageNamed:name withRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

+ (UIImage *)RMR_backgroundImageWithColor:(UIColor *)fillColor
{
    return [self RMR_backgroundImageWithColor:fillColor size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)RMR_backgroundImageWithColor:(UIColor *)fillColor size:(CGSize)size
{
    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, size.width, size.height);

    UIGraphicsBeginImageContext(size);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [fillColor CGColor]);

    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)RMR_backgroundImageWithColor:(UIColor *)fillColor
                                     size:(CGSize)size
                             cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, size.width, size.height);

    UIGraphicsBeginImageContextWithOptions(size, NO, CGFloatZero);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [fillColor CGColor]);

    CGPathRef path =
        [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius].CGPath;

    CGContextAddPath(context, path);

    CGContextFillPath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}

+ (UIImage *)RMR_resizableImageWithColor:(UIColor *)fillColor
                            cornerRadius:(CGFloat)cornerRadius
{
    CGFloat size = cornerRadius * 2.f + 1.f;

    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, size, size);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, CGFloatZero);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [fillColor CGColor]);

    CGContextFillEllipseInRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIEdgeInsets capInsets =
        UIEdgeInsetsMake(cornerRadius, cornerRadius,
                         cornerRadius, cornerRadius);

    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)RMR_resizableImageWithBorderColor:(UIColor *)borderColor
                                  cornerRadius:(CGFloat)cornerRadius
                                     lineWidth:(CGFloat)lineWidth
{
    CGFloat borderWidth = lineWidth + cornerRadius;

    CGFloat size = borderWidth * 2.f + 1.f;

    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, size, size);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 4.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, lineWidth);

    CGFloat insetModifier = lineWidth / 2.f;

    CGPathRef path =
        [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, insetModifier, insetModifier)
                                   cornerRadius:cornerRadius].CGPath;

    CGContextAddPath(context, path);

    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);

    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIEdgeInsets capInsets =
        UIEdgeInsetsMake(borderWidth, borderWidth,
                         borderWidth, borderWidth);

    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)RMR_resizableImageWithBorderColor:(UIColor *)borderColor
                                  cornerRadius:(CGFloat)cornerRadius
                                     lineWidth:(CGFloat)lineWidth
                                     fillColor:(UIColor *)fillColor
{
    CGFloat borderWidth = lineWidth + cornerRadius;

    CGFloat size = borderWidth * 2.f + 1.f;

    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, size, size);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 4.f);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineWidth(context, lineWidth);

    CGPathRef path =
        [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, lineWidth, lineWidth)
                                   cornerRadius:cornerRadius].CGPath;

    CGContextAddPath(context, path);

    CGContextSetFillColorWithColor(context, fillColor.CGColor);

    CGContextFillPath(context);

    CGFloat insetModifier = lineWidth / 2.f;

    path =
        [UIBezierPath bezierPathWithRoundedRect:CGRectInset(rect, insetModifier, insetModifier)
                                   cornerRadius:cornerRadius].CGPath;

    CGContextAddPath(context, path);

    CGContextSetStrokeColorWithColor(context, borderColor.CGColor);

    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIEdgeInsets capInsets =
    UIEdgeInsetsMake(borderWidth, borderWidth,
                     borderWidth, borderWidth);

    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)RMR_circleWithBorderColor:(UIColor *)borderColor
                             lineWidth:(CGFloat)lineWidth
                             fillColor:(UIColor *)fillColor
                              diameter:(CGFloat)diameter
{
    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, diameter, diameter);

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    if (fillColor) {
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGFloat fillInset = lineWidth;
        CGContextFillEllipseInRect(context, CGRectInset(rect, fillInset, fillInset));
    }

    if (borderColor) {
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        CGContextSetLineWidth(context, lineWidth);
        CGRect borderRect = CGRectInset(rect, lineWidth/2.f, lineWidth/2.f);
        CGContextStrokeEllipseInRect(context, borderRect);
    }

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return image;
}



+ (UIImage *)RMR_resizableHorizontalRoundCapLine:(CGFloat)lineWidth color:(UIColor *)lineColor
{
    CGFloat length = lineWidth + 1.f;

    CGRect rect = CGRectMake(CGFloatZero, CGFloatZero, length, lineWidth);

    CGFloat lineWidthHalf = lineWidth/2.f;

    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);

    CGContextMoveToPoint(context, lineWidthHalf, lineWidthHalf);
    CGContextAddLineToPoint(context, length-lineWidthHalf, lineWidthHalf);
    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    UIEdgeInsets capInsets =
        UIEdgeInsetsMake(CGFloatZero, lineWidthHalf,
                         CGFloatZero, lineWidthHalf);

    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)RMR_resizableUnderlineImage:(UIColor *)lineColor
                               lineWidth:(CGFloat)lineWidth
                               fillColor:(UIColor *)fillColor
{
    CGFloat resultHeight = 4.f + lineWidth * 2.f;

    CGRect frame = CGRectMake(CGFloatZero, CGFloatZero, 1.f, resultHeight);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [fillColor setFill];

    CGContextFillRect(context, frame);

    [lineColor setStroke];

    CGContextSetLineWidth(context, lineWidth);

    CGFloat middlePoint = resultHeight - lineWidth/2.f;

    CGContextMoveToPoint(context, CGFloatZero, middlePoint);
    CGContextAddLineToPoint(context, 1.f, middlePoint);

    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIEdgeInsets capInsets = UIEdgeInsetsMake(1.f, 0., lineWidth * 2.f, 0.f);

    return [image resizableImageWithCapInsets:capInsets];
}

+ (UIImage *)RMR_resizableToplineImage:(UIColor *)lineColor
                               lineWidth:(CGFloat)lineWidth
                               fillColor:(UIColor *)fillColor
{
    CGFloat resultHeight = 4.f + lineWidth * 2.f;

    CGRect frame = CGRectMake(CGFloatZero, CGFloatZero, 1.f, resultHeight);
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    [fillColor setFill];

    CGContextFillRect(context, frame);

    [lineColor setStroke];

    CGContextSetLineWidth(context, lineWidth);

    CGFloat middlePoint = lineWidth/2.f;

    CGContextMoveToPoint(context, CGFloatZero, middlePoint);
    CGContextAddLineToPoint(context, 1.f, middlePoint);

    CGContextStrokePath(context);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIEdgeInsets capInsets = UIEdgeInsetsMake(lineWidth * 2.f, 0., 1.f, 0.f);

    return [image resizableImageWithCapInsets:capInsets];
}

@end
