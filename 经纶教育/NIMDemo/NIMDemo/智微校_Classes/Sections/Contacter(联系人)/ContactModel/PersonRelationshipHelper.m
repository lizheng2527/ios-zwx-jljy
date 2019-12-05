//
//  PersonRelationshipHelper.m
//  TYHxiaoxin
//
//  Created by 大存神 on 15/9/9.
//  Copyright (c) 2015年 Lanxum. All rights reserved.
//

#import "PersonRelationshipHelper.h"
#import "PersonModel.h"
#import <AFNetworking.h>

@implementation PersonRelationshipHelper
- (void)isMybuddyWithSessionID:(NSString *)sessionID andDeal:(void (^)(BOOL, NSMutableArray *))completion
{
    _array = [NSMutableArray array];
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *myVoipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"bd/buddy/isMyBuddy?sys_username=%@%@%@&sys_auto_authenticate=true&sys_password=%@&voipAccount=%@&buddyVoipAccount=%@",userName,@"%2C",organizationId,passWord,myVoipAccount,sessionID]];
        ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    [manager GET:ContactUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            PersonModel *model = [[PersonModel alloc]init];
            model.departmentName = [responseObject objectForKey:@"departmentName"];
            model.isMyBuddy  = [responseObject objectForKey:@"isMyBuddy"];
            model.voipAccount = [responseObject objectForKey:@"voipAccount"];
            model.name = [responseObject objectForKey:@"name"];
            model.headPortraitUrl = [responseObject objectForKey:@"headPortraitUrl"];
            model.mobieNum = [responseObject objectForKey:@"mobileNum"];
            [_array addObject:model];
            completion(YES,_array);
            
        }else{
            completion(NO,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
        
    }];
}

+(BOOL)addBuddyWithSessionID:(NSString *)sessionID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *myVoipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"bd/buddy/addContact?sys_username=%@%@%@&sys_auto_authenticate=true&sys_password=%@&voipAccount=%@&buddyVoipAccount=%@",userName,@"%2C",organizationId,passWord,myVoipAccount,sessionID]];
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:10.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(!error && data && response.statusCode==200)
    {
        return YES;
    }
    else
        return NO;
    
}

+(BOOL)deleteBuddyWithSessionId:(NSString *)sessionID
{
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *myVoipAccount = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_VOIP];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"bd/buddy/deleteContacts?sys_username=%@%@%@&sys_auto_authenticate=true&sys_password=%@&voipAccount=%@&buddyVoipAccounts=%@",userName,@"%2C",organizationId,passWord,myVoipAccount,sessionID]];
    
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:10.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(!error && data && response.statusCode==200)
    {
        return YES;
        
    }
    else
        return NO;
}

-(void)addFriendWithKeyWord:(NSString *)keyWord andDeal:(void(^)(BOOL,NSMutableArray *))completion
{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
//    NSString *myVoipAccount = [DemoGlobalClass sharedInstance].userName;
    
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/bd/user/serachUserWithParam?sys_username=%@%@%@&sys_auto_authenticate=true&sys_password=%@&organizationId=%@&name=%@",userName,@"%2C",organizationId,passWord,organizationId,keyWord]];

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes: [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css", @"text/plain",nil]];
    
    [manager GET:ContactUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        _array = [NSMutableArray array];
        for (NSDictionary *dic in responseObject) {
            PersonModel *model = [[PersonModel alloc]init];
            model.personID =  [dic objectForKey:@"id"];
            model.name = [dic objectForKey:@"name"];
            model.voipAccount = [dic objectForKey:@"voipAccount"];
            model.accId = [dic objectForKey:@"accId"];
            if ([dic objectForKey:@"headPortraitUrl"]) {
                model.headPortraitUrl = [dic objectForKey:@"headPortraitUrl"];
            }
            NSLog(@"%@",model.name);
            [_array addObject:model];
        }
//        NSLog(@"%@",model.name);
        if (_array) {
            completion(YES,_array);
        }
        else
        {
            completion(NO,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

+(BOOL)addPhoneNumWithKey:(NSString *)phoneNum
{
    
    NSString *userName = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_LOGINNAME];
    NSString *passWord = [[NSUserDefaults standardUserDefaults]
                          valueForKey:USER_DEFAULT_PASSWORD];
    NSString *organizationId = [[NSUserDefaults standardUserDefaults]valueForKey:USER_DEFAULT_ORIGANIZATION_ID];
     NSString *loginID = [[NSUserDefaults standardUserDefaults]valueForKey:@"LoginID"];
    
    NSString *ContactUrl = [BaseURL stringByAppendingString:[NSString stringWithFormat:@"/bd/user/updateMobileNum?mobileNum=%@&sys_username=%@%@%@&sys_auto_authenticate=true&userId=%@&sys_password=%@",phoneNum,userName,@"%2C",organizationId,loginID,passWord]];
    NSLog(@"my phone url%@",ContactUrl);
    ContactUrl = [ContactUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest
                                    requestWithURL:[
                                                    NSURL URLWithString:ContactUrl] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    [request setTimeoutInterval:10.0f];
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:&response error:&error];
    
    if(!error && data && response.statusCode==200)
    {
        return YES;
    }
    else
        return NO;
}



@end
