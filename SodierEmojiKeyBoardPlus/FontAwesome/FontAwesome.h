//
//  FontAwesome.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/9/21.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "font-awesome-codes.h"


/**
 * icon font or web font
 * Font Awesome 4.4
 * http://fortawesome.github.io/Font-Awesome/icons/
 * usage：info.plist add 'Fonts provided by application' item 'FontAwesome.otf‘
 * 15/9/21
 */

@interface FontAwesome : NSObject

//================================
// Font and Label Methods
//================================

/**
 * Get the FontAwesome font.
 */
+ (UIFont *)fontWithSize:(CGFloat)size;

/**
 * Make a sized-to-fit UILabel containing an icon in the given font size and color.
 */
+ (UILabel *)labelWithIcon:(NSString *)fa_icon
                     size:(CGFloat)size
                    color:(UIColor *)color;

/**
 * Adjust an existing UILabel to show a FontAwesome icon.
 */
+ (void)label:(UILabel *)label
      setIcon:(NSString *)fa_icon
         size:(CGFloat)size
        color:(UIColor *)color
    sizeToFit:(BOOL)shouldSizeToFit;

//================================
// Image Methods
//================================

/**
 * Create a UIImage with a FontAwesome icon, with the image and the icon the same size
 */
+ (UIImage *)imageWithIcon:(NSString *)fa_icon
                iconColor:(UIColor *)iconColor
                 iconSize:(CGFloat)iconSize;

/**
 *Create a UIImage with a FontAwesome icon, and specify a square size for the icon, which will be centered within the CGSize specified for the image itself.
 */
+ (UIImage *)imageWithIcon:(NSString *)fa_icon
                iconColor:(UIColor *)color
                 iconSize:(CGFloat)iconSize
                imageSize:(CGSize)imageSize;

/*! The image and the icon inside it can be from a custom font:
 */
+ (UIImage *)imageWithText:(NSString *)characterCodeString
                     font:(UIFont *)font
                iconColor:(UIColor *)iconColor
                imageSize:(CGSize)imageSize;

/**
 *NOTE: This method is deprecated! Use -imageWithIcon:iconColor:iconSize: instead. It does exactly the same thing, but I got fed up with it not matching the phrasing of the second UIImage creation method.
 */
+ (UIImage*)imageWithIcon:(NSString *)fa_icon size:(CGFloat)size color:(UIColor *)color __attribute__((deprecated));

@end
