//
//  SJRichLabel.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/8/28.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJEmojiLabel.h"

@interface SJRichLabel : SJEmojiLabel

/**
 * 是否支持icon font
 */
@property (nonatomic, assign) BOOL iconFontEnable;

/**
 * 富文本，*使用此字段有效
 */
@property (nonatomic, strong) NSString *richText;


/**
 * 超链接富文本，*在字体等属性赋值后使用
 * linkUrlArray 链接字符串数组
 */
- (void)addLinkText:(NSString *)text linkUrlArray:(NSMutableArray *)linkUrlArray;

/**
 * 文本高度计算
 */
+ (CGFloat)richHeightWithText:(NSString *)text
                         font:(UIFont *)font
           constrainedToWidth:(CGFloat)width
                  lineSpacing:(CGFloat)lineSpacing;

/**
 * 链接带有中文需要encode
 */
+ (NSString *)urlEncode:(NSString *)str;

+ (NSString *)urlDecode:(NSString *)str;

@end
