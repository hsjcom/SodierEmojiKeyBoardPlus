//
//  SJRichLabel.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/8/28.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "SJRichLabel.h"
#import "NSString+EMAdditions.h"
#import "FontAwesome.h"

@implementation SJRichLabel

NSString *const kLinkOpenMarkup  = @"<url>";
NSString *const kLinkCloseMarkup = @"</url>";

- (void)setRichText:(NSString *)richText {
    [self richTextConfig];
    
    self.text = richText.attributedString;
}

//富文本
- (void)richTextConfig {
    [EMStringStylingConfiguration sharedInstance].defaultFont = self.iconFontEnable ? [FontAwesome fontWithSize:self.font.pointSize] : [UIFont systemFontOfSize:self.font.pointSize];
    [EMStringStylingConfiguration sharedInstance].strongFont = [UIFont boldSystemFontOfSize:self.font.pointSize];
    [EMStringStylingConfiguration sharedInstance].emphasisFont = [SJRichLabel italicFontOfSize:self.font.pointSize];
    
    // Then for the demo I created a bunch of custom styling class to provide examples
    
    // The code tag a little bit like in Github (custom font, custom color, a background color)
    EMStylingClass *aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<code>"];
    aStylingClass.color = [UIColor colorWithWhite:0.151 alpha:1.000];
    aStylingClass.font = [UIFont systemFontOfSize:self.font.pointSize];
    aStylingClass.attributes = @{NSBackgroundColorAttributeName:[UIColor orangeColor]};
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
        
        self.richText = realText;
    }
    
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
            
            if (styleRange.location < realText.length && realText.length > styleRange.length && linkUrlArray > 0) {
                NSString *urlStr = linkUrlArray[i];
                NSURL *url;
                if (urlStr && [urlStr length] > 0) {
                    url = [NSURL URLWithString:urlStr];
                }
                [self addLinkToURL:url withRange:styleRange];
            }
            
            [styleAttributedString replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
            NSRange closeMarkupRange2 = [styleAttributedString.mutableString rangeOfString:kLinkCloseMarkup];
            [styleAttributedString replaceCharactersInRange:NSMakeRange(closeMarkupRange2.location, closeMarkupRange2.length) withString:@""];
        }
    }
}






@end
