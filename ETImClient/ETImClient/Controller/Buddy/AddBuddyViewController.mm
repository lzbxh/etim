//
//  AddBuddyViewController.m
//  ETImClient
//
//  Created by ethan on 8/23/14.
//  Copyright (c) 2014 Pingan. All rights reserved.
//

#import "AddBuddyViewController.h"
#import "TextFieldTableViewCell.h"
#import "ProfileViewController.h"

#include "Client.h"
#include "Singleton.h"
#include "Session.h"
#include "ActionManager.h"

using namespace etim;
using namespace etim::pub;

@interface AddBuddyViewController ()

@end

@implementation AddBuddyViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notiNameFromCmd(CMD_SEARCH_BUDDY) object:nil];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);
    self.title = @"添加好友";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(responseToSearchBuddyResult)
                                                  name:notiNameFromCmd(CMD_SEARCH_BUDDY)
                                                object:nil];
    [self createUI];
}

- (void)createUI {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               RECT_WIDTH(self.view),
                                                               RECT_HEIGHT(self.view))
                                              style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB_TO_UICOLOR(240, 239, 244);
    _tableView.separatorStyle =  UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark -
#pragma mark tableview datasource & delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查找好友";
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AddBuddyCell";
    TextFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[TextFieldTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.textField.placeholder = @"要查找帐号";
        cell.textField.delegate = self;
        cell.textField.returnKeyType = UIReturnKeySearch;
    }
    
    return cell;
}

#pragma mark -
#pragma mark response

- (void)responseToSearchBuddyResult {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    if (sess->GetCmd() == CMD_SEARCH_BUDDY) {
        if (sess->IsError()) {
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"查找结果" description:stdStrToNsStr(sess->GetErrorMsg()) type:TWMessageBarMessageTypeInfo];
        } else {
            ProfileViewController *vc = [[ProfileViewController alloc] initWithUser:sess->GetSearchIMUser()];
            [self.navigationController pushViewController:vc animated:YES];
        }
    } else {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"查找错误" description:@"未知错误" type:TWMessageBarMessageTypeError];
    }

}
#pragma mark -
#pragma mark textfield delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (![textField.text length]) {
        [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"温馨提示" description:@"请输入要查找的帐号" type:TWMessageBarMessageTypeInfo];
        return NO;
    }
    
    [textField resignFirstResponder];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    etim::Session *sess = [[Client sharedInstance] session];
    sess->Clear();
    sess->SetCmd(CMD_SEARCH_BUDDY);
    sess->SetAttribute("name", nsStrToStdStr(textField.text));
    [[Client sharedInstance] doAction:*sess];
    
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