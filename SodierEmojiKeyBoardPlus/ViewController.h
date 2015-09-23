//
//  ViewController.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/24.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiBoard.h"
#import "SJEmojiLabel.h"

#import "SJRichLabel.h"

@interface ViewController : UIViewController<EmojiBoardDelegate, UITextViewDelegate, MLEmojiLabelDelegate>{
    UIView *_toolBar;
    UITextView *_textView;
    UIButton *_keyboardButton;
    UIButton *_imageBoardButton;
    UIButton *_sendButton;
    
    BOOL _isFirstShowKeyboard;
    BOOL _isButtonClicked;
    BOOL _isBoardShowing;
    
    BOOL _isKeyBoardShow;
    
    BOOL _isEmojiBoardShow;
    BOOL _isImageBoardShow;
    
    CGFloat _keyboardHeight;
    EmojiBoard *_emojiBoard;
    UIView *_imageBoard;
    
    SJEmojiLabel *_contentLabel;
}


@end

