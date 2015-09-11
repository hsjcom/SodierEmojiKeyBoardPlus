//
//  SJRichLabel.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/8/28.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "HBEmojiLabel.h"

@interface SJRichLabel : HBEmojiLabel

/**
 * 富文本，*使用此字段有效
 */
@property (nonatomic, strong) NSString *richText;


/**
 * 超链接富文本，*在字体等属性赋值后使用
 * linkUrlArray 链接字符串数组
 */
- (void)addLinkText:(NSString *)text linkUrlArray:(NSMutableArray *)linkUrlArray;

@end
