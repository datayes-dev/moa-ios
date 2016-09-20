/** 
 * 通联数据机密
 * --------------------------------------------------------------------
 * 通联数据股份公司版权所有 © 2013-2016
 * 
 * 注意：本文所载所有信息均属于通联数据股份公司资产。本文所包含的知识和技术概念均属于
 * 通联数据产权，并可能由中国、美国和其他国家专利或申请中的专利所覆盖，并受商业秘密或
 * 版权法保护。
 * 除非事先获得通联数据股份公司书面许可，严禁传播文中信息或复制本材料。
 * 
 * DataYes CONFIDENTIAL
 * --------------------------------------------------------------------
 * Copyright © 2013-2016 DataYes, All Rights Reserved.
 * 
 * NOTICE: All information contained herein is the property of DataYes 
 * Incorporated. The intellectual and technical concepts contained herein are 
 * proprietary to DataYes Incorporated, and may be covered by China, U.S. and 
 * Other Countries Patents, patents in process, and are protected by trade 
 * secret or copyright law. 
 * Dissemination of this information or reproduction of this material is 
 * strictly forbidden unless prior written permission is obtained from DataYes.
 */
//
//  DYLoginUserInfo.m
//  IntelligenceResearchReport
//
//  Created by wangshaiding on 15/9/25.
//

#import "DYLoginUserInfo.h"
#import "DYAppConfigManager.h"

static NSString* const SHORT_FILENAME = @"LoginUserInfo.txt";

static DYLoginUserInfo* _sharedDYLoginUserInfo = nil;

@implementation DYLoginUserInfo


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDYLoginUserInfo = [[DYLoginUserInfo alloc] init];
    });
    
    return _sharedDYLoginUserInfo;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

- (void)parseFromDictionary
{
    if (self.userIdentityInfo != nil && [self.userIdentityInfo isKindOfClass:[NSDictionary class]]) {
        // 获取头像信息
        NSDictionary* userDic = self.userIdentityInfo[@"user"];
        if (userDic != nil && [userDic isKindOfClass:[NSDictionary class]]) {
            NSString* imageId = userDic[@"imageId"];
            if (imageId != nil && [imageId isKindOfClass:[NSString class]]) {
                self.avatar = imageId;
            } else {
                self.avatar = nil;
            }
        }
        // 获取用户名信息
        // 先取personalUser里的信息
        NSDictionary* personalUser = self.userIdentityInfo[@"personalUser"];
        if (personalUser != nil && [personalUser isKindOfClass:[NSDictionary class]]) {
            NSString* nickName = personalUser[@"nickName"];
            
            if (nickName != nil && [nickName isKindOfClass:[NSString class]] && [nickName length] > 0) {
                self.userName = nickName;
            }
            else {
                NSString* givenName = personalUser[@"givenName"];
                NSString* surName = personalUser[@"surName"];
                
                NSMutableString* mString = [NSMutableString string];
                if (surName != nil && [surName isKindOfClass:[NSString class]] && [surName length] > 0) {
                    [mString appendString:surName];
                }
                if (givenName != nil && [givenName isKindOfClass:[NSString class]] && [givenName length] > 0) {
                    [mString appendString:givenName];
                }
                
                if ([mString length] > 0) {
                    self.userName = mString;
                } else {
                    NSString* userName = personalUser[@"userName"];
                    if (userName != nil && [userName isKindOfClass:[NSString class]] && [userName length] > 0) {
                        self.userName = userName;
                    }
                    else {
                        self.userName = nil;
                    }
                }
            }
        }
        
        // 没有的话，再取accounts里的信息
        if (self.userName == nil || [self.userName length] <= 0) {
            NSArray* accountsArray = self.userIdentityInfo[@"accounts"];
            if (accountsArray != nil && [accountsArray isKindOfClass:[NSArray class]] && [accountsArray count] > 0) {
                for (NSDictionary* dic in accountsArray) {
                    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
                        NSNumber* isActive = dic[@"isActive"];
                        if (isActive != nil && [isActive isKindOfClass:[NSNumber class]] && [isActive boolValue] == YES) {
                            NSString* nickName = dic[@"nickName"];
                            
                            if (nickName != nil && [nickName isKindOfClass:[NSString class]] && [nickName length] > 0) {
                                self.userName = nickName;
                            }
                            else {
                                NSString* givenName = dic[@"givenName"];
                                NSString* surName = dic[@"surName"];
                                
                                NSMutableString* mString = [NSMutableString string];
                                if (surName != nil && [surName isKindOfClass:[NSString class]] && [surName length] > 0) {
                                    [mString appendString:surName];
                                }
                                if (givenName != nil && [givenName isKindOfClass:[NSString class]] && [givenName length] > 0) {
                                    [mString appendString:givenName];
                                }
                                
                                if ([mString length] > 0) {
                                    self.userName = mString;
                                } else {
                                    NSString* username = dic[@"username"];
                                    if (username != nil && [username isKindOfClass:[NSString class]] && [username length] > 0) {
                                        self.userName = username;
                                    }
                                    else {
                                        self.userName = @"匿名用户";
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

- (NSURL*)avatarURL {
    if ([self.avatar length] > 0) {
        NSNumber *currentEvn = [DYAppConfigManager shareInstance].currentEnvironment;
        ECurrentEnvType currentEnvType = [currentEvn integerValue];
        
        switch (currentEnvType) {
            case eCurrentEnvTypeProduct:
                return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://static.wmcloud.com/v1/AUTH_datayes/", self.avatar]];
                break;
            
            default:
                return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", @"https://file.wmcloud-stg.com/v1/AUTH_datayes/", self.avatar]];
                break;
        }
    } else {
        return nil;
    }
}

- (BOOL)isBindToEnterpriseAccount
{
    if (self.userIdentityInfo != nil && [self.userIdentityInfo isKindOfClass:[NSDictionary class]]) {
        NSArray* accountArray = self.userIdentityInfo[@"accounts"];
        // 用户默认会有一个wmcloud.com的租户帐号，这个其实是个人帐号，如果还有其他帐号，则认为他绑定了企业帐号
        if ([accountArray isKindOfClass:[NSArray class]] && [accountArray count] > 1) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isEnterpriseAccount
{
    if ([self isBindToEnterpriseAccount]) {
        if (self.userIdentityInfo != nil && [self.userIdentityInfo isKindOfClass:[NSDictionary class]]) {
            NSArray* accountArray = self.userIdentityInfo[@"accounts"];
            if (accountArray != nil && [accountArray isKindOfClass:[NSArray class]] && [accountArray count] > 0) {
                for (NSDictionary* dic in accountArray) {
                    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
                        NSNumber* isActive = dic[@"isActive"];
                        if (isActive != nil && [isActive isKindOfClass:[NSNumber class]] && [isActive boolValue] == YES) {
                            NSString* domain = dic[@"domain"];
                            // wmcloud.com 租户其实是个人帐号的租户，所以如果有一个不是wmcloud.com的租户，那就是企业帐号
                            if (domain != nil && [domain isKindOfClass:[NSString class]] && [domain compare:@"wmcloud.com"] != NSOrderedSame) {
                                return YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    return NO;
}

- (NSString*)principleName
{
    if ([self isBindToEnterpriseAccount]) {
        if (self.userIdentityInfo != nil && [self.userIdentityInfo isKindOfClass:[NSDictionary class]]) {
            NSArray* accountArray = self.userIdentityInfo[@"accounts"];
            if (accountArray != nil && [accountArray isKindOfClass:[NSArray class]] && [accountArray count] > 0) {
                for (NSDictionary* dic in accountArray) {
                    if (dic != nil && [dic isKindOfClass:[NSDictionary class]]) {
                        NSNumber* isActive = dic[@"isActive"];
                        if (isActive != nil && [isActive isKindOfClass:[NSNumber class]] && [isActive boolValue] == YES) {
                            NSString* principalName = dic[@"principalName"];
                            if (principalName != nil && [principalName isKindOfClass:[NSString class]]) {
                                return principalName;
                            }
                        }
                    }
                }
            }
        }
    }
    
    return nil;
}

@end
