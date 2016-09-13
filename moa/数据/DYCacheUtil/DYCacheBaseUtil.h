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
//  DYCacheBaseUtil.h
//  DataNote
//
//  Created by songxiaojun on 13/6/9.
//

#import <Foundation/Foundation.h>

typedef enum {
    JMDataTypeEnumData  = 0,         //NSData
    JMDataTypeEnumImage  = 1,        //UIImage
    JMDataTypeEnumString  = 2,       //NSString
    JMDataTypeEnumDictionary  = 3,   //NSDictionary
    JMDataTypeEnumArray  = 4,        //NSArray
    JMDataTypeEnumObject  = 5,       //NSObject
} JMDataTypeEnum;//可缓存的基本类型

@interface DYCacheBaseUtil : NSObject

// 将data存入path路径下
+(BOOL)saveData:(NSData *)data AtPath:(NSString *)path;

// 读取path路径下data
+(NSData *)loadDataAtPath:(NSString *)path;

// 移除path路径
+(BOOL)removeDataAtPath:(NSString *)path;

// 将基本对象存入path路径下
+(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType AtPath:(NSString *)path;

// 将基本对象存从path路径下取出
+(id)loadDataAtPath:(NSString *)path DataType:(JMDataTypeEnum)dataType;

// 获取filePath所在文件大小
+(long long)getFileSizeAtPath:(NSString *)filePath;

// 获取folderPath所在文件夹大小
+(long long)getFolderSizeAtPath:(NSString *)folderPath;

// 获取path所在文件的属性（创建日期，大小等）
+(NSDictionary *)getAttributesOfItemAtPath:(NSString *)path;

@end
