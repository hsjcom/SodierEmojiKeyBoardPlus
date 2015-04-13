//
//  EmojiBoard.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/24.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "EmojiBoard.h"

@protocol EmojiBoardDelegate <NSObject>

@optional

- (void)textViewDidChange:(UITextView *)textView;

- (void)textFieldDidChange:(UITextField *)textField;

@end




@interface EmojiBoard : UIView<UIScrollViewDelegate>{
    UIScrollView *_emojiView;
    UIPageControl *_pageControl;
    NSDictionary *_emojiMap;
}


@property (nonatomic, weak) id<EmojiBoardDelegate> delegate;

//适用于UITextField \ UITextView
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) UITextView *inputTextView;


- (void)deleteEmoji;


@end
