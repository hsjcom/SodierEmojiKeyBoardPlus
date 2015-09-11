//
//  RootViewController.m
//  SodierEmojiKeyBoardPlus
//
//  Created by Soldier on 15/9/10.
//  Copyright (c) 2015年 Soldier. All rights reserved.
//

#import "RootViewController.h"
#import "ViewController.h"
#import "RichViewController.h"

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"SUPER TEXT";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(self.view.frame.size.width * 0.5 - 150 * 0.5, 200, 150, 40);
    [btn1 setTitle:@"Emoji Label" forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(emojiLabelView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(self.view.frame.size.width * 0.5 - 150 * 0.5, 280, 150, 40);
    [btn2 setTitle:@"RichText Label" forState:UIControlStateNormal];
    [btn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(richTextLabelView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
}

- (void)emojiLabelView {
    ViewController *controller = [[ViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)richTextLabelView {
    RichViewController *controller = [[RichViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
