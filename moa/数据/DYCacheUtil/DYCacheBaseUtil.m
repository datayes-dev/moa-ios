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
//  DYCacheBaseUtil.m
//  DataNote
//
//  Created by songxiaojun on 13/6/9.
//

#import "DYCacheBaseUtil.h"

@implementation DYCacheBaseUtil

#pragma mark - 基本读写方法
//将data存入path路径下
+(BOOL)saveData:(NSData *)data AtPath:(NSString *)path{
    BOOL result = NO;
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        
        [self createDirectoryAtPath:path];
        
        if (![fileMgr fileExistsAtPath:path]) {
            return [fileMgr createFileAtPath:path contents:data attributes:nil];
        } else {
            return [data writeToFile:path atomically:YES];
        }
    }
    @catch (NSException *e) {
        result = NO;
    }
    return result;
}

//读取path路径下data
+(NSData *)loadDataAtPath:(NSString *)path{
    NSData *data = [NSData dataWithContentsOfFile:path];
    return data;
}

//移除path路径
+(BOOL)removeDataAtPath:(NSString *)path{
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    return [fileMgr removeItemAtPath:path error:&error];
}

//将基本对象存入path路径下
+(BOOL)saveData:(id)object DataType:(JMDataTypeEnum)dataType AtPath:(NSString *)path{
    BOOL result = NO;
    @try {
        NSData *tempData = [self returnData:object type:dataType name:path];
        return [self saveData:tempData AtPath:path];
    }
    @catch (NSException *e) {
        result = NO;
    }
    return result;
}

//将基本对象从path路径下取出
+(id)loadDataAtPath:(NSString *)path DataType:(JMDataTypeEnum)dataType{
    id res = nil;
    @try {
        NSData *fileData = [self loadDataAtPath:path];
        if (fileData != nil && [fileData length] > 0) {
            res=[self returnObjectWithData:fileData type:dataType];
        }
    }
    @catch (NSException *e) {
        res = nil;
    }
    return res;
}


//获取filePath所在文件大小
+(long long)getFileSizeAtPath:(NSString *)filePath{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:filePath]){
        return 0;
    }
    long long fileSize=[fileMgr attributesOfItemAtPath:filePath error:nil].fileSize;
    return fileSize;
}

//获取folderPath所在文件夹大小
+(long long)getFolderSizeAtPath:(NSString *)folderPath{
    NSFileManager* fileMgr = [NSFileManager defaultManager];
    if (![fileMgr fileExistsAtPath:folderPath]){
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[fileMgr subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    NSString *filePath;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        filePath=[folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self getFileSizeAtPath:filePath];
    }
    return folderSize;
}

+(NSDictionary *)getAttributesOfItemAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:nil];
    return fileAttributes;
}

#pragma mark - auxiliary，辅助方法


//生产path路径所需的文件夹
+(void)createDirectoryAtPath:(NSString *)path{
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if([fileMgr fileExistsAtPath:path]){
        return;
    }
    else{
        NSString *folderPath=@"";
        NSArray *folderArr = [self splitPath:path withflag:@"/"];
        for(int i=0;i<folderArr.count-1;i++){
            folderPath=[folderPath stringByAppendingPathComponent:[folderArr objectAtIndex:i]];
            if([fileMgr fileExistsAtPath:folderPath]){
                
            }
            else{
                [fileMgr createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
        }
    }
}
// 通过flag分割字符串
+ (NSArray *)splitPath:(NSString *)path withflag:(NSString *)flag{
    NSString *splitPath = nil;
    NSArray *folderArr = [[NSArray alloc] init];
    if (path!=nil||![path isEqual:@""]) {
        splitPath = path;
    } else {
        return nil;
    }
    folderArr = [splitPath componentsSeparatedByString:flag];
    return folderArr;
}

//nsdata转基本对象
+(id)returnObjectWithData:(NSData *)data type:(JMDataTypeEnum)dataType{
    id res = nil;
    switch (dataType) {
        case JMDataTypeEnumData:{//二进制流
            res=data;
        }
            break;
        case JMDataTypeEnumImage:{//图片
            res=[UIImage imageWithData:data];
        }
            break;
        case JMDataTypeEnumString:{//字符串
            res = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
            break;
        default:{//字典,数组,NSobject
            res = [NSKeyedUnarchiver unarchiveObjectWithData:data];//序列化
        }
            break;
    }
    return res;
}

//基本对象转nsdata
+ (NSData *)returnData:(id)object type:(JMDataTypeEnum)dataType name:(NSString *)name {
    NSData *tempData = nil;
    
    switch (dataType) {
        case JMDataTypeEnumData:{//二进制流
            tempData = object;
        }
            break;
        case JMDataTypeEnumImage:{//图片
            if ([self endsWith:name arg:@"png"] || [self endsWith:name arg:@"PNG"]) {
                tempData = UIImagePNGRepresentation(object);
            } else {
                tempData = UIImageJPEGRepresentation(object, 0);
            }
        }
            break;
        case JMDataTypeEnumString:{//字符串
            tempData = [object dataUsingEncoding:NSUTF8StringEncoding];
        }
            break;
        default:{//字典,数组,NSObject
            tempData = [NSKeyedArchiver archivedDataWithRootObject:object];//序列化
        }
            break;
    }
    return tempData;
}

//判断字符串resource是否以arg结尾（用于区分图片类型）
+ (BOOL)endsWith:(NSString *)resource arg:(NSString *)arg {
    if(resource==nil || arg==nil){
        return NO;
    }
    if([arg length]>[resource length]){
        return NO;
    }
    int index = (int)([resource length]-[arg length]);
    NSString *substr = [resource substringFromIndex:index];
    if([arg isEqual:substr]){
        return YES;
    }else{
        return NO;
    }
}




@end
