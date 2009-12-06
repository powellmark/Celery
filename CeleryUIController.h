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
@interface CeleryUIController : NSObject <FoodListening, NSComboBoxDataSource, NSComboBoxDelegate, NSTextFieldDelegate> {
	IBOutlet NSWindow *myParentWindow;
	IBOutlet NSTableView *displayTable;
	IBOutlet NSTextField *detailView;
	IBOutlet NSTextField *countLabel;
	IBOutlet NSButton *nextButton;
	IBOutlet NSButton *prevButton;
	IBOutlet NSComboBox *servingCombo;
	IBOutlet NSProgressIndicator *searching;
	IBOutlet NSTextField* searchField;
	IBOutlet NSDrawer* infoDrawer;
	IBOutlet NSView* infoView;
	
	IBOutlet NSTextField* servingSizeLabel;
	IBOutlet NSTextField* servingsUnitLabel;
	IBOutlet NSTextField* servingsPerLabel;
	
	IBOutlet NSTextField* caloriesLabel;
	IBOutlet NSTextField* caloriesFromFatLabel;
	IBOutlet NSTextField* totalFatLabel;
	IBOutlet NSTextField* totalFatPercentLabel;
	IBOutlet NSTextField* saturatedFatLabel;
	IBOutlet NSTextField* saturatedFatPercentLabel;
	IBOutlet NSTextField* cholesterolLabel;
	IBOutlet NSTextField* cholesterolPercentLabel;
	IBOutlet NSTextField* sodiumLabel;
	IBOutlet NSTextField* sodiumPercentLabel;
	IBOutlet NSTextField* totalCarbohydrateLabel;
	IBOutlet NSTextField* totalCarbohydratePercentLabel;
	IBOutlet NSTextField* dietaryFiberLabel;
	IBOutlet NSTextField* dietaryFiberPercentLabel;
	IBOutlet NSTextField* sugarsLabel;
	IBOutlet NSTextField* proteinLabel;
	IBOutlet NSTextField* vitaminAPercentLabel;
	IBOutlet NSTextField* vitaminCPercentLabel;
	IBOutlet NSTextField* calciumLabel;
	IBOutlet NSTextField* ironLabel;
	
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
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)itemIndex;
- (void)comboBoxWillPopUp:(NSNotification *)notification;
- (void)comboBoxWillDismiss:(NSNotification *)notification;
- (void)comboBoxSelectionDidChange:(NSNotification *)notification;
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification;

@end
