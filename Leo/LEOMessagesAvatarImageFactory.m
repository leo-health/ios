//
//  LEOMessagesAvatarImageFactory.m
//
//
//  Created by Zachary Drossman on 7/21/15.
//
//

#import "LEOMessagesAvatarImageFactory.h"
#import "UIColor+JSQMessages.h"

@interface LEOMessagesAvatarImageFactory ()

+ (UIImage *)jsq_circularImage:(UIImage *)image
                  withDiameter:(NSUInteger)diameter
              highlightedColor:(UIColor *)highlightedColor
                   borderColor:(UIColor *)borderColor
                   borderWidth:(NSUInteger)borderWidth;

+ (UIImage *)jsq_imageWitInitials:(NSString *)initials
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                         diameter:(NSUInteger)diameter
                      borderColor:(UIColor *)borderColor
                      borderWidth:(NSUInteger)borderWidth;
@end



@implementation LEOMessagesAvatarImageFactory

#pragma mark - Public

+ (JSQMessagesAvatarImage *)avatarImageWithPlaceholder:(UIImage *)placeholderImage diameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth
{
    UIImage *circlePlaceholderImage = [LEOMessagesAvatarImageFactory jsq_circularImage:placeholderImage
                                                                          withDiameter:diameter
                                                                      highlightedColor:nil
                                                                           borderColor:borderColor
                                                                           borderWidth:borderWidth];
    
    return [JSQMessagesAvatarImage avatarImageWithPlaceholder:circlePlaceholderImage];
}

+ (JSQMessagesAvatarImage *)avatarImageWithImage:(UIImage *)image diameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth
{
    UIImage *avatar = [LEOMessagesAvatarImageFactory circularAvatarImage:image
                                                            withDiameter:diameter
                                                             borderColor:borderColor
                                                             borderWidth:borderWidth];
    UIImage *highlightedAvatar = [LEOMessagesAvatarImageFactory circularAvatarHighlightedImage:image
                                                                                  withDiameter:diameter
                                                                                   borderColor:borderColor
                                                                                   borderWidth:borderWidth];
    
    return [[JSQMessagesAvatarImage alloc] initWithAvatarImage:avatar
                                              highlightedImage:highlightedAvatar
                                              placeholderImage:avatar];
}

+ (UIImage *)circularAvatarImage:(UIImage *)image withDiameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth
{
    return [LEOMessagesAvatarImageFactory jsq_circularImage:image
                                               withDiameter:diameter
                                           highlightedColor:nil
                                                borderColor:borderColor
                                                borderWidth:borderWidth];
}

+ (UIImage *)circularAvatarHighlightedImage:(UIImage *)image withDiameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth
{
    return [LEOMessagesAvatarImageFactory jsq_circularImage:image
                                               withDiameter:diameter
                                           highlightedColor:[UIColor colorWithWhite:0.1f alpha:0.3f]
                                                borderColor:borderColor
                                                borderWidth:borderWidth];
}

+ (UIImage *)circularAvatarWithInitials:(NSString *)userInitials withDiameter:(NSUInteger)diameter backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth
{
    return [LEOMessagesAvatarImageFactory jsq_imageWitInitials:userInitials
                                                               backgroundColor:backgroundColor
                                                                     textColor:textColor
                                                                          font:font
                                                                      diameter:diameter
                                                                   borderColor:borderColor
                                                                   borderWidth:borderWidth];
}

+ (JSQMessagesAvatarImage *)avatarImageWithUserInitials:(NSString *)userInitials
                                        backgroundColor:(UIColor *)backgroundColor
                                              textColor:(UIColor *)textColor
                                                   font:(UIFont *)font
                                               diameter:(NSUInteger)diameter
                                            borderColor:(UIColor *)borderColor
                                            borderWidth:(NSUInteger)borderWidth
{
    UIImage *avatarImage = [LEOMessagesAvatarImageFactory jsq_imageWitInitials:userInitials
                                                               backgroundColor:backgroundColor
                                                                     textColor:textColor
                                                                          font:font
                                                                      diameter:diameter
                                                                   borderColor:borderColor
                                                                   borderWidth:borderWidth];
    
    UIImage *avatarHighlightedImage = [LEOMessagesAvatarImageFactory jsq_circularImage:avatarImage
                                                                          withDiameter:diameter
                                                                      highlightedColor:[UIColor colorWithWhite:0.1f alpha:0.3f]
                                                                           borderColor: borderColor
                                                                           borderWidth:borderWidth];
    
    return [[JSQMessagesAvatarImage alloc] initWithAvatarImage:avatarImage
                                              highlightedImage:avatarHighlightedImage
                                              placeholderImage:avatarImage];
}

#pragma mark - Private

+ (UIImage *)jsq_imageWitInitials:(NSString *)initials
                  backgroundColor:(UIColor *)backgroundColor
                        textColor:(UIColor *)textColor
                             font:(UIFont *)font
                         diameter:(NSUInteger)diameter
                      borderColor:(UIColor *)borderColor
                      borderWidth:(NSUInteger)borderWidth
{
    NSParameterAssert(initials != nil);
    NSParameterAssert(backgroundColor != nil);
    NSParameterAssert(textColor != nil);
    NSParameterAssert(font != nil);
    NSParameterAssert(borderColor != nil);
    NSParameterAssert(borderWidth >= 0);
    NSParameterAssert(diameter > 0);
    
    CGRect frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
    
    NSDictionary *attributes = @{ NSFontAttributeName : font,
                                  NSForegroundColorAttributeName : textColor };
    
    CGRect textFrame = [initials boundingRectWithSize:frame.size
                                              options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                           attributes:attributes
                                              context:nil];
    
    CGPoint frameMidPoint = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    CGPoint textFrameMidPoint = CGPointMake(CGRectGetMidX(textFrame), CGRectGetMidY(textFrame));
    
    CGFloat dx = frameMidPoint.x - textFrameMidPoint.x;
    CGFloat dy = frameMidPoint.y - textFrameMidPoint.y;
    CGPoint drawPoint = CGPointMake(dx, dy);
    UIImage *image = nil;
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
        CGContextFillRect(context, frame);
        [initials drawAtPoint:drawPoint withAttributes:attributes];
        
        image = UIGraphicsGetImageFromCurrentImageContext();
        
    }
    UIGraphicsEndImageContext();
    
    return [LEOMessagesAvatarImageFactory jsq_circularImage:image withDiameter:diameter highlightedColor:nil borderColor:borderColor borderWidth:borderWidth];
}

+ (UIImage *)jsq_circularImage:(UIImage *)image withDiameter:(NSUInteger)diameter highlightedColor:(UIColor *)highlightedColor borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth;
{
    NSParameterAssert(image != nil);
    NSParameterAssert(diameter > 0);
    NSParameterAssert(borderColor != nil);
    NSParameterAssert(borderWidth >= 0);
    
    CGRect frame = CGRectMake(0.0f, 0.0f, diameter, diameter);
    
    UIImage *newImage = nil;
    
    UIGraphicsBeginImageContextWithOptions(frame.size, NO, [UIScreen mainScreen].scale);
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        
        UIBezierPath *clippingPath = [UIBezierPath bezierPathWithOvalInRect:frame];
        
        [clippingPath addClip];
        
        [image drawInRect:frame];
        
        if (highlightedColor != nil) {
            CGContextSetFillColorWithColor(context, highlightedColor.CGColor);
            CGContextFillEllipseInRect(context, frame);
        }
        
        UIBezierPath *borderPath = [UIBezierPath bezierPathWithOvalInRect:frame];
        [borderColor setStroke];
        borderPath.lineWidth = borderWidth;
        [borderPath stroke];
        CGContextAddPath(context, borderPath.CGPath);
        
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        
    }
    UIGraphicsEndImageContext();
    
    return newImage;
}


@end
