//
//  RichViewController.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "RichViewController.h"
#import "FontAwesome.h"

@implementation RichViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Rich Text";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _isShowString = NO;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"text" style:UIBarButtonItemStyleDone target:self action:@selector(showString)];
    
    
    _richLabel = [[SJRichLabel alloc] initWithFrame:CGRectMake(10, 74, self.view.frame.size.width - 20, self.view.frame.size.height - 74 - 10)];
    _richLabel.delegate = self;
    _richLabel.textAlignment = NSTextAlignmentLeft;
    _richLabel.backgroundColor = [UIColor whiteColor];
    _richLabel.iconFontEnable = YES;
    _richLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_richLabel];
    
    [self constructText];
    [self setRichText];
    
    
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    

}

- (void)constructText {
    self.text = @"<h4>About SJString</h4>\n I am Soldier 这是富文本 \uf135 <url>hsjer.com</url><p><strong>SJString</strong> \uf27b \uf21c stands for <em><strong>E</strong>asy <strong>M</strong>arkup <strong>S</strong>tring</em>. \uf15b:<url>设置可点击文字的范围</url> I hesitated to call it SONSAString : Sick Of NSAttributedString...</p>\n<p>Most of the time if you need to display a text with different styling in it, like \"<strong>This text is bold</strong> but then <em>italic 中文.</em>\",\uf030 you would use an <code>NSAttributedString</code> and its API.[大兵][大兵] Same thing if suddenly your text is <green><strong>GREEN</strong></green> and then <red><strong>RED</strong></red>...</p><p>Personnaly I don't like it! It clusters my classes with a lot of boilerplate code to find range and apply style, etc...</p>\n[微笑][微笑]<p>This is what <strong>SJString</strong> is about. Use the efficient <u>HTML markup</u>you would expect it to.</p>\n<h1>h1 header</h1><h2>h2 header</h2><h3>h3 header</h3><stroke>Stroke text</stroke>\n<strong>strong</strong>\n<em>emphasis</em>\n<u>underline</u>\n<s>strikethrough</s>\n<code>and pretty much whatever you think of...</code>";
}

- (void)setRichText {
    NSString *url = @"http://www.hsjer.com/";
    NSMutableArray *urls = [NSMutableArray arrayWithObjects:url, url, nil];
    [_richLabel addLinkText:self.text linkUrlArray:urls];
}

#pragma mark - TTTAttributedLabelDelegate

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url {
    
   [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - MLEmojiLabelDelegate

//打开链接
- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type {
}

- (void)showString {
    _isShowString = !_isShowString;
    if (self.isShowString) {
        _richLabel.text = self.text;
    } else {
        [self setRichText];
    }
}

@end
