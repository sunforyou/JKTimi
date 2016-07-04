//
//  JKNumberKeyboardViewController.m
//  JKTimi
//
//  Created by 宋旭 on 16/5/20.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKNumberKeyboardViewController.h"

@interface JKNumberKeyboardViewController() <UITextFieldDelegate>

/** 缓存值 */
@property (nonatomic) float storeValue;

/** 输入值 */
@property (nonatomic) float inputValue;

/** 结果值 */
@property (nonatomic) float resultValue;

/** 加号点击次数 */
@property (nonatomic) NSInteger tapCount;

@property (weak, nonatomic) IBOutlet UITextField *mTextNumberField;

/** 键盘已触底 */
@property (assign, nonatomic) BOOL isKeyBoardBottoming;

@end

@implementation JKNumberKeyboardViewController

@synthesize resultValue;
@synthesize storeValue;
@synthesize inputValue;
@synthesize tapCount;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:RGBCOLORVA(0x000000, 0.2)];
    
    //初始化价格输入栏
    self.mTextNumberField.placeholder = @"0.00";
    //设置光标显示
    self.mTextNumberField.inputView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.mTextNumberField.delegate = self;
    
    self.isKeyBoardBottoming = NO;
    
}

+ (instancetype)viewControllerFromXIB {
    return [[JKNumberKeyboardViewController alloc] initWithNibName:NSStringFromClass([self class])
                                                            bundle:[NSBundle mainBundle]];
}

#pragma mark - 键盘的推出及隐藏

- (void)displayNumKeyboardViewAnimateByDistance:(CGFloat)distance {
    if (!self.isKeyBoardBottoming) {
        [UIView animateWithDuration:0.2 animations:^ {
            self.view.frame = CGRectMake(0, HEIGHT - kCUSTOM_KEYBOARD_HEIGHT + distance, WIDTH, kCUSTOM_KEYBOARD_HEIGHT);
        } completion:^(BOOL finished) {
            [self.mTextNumberField becomeFirstResponder];
        }];
    }
}

/** 推出键盘 */
- (void)showNumKeyboardViewAnimateWithPrice:(NSString *)priceString {
    float vaule = self.mTextNumberField.text.floatValue;
    [self.mTextNumberField setText:(0 == vaule) ? @"" : priceString];
    [self.view setBackgroundColor:RGBCOLORVA(0x000000, 0.2)];
    
    [UIView animateWithDuration:0.2 animations:^ {
        self.view.frame = CGRectMake(0, HEIGHT - kCUSTOM_KEYBOARD_HEIGHT, WIDTH, kCUSTOM_KEYBOARD_HEIGHT);
    } completion:^(BOOL finished) {
        [self.mTextNumberField becomeFirstResponder];
        self.isKeyBoardBottoming = NO;
    }];
}

/**
 *  推出键盘
 *
 *  @param priceString  账目金额
 *  @param category     账目类型
 */
- (void)showNumKeyboardViewAnimateWithPrice:(NSString *)priceString withAccountType:(NSString *)category {
    
    [self.mTextNumberField setText: priceString];
    [self.view setBackgroundColor:RGBCOLORVA(0x000000, 0.2)];
    
    [UIView animateWithDuration:0.2 animations:^ {
        self.view.frame = CGRectMake(0, HEIGHT - kCUSTOM_KEYBOARD_HEIGHT, WIDTH, kCUSTOM_KEYBOARD_HEIGHT);
        
        [self.placeholderView setImage:[UIImage imageNamed:category]];
        [self.placeholderLabel setText:category];
        
    } completion:^(BOOL finished) {
        [self.mTextNumberField becomeFirstResponder];
        self.isKeyBoardBottoming = NO;
    }];
}

/** 键盘下滑消失 */
- (void)hideNumKeyboardViewWithAnimateWithSegue:(BOOL)didSegue  {
    
    [UIView animateWithDuration:0.2 animations:^ {
        self.view.frame = CGRectMake(0, HEIGHT - 44, WIDTH, 44);
        
    } completion:^(BOOL finished) {
        if (didSegue) {
            NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:self.mTextNumberField.text, @"AccountMoney", self.placeholderLabel.text, @"AccountName", nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"SegueToTimeLineViewController"
                                                                object:nil
                                                              userInfo:dict];
        }
        [self.mTextNumberField resignFirstResponder];
        [self.view setBackgroundColor:[UIColor clearColor]];
    }];
}

- (void)hideNumKeyboardViewWithAnimationByDistance:(CGFloat)distance {
    
    if (!self.isKeyBoardBottoming) {
        [UIView animateWithDuration:0.2 animations:^ {
            self.view.frame = CGRectMake(0, (HEIGHT - kCUSTOM_KEYBOARD_HEIGHT) + distance, WIDTH, 44);
        } completion:^(BOOL finished) {
            if (HEIGHT - self.view.frame.origin.y == 44) {
                self.isKeyBoardBottoming = YES;
            }
            [self.mTextNumberField resignFirstResponder];
            [self.view setBackgroundColor:[UIColor clearColor]];
        }];
    }
}

#pragma mark - 键盘全按键点击事件
/**
 *  键盘全按键点击事件
 *
 1000->0
 1001->1
 1002->2
 1003->3
 1004->4
 1005->5
 1006->6
 1007->7
 1008->8
 1009->9
 1010->.
 1011->C
 1012->del
 1013->OK
 1014->+
 *
 */
- (IBAction)keyboardViewAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    
    switch (tag) {
        case 1010:
        {
            //"."
            if(self.mTextNumberField.text.length > 0 && ![self.mTextNumberField.text containsString:@"."]){
                [self.mTextNumberField insertText:@"."];
            }
        }
            break;
        case 1011:
        {
            //"C"
            [self clearInput];
        }
            break;
        case 1012:
        {
            //"del"
            if(self.mTextNumberField.text.length > 0)
                [self.mTextNumberField deleteBackward];
        }
            break;
        case 1013:
        {
            //"OK"
            [self hideNumKeyboardViewWithAnimateWithSegue:YES];
            
        }
            break;
        case 1014:
        {
            //+
            tapCount++;
            inputValue = self.mTextNumberField.text.floatValue;
            resultValue = storeValue + inputValue;
            if (tapCount % 2 == 1) {
                self.mTextNumberField.text = @"";
            } else {
                self.mTextNumberField.text = [NSString stringWithFormat:@"%0.2lf", resultValue];
                inputValue = 0;
                resultValue = 0;
            }
            storeValue = resultValue;
        }
            break;
            
        default:
        {
            // 数字 -- 小数点后仅限2位
            if([self.mTextNumberField.text containsString:@"."]){
                NSRange ran = [self.mTextNumberField.text rangeOfString:@"."];
                if (self.mTextNumberField.text.length - ran.location <= 2) {
                    NSString *text = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
                    [self.mTextNumberField insertText:text];
                }
            } else {
                NSString *text = [NSString stringWithFormat:@"%ld",sender.tag - 1000];
                [self.mTextNumberField insertText:text];
            }
        }
            break;
    }
}

#pragma mark - UITextFieldDelegate Methods
/** 用户准备填写金额时弹出键盘 */
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self showNumKeyboardViewAnimateWithPrice:self.mTextNumberField.text];
    return YES;
}

/** 清理缓存 */
- (void)clearInput {
    if(self.mTextNumberField.text.length > 0) self.mTextNumberField.text = @"";
    storeValue = 0;
    inputValue = 0;
    resultValue = 0;
    tapCount = 0;
}

@end
