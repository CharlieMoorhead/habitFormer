//
//  DBManager.h
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/3/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

//private
@property (nonatomic,strong) NSString *documentsDirectory;
@property (nonatomic,strong) NSString *databaseFilename;
@property (nonatomic,strong) NSMutableArray *arrResults;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;
-(void)copyDatabaseIntoDocumentsDirectory;
-(void)runQuery:(const char*)query isQueryExecutable:(BOOL)queryExecutable;

//public
@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;

-(NSArray *)loadDataFromDB:(NSString *)query;
-(void)executeQuery:(NSString *)query;

@end
