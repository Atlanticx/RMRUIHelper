//
//  UIImage+RMRHelper.h
//  RMRUIHelper
//
//  Created by Roman Churkin on 26/01/15.
//  Copyright (c) 2014 Redmadrobot. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (RMRHelper)

/**
 Инициализирует изображение с указанным именем и rendering mode
 */
+ (UIImage *)RMR_imageNamed:(NSString *)name
          withRenderingMode:(UIImageRenderingMode)renderingMode;

/**
 Инициализирует изображение с указанным именем и rendering mode == UIImageRenderingModeAlwaysTemplate
 
 @see renderingMode
 */
+ (UIImage *)RMR_templateImageNamed:(NSString *)name;

/**
 Метод создает изображение размером 1х1 с заданным цветом заливки

 @param fillColor цвет заливки
 */
+ (UIImage *)RMR_backgroundImageWithColor:(UIColor *)fillColor;

/**
 Метод создает изображение заданного размера с указанным цветом заливки

 @param fillColor цвет заливки
 @param size  размер
 */
+ (UIImage *)RMR_backgroundImageWithColor:(UIColor *)fillColor size:(CGSize)size;

/**
 Метод создает изображение прямоугольника заданного размера с указанным цветом заливки
 и радиусом скругления

 @param fillColor    цвет заливки
 @param size         размер
 @param cornerRadius радиус скругления
 */
+ (UIImage *)RMR_backgroundImageWithColor:(UIColor *)fillColor
                                     size:(CGSize)size
                             cornerRadius:(CGFloat)cornerRadius;

/**
 Метод создает изображение прямоугольника переменного размера с указанным цветом заливки
 и радиусом скругления

 @param fillColor    цвет заливки
 @param cornerRadius радиус скругления
 */
+ (UIImage *)RMR_resizableImageWithColor:(UIColor *)fillColor
                            cornerRadius:(CGFloat)cornerRadius;


/**
 Метод создает изображение с контуром прямоугольника переменного размера с указанным радиусом скругления

 @param borderColor  цвет контура
 @param cornerRadius радиус скругления
 @param lineWidth    толщина контура
 */
+ (UIImage *)RMR_resizableImageWithBorderColor:(UIColor *)borderColor
                                  cornerRadius:(CGFloat)cornerRadius
                                     lineWidth:(CGFloat)lineWidth;

/**
 Метод создает изображение прямоугольника переменного размера с указанным радиусом скругления

 @param borderColor  цвет контура
 @param cornerRadius радиус скругления
 @param lineWidth    толщина контура
 @param fillColor    цвет заливки
 */
+ (UIImage *)RMR_resizableImageWithBorderColor:(UIColor *)borderColor
                                  cornerRadius:(CGFloat)cornerRadius
                                     lineWidth:(CGFloat)lineWidth
                                     fillColor:(UIColor *)fillColor;

/**
 Метод создает изображение круга заданного диаметра

 @param borderColor цвет контура
 @param lineWidth   толщина контура
 @param fillColor   цвет заливки
 @param diameter    диаметр
 */
+ (UIImage *)RMR_circleWithBorderColor:(UIColor *)borderColor
                             lineWidth:(CGFloat)lineWidth
                             fillColor:(UIColor *)fillColor
                              diameter:(CGFloat)diameter;

/**
 Метод создает изображение горизонтальной линии переменной длины с загругленными концами

 @param lineWidth толщина линии
 @param lineColor цвет линии
 */
+ (UIImage *)RMR_resizableHorizontalRoundCapLine:(CGFloat)lineWidth color:(UIColor *)lineColor;

/**
 Метод создает изображение переменного размера с горизонтальной полоской внизу

 @param lineColor цвет линии
 @param lineWidth толщина линии
 @param fillColor цвет заливки изображения
 */
+ (UIImage *)RMR_resizableUnderlineImage:(UIColor *)lineColor
                               lineWidth:(CGFloat)lineWidth
                               fillColor:(UIColor *)fillColor;

/**
 Метод создает изображение переменного размера с горизонтальной полоской вверху

 @param lineColor цвет линии
 @param lineWidth толщина линии
 @param fillColor цвет заливки изображения
 */
+ (UIImage *)RMR_resizableToplineImage:(UIColor *)lineColor
                               lineWidth:(CGFloat)lineWidth
                               fillColor:(UIColor *)fillColor;

@end
