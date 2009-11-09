//
//  TableArrayDelegate.h
//  Celery
//
//  Created by Mark Powell on 11/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodData.h"

@interface TableArrayDelegate : NSObject <NSTableViewDataSource, NSTableViewDelegate> {
	NSMutableArray* dataSource;
	id delegate;
}

@property (nonatomic, retain) id delegate;

- (void) removeAllData;
- (void) addData:(id)data;
- (id) tableView:(NSTableView *) aTableView objectValueForTableColumn:(NSTableColumn *) aTableColumn
			 row:(int) rowIndex;
- (int)numberOfRowsInTableView:(NSTableView *)aTableView;
- (void)tableViewSelectionDidChange:(NSNotification *)notification;

@end



@protocol FoodListening
-(void) foodSelected:(FoodData*)data;
@end
