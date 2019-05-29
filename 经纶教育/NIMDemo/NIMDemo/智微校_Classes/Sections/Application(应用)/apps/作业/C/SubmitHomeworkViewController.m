//
//  SubmitHomeworkViewController.m
//  TYHxiaoxin
//
//  Created by 大存神 on 16/6/29.
//  Copyright © 2016年 Lanxum. All rights reserved.
//

#import "SubmitHomeworkViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
#import <MJRefresh.h>

#import <AssetsLibrary/AssetsLibrary.h>

#import <MBProgressHUD.h>
#import <UIView+Toast.h>

#import <AFNetworking.h>
#import "HWNetWorkHandler.h"

#define ImageGridWidth [UIScreen mainScreen].bounds.size.width*0.7
#define myCyanColor colorWithRed:54/255.0 green:191/255.0 blue:181/255.0 alpha:1
@interface SubmitHomeworkViewController ()
@property(nonatomic, strong)UILabel *placeHolderLabel;
//获取用户所属班级ID
@property(nonatomic,copy)NSString *departmentID;

@end

@implementation SubmitHomeworkViewController
{
    UIBarButtonItem * rightBtn;
    UIButton *chooseClassBtn;
    NSString *userName;
    NSString *password;
    NSString *organizationID;
    NSString *userID;
}

-(void)getNeedData
{
    userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    password = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3PWD];
    organizationID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    userID = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_V3ID];
}


-(void)viewDidLoad
{
    [super viewDidLoad];
}


@end

