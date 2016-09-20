//
//  DYMoneyDataSource.h
//  moa
//
//  Created by 鄢彭超 on 16/9/20.
//  Copyright © 2016年 datayes. All rights reserved.
//

#import "DYDataSourceBase.h"

@interface DYMoneyDataSource : DYDataSourceBase

/**
 *	@brief	获取对象实例
 *
 *	@return	返回对象实例
 */
+ (instancetype)shareInstance;

/**
 *	@brief	获取钱包
 *
 *	@param 	resultBlock 	结果回调
 */
- (void)getWalletInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	创建新钱包
 *
 *	@param 	resultBlock 	结果回调
 */
- (void)createNewWalletWithResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	获取钱包详情
 *
 *	@param 	resultBlock 	结果回调
 */
- (void)getWalletDetailInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock;

/**
 *	@brief	获取钱包交易历史
 *
 *	@param 	resultBlock 	结果回调
 */
- (void)getWalletPaymentsInfoWithResultBlock:(DYInterfaceResultBlock)resultBlock;

@end
