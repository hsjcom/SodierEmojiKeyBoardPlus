//
//  EmojiBoard.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/24.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "EmojiBoard.h"
#import "EmojiButton.h"

#define EMOJI_X_START 17
#define EMOJI_X_PADDING 15
#define EMOJI_Y_START 20
#define EMOJI_Y_PADDING 20

#define EMOJI_COUNT_ALL  51
#define EMOJI_COUNT_ROW  3
#define EMOJI_COUNT_CLU  7
#define EMOJI_COUNT_PAGE (EMOJI_COUNT_ROW * EMOJI_COUNT_CLU) //每页个数
#define EMOJI_ICON_SIZE floor(([[UIScreen mainScreen] bounds].size.width - EMOJI_X_START * 2 - EMOJI_X_PADDING * (EMOJI_COUNT_CLU - 1)) / EMOJI_COUNT_CLU) //28
#define EMOJI_PAGE_ALL (EMOJI_COUNT_ALL / EMOJI_COUNT_PAGE + 1) //共有多少页

@implementation EmojiBoard

@synthesize delegate;

@synthesize inputTextField = _inputTextField;
@synthesize inputTextView = _inputTextView;

- (void)dealloc {
    [self setDelegate:nil];
}

- (id)init {
    CGFloat with = [[UIScreen mainScreen] bounds].size.width;
    self = [super initWithFrame:CGRectMake(0, 0, with, 216)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:236.0 / 255.0 green:236.0 / 255.0 blue:236.0 / 255.0 alpha:1];

//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//        if ([[languages objectAtIndex:0] hasPrefix:@"zh"]) {
//            _emojiMap = [NSDictionary dictionaryWithContentsOfFile:
//                         [[NSBundle mainBundle] pathForResource:@"faceMap_ch"
//                                                         ofType:@"plist"]];
//        } else {
//            _emojiMap = [NSDictionary dictionaryWithContentsOfFile:
//                         [[NSBundle mainBundle] pathForResource:@"faceMap_en"
//                                                         ofType:@"plist"]];
//        }
       
        _emojiMap = [NSDictionary dictionaryWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"EmojiMap"
                                                     ofType:@"plist"]];
       
//        [[NSUserDefaults standardUserDefaults] setObject:_emojiMap forKey:@"FaceMap"];

        [self constructEmojiView];
        
        [self layoutEmojiView];
    }

    return self;
}

- (void)constructEmojiView{
    //表情盘
    _emojiView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 190)];
    _emojiView.pagingEnabled = YES;
    _emojiView.contentSize = CGSizeMake((EMOJI_COUNT_ALL / EMOJI_COUNT_PAGE + 1) * self.frame.size.width, 190);
    _emojiView.showsHorizontalScrollIndicator = NO;
    _emojiView.showsVerticalScrollIndicator = NO;
    _emojiView.delegate = self;
    
    //添加PageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.frame.size.width * 0.5 - EMOJI_PAGE_ALL * 20 * 0.5, self.frame.size.height - 15 - 20, EMOJI_PAGE_ALL * 20, 20)];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithRed:255.0 / 255.0 green:255.0 / 255.0 blue:255.0 / 255.0 alpha:1];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.5];
    [_pageControl addTarget:self
                     action:@selector(pageChange:)
           forControlEvents:UIControlEventValueChanged];
    _pageControl.numberOfPages = EMOJI_PAGE_ALL;
    _pageControl.currentPage = 0;
    [self addSubview:_pageControl];
    
    [self addSubview:_emojiView];
}

- (void)layoutEmojiView{
    int deleteBtnCount = 0;
    for (int i = 1; i <= EMOJI_COUNT_PAGE * EMOJI_PAGE_ALL; i++) {
        //计算每一个表情按钮的坐标和在哪一屏
        CGFloat x = (((i - 1) % EMOJI_COUNT_PAGE) % EMOJI_COUNT_CLU) * (EMOJI_ICON_SIZE + EMOJI_X_PADDING) + EMOJI_X_START + ((i - 1) / EMOJI_COUNT_PAGE * self.frame.size.width);
        CGFloat y = (((i - 1) % EMOJI_COUNT_PAGE) / EMOJI_COUNT_CLU) * (EMOJI_ICON_SIZE + EMOJI_Y_PADDING) + EMOJI_Y_START;
        
        
        //删除按钮
        if (i % EMOJI_COUNT_PAGE == 0) {
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteEmoji"] forState:UIControlStateNormal];
            [deleteBtn setImage:[UIImage imageNamed:@"deleteEmoji_hl"] forState:UIControlStateSelected];
            [deleteBtn addTarget:self action:@selector(deleteEmoji) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.frame = CGRectMake(x + 5, y + 10, 23, 21);
            [_emojiView addSubview:deleteBtn];
            
            deleteBtnCount ++;
            
            continue;
        }
        
        if (i > (EMOJI_COUNT_ALL + EMOJI_PAGE_ALL - 1)) {
            continue;
        }
        
        //表情
        EmojiButton *emojiButton = [EmojiButton buttonWithType:UIButtonTypeCustom];
        emojiButton.buttonIndex = i - deleteBtnCount;
        [emojiButton addTarget:self
                        action:@selector(emojiButton:)
              forControlEvents:UIControlEventTouchUpInside];
        emojiButton.frame = CGRectMake(x, y, EMOJI_ICON_SIZE, EMOJI_ICON_SIZE);
        [emojiButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"emoji_%03d", i - deleteBtnCount]] forState:UIControlStateNormal];
        [_emojiView addSubview:emojiButton];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_pageControl setCurrentPage:_emojiView.contentOffset.x / self.frame.size.width];
    [_pageControl updateCurrentPageDisplay];
}

- (void)pageChange:(id)sender {
    [_emojiView setContentOffset:CGPointMake(_pageControl.currentPage * self.frame.size.width, 0) animated:YES];
    [_pageControl setCurrentPage:_pageControl.currentPage];
}

- (void)emojiButton:(id)sender {
    int i = (int)((EmojiButton *)sender).buttonIndex;
    if (self.inputTextField) {

        NSMutableString *emojiString = [[NSMutableString alloc]initWithString:self.inputTextField.text];
        [emojiString appendString:[_emojiMap objectForKey:[NSString stringWithFormat:@"%03d", i]]];
        self.inputTextField.text = emojiString;
        
    } else if (self.inputTextView) {
        NSMutableString *emojiString = [[NSMutableString alloc]initWithString:self.inputTextView.text];
        [emojiString insertString:[_emojiMap objectForKey:[NSString stringWithFormat:@"%03d", i]] atIndex: self.inputTextView.selectedRange.location];
        self.inputTextView.text = emojiString;

        if (delegate && [delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [delegate textViewDidChange:self.inputTextView];
        }
    }
}

- (void)deleteEmoji {
    NSString *inputString;
    inputString = self.inputTextField.text;
    if (self.inputTextView) {
        inputString = self.inputTextView.text;
    }
    
    NSString *string = nil;
    NSInteger stringLength = inputString.length;
    if (stringLength > 0) {
        if ([@"]" isEqualToString:[inputString substringFromIndex:stringLength-1]]) {
            if ([inputString rangeOfString:@"["].location == NSNotFound){
                string = [inputString substringToIndex:stringLength - 1];
            } else {
                string = [inputString substringToIndex:[inputString rangeOfString:@"[" options:NSBackwardsSearch].location];
            }
        } else {
            string = [inputString substringToIndex:stringLength - 1];
        }
    }
    
    if (self.inputTextField) {
        self.inputTextField.text = string;
        
    } else if (self.inputTextView) {
        self.inputTextView.text = string;
        
        if (delegate && [delegate respondsToSelector:@selector(textViewDidChange:)]) {
            [delegate textViewDidChange:self.inputTextView];
        }
    }
}



@end
