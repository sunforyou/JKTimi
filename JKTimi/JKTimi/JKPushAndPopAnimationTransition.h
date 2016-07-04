//
//  JKPushAndPopAnimationTransition.h
//  JKTimi
//
//  Created by 宋旭 on 16/5/24.
//  Copyright © 2016年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JKPushAndPopAnimationTransitionType) {
    JKPushAndPopAnimationTransitionTypePush = 0 << 16,
    JKPushAndPopAnimationTransitionTypePop  = 1 << 16,
    JKSystemAnimationTransitionTypeFlipFromLeft = 2 << 16
};

typedef NS_ENUM(NSInteger, JKAnimationTransitionType) {
    JKAnimationTransitionTypeSlide = 0,
    JKAnimationTransitionTypeShuffle
};

@interface JKPushAndPopAnimationTransition : NSObject <UIViewControllerAnimatedTransitioning>

/**
 *  动画过渡代理管理的是push还是pop
 */
@property (nonatomic, assign) JKPushAndPopAnimationTransitionType type;

@property (nonatomic, assign) JKAnimationTransitionType animationType;

/**
 *  初始化动画过渡代理
 * @prama type 初始化pop还是push的代理
 */
+ (instancetype)transitionWithType:(JKPushAndPopAnimationTransitionType)type;
- (instancetype)initWithTransitionType:(JKPushAndPopAnimationTransitionType)type;

@end
