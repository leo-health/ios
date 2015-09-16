//
//  LEOMessagesAvatarImageFactory.h
//
//  Originally Created as JSQMessagesAvatarImageFactory.h by Jesse Squires
//  Modified for Leo Health by Zachary Drossman
//
//  http://www.jessesquires.com
//
//
//  Documentation
//  http://cocoadocs.org/docsets/JSQMessagesViewController
//
//
//  GitHub
//  https://github.com/jessesquires/JSQMessagesViewController
//
//
//  License
//  Copyright (c) 2014 Jesse Squires
//  Released under an MIT license: http://opensource.org/licenses/MIT
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "JSQMessagesAvatarImage.h"

/**
 *  `JSQMessagesAvatarImageFactory` is a factory that provides a means for creating and styling
 *  `JSQMessagesAvatarImage` objects to be displayed in a `JSQMessagesCollectionViewCell` of a `JSQMessagesCollectionView`.
 */
@interface LEOMessagesAvatarImageFactory : NSObject

/**
 *  Creates and returns a `JSQMessagesAvatarImage` object with the specified placeholderImage that is
 *  cropped to a circle of the given diameter.
 *
 *  @param placeholderImage An image object that represents a placeholder avatar image. This value must not be `nil`.
 *  @param diameter         An integer value specifying the diameter size of the avatar in points. This value must be greater than `0`.
 *  @param borderColor The color of the border of the circle. This value must not be `nil`.
 *  @param borderWidth The width of the border of the circle. This value must be greater than or equal to `0`.
 *
 *  @return An initialized `JSQMessagesAvatarImage` object if created successfully, `nil` otherwise.
 */
+ (JSQMessagesAvatarImage *)avatarImageWithPlaceholder:(UIImage *)placeholderImage diameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth;

/**
 *  Creates and returns a `JSQMessagesAvatarImage` object with the specified image that is
 *  cropped to a circle of the given diameter and used for the `avatarImage` and `avatarPlaceholderImage` properties
 *  of the returned `JSQMessagesAvatarImage` object. This image is then copied and has a transparent black mask applied to it,
 *  which is used for the `avatarHighlightedImage` property of the returned `JSQMessagesAvatarImage` object.
 *
 *  @param image    An image object that represents an avatar image. This value must not be `nil`.
 *  @param diameter An integer value specifying the diameter size of the avatar in points. This value must be greater than `0`.
 *  @param borderColor The color of the border of the circle. This value must not be `nil`.
 *  @param borderWidth The width of the border of the circle. This value must be greater than or equal to `0`.
 *
 *  @return An initialized `JSQMessagesAvatarImage` object if created successfully, `nil` otherwise.
 */
+ (JSQMessagesAvatarImage *)avatarImageWithImage:(UIImage *)image diameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth;

/**
 *  Returns a copy of the specified image that is cropped to a circle with the given diameter.
 *
 *  @param image    The image to crop. This value must not be `nil`.
 *  @param diameter An integer value specifying the diameter size of the image in points. This value must be greater than `0`.
 *  @param borderColor The color of the border of the circle. This value must not be `nil`.
 *  @param borderWidth The width of the border of the circle. This value must be greater than or equal to `0`.
 *
 *  @return A new image object if successful, `nil` otherwise.
 */
+ (UIImage *)circularAvatarImage:(UIImage *)image withDiameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth;

/**
 *  Returns a copy of the specified image that is cropped to a circle with the given diameter.
 *  Additionally, a transparent overlay is applied to the image to represent a pressed or highlighted state.
 *
 *  @param image    The image to crop. This value must not be `nil`.
 *  @param diameter An integer value specifying the diameter size of the image in points. This value must be greater than `0`.
 *  @param borderColor The color of the border of the circle. This value must not be `nil`.
 *  @param borderWidth The width of the border of the circle. This value must be greater than or equal to `0`.
 *
 *  @return A new image object if successful, `nil` otherwise.
 */
+ (UIImage *)circularAvatarHighlightedImage:(UIImage *)image withDiameter:(NSUInteger)diameter borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth;


/**
 *  Returns a circular UIImage with the diameter and background color specified, inside of which is the user's initials with specified text color and font.
 *
 *  @param userInitials    The initials of the user. This value must not be `nil`.
 *  @param diameter An integer value specifying the diameter size of the image in points. This value must be greater than `0`.
 *  @param backgroundColor The color of the background of the circle. This value must not be `nil`.
 *  @param font The font for the initials. This value must not be `nil`.
 *  @param textColor The color of the initials. This value must not be `nil`.
 *  @param borderColor The color of the border of the circle. This value must not be `nil`.
 *  @param borderWidth The width of the border of the circle. This value must be greater than or equal to `0`.
 *
 *  @return A new image object if successful, `nil` otherwise.
 */
+ (UIImage *)circularAvatarWithInitials:(NSString *)userInitials withDiameter:(NSUInteger)diameter backgroundColor:(UIColor *)backgroundColor font:(UIFont *)font textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor borderWidth:(NSUInteger)borderWidth;

/**
 *  Creates and returns a `JSQMessagesAvatarImage` object with a circular shape that displays the specified userInitials
 *  with the given backgroundColor, textColor, font, and diameter.
 *
 *  @param userInitials    The user initials to display in the avatar image. This value must not be `nil`.
 *  @param backgroundColor The background color of the avatar. This value must not be `nil`.
 *  @param textColor       The color of the text of the userInitials. This value must not be `nil`.
 *  @param font            The font applied to userInitials. This value must not be `nil`.
 *  @param diameter        The diameter of the avatar image. This value must be greater than `0`.
 *  @param borderColor The color of the border of the circle. This value must not be `nil`.
 *  @param borderWidth The width of the border of the circle. This value must be greater than or equal to `0`.
 *
 *  @return An initialized `JSQMessagesAvatarImage` object if created successfully, `nil` otherwise.
 *
 *  @discussion This method does not attempt to detect or correct incompatible parameters.
 *  That is to say, you are responsible for providing a font size and diameter that make sense.
 *  For example, a font size of `14.0f` and a diameter of `34.0f` will result in an avatar similar to Messages in iOS 7.
 *  However, a font size `30.0f` and diameter of `10.0f` will not produce a desirable image.
 *  Further, this method does not check the length of userInitials. It is recommended that you pass a string of length `2` or `3`.
 *
 *  @modification This method has been modified from the original implementation to support border for the avatar
 */
+ (JSQMessagesAvatarImage *)avatarImageWithUserInitials:(NSString *)userInitials
                                        backgroundColor:(UIColor *)backgroundColor
                                              textColor:(UIColor *)textColor
                                                   font:(UIFont *)font
                                               diameter:(NSUInteger)diameter
                                            borderColor:(UIColor *)borderColor
                                            borderWidth:(NSUInteger)borderWidth;

@end

