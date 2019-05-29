//
//  WHGoodsDetailListController.m
//  TYHxiaoxin
//
//  Created by 中电和讯 on 17/2/9.
//  Copyright © 2017年 Lanxum. All rights reserved.
//

#import "WHGoodsDetailListController.h"

#import "WHNetHelper.h"
#import "WHGoodsModel.h"

#import <UIView+Toast.h>
#import "LDCalendarView.h"
#import "WHApplicationController.h"
#import "NSString+Empty.h"
#import "WHAddApplicationDiliverController.h"
#import "hexColor.h"

@interface WHGoodsDetailListController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property(nonatomic,retain)NSMutableArray *dataArray;

@end

@implementation WHGoodsDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if ([_goodsID isEqualToString:@"search"]) {
        _isEdited = YES;
    }else{
        _isEdited = NO;
    }
    [self initView];
    [self createBarItem];
    if (![@"search" isEqualToString:_goodsID]) {
        [self dataRequestWithGoodsID:_goodsID GoodsName:@"" ];
    }
}

-(void)setTmpDataArray:(NSMutableArray *)tmpDataArray
{
    if (tmpDataArray.count) {
        _tmpDataArray = [NSMutableArray arrayWithArray:tmpDataArray];
    }else _tmpDataArray = [NSMutableArray array];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dataRequestWithGoodsID
-(void)dataRequestWithGoodsID :(NSString *) goodsID GoodsName:(NSString *) goodName
{
    WHNetHelper *helper = [[WHNetHelper alloc]init];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelFont = [UIFont systemFontOfSize:12];
        hud.labelText = @"正在获取数据";
        [helper getGoodsDetailListWithGoodsID:goodsID GoodsName:goodName andStatus:^(BOOL successful, NSMutableArray *dataSource) {
            _dataArray = [NSMutableArray arrayWithArray:dataSource];
            [_mainTableView reloadData];
            [hud removeFromSuperview];
            
        } failure:^(NSError *error) {
            
            [self.view makeToast:@"获取数据失败" duration:1 position:nil];
            [hud removeFromSuperview];
            
        }];
    
}


#pragma mark - TableViewConfig
-(void)initView
{
    self.title = @"物品详情";
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 60)];
//    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
//    _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 10, self.view.frame.size.width - 30, 30)];
//    _textField.borderStyle = UITextBorderStyleRoundedRect;
//    _textField.delegate = self;
//    _textField.returnKeyType = UIReturnKeySearch;
//    _textField.placeholder = @"请输入物品名称";
//    [self.view addSubview:view];
    
    
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    _mainTableView.tableFooterView = [UIView new];
    _mainTableView.bounces = NO;
    _mainTableView.editing = YES;
    _mainTableView.allowsMultipleSelectionDuringEditing = YES;
   
    
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 290)];
        view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(15, 7.5, self.view.frame.size.width - 30, 30)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.delegate = self;
        _textField.returnKeyType = UIReturnKeySearch;
        _textField.placeholder = @"请输入物品名称";
        if (_isEdited) {
            [_textField becomeFirstResponder];
        }
    
        [view addSubview:_textField];
        return view;
    

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textField resignFirstResponder];
    [self searchBtnClick];
    return YES;
}

-(void)searchBtnClick
{
    NSString *tempStr =  _textField.text ;
    if ([NSString isBlankString:tempStr]) {
        [_textField resignFirstResponder];
        [self.view makeToast:@"请输入有效的物品名称" duration:1.0f position:CSToastPositionCenter];
    }else{
        [self dataRequestWithGoodsID:@"" GoodsName:tempStr];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([_goodsID isEqualToString:@"search"]) {
        
        return 45;
    }
    return 0;
}


#pragma mark - tableview Delegate & DataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *iden1 = @"WHMineListCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden1];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden1];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[_dataArray[indexPath.row] name]];
    cell.textLabel.textColor = [hexColor  colorWithHex:@"576b95"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    
    WHGoodsDetailModel *model = _dataArray[indexPath.row];
    
    
    if (![NSString isBlankString:[_dataArray[indexPath.row] brand]] )  {
        
        if (![NSString isBlankString:model.size]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"品牌:%@ 型号:%@", model.brand,model.size];
        }
        else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"品牌:%@", model.brand];
        }
        
    }else{
        if (![NSString isBlankString:model.size]) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"型号:%@ ", model.size];
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHGoodsDetailModel *model = _dataArray[indexPath.row];
    
    if(![_tmpDataArray containsObject:model])
    {
        
        model.count = [NSString stringWithFormat:@"%d",1]; //默认为1;
        [_tmpDataArray addObject:model];
        
    }
   
//    for (WHGoodsDetailModel *modelInArray in _tmpDataArray) {
//        if (![modelInArray.goodsInfoName isEqualToString:model.name]) {
//            [_tmpDataArray addObject:model];
//        }
//    }
    
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WHGoodsDetailModel *model = _dataArray[indexPath.row];
    if([_tmpDataArray containsObject:model])
    {
        [_tmpDataArray removeObject:model];
    }
    
//    for (WHGoodsDetailModel *modelInArray in _tmpDataArray) {
//        if ([modelInArray.goodsInfoName isEqualToString:model.name]) {
//            [_tmpDataArray removeObject:modelInArray];
//        }
//    }
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}




#pragma mark - Other
-(void)createBarItem
{
    UIBarButtonItem *
    barItemInNavigationBarAppearanceProxy = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    //设置字体为加粗的12号系统字，自己也可以随便设置。
    [barItemInNavigationBarAppearanceProxy
     setTitleTextAttributes:[NSDictionary
                             dictionaryWithObjectsAndKeys:[UIFont
                                                           boldSystemFontOfSize:14], NSFontAttributeName,nil] forState:UIControlStateNormal];
    
    UIBarButtonItem * leftItem = nil;
    UIBarButtonItem * rightItem = nil;
    
    leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"title_bar_back"] style:UIBarButtonItemStyleDone target:self action:@selector(returnClick:)];
    rightItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self
                                               action:@selector(diliverAction:)];
    

    self.navigationItem.leftBarButtonItem =leftItem;
    self.navigationItem.rightBarButtonItem =rightItem;
}

-(void)returnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)diliverAction:(id)sender
{
    UIViewController
    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
    
    if ([takeView isKindOfClass:[WHApplicationController class]]) {
        WHApplicationController *whacView = (WHApplicationController *)takeView;
        whacView.dataArray = [NSMutableArray arrayWithArray:_tmpDataArray];
        [self.navigationController
         popToViewController:whacView animated:true];
    }
    else if([takeView isKindOfClass:[WHAddApplicationDiliverController class]]) {
        WHAddApplicationDiliverController *whacView = (WHAddApplicationDiliverController *)takeView;
        whacView.dataArray = [NSMutableArray arrayWithArray:_tmpDataArray];
        [self.navigationController
         popToViewController:whacView animated:true];
    }
    
//    WHApplicationController
//    *takeView = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-3];
//    takeView.dataArray = [NSMutableArray arrayWithArray:_tmpDataArray];
//    [self.navigationController
//     popToViewController:takeView animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
