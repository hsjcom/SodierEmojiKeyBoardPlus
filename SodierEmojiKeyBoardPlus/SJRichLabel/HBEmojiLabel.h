//
//  HBEmojiLabel.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/29.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "MLEmojiLabel.h"

@interface HBEmojiLabel : MLEmojiLabel

- (CGSize)sizeWithConstrainedToWidth:(CGFloat)width;

+ (CGFloat)heightWithText:(id)text
                     font:(UIFont *)font
       constrainedToWidth:(CGFloat)width;

+ (CGFloat)heightWithText:(id)text
                     font:(UIFont *)font
       constrainedToWidth:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing;

+ (CGFloat)heightWithText:(id)text
                     font:(UIFont *)font
       constrainedToWidth:(CGFloat)width
            numberOfLines:(NSInteger)numberOfLines;

+ (CGSize)sizeWithText:(id)text
                  font:(UIFont *)font
    constrainedToWidth:(CGFloat)width;

//NSMutableAttributedString类型文本高度
+ (CGSize)attributedStringSizeWithText:(id)text
                                  font:(UIFont *)font
                    constrainedToWidth:(CGFloat)width
                           lineSpacing:(CGFloat)lineSpacing;

@end
