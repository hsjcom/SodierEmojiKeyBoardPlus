//
//  ViewController.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/24.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiBoard.h"
#import "HBEmojiLabel.h"

@interface ViewController : UIViewController<EmojiBoardDelegate, UITextViewDelegate>{
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
    
    HBEmojiLabel *_contentLabel;
}


@end

