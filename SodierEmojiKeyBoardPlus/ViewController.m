//
//  ViewController.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/3/24.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "ViewController.h"

#import "NSString+EMAdditions.h"
#import "EMStringStylingConfiguration.h"

@interface ViewController ()

@end



@implementation ViewController

static inline NSRegularExpression * NameRegularExpression() {
    static NSRegularExpression *_nameRegularExpression = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _nameRegularExpression = [[NSRegularExpression alloc] initWithPattern:@"^\\w+" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    
    return _nameRegularExpression;
}

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
    self.title = @"Emoji Label & keyboard";
    self.view.backgroundColor = [UIColor whiteColor];
    
    SJEmojiLabel *titleLabel = [[SJEmojiLabel alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width - 20, 20)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = @"[大兵] [大兵]I am Soldier[大兵][大兵]";
    [self.view addSubview:titleLabel];
    
    [self constructView];
    [self constructKeyBoardView];
    
    
//    [self attributedString];
    
//    [self textString];
    
    [self richText];
    
//    [self hyperlinkText];
    
//    [self customLinkText];
}

- (void)constructView{
    _contentLabel = [[SJEmojiLabel alloc] initWithFrame:CGRectMake(10, 100, self.view.frame.size.width - 20, 300)];
    _contentLabel.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.1];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.font = [UIFont systemFontOfSize:18];
    _contentLabel.delegate = self; //打开链接
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
- (void)textString {
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

//富文本
- (void)richText {
    [EMStringStylingConfiguration sharedInstance].defaultFont  = [UIFont italicSystemFontOfSize:15];//[UIFont fontWithName:@"Avenir-Light" size:15];
    [EMStringStylingConfiguration sharedInstance].strongFont   = [UIFont fontWithName:@"Avenir" size:15];
    [EMStringStylingConfiguration sharedInstance].emphasisFont = [UIFont fontWithName:@"Avenir-LightOblique" size:15];
    
    // Then for the demo I created a bunch of custom styling class to provide examples
    
    // The code tag a little bit like in Github (custom font, custom color, a background color)
    EMStylingClass *aStylingClass = [[EMStylingClass alloc] initWithMarkup:@"<code>"];
    aStylingClass.color           = [UIColor colorWithWhite:0.151 alpha:1.000];
    aStylingClass.font            = [UIFont fontWithName:@"Courier" size:14];
    aStylingClass.attributes      = @{NSBackgroundColorAttributeName : [UIColor colorWithWhite:0.901 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in RED
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<red>"];
    aStylingClass.color = [UIColor colorWithRed:0.773 green:0.000 blue:0.263 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text in GREEN
    aStylingClass       = [[EMStylingClass alloc] initWithMarkup:@"<green>"];
    aStylingClass.color = [UIColor colorWithRed:0.269 green:0.828 blue:0.392 alpha:1.000];
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    // A styling class for text with stroke
    aStylingClass            = [[EMStylingClass alloc] initWithMarkup:@"<stroke>"];
    aStylingClass.font       = [UIFont fontWithName:@"Avenir-Black" size:26];
    aStylingClass.color      = [UIColor whiteColor];
    aStylingClass.attributes = @{NSStrokeWidthAttributeName: @-6,
                                 NSStrokeColorAttributeName:[UIColor colorWithRed:0.111 green:0.568 blue:0.764 alpha:1.000]};
    [[EMStringStylingConfiguration sharedInstance] addNewStylingClass:aStylingClass];
    
    /**
     *  END of setup to be done only once througout entire app.
     */
    
    // Our big text stored in a string with tags for EMString styling
    NSString *text = @"富文本<h4>About EMString</h4>\n<p><strong>EMString</strong> http://www.hsjer.com/ [微笑][大兵][微笑][微笑][微笑][大兵][微笑][微笑] stands for <em><strong>E</strong>asy <strong>M</strong>arkup <strong>S</strong>tring</em>. I hesitated to call it SONSAString : Sick Of NSAttributedString...</p>\n<p>Most of the time if you need to display a text with different styling in it, like \"<strong>This text is bold</strong> but then <em>italic.</em>\", you would use an <code>NSAttributedString</code> and its API. Same thing if suddenly your text is <green><strong>GREEN</strong></green> and then <red><strong>RED</strong></red>...</p><p>Personnaly I don't like it! It clusters my classes with a lot of boilerplate code to find range and apply style, etc...</p>\n<p>This is what <strong>EMString</strong> is about. Use the efficient <u>HTML markup</u> system we all know and get an iOS string stylized in one line of code and behave like you would expect it to.</p>\n<h1>h1 header</h1><h2>h2 header</h2><h3>h3 header</h3><stroke>Stroke text</stroke>\n<strong>strong</strong>\n<em>emphasis</em>\n<u>underline</u>\n<s>strikethrough</s>\n<code>and pretty much whatever you think of...</code>";
    
    _contentLabel.disableThreeCommon = NO;
    _contentLabel.text = text.attributedString;
}

//hyperlink
- (void)hyperlinkText {
    _contentLabel.linkAttributes = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    
    NSString *text = @"哈哈设置可点击文字的范围设置可点击文本的颜色说说";
    
    [_contentLabel setText:text afterInheritingLabelAttributesAndConfiguringWithBlock:^ NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
         //设置可点击文字的范围
         NSRange boldRange = [[mutableAttributedString string] rangeOfString:@"设置可点击文字的范围" options:NSCaseInsensitiveSearch];

         //设定可点击文字的的大小
         UIFont *boldSystemFont = [UIFont boldSystemFontOfSize:16];
         CTFontRef font = CTFontCreateWithName((__bridge CFStringRef)boldSystemFont.fontName, boldSystemFont.pointSize, NULL);

         if (font) {
             //设置可点击文本的大小
             [mutableAttributedString addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)font range:boldRange];
             //设置可点击文本的颜色
             [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor blueColor] CGColor] range:boldRange];
             CFRelease(font);
         }
         return mutableAttributedString;
     }];
    
    //正则
    NSRegularExpression *regexp = NameRegularExpression();
    NSRange linkRange = [regexp rangeOfFirstMatchInString:text options:0 range:NSMakeRange(2, 10)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hsjer.com/"]];
    
    //设置链接的url
    [_contentLabel addLinkToURL:url withRange:linkRange];
}

- (void)customLinkText {
    NSString *openMarkup = @"<url>";
    NSString *closeMarkup = @"</url>";
    NSString *text = @"[微笑]<url>设置可点击文字的范围</url>设置可点击文本的颜色<url>说说</url>范围<url>范围</url>范围范<url>围</url>范围范围<h4>About EMString</h4>\n<p><strong>EMString</strong> \n <strong>http://www.hsjer.com/</strong> [微笑][大兵][微笑][微笑][微笑][大兵][微笑][微笑]";
    
    _contentLabel.text = text.attributedString;
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hsjer.com/"]];
    
    NSMutableAttributedString *styleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    
    NSRange openMarkupRange, closeMarkupRange;
    NSUInteger markupCount = 0, openMarkupCount = 0, closeMarkupCount = 0;
    
    //get openMarkupCount
    NSMutableAttributedString *styleAttributedString2 = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    while((openMarkupRange = [styleAttributedString2.mutableString rangeOfString:openMarkup]).location != NSNotFound) {
        openMarkupCount ++;
        [styleAttributedString2 replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
    }
    
    //get closeMarkupCount
    NSMutableAttributedString *styleAttributedString3 = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    while((closeMarkupRange = [styleAttributedString3.mutableString rangeOfString:closeMarkup]).location != NSNotFound) {
        closeMarkupCount ++;
        [styleAttributedString3 replaceCharactersInRange:NSMakeRange(closeMarkupRange.location, closeMarkupRange.length) withString:@""];
    }
    
    if (openMarkupCount == closeMarkupCount) {
        markupCount = openMarkupCount;
        
        NSString *realText = [NSString stringWithString:text];
        realText = [realText stringByReplacingOccurrencesOfString:openMarkup withString:@""];
        realText = [realText stringByReplacingOccurrencesOfString:closeMarkup withString:@""];
        
        _contentLabel.text = realText.attributedString;
    }
    
    for (int i = 0; i < markupCount; i++) {
        if((openMarkupRange = [styleAttributedString.mutableString rangeOfString:openMarkup]).location != NSNotFound) {
            
            // Find range of close markup
            closeMarkupRange = [styleAttributedString.mutableString rangeOfString:closeMarkup];
            if (closeMarkupRange.location == NSNotFound) {
                NSLog(@"Error finding close markup");
                return;
            }
            
            // Calculate the style range that represent the string between the open and close markups
            NSRange styleRange = NSMakeRange(openMarkupRange.location, closeMarkupRange.location - openMarkupRange.location - openMarkup.length);
            
            if (styleRange.location < text.length && text.length > styleRange.length) {
                
                [_contentLabel addLinkToURL:url withRange:styleRange];
            }
            
            [styleAttributedString replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
            NSRange closeMarkupRange2 = [styleAttributedString.mutableString rangeOfString:closeMarkup];
            [styleAttributedString replaceCharactersInRange:NSMakeRange(closeMarkupRange2.location, closeMarkupRange2.length) withString:@""];
        }
    }
}

//自定义文本链接
- (void)customLinkText2 {
    NSString *openMarkup = @"<url>";
    NSString *closeMarkup = @"</url>";
    NSString *text = @"<url>设置可点击文字的范围</url>设置可点击文本的颜色<url>说说</url>范围<url>范围</url>范围范<url>围</url>范围范围";
    _contentLabel.text = text;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.hsjer.com/"]];
    
    NSMutableAttributedString *styleAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    
    NSRange openMarkupRange, closeMarkupRange;
    NSUInteger markupCount = 0, openMarkupCount = 0, closeMarkupCount = 0;
    
    //get openMarkupCount
    NSMutableAttributedString *styleAttributedString2 = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    while((openMarkupRange = [styleAttributedString2.mutableString rangeOfString:openMarkup]).location != NSNotFound) {
        openMarkupCount ++;
        [styleAttributedString2 replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
    }
    
    //get closeMarkupCount
    NSMutableAttributedString *styleAttributedString3 = [[NSMutableAttributedString alloc] initWithAttributedString:text.attributedString];
    while((closeMarkupRange = [styleAttributedString3.mutableString rangeOfString:closeMarkup]).location != NSNotFound) {
        closeMarkupCount ++;
        [styleAttributedString3 replaceCharactersInRange:NSMakeRange(closeMarkupRange.location, closeMarkupRange.length) withString:@""];
    }
    
    if (openMarkupCount == closeMarkupCount) {
        markupCount = openMarkupCount;
    }
    
    for (int i = 0; i < markupCount; i++) {
        if((openMarkupRange = [styleAttributedString.mutableString rangeOfString:openMarkup]).location != NSNotFound) {
            
            // Find range of close markup
            closeMarkupRange = [styleAttributedString.mutableString rangeOfString:closeMarkup];
            if (closeMarkupRange.location == NSNotFound) {
                NSLog(@"Error finding close markup");
                return;
            }
            
            // Calculate the style range that represent the string between the open and close markups
            NSUInteger location = i > 0 ? openMarkupRange.location + (openMarkup.length + closeMarkup.length) * i + openMarkup.length : openMarkupRange.location + openMarkup.length;
            NSRange styleRange = NSMakeRange(location, closeMarkupRange.location - openMarkupRange.location - openMarkup.length);
            
            [_contentLabel addLinkToURL:url withRange:styleRange];
            
            [styleAttributedString replaceCharactersInRange:NSMakeRange(openMarkupRange.location, openMarkupRange.length) withString:@""];
            NSRange closeMarkupRange2 = [styleAttributedString.mutableString rangeOfString:closeMarkup];
            [styleAttributedString.mutableString replaceCharactersInRange:NSMakeRange(closeMarkupRange2.location, closeMarkupRange2.length) withString:@""];
        }
    }
}


#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
  
//    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - MLEmojiLabelDelegate

//打开链接
- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type {
    if (type == MLEmojiLabelLinkTypeURL && link.length > 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
    }
}

@end
