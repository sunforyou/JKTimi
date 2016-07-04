//
//  JKTimiCollectionViewCell.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/12.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKTimiCollectionViewCell.h"

@implementation JKTimiCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupContentViewWithCategory];
    }
    return self;
}

- (void)setupContentViewWithCategory {
    /**创建对应类目图片的按钮*/
    self.categoryButton = [[UIButton alloc] initWithFrame:CGRectZero];
    self.categoryButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryButton.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:self.categoryButton];
    
    /**创建对应类目图片的Label*/
    self.categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.categoryLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryLabel.textColor = [UIColor blueColor];
    self.categoryLabel.font = [UIFont systemFontOfSize:20];
    [self.contentView addSubview:self.categoryLabel];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryButton]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_categoryButton)]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_categoryLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_categoryLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_categoryButton]-[_categoryLabel]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_categoryButton,_categoryLabel)]];
}

@end
