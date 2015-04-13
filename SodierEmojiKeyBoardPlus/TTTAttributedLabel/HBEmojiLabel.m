//
//  HBEmojiLabel.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/29.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "HBEmojiLabel.h"

@implementation HBEmojiLabel

/*
 * Readme
 *
 * by Soldier
 * on 15/4/3.
 *
 * self.text = NSString / NSAttributedString ok
 * self.attributedText = NSAttributedString emoji无效
 *
 * 使用NSAttributedString后Label.font、Label.textColor，label默认行间距将失效,需要在NSAttributedString重设font，textColor，label默认行间距
 *
 * to do，使用NSAttributedString，如有较多emoji UI会出错，慎用！
 *
 *使用以下方法解决 注* 使用kCTForegroundColorAttributeName，NSForegroundColorAttributeName有问题;
 *使用NSMutableParagraphStyle有问题
 *- (void)setText:(id)text
 afterInheritingLabelAttributesAndConfiguringWithBlock:(NSMutableAttributedString * (^)(NSMutableAttributedString *mutableAttributedString))block
 *
 */

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
        self.customEmojiPlistName = @"EmojiImageMap.plist";
        self.lineSpacing = 4;
        self.emojiOriginYOffsetRatioWithLineHeight = - 0.15; //表情绘制的y坐标矫正值，和字体高度的比例，越大越往下

        self.emojiWidthRatioWithLineHeight = 1.0; //和字体高度的比例
        
        self.disableThreeCommon = YES;//禁用电话，邮箱，连接三者
    }
    return self;
}

- (CGSize)sizeWithConstrainedToWidth:(CGFloat)width {
    return [self preferredSizeWithMaxWidth:width];
}

+ (CGFloat)heightWithText:(id)text
                     font:(UIFont *)font
       constrainedToWidth:(CGFloat)width {
    
    return [HBEmojiLabel heightWithText:text font:font constrainedToWidth:width lineSpacing:4];
}

+ (CGFloat)heightWithText:(id)text
                     font:(UIFont *)font
       constrainedToWidth:(CGFloat)width
              lineSpacing:(CGFloat)lineSpacing {
    HBEmojiLabel *label = [[HBEmojiLabel alloc] init];
    label.font = font;
    label.lineSpacing = lineSpacing;
    label.text = text;
    
    return [label preferredSizeWithMaxWidth:width].height;
}

+ (CGFloat)heightWithText:(id)text
                     font:(UIFont *)font
       constrainedToWidth:(CGFloat)width
            numberOfLines:(NSInteger)numberOfLines {
    HBEmojiLabel *label = [[HBEmojiLabel alloc] init];
    label.font = font;
    label.numberOfLines = numberOfLines;
    label.text = text;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    return [label sizeWithConstrainedToWidth:width].height;
}

+ (CGSize)sizeWithText:(id)text
                  font:(UIFont *)font
    constrainedToWidth:(CGFloat)width {
    HBEmojiLabel *label = [[HBEmojiLabel alloc] init];
    label.font = font;
    label.lineSpacing = 4;
    label.text = text;
    
    return [label preferredSizeWithMaxWidth:width];
}

+ (CGSize)attributedStringSizeWithText:(id)text
                                  font:(UIFont *)font
                    constrainedToWidth:(CGFloat)width
                           lineSpacing:(CGFloat)lineSpacing {
    HBEmojiLabel *label = [[HBEmojiLabel alloc] init];
    label.font = font;
    label.lineSpacing = lineSpacing;
    
    [label setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        return mutableAttributedString;
    }];
    
    return [label sizeWithConstrainedToWidth:width];
}



@end
