//
//  DBManager.m
//  HabitFormer
//
//  Created by Charlie Moorhead on 3/3/15.
//  Copyright (c) 2015 Charlie Moorhead. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename
{
    self = [super init];
    if (self)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        self.databaseFilename = dbFilename;
        
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}

-(void)copyDatabaseIntoDocumentsDirectory
{
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath])
    {
        NSString *sourcePath =
            [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        if (error != nil)
        {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
    sqlite3 *sqlite3Database;
    
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    
    if (self.arrResults != nil)
        {
            [self.arrResults removeAllObjects];
            self.arrResults = nil;
        }
    self.arrResults = [[NSMutableArray alloc] init];
    
    if (self.arrColumnNames != nil)
    {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    if (openDatabaseResult == SQLITE_OK)
    {
        sqlite3_stmt *compiledStatement;
        
        BOOL preparedStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        if (preparedStatementResult == SQLITE_OK)
        {
            if (!queryExecutable)
            {
                //in this case, data must be loaded from the database
                
                NSMutableArray *arrDataRow;
                
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    arrDataRow = [[NSMutableArray alloc] init];
                    
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    for (int i=0; i<totalColumns; i++)
                    {
                        char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        if (dbDataAsChars != NULL)
                        {
                            [arrDataRow addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                        
                        if (self.arrColumnNames.count != totalColumns)
                        {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
                    
                    if (arrDataRow.count > 0)
                    {
                        [self.arrResults addObject:arrDataRow];
                    }
                }
            }
            else //queryExecutable==YES
            {
                //this is the case of an executable query (insert, update, etc)
                
                int executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE)
                {
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
                }
                else
                {//error executing
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
                }
            }
        }
        else
        {//error preparing statement
            NSLog(@"DB Statement Error: %s", sqlite3_errmsg(sqlite3Database));

        }
        
        sqlite3_finalize(compiledStatement);
    }
    else
    {//error opening database
        NSLog(@"DB Open Error: %s", sqlite3_errmsg(sqlite3Database));
    }
    
    sqlite3_close(sqlite3Database);
}

-(NSArray *)loadDataFromDB:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query
{
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
