//
//  CeleryUIController.h
//  Celery
//
//  Created by Mark Powell on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FatSecretManager.h"
#import "JSON.h"
#import "TableArrayDelegate.h"
#import "FoodData.h"

//testing git
@interface CeleryUIController : NSObject <FoodListening, NSComboBoxDataSource, NSComboBoxDelegate> {

	IBOutlet NSTextField *inputText;
	IBOutlet NSTableView *displayTable;
	IBOutlet NSTextField *detailView;
	IBOutlet NSButton *addButton;
	IBOutlet NSTextField *countLabel;
	IBOutlet NSButton *nextButton;
	IBOutlet NSButton *prevButton;
	IBOutlet NSComboBox *servingCombo;
	IBOutlet NSProgressIndicator *searching;
	
	FatSecretManager* restManager;
	
	TableArrayDelegate* foodData;
	
	FoodData * selectedData;
	
	int currentPage;
	int maxPages;
	
	BOOL updating;
}

- (IBAction)searchForFood:(id)sender;
- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody;
- (void)performedMethodLoadForURL2:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody;
- (IBAction) nextPage:(id)sender;
- (IBAction) prevPage:(id)sender;
- (void) foodSelected:(FoodData *)data;
- (void) displayDetailForServing:(NSDictionary*) serving forFoodNamed:(NSString*) name;
- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox;
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index;
- (void)comboBoxWillPopUp:(NSNotification *)notification;
- (void)comboBoxWillDismiss:(NSNotification *)notification;
- (void)comboBoxSelectionDidChange:(NSNotification *)notification;
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification;

@end
