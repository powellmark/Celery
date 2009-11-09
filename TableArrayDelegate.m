//
//  TableArrayDelegate.m
//  Celery
//
//  Created by Mark Powell on 11/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//



//
//  TableArrayDelegate.h
//  Celery
//
//  Created by Mark Powell on 11/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableArrayDelegate.h"

@implementation TableArrayDelegate

@synthesize delegate;

- (id) init {
    if (self = [super init]) {
		dataSource = [[NSMutableArray alloc] init];
	}
    return self;
}
// just returns the item for the right row
- (id) tableView:(NSTableView *) aTableView objectValueForTableColumn:(NSTableColumn *) aTableColumn
				 row:(int) rowIndex {  
	
	FoodData* data = [dataSource objectAtIndex:rowIndex];
	if([[aTableColumn identifier] isEqualToString:@"Name"]) {
		return data.foodName;
	} else if([[aTableColumn identifier] isEqualToString:@"Brand"]) {
		return data.brandName;
	} else if([[aTableColumn identifier] isEqualToString:@"Description"]) {
		return data.shortDescription;
	}
	
	return nil;  
}

// just returns the number of items we have.
- (int)numberOfRowsInTableView:(NSTableView *)aTableView {
	return [dataSource count];  
}
- (void) removeAllData {
	[dataSource removeAllObjects];
}
- (void) addData:(FoodData*)data {
	
	[dataSource addObject:data];
}
- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSTableView *view = [notification object];
	FoodData* data = [dataSource objectAtIndex:[view selectedRow]];
	
	if([delegate conformsToProtocol:@protocol(FoodListening)]) {
		[delegate foodSelected:data];
	}
}
@end

