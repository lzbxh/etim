//
//  LoginViewController.m
//  ETImClient
//
//  Created by Ethan on 14/7/31.
//  Copyright (c) 2014年 Pingan. All rights reserved.
//

#import "LoginViewController.h"
#import "RegViewController.h"
#import "LeeScrollView.h"
#import "BaseTabBarViewController.h"
#import "AppDelegate.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;


@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)init {
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)createUI {
    [self createDefaultBg];
    
    LeeScrollView *scrollView = [[LeeScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    _iconImgView = [[UIImageView alloc] init];
    _iconImgView.frame = CGRectMake((RECT_WIDTH(self.view) - 68)/2.0f, 40, 68, 68);
    _iconImgView.backgroundColor = [UIColor colorWithPatternImage:IMAGE_PNG(@"login_avatar")];
    _iconImgView.image = IMAGE_PNG(@"login_avatar_default");
    _iconImgView.layer.cornerRadius = 5.0f;
    _iconImgView.layer.masksToBounds = YES;
    [scrollView addSubview:_iconImgView];
    
    
    UIImageView *textBg = [[UIImageView alloc] initWithFrame:CGRectMake((RECT_WIDTH(self.view) - 302)/2.0f, RECT_MAX_Y(_iconImgView) + 20, 302, 90)];
    textBg.image = IMAGE_PNG(@"login_textfield");
    [scrollView addSubview:textBg];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(RECT_ORIGIN_X(textBg) + 5, RECT_ORIGIN_Y(textBg) + 4, RECT_WIDTH(textBg) - 10, 45)];
    _nameTextField.placeholder = @"用户名";
    _nameTextField.backgroundColor = [UIColor clearColor];
    _nameTextField.returnKeyType = UIReturnKeyNext;
    _nameTextField.delegate = self;
    [scrollView addSubview:_nameTextField];
    
    _pwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(RECT_ORIGIN_X(_nameTextField), RECT_MAX_Y(_nameTextField), RECT_WIDTH(_nameTextField), RECT_HEIGHT(_nameTextField))];
    _pwdTextField.placeholder = @"密码";
    _pwdTextField.backgroundColor = [UIColor clearColor];
    _pwdTextField.returnKeyType = UIReturnKeyGo;
    _pwdTextField.delegate = self;
    [scrollView addSubview:_pwdTextField];
    
    _loginBtn = [[UIButton alloc] initWithFrame:CGRectMake((RECT_WIDTH(self.view) - 290)/2.0f, RECT_MAX_Y(_pwdTextField) + 20, 290, 44)];
    [_loginBtn setBackgroundImage:IMAGE_PNG(@"login_btn_blue_nor") forState:UIControlStateNormal];
    [_loginBtn setBackgroundImage:IMAGE_PNG(@"login_btn_blue_press") forState:UIControlStateHighlighted];
    [_loginBtn setBackgroundImage:IMAGE_PNG(@"login_btn_blue_press") forState:UIControlStateSelected];
    [_loginBtn addTarget:self action:@selector(responseToLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [scrollView addSubview:_loginBtn];
    
    _regBtn = [[UIButton alloc] initWithFrame:CGRectMake(RECT_WIDTH(self.view) - 100, RECT_HEIGHT(self.view) - 50, 80, 44)];
    [_regBtn setTitle:@"--注册--" forState:UIControlStateNormal];
    [_regBtn addTarget:self action:@selector(responseToRegBtn:) forControlEvents:UIControlEventTouchUpInside];

    [scrollView addSubview:_regBtn];
}


#pragma mark -
#pragma mark response

- (void)responseToLoginBtn:(UIButton *)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        Session *sess = Singleton<Client>::Instance().GetSession();
		sess->Clear();
		sess->SetCmd(CMD_LOGIN);
		sess->SetAttribute("name", "admin");
		sess->SetAttribute("pass", "admin");
        Singleton<ActionManager>::Instance().DoAction(*sess);
    });
}

- (void)responseToRegBtn:(UIButton *)sender {
    RegViewController *vc = [[RegViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
#pragma mark textfield delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == _nameTextField) {
        [_pwdTextField becomeFirstResponder];
    } else {
        [_pwdTextField resignFirstResponder];
        //TODO login
        BaseTabBarViewController *tabbar = [[BaseTabBarViewController alloc] init];
        [[[UIApplication sharedApplication] keyWindow] setRootViewController:tabbar];
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end