//
//  SJRichLabel.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/8/28.
//  Copyright (c) 2015年 Shaojie Hong. All rights reserved.
//

#import "SJRichLabel.h"
#import "NSString+EMAdditions.h"
#import "FontAwesome.h"

@implementation SJRichLabel

NSString *const kLinkOpenMarkup  = @"<url>";
NSString *const kLinkCloseMarkup = @"</url>";

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        /*
         * emoji origin.y 矫正
         */
//        self.emojiOriginYOffsetRatioWithLineHeight = 0.06;
    }
    return self;
}

- (void)setRichText:(NSString *)richText {
    NSString *realText = [self handelHtmlString:richText];
    realText = [self handelTextCorrelation:realText];
    
    [self richTextConfig];
    
    self.text = realText.attributedString;
}

- (NSString *)handelHtmlString:(NSString *)text {
    NSString *realText = text;
    //换行
    realText = [realText stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    realText = [realText stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    
    //空格
    realText = [realText stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@"   "];
    
    return realText;
}

- (NSString *)handelTextCorrelation:(NSString *)text {
    /*
     * fix bug:同时设置粗体和斜体问题
     *
     */
    
    NSString *realText = text;
    
    int openMarkupCount = 0, closeMarkupCount = 0;
    NSRange openMarkupRange, closeMarkupRange;
    
    NSString *openMarkup = @"<strong><em>", *closeMarkup = @"</em></strong>";
    
    NSMutableString *realTextCopy = [NSMutableString stringWithString:realText];
    
    while((openMarkupRange = [realTextCopy rangeOfString:openMarkup]).location != NSNotFound) {
        openMarkupCount ++;
        [realTextCopy replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
    }
    
    while((closeMarkupRange = [realTextCopy rangeOfString:closeMarkup]).location != NSNotFound) {
        closeMarkupCount ++;
        [realTextCopy replaceCharactersInRange:NSMakeRange(closeMarkupRange.location, closeMarkupRange.length) withString:@""];
    }
    
    if (openMarkupCount == closeMarkupCount && openMarkupCount > 0  && closeMarkupCount > 0) {
        realText = [realText stringByReplacingOccurrencesOfString:openMarkup withString:@"<strongItalic>"];
        realText = [realText stringByReplacingOccurrencesOfString:closeMarkup withString:@"</strongItalic>"];
    }
    
    //
    realTextCopy = [NSMutableString stringWithString:realText];
    openMarkupCount = 0, closeMarkupCount = 0;
    
    NSString *openMarkup2 = @"<em><strong>", *closeMarkup2 = @"</strong></em>";
    
    while((openMarkupRange = [realTextCopy rangeOfString:openMarkup2]).location != NSNotFound) {
        openMarkupCount ++;
        [realTextCopy replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
    }
    
    while((closeMarkupRange = [realTextCopy rangeOfString:closeMarkup2]).location != NSNotFound) {
        closeMarkupCount ++;
        [realTextCopy replaceCharactersInRange:NSMakeRange(closeMarkupRange.location, closeMarkupRange.length) withString:@""];
    }
    
    if (openMarkupCount == closeMarkupCount && openMarkupCount > 0  && closeMarkupCount > 0) {
        realText = [realText stringByReplacingOccurrencesOfString:openMarkup2 withString:@"<strongItalic>"];
        realText = [realText stringByReplacingOccurrencesOfString:closeMarkup2 withString:@"</strongItalic>"];
    }
    
    return realText;
}

//富文本
- (void)richTextConfig {
    [EMStringStylingConfiguration sharedInstance].defaultFont = self.iconFontEnable ? [FontAwesome fontWithSize:self.font.pointSize] : [UIFont systemFontOfSize:self.font.pointSize];
    [EMStringStylingConfiguration sharedInstance].emphasisFont = [SJRichLabel italicFontOfSize:self.font.pointSize];
    [EMStringStylingConfiguration sharedInstance].strongFont = [UIFont boldSystemFontOfSize:self.font.pointSize];
    [EMStringStylingConfiguration sharedInstance].lineSpacing = self.lineSpacing;
    [EMStringStylingConfiguration sharedInstance].defaultColor = self.textColor;
    
    // Then for the demo I created a bunch of custom styling class to provide examples
    
    // The code tag a little bit like in Github (custom font, custom color, a background color)
    EMStylingClass *aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<code>"];
    aStylingClass.color = [UIColor colorWithWhite:0.151 alpha:1.000];
    aStylingClass.font = [UIFont systemFontOfSize:self.font.pointSize];
    aStylingClass.attributes = @{NSBackgroundColorAttributeName:[UIColor colorWithWhite:0.151 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in RED
    aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<red>"];
    aStylingClass.color = [UIColor colorWithRed:0.773 green:0.000 blue:0.263 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in GREEN
    aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<green>"];
    aStylingClass.color = [UIColor colorWithRed:0.269 green:0.828 blue:0.392 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text with stroke
    aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<stroke>"];
    aStylingClass.font = [UIFont fontWithName:@"Avenir-Black" size:self.font.pointSize];
    aStylingClass.color = [UIColor whiteColor];
    aStylingClass.attributes = @{NSStrokeWidthAttributeName: @-6,
                                 NSStrokeColorAttributeName:[UIColor colorWithRed:0.111 green:0.568 blue:0.764 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
}

//斜体，解决中文italicSystemFontOfSize无效问题
+ (UIFont *)italicFontOfSize:(CGFloat)fontSize {
    CGAffineTransform matrix = CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
    
    UIFontDescriptor *desc = [UIFontDescriptor fontDescriptorWithName:[UIFont systemFontOfSize:17 ].fontName matrix:matrix];
    
    UIFont *font = [UIFont fontWithDescriptor:desc size:fontSize];
    return font;
}

- (void)addLinkText:(NSString *)text linkUrlArray:(NSMutableArray *)linkUrlArray {
    NSMutableAttributedString *styleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    
    NSRange openMarkupRange, closeMarkupRange;
    NSUInteger markupCount = 0, openMarkupCount = 0, closeMarkupCount = 0;
    
    //get openMarkupCount
    NSMutableAttributedString *styleAttributedString2 = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    while((openMarkupRange = [styleAttributedString2.mutableString rangeOfString:kLinkOpenMarkup]).location != NSNotFound) {
        openMarkupCount ++;
        [styleAttributedString2 replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
    }
    
    //get closeMarkupCount
    NSMutableAttributedString *styleAttributedString3 = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    while((closeMarkupRange = [styleAttributedString3.mutableString rangeOfString:kLinkCloseMarkup]).location != NSNotFound) {
        closeMarkupCount ++;
        [styleAttributedString3 replaceCharactersInRange:NSMakeRange(closeMarkupRange.location, closeMarkupRange.length) withString:@""];
    }
    
    NSString *realText = [NSString stringWithString:text];
    if (openMarkupCount == closeMarkupCount) {
        markupCount = openMarkupCount;
        
        realText = [realText stringByReplacingOccurrencesOfString:kLinkOpenMarkup withString:@""];
        realText = [realText stringByReplacingOccurrencesOfString:kLinkCloseMarkup withString:@""];
    }
    
    self.richText = text;
    styleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText]; //fix 自定义emoji range计算不准问题
    
    self.richText = realText;
    
    for (int i = 0; i < markupCount; i++) {
        if((openMarkupRange = [styleAttributedString.mutableString rangeOfString:kLinkOpenMarkup]).location != NSNotFound) {
            
            // Find range of close markup
            closeMarkupRange = [styleAttributedString.mutableString rangeOfString:kLinkCloseMarkup];
            if (closeMarkupRange.location == NSNotFound) {
                NSLog(@"Error finding close markup");
                return;
            }
            
            // Calculate the style range that represent the string between the open and close markups
            NSRange styleRange = NSMakeRange(openMarkupRange.location, closeMarkupRange.location - openMarkupRange.location - kLinkOpenMarkup.length);
            
            if (styleRange.location < realText.length && realText.length >= styleRange.length) {
                NSURL *url;
                if (linkUrlArray.count > 0 && linkUrlArray.count > i) {
                    NSString *urlStr = linkUrlArray[i];
                    if (urlStr && [urlStr length] > 0) {
                        url = [NSURL URLWithString:urlStr];
                    }
                }
                [self addLinkToURL:url withRange:styleRange];
            }
            
            [styleAttributedString replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
            NSRange closeMarkupRange2 = [styleAttributedString.mutableString rangeOfString:kLinkCloseMarkup];
            [styleAttributedString replaceCharactersInRange:NSMakeRange(closeMarkupRange2.location, closeMarkupRange2.length) withString:@""];
        }
    }
}

/**
 * 文本高度计算
 */
+ (CGFloat)richHeightWithText:(NSString *)text
                         font:(UIFont *)font
           constrainedToWidth:(CGFloat)width
                  lineSpacing:(CGFloat)lineSpacing {
    SJRichLabel *contentLabel = [[SJRichLabel alloc] initWithFrame:CGRectMake(0, 0, width, 30)];
    contentLabel.disableThreeCommon = YES;
    contentLabel.lineSpacing = lineSpacing;
    contentLabel.textAlignment =  NSTextAlignmentLeft;
    contentLabel.iconFontEnable = YES;
    contentLabel.numberOfLines = 0;
    contentLabel.font = font;
    [contentLabel addLinkText:text linkUrlArray:nil];
    
    [contentLabel sizeToFit];
    contentLabel.frame = CGRectMake(0, 0, width, contentLabel.frame.size.height);
    
    return contentLabel.frame.size.height;
}






@end
