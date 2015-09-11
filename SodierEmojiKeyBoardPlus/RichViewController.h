//
//  RichViewController.h
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SJRichLabel.h"

@interface RichViewController : UIViewController <MLEmojiLabelDelegate>

@property (nonatomic, strong) SJRichLabel *richLabel;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) BOOL isShowString;

@end
