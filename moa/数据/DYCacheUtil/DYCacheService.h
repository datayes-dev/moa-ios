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
//  DYCacheService.h
//  IntelligenceResearchReport
//
//  Created by datayes on 16/8/9.
//  文件存储管理类
/*  文件夹目录结构
 Documents|cache  |common |net    |
          |       |       |device |
          |       |user   |id1    |
          |       |       |id2    |
          |file   |
*/

#import "DYCacheBaseUtil.h"
#import "DYCacheKeys.h"

//存,取默认路径，要求数据格式为NSData
#define saveToCache(key,object)   [[DYCacheService shareInstance] saveData:object DataType:JMDataTypeEnumData FolderPath:dyCacheDevice UserId:nil FileName:key IsNational:NO];

#define loadFromCache(key)        [[DYCacheService shareInstance] loadDataWithDataType:JMDataTypeEnumData FolderPath:dyCacheDevice UserId:nil FileName:key IsNational:NO];


//存,取Cache/Net路径，要求数据格式为NSData
#define saveToCacheNet(key,object)   [[DYCacheService shareInstance] saveData:object DataType:JMDataTypeEnumData FolderPath:dyCacheNet UserId:nil FileName:key IsNational:NO];

#define loadFromCacheNet(key)        [[DYCacheService shareInstance] loadDataWithDataType:JMDataTypeEnumData FolderPath:dyCacheNet UserId:nil FileName:key IsNational:NO];


//-------------------------------------------------------------
//存，取默认路径数据返回指定类型
//@param dataType   数据类型(JMDataTypeEnum)
#define saveToCacheWithType(key,object,dataType)   [[DYCacheService shareInstance] saveData:object DataType:dataType FolderPath:dyCacheDevice UserId:nil FileName:key IsNational:NO];


#define loadFromCacheWithType(key,dataType)        [[DYCacheService shareInstance] loadDataWithDataType:dataType FolderPath:dyCacheDevice UserId:nil FileName:key IsNational:NO];


//-------------------------------------------------------------
/**
 * 将基本对象存入指定文件
 *
 * @param object       数据
 * @param dataType     数据类型(JMDataTypeEnum)
 * @param folderPath   文件夹类型(DYCacheFolder)
 * @param userId       和用户相关则需要userId
 * @param key          文件名
 * @param isNational   是否支持国际化
 *
 * @return 将基本对象存入指定文件成功（失败）
 */
#define saveToCacheWithParams(key,object,dataType,folderPath,userId,isNational)   [[DYCacheService shareInstance] saveData:object DataType:dataType FolderPath:folderPath UserId:userId FileName:key IsNational:isNational];
/**
 * 将基本对象从指定文件取出
 *
 * @param dataType     数据类型(JMDataTypeEnum)
 * @param folderPath   文件夹类型(DYCacheFolder)
 * @param userId       和用户相关则需要userId
 * @param key          文件名
 * @param isNational   是否支持国际化
 *
 * @return 指定类型的数据
 */
#define loadFromCacheWithParams(key,dataType,folderPath,userId,isNational)        [[DYCacheService shareInstance] loadDataWithDataType:dataType FolderPath:folderPath UserId:userId FileName:key IsNational:isNational];





typedef enum //文件夹类型
{
    dyCacheNet =0,       // 网络
    dyCacheDevice = 1,   // 设备
    dyCacheUser = 2,     // 用户
    dyFile=3,            // 不可删文件夹
}DYCacheFolder;



@interface DYCacheService : NSObject

+ (DYCacheService *)shareInstance;



/**
 * 返回文件夹路径
 *
 * @param cacheFolder  文件夹类型
 * @param userId       和用户相关则需要userId
 *
 * @return 返回文件夹路径，默认路径为dyCacheDevice，如果选择用户文件夹，存在默认用户文件夹
 */
-(NSString *)getFolder:(DYCacheFolder)cacheFolder AndUserId:(NSString *)userId;



/**
 * 返回文件路径
 *
 * @param cacheFolder  文件夹类型
 * @param userId       和用户相关则需要userId
 * @param fileName     文件名
 * @param national     是否支持国际化
 *
 * @return 返回文件路径
 */
-(NSString *)getFilePath:(DYCacheFolder)cacheFolder AndUserId:(NSString *)userId FileName:(NSString *)fileName IsNational:(BOOL)national;

// 将基本对象存入path路径下
-(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType AtPath:(NSString *)path;

// 将基本对象存从path路径下取出
-(id)loadDataAtPath:(NSString *)path DataType:(JMDataTypeEnum)dataType;

// 移除path路径
-(BOOL)removeDataAtPath:(NSString *)path;

// 获取filePath所在文件大小
-(long long)getFileSizeAtPath:(NSString *)filePath;

// 获取folderPath所在文件夹大小
-(long long)getFolderSizeAtPath:(NSString *)folderPath;

// 获取path所在文件的属性（创建日期，大小等）
-(NSDictionary *)getAttributesOfItemAtPath:(NSString *)path;




/**
 * 将基本对象存入指定文件
 *
 * @param object       数据
 * @param dataType     数据类型(JMDataTypeEnum)
 * @param cacheFolder  文件夹类型(DYCacheFolder)
 * @param userId       和用户相关则需要userId
 * @param fileName     文件名
 * @param national     是否支持国际化
 *
 * @return 将基本对象存入指定文件成功（失败）
 */
-(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType FolderPath:(DYCacheFolder)cacheFolder UserId:(NSString *)userId FileName:(NSString *)fileName IsNational:(BOOL)national;

/**
 * 将基本对象从指定文件取出
 *
 * @param dataType     数据类型(JMDataTypeEnum)
 * @param cacheFolder  文件夹类型(DYCacheFolder)
 * @param userId       和用户相关则需要userId
 * @param fileName     文件名
 * @param national     是否支持国际化
 *
 * @return 指定类型的数据
 */
-(id)loadDataWithDataType:(JMDataTypeEnum)dataType FolderPath:(DYCacheFolder)cacheFolder UserId:(NSString *)userId FileName:(NSString *)fileName IsNational:(BOOL)national;



@end
