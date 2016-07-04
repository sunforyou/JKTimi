//
//  JKCollectionViewCell.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/16.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKCollectionViewCell.h"

@implementation JKCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_imageView setUserInteractionEnabled:YES];
    _imageView.contentMode = UIViewContentModeCenter;
    _imageView.layer.cornerRadius = kImageDiameter * 0.5;
    [self addSubview:_imageView];
    
    self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.descLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.descLabel.textAlignment = NSTextAlignmentCenter;
    self.descLabel.adjustsFontSizeToFitWidth = YES;
    self.descLabel.textColor = [UIColor blueColor];
    [self addSubview:self.descLabel];
    
    // 自定义autoLayout
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_imageView]-[_descLabel]-|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_imageView, _descLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_descLabel]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_descLabel)]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|"
                                                                 options:0
                                                                 metrics:nil
                                                                   views:NSDictionaryOfVariableBindings(_imageView)]];
}

@end
