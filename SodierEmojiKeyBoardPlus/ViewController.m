//
//  ViewController.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/24.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end



@implementation ViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardDidHide:)
                                                     name:UIKeyboardDidHideNotification
                                                   object:nil];
        
        _isFirstShowKeyboard = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    HBEmojiLabel *titleLabel = [[HBEmojiLabel alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 20)];
    titleLabel.text = @"[大兵] [大兵] I am Soldier [大兵] [大兵]";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:titleLabel];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self constructView];
    [self constructKeyBoardView];
}

- (void)constructView{
    _contentLabel = [[HBEmojiLabel alloc] initWithFrame:CGRectMake(10, 50, self.view.frame.size.width - 20, 300)];//CGRectMake(10, 20, self.view.frame.size.width - 20, 300)
    _contentLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.1];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:_contentLabel];
}

- (void)constructKeyBoardView{
    _toolBar = [[UIView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 100, self.view.frame.size.width, 100)];
    _toolBar.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.6];
    [self.view addSubview:_toolBar];
    
    _keyboardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _keyboardButton.frame = CGRectMake(10, 10, 32, 32);
    [_keyboardButton setImage:[UIImage imageNamed:@"keyBoardBtn"] forState:UIControlStateNormal];
    [_keyboardButton addTarget:self action:@selector(keyboardClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_keyboardButton];
    
    _imageBoardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _imageBoardButton.frame = CGRectMake(10, 62, 32, 32);
    [_imageBoardButton setImage:[UIImage imageNamed:@"imageBoardBtn"] forState:UIControlStateNormal];
    [_imageBoardButton addTarget:self action:@selector(imageBoardClick) forControlEvents:UIControlEventTouchUpInside];
    [_toolBar addSubview:_imageBoardButton];
    
    _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendButton.frame = CGRectMake(_toolBar.frame.size.width - 50, 10, 45, 35);
    [_sendButton addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_sendButton.layer setCornerRadius:6];
    [_sendButton.layer setMasksToBounds:YES];
    [_sendButton setTitle:@"send" forState:UIControlStateNormal];
    [_sendButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    [_toolBar addSubview:_sendButton];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(52, 10, _toolBar.frame.size.width - 52 - 60, _toolBar.frame.size.height - 20)];
    [_textView.layer setCornerRadius:6];
    [_textView.layer setMasksToBounds:YES];
    _textView.font = [UIFont systemFontOfSize:16];
    _textView.delegate = self;
    [_toolBar addSubview:_textView];
    
    [self constructEmojiBoard];
    [self constructImageBoard];
}

- (void)constructEmojiBoard {
    _emojiBoard = [[EmojiBoard alloc] init];
    _emojiBoard.delegate = self;
    _emojiBoard.inputTextView = _textView;
}

- (void)constructImageBoard{
    _imageBoard = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 216)];
    _imageBoard.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, 50, 50)];
    photoLabel.text = @"相册";
    photoLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_imageBoard addSubview:photoLabel];
    
    UILabel *cameraLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 30, 50, 50)];
    cameraLabel.text = @"相机";
    cameraLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [_imageBoard addSubview:cameraLabel];
}

- (void)keyboardClick{
    _isButtonClicked = YES;
    
    if (_isBoardShowing) {
        [_textView resignFirstResponder];
    } else {
        if (_isFirstShowKeyboard) {
            _isFirstShowKeyboard = NO;
            _isKeyBoardShow = NO;
        }
        
        if (!_isKeyBoardShow) {
            _textView.inputView = _emojiBoard;
        }
        
        [_textView becomeFirstResponder];
    }
}

- (void)imageBoardClick{
    
}

- (void)sendBtnAction {
    _textView.text = @"";
    [self textViewDidChange:_textView];
    
    [_textView resignFirstResponder];
    
    _isFirstShowKeyboard = YES;
    _isButtonClicked = NO;
    
    _textView.inputView = nil;
    
    [_keyboardButton setImage:[UIImage imageNamed:@"emojiBoardBtn"]
                    forState:UIControlStateNormal];
}


#pragma mark - NSNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    _isBoardShowing = YES;
    
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [aValue CGRectValue];
    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _toolBar.frame;
                         frame.origin.y += _keyboardHeight;
                         frame.origin.y -= keyboardRect.size.height;
                         _toolBar.frame = frame;
                         
                         _keyboardHeight = keyboardRect.size.height;
                     }];
    
    if (_isFirstShowKeyboard) {
        _isFirstShowKeyboard = NO;
        _isKeyBoardShow = !_isButtonClicked;
    }
    
    if (_isKeyBoardShow ) {
        [_keyboardButton setImage:[UIImage imageNamed:@"keyBoardBtn"]
                        forState:UIControlStateNormal];
    } else {
        [_keyboardButton setImage:[UIImage imageNamed:@"emojiBoardBtn"]
                        forState:UIControlStateNormal];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = _toolBar.frame;
                         frame.origin.y += _keyboardHeight;
                         _toolBar.frame = frame;
                         
                         _keyboardHeight = 0;
                     }];
}

- (void)keyboardDidHide:(NSNotification *)notification {
    _isBoardShowing = NO;
    
    if (_isButtonClicked) {
        _isButtonClicked = NO;
        if (![_textView.inputView isEqual:_emojiBoard] ) {
            _isKeyBoardShow = NO;
            _textView.inputView = _emojiBoard;
        } else {
            _isKeyBoardShow = YES;
            _textView.inputView = nil;
        }
        [_textView becomeFirstResponder];
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"textViewDidChange %@", textView.text);

    
    _contentLabel.text = textView.text;
    
//    [self attributedString];
    
//    [self textString];
}

//NSMutableAttributedString
- (void)attributedString{
    NSString *content = @"对潇潇暮雨洒江天，一番洗清秋。渐霜风凄紧，关河冷落，残照当楼。[微笑]是处红衰翠减，苒苒物华休。惟有长江水，无语东流。不忍登高临远，望故乡渺邈，[微笑]归思难收。 叹年来踪迹，何事苦淹留。[微笑] 想佳人、妆楼颙望，误几回、天际识归舟。争知我、倚阑干处，正恁凝愁 [微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑]";
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:content];
    
    //text方法
    
     //method 1
//    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.080 green:0.122 blue:0.258 alpha:1.000] range:NSMakeRange(9, 5)];
//    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0f] range:NSMakeRange(9, 5)];
//    //行间距
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineHeightMultiple = 6 + 13;
//    paragraphStyle.maximumLineHeight = 6 + 13;
//    paragraphStyle.minimumLineHeight = 6 + 13;
//    paragraphStyle.alignment = NSTextAlignmentJustified;
//    [attString addAttribute:(NSString *) NSParagraphStyleAttributeName
//                      value:paragraphStyle
//                      range:NSMakeRange(0, content.length)];
//    _contentLabel.text = attString;
    
     //method 2
//    [_contentLabel setText:attString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.313 green:0.479 blue:1.000 alpha:1.000] range:NSMakeRange(0, 4)];
//        
//        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0f] range:NSMakeRange(22, 4)];
//        [mutableAttributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.627 green:0.374 blue:0.219 alpha:1.000] range:NSMakeRange(22, 4)];
//        return mutableAttributedString;
//    }];
    
    
    //自适应文本
    
    //method 1 ok
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.313 green:0.479 blue:1.000 alpha:1.000] range:NSMakeRange(0, 4)];
    [attString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0f] range:NSMakeRange(22, 4)];
    [attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:[UIColor colorWithRed:0.627 green:0.374 blue:0.219 alpha:1.000] range:NSMakeRange(22, 4)];
    _contentLabel.text = attString;

//    [_contentLabel sizeToFit];
//    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
    
    //method 2 ok
//    CGSize size = [attString boundingRectWithSize:CGSizeMake(_contentLabel.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
//    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, size.height);
    
    //method 3 ok
//    CGSize textSize = [_contentLabel preferredSizeWithMaxWidth:self.view.frame.size.width - 20];
//    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, textSize.height);
}

//NSString
- (void)textString{
    NSString *text = @"对潇潇暮雨洒江天，一番洗清秋。[微笑]渐霜风凄紧，关河冷落，残照当楼。[微笑]是处红衰翠减，苒苒物华休。惟有长江水，无语东流。不忍登高临远，望故乡渺邈，归思难收。[微笑] 叹年来踪迹，何事苦淹留。[微笑] 想佳人、妆楼颙望，误几回、天际识归舟。争知我、倚阑干处，正恁凝愁 [微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑][微笑]";
    _contentLabel.text = text;
    
    
    //自适应文本
    
    //method 1 ok
//    [_contentLabel sizeToFit];
//    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, _contentLabel.frame.size.height);
    
    //method 2 ok
    CGSize textSize = [_contentLabel preferredSizeWithMaxWidth:self.view.frame.size.width - 20];
    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, textSize.height);
    
    //method 3 emoji多时高度出错
//    CGSize textSize = [text sizeWithFont:[UIFont systemFontOfSize:19]
//                              constrainedToSize:CGSizeMake(self.view.frame.size.width - 20, CGFLOAT_MAX)
//                                  lineBreakMode:NSLineBreakByTruncatingTail];
//    _contentLabel.frame = CGRectMake(_contentLabel.frame.origin.x, _contentLabel.frame.origin.y, _contentLabel.frame.size.width, textSize.height);
}

@end
