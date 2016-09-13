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
//  DYDataSourceError.m
//  IntelligenceResearchReport
//
//  Created by datayes on 16/5/11.
//

#import "DYDataSourceError.h"
#import "DYInterfaceReqeustItem.h"
#import "DYDataSourceBase.h"

static DYDataSourceError* dYDataSourceError;

@interface DYDataSourceError ()

@property (nonatomic, strong)NSMutableArray* mDisuseRequestItemArray;//运维模式请求数组

@end



@implementation DYDataSourceError

#pragma mark - 单例
+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dYDataSourceError = [[DYDataSourceError alloc] init];
        dYDataSourceError.mDisuseRequestItemArray = [[NSMutableArray alloc] init];
        dYDataSourceError.errorState = normalState;
    });
    
    return dYDataSourceError;
}


#pragma mark - 运维模式
//是否已经是运维模式状态
-(BOOL)isDisuseState{
    if(self.errorState==disuseState){
        return YES;
    }
    else{
        return NO;
    }
}

//将因为运维模式不成功的接口参数先保存起来
- (void)addRequestIntoDisuseQueueWithMsgId:(EInterfaceId)msgId
                                parameters:(id)params
                             canUsingCache:(BOOL)usingCacheFlag
                               forceReload:(BOOL)reloadFlag
                               resultBlock:(DYInterfaceResultBlock)resultBlock{
    DYInterfaceReqeustItem* item = [[DYInterfaceReqeustItem alloc] init];
    item.msgId = msgId;
    item.params = params;
    item.usingCacheFlag = usingCacheFlag;
    item.reloadFlag = reloadFlag;
    item.resultBlock = resultBlock;
    
    [self.mDisuseRequestItemArray addObject:item];

}

//恢复因为运维模式不成功需要重发的请求
- (void)resumeAllDisuseRequstWithTarget:(DYDataSourceBase*)target{
    NSUInteger count = [self.mDisuseRequestItemArray count];
    self.errorState = normalState;
    if(target){
        DYDataSourceBase *dYDataSourceBase = (DYDataSourceBase *)target;
        
        for (NSUInteger i = 0 ; i < count ; i ++) {
            DYInterfaceReqeustItem* requestItem = self.mDisuseRequestItemArray[0];
            // 恢复启动时都不加载缓存
            [dYDataSourceBase sendRequestWithMsgId:requestItem.msgId parameters:requestItem.params canUsingCache:NO forceReload:requestItem.reloadFlag resultBlock:requestItem.resultBlock];
            [self.mDisuseRequestItemArray removeObjectAtIndex:0];
        }
    }
}

@end
