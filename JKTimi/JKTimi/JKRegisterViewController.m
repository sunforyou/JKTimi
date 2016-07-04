//
//  JKRegisterViewController.m
//  JKTimi
//
//  Created by 宋旭 on 16/6/7.
//  Copyright © 2016年 sky. All rights reserved.
//

#import "JKRegisterViewController.h"
#import "SVProgressHUD.h"

@interface JKRegisterViewController()

/** 注册界面基本控件 */
@property (strong, nonatomic) UIView *backgroundBoard;
@property (strong, nonatomic) UITextField *inputAccount;
@property (strong, nonatomic) UITextField *inputPassword;
@property (strong, nonatomic) UILabel *accountLabel;
@property (strong, nonatomic) UILabel *passwordLabel;
@property (strong, nonatomic) UIButton *confirm;

@end

@implementation JKRegisterViewController

#pragma mark - Getters
- (UIView *)backgroundBoard {
    if (!_backgroundBoard) {
        _backgroundBoard = [[UIView alloc] init];
        [_backgroundBoard setBackgroundColor:[UIColor lightGrayColor]];
        [_backgroundBoard.layer setCornerRadius:15];
        [_backgroundBoard setUserInteractionEnabled:YES];
        [_backgroundBoard setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _backgroundBoard;
}

- (UITextField *)inputAccount {
    if (!_inputAccount) {
        _inputAccount = [[UITextField alloc] init];
        _inputAccount.placeholder = @"请输入用户名";
        [_inputAccount setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _inputAccount;
}

- (UITextField *)inputPassword {
    if (!_inputPassword) {
        _inputPassword = [[UITextField alloc] init];
        _inputPassword.placeholder = @"请输入密码";
        [_inputPassword setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _inputPassword;
}

- (UILabel *)accountLabel {
    if (!_accountLabel) {
        _accountLabel = [[UILabel alloc] init];
        _accountLabel.text = @"账号:";
        _accountLabel.contentMode = NSLayoutFormatAlignAllRight;
        [_accountLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _accountLabel;
}

- (UILabel *)passwordLabel {
    if (!_passwordLabel) {
        _passwordLabel = [[UILabel alloc] init];
        _passwordLabel.text = @"密码:";
        _passwordLabel.contentMode = NSLayoutFormatAlignAllRight;
        [_passwordLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    return _passwordLabel;
}

- (UIButton *)confirm {
    if (!_confirm) {
        _confirm = [[UIButton alloc] init];
        [_confirm setTitle:@"注册" forState:UIControlStateNormal];
        [_confirm setTintColor:[UIColor whiteColor]];
        [_confirm setBackgroundColor:[UIColor blueColor]];
        [_confirm.layer setCornerRadius:12];
        [_confirm setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_confirm addTarget:self action:@selector(confirmButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirm;
}

+ (JKRegisterViewController *)generateRegisterVC {
    JKRegisterViewController *registerVC = [[JKRegisterViewController alloc] init];
    [registerVC.view setBackgroundColor:[UIColor clearColor]];
    [registerVC layoutRegisterView];
    
    return registerVC;
}

#pragma mark - Setup RegisterView
/** 注册界面布局 */
- (void)layoutRegisterView {
    //display
    [self.backgroundBoard addSubview:self.confirm];
    [self.backgroundBoard addSubview:self.accountLabel];
    [self.backgroundBoard addSubview:self.passwordLabel];
    [self.backgroundBoard addSubview:self.inputAccount];
    [self.backgroundBoard addSubview:self.inputPassword];
    [self.view addSubview:self.backgroundBoard];
    
    //Layout注册界面所有控件
    [self.backgroundBoard addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[accountLabel(60)]-[inputAccount(200)]-|" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"accountLabel":_accountLabel,@"inputAccount":_inputAccount}]];
    
    [self.backgroundBoard addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[passwordLabel(60)]-[inputPassword(200)]-|" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"passwordLabel":_passwordLabel,@"inputPassword":_inputPassword}]];
    
    [self.backgroundBoard addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[confirm]-|" options:NSLayoutFormatAlignAllBottom | NSLayoutFormatAlignAllTop metrics:nil views:@{@"confirm":_confirm}]];
    
    [self.backgroundBoard addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[accountLabel(35)]-5-[passwordLabel(35)]-5-[confirm(35)]-|" options:0 metrics:nil views:@{@"accountLabel":_accountLabel,@"passwordLabel":_passwordLabel,@"confirm":_confirm}]];
    
    //layout注册界面画板
    NSLayoutConstraint *bgbConstraintX = [NSLayoutConstraint constraintWithItem:_backgroundBoard
                                                                      attribute:NSLayoutAttributeCenterX
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterX
                                                                     multiplier:1.0
                                                                       constant:0.0];
    
    [self.view addConstraint:bgbConstraintX];
    
    NSLayoutConstraint *bgbConstraintY = [NSLayoutConstraint constraintWithItem:_backgroundBoard
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:0
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:0.7
                                                                       constant:0.0];
    
    [self.view addConstraint:bgbConstraintY];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[backgroundBoard]" options:0 metrics:nil views:@{@"backgroundBoard":_backgroundBoard}]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[backgroundBoard]" options:0 metrics:nil views:@{@"backgroundBoard":_backgroundBoard}]];
}

#pragma mark - Button Clicked Handler
/** 确认注册 */
- (void)confirmButtonClicked:(id)sender {
    
    [SVProgressHUD show];
    //0.输入不能为空
    if (self.inputAccount.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.inputAccount.placeholder];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    if (self.inputPassword.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:self.inputPassword.placeholder];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
        return;
    }
    
    //1.确定请求路径
    NSURL *url = JKSERVERURL_REGISTERURL;
    
    //2.创建请求对象
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    //3.请求方法
    request.HTTPMethod = @"POST";
    
    //4.携带参数设置
    NSString *param = [NSString stringWithFormat:@"username=%@&password=%@",self.inputAccount.text,self.inputPassword.text];
    
    NSLog(@"%@",param);
    
    //5.设置请求体
    request.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    [request setValue:@"iOS" forHTTPHeaderField:@"User-Agent"];
    
    //6.异步发送请求
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"请求失败");
        } else {
            //7.解析服务器返回数据
            NSString *res = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //8.弹窗提示操作结果
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([res containsString:@"Success"]) {
                    [SVProgressHUD showSuccessWithStatus:res];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                    //返回登录界面
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:res];
                    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
                }
            });
            NSLog(@"%@---%@",res,[NSThread currentThread]);
        }
    }];
    [task resume];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
