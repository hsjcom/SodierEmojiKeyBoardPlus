//
//  MLEmojiLabel.h
//  MLEmojiLabel
//
//  Created by molon on 5/19/14.
//  Copyright (c) 2014 molon. All rights reserved.
//

#import "TTTAttributedLabel.h"


typedef NS_OPTIONS(NSUInteger, MLEmojiLabelLinkType) {
    MLEmojiLabelLinkTypeURL = 0,
    MLEmojiLabelLinkTypeEmail,
    MLEmojiLabelLinkTypePhoneNumber,
    MLEmojiLabelLinkTypeAt,
    MLEmojiLabelLinkTypePoundSign,
};


@class MLEmojiLabel;
@protocol MLEmojiLabelDelegate <TTTAttributedLabelDelegate>

@optional
- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel
       didSelectLink:(NSString *)link
            withType:(MLEmojiLabelLinkType)type;


@end

@interface MLEmojiLabel : TTTAttributedLabel

@property (nonatomic, assign) BOOL disableEmoji; //禁用表情
@property (nonatomic, assign) BOOL disableThreeCommon; //禁用电话，邮箱，连接三者

@property (nonatomic, assign) BOOL isNeedAtAndPoundSign; //是否需要话题和@功能，默认为不需要

@property (nonatomic, copy) NSString *customEmojiRegex; //自定义表情正则
@property (nonatomic, copy) NSString *customEmojiPlistName; //xxxxx.plist 格式

@property (nonatomic, weak) id<MLEmojiLabelDelegate> delegate; //点击连接的代理方法

@property (nonatomic, copy, readonly) id emojiText; //外部能获取text的原始副本

/*
 * by Soldier
 */
@property (nonatomic, assign) CGFloat emojiWidthRatioWithLineHeight; //和字体高度的比例
@property (nonatomic, assign) CGFloat emojiOriginYOffsetRatioWithLineHeight; //表情绘制的y坐标矫正值，和字体高度的比例，越大越往下

- (CGSize)preferredSizeWithMaxWidth:(CGFloat)maxWidth;

@end
