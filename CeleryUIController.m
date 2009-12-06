//
//  CeleryUIController.m
//  Celery
//
//  Created by Mark Powell on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "CeleryUIController.h"


@implementation CeleryUIController

- (IBAction)searchForFood:(id)sender {
	if(!updating) {
		updating = YES;
		[searching startAnimation:self];
		if(!restManager) {
			restManager = [[FatSecretManager alloc] init];
			[restManager authenticateWithServer];
			[servingCombo setDataSource:self];
			[servingCombo setDelegate:self];
		}
	
		currentPage = 0;
		maxPages = 0;
	
		[restManager searchForFoodWithString:[searchField stringValue] forTarget:self forSelector:@selector(performedMethodLoadForURL:withResponseBody:) pageNumber:currentPage];
	}
}

- (IBAction) nextPage:(id)sender {
	if(!updating) {
		updating = YES;
	
		[searching startAnimation:self];
		if(!restManager) {
			restManager = [[FatSecretManager alloc] init];
			[restManager authenticateWithServer];
		}
	
		if(![prevButton isEnabled]) {
			[prevButton setEnabled:YES];
		}
	
		currentPage++;
		if(currentPage == maxPages) {
			[nextButton setEnabled:NO];
		} 
	
		[restManager searchForFoodWithString:[searchField stringValue] forTarget:self forSelector:@selector(performedMethodLoadForURL:withResponseBody:) pageNumber:currentPage];
	}
	
}

- (IBAction) prevPage:(id)sender {
	if(!updating) {
		updating = YES;
		[searching startAnimation:self];
		if(!restManager) {
			restManager = [[FatSecretManager alloc] init];
			[restManager authenticateWithServer];
		}
	
		if(![nextButton isEnabled]) {
			[nextButton setEnabled:YES];
		}
	
		currentPage--;
		if(currentPage == 0) {
			[prevButton setEnabled:NO];
		} 
	
		[restManager searchForFoodWithString:[searchField stringValue] forTarget:self forSelector:@selector(performedMethodLoadForURL:withResponseBody:) pageNumber:currentPage];
	}
}
	 
- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody {
	id dict = [inResponseBody JSONValue];
	id foodDict = [dict objectForKey:@"foods"];
	int page = [[foodDict objectForKey:@"max_results"] intValue];
	int total = [[foodDict objectForKey:@"total_results"] intValue];
	
	maxPages = total/page;
	
	[countLabel setStringValue:[NSString stringWithFormat:@"%i/%i", currentPage, maxPages]];
	
	id tempFoods = [foodDict objectForKey:@"food"];
	NSArray* foods = nil;
	if([tempFoods isKindOfClass:[NSDictionary class]]) {
		foods = [[[NSArray alloc] initWithObjects:tempFoods,nil] autorelease];
	} else {
		foods = (NSArray*)tempFoods;
	}
	
	if(!foodData) {
		foodData = [[TableArrayDelegate alloc] init];
		foodData.delegate = self;
		[displayTable setDataSource:foodData];
		[displayTable setDelegate:foodData];
	}
	
	[foodData removeAllData];
	
	for(NSDictionary* foodInfo in foods) {
		FoodData* foodItem = [[FoodData alloc] init];
		
		foodItem.foodName = (NSString*)[foodInfo objectForKey:@"food_name"];
		foodItem.foodID = [[foodInfo objectForKey:@"food_id"] intValue];
		foodItem.brandName = (NSString*)[foodInfo objectForKey:@"brand_name"];
		foodItem.shortDescription = (NSString*)[foodInfo objectForKey:@"food_description"];
		
		[foodData addData:foodItem];
		
		[foodItem release];
	}
	
	[displayTable reloadData];
	[searching stopAnimation:self];
	updating = NO;
}

- (void)performedMethodLoadForURL2:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody {
	
	NSDictionary* dict = (NSDictionary*)[[inResponseBody JSONValue] objectForKey:@"food"];
	NSDictionary* servings = [dict objectForKey:@"servings"];
	id tempServing = [servings objectForKey:@"serving"];
	
	NSArray* servingList = nil;
	if([tempServing isKindOfClass:[NSDictionary class]]) {
		servingList = [[NSArray alloc] initWithObjects:tempServing,nil];
	} else {
		servingList = (NSArray*)tempServing;
	}
	
	
	
	NSDictionary* serving = [servingList objectAtIndex:0];
	NSString* name = [dict objectForKey:@"food_name"];
	[self displayDetailForServing:serving forFoodNamed:name];
	
	selectedData.detailedDescription = servingList;
	
	[searching stopAnimation:self];
	updating = NO;
}

- (void) displayDetailForServing:(NSDictionary*) serving forFoodNamed:(NSString*) name {
	[servingSizeLabel setStringValue:[serving objectForKey:@"serving_description"]];
	[servingsPerLabel setStringValue:[serving objectForKey:@"number_of_units"]];
	
	NSString* calories = [serving objectForKey:@"calories"];
	if(calories) {
		[caloriesLabel setStringValue:calories];
	} else {
		[caloriesLabel setStringValue:@"0"];
	}
	
	NSString* carbohydrate = [serving objectForKey:@"carbohydrate"];
	if(carbohydrate) {
		[totalCarbohydrateLabel setStringValue:[carbohydrate  stringByAppendingString:@"g"]];
		double carbValue = [carbohydrate doubleValue];
		int percent = (int)((carbValue / 300.0f) * 100);
		[totalCarbohydratePercentLabel setStringValue:[NSString stringWithFormat:@"%i%%", percent]];

	} else {
		[totalCarbohydrateLabel setStringValue:@"0g"];
		[totalCarbohydratePercentLabel setStringValue:@"0%"];
	}
	
	[proteinLabel setStringValue:[[serving objectForKey:@"protein"]  stringByAppendingString:@"g"]];
	
	NSString* fat = [serving objectForKey:@"fat"];
	if(fat) {
		[totalFatLabel setStringValue:[fat stringByAppendingString:@"g"]];
		double fatValue = [fat doubleValue];
		double caloriesFromFat = fatValue * 9;
		int percent = (int)((fatValue / 65.0f) * 100);
		[caloriesFromFatLabel setStringValue:[NSString stringWithFormat:@"%4.2f",caloriesFromFat]];
		[totalFatPercentLabel setStringValue:[NSString stringWithFormat:@"%i%%", percent]];
	} else {
		[totalFatLabel setStringValue:@"0g"];
		[caloriesFromFatLabel setStringValue:@"0"];
		[totalFatPercentLabel setStringValue:@"0%"];
	}
	NSString* saturatedFat = [serving objectForKey:@"saturated_fat"];
	if(saturatedFat) {
		double satFatValue = [saturatedFat doubleValue];
		int percent = (int)((satFatValue / 20.0f) * 100);
		
		[saturatedFatLabel setStringValue:[saturatedFat stringByAppendingString:@"g"]];
		[saturatedFatPercentLabel setStringValue:[NSString stringWithFormat:@"%i%%", percent]];
	} else {
		[saturatedFatLabel setStringValue:@"0g"];
		[saturatedFatPercentLabel setStringValue:@"0%"];
	}
		 
	NSString* cholesterol = [serving objectForKey:@"cholesterol"];
	if(cholesterol) {
		[cholesterolLabel setStringValue:[cholesterol stringByAppendingString:@"mg"]];
		double cholValue = [cholesterol doubleValue];
		int percent = (int)((cholValue / 300.0f) * 100);
		[cholesterolPercentLabel setStringValue:[NSString stringWithFormat:@"%i%%", percent]];

	} else {
		[cholesterolLabel setStringValue:@"0mg"];
		[cholesterolPercentLabel setStringValue:@"0%"];
	}
	
	NSString* sodium = [serving objectForKey:@"sodium"];
	if(sodium) {
		[sodiumLabel setStringValue:[sodium stringByAppendingString:@"mg"]];
		double sodiumValue = [sodium doubleValue];
		int percent = (int)((sodiumValue / 2400.0f) * 100);
		[sodiumPercentLabel setStringValue:[NSString stringWithFormat:@"%i%%", percent]];
	} else {
		[sodiumLabel setStringValue:@"0mg"];
		[sodiumPercentLabel setStringValue:@"0%"];
	}
	
	NSString* dietaryFiber = [serving objectForKey:@"fiber"];
	if(dietaryFiber) {
		[dietaryFiberLabel setStringValue:[dietaryFiber stringByAppendingString:@"g"]];
		double fiberValue = [dietaryFiber doubleValue];
		int percent = (int)((fiberValue / 25.0f) * 100);
		[dietaryFiberPercentLabel setStringValue:[NSString stringWithFormat:@"%i%%", percent]];
	} else {
		[dietaryFiberLabel setStringValue:@"0g"];
		[dietaryFiberPercentLabel setStringValue:@"0%"];
		
	}
	[sugarsLabel setStringValue:[[serving objectForKey:@"sugar"] stringByAppendingString:@"g"]];
	
	
	NSString* vitaminAPercent = [serving objectForKey:@"vitamin_a"];
	if(!vitaminAPercent) {
		vitaminAPercent = @"0";
	}
	[vitaminAPercentLabel setStringValue:[vitaminAPercent stringByAppendingString:@"%"]];
	NSString* vitaminCPercent = [serving objectForKey:@"vitamin_c"];
	if(!vitaminCPercent) {
		vitaminCPercent = @"0%";
	}
	[vitaminCPercentLabel setStringValue:[vitaminCPercent stringByAppendingString:@"%"]];
	
	NSString* calcium = [serving objectForKey:@"calcium"];
	if(!calcium) {
		calcium = @"0";
	}
	[calciumLabel setStringValue:[calcium stringByAppendingString:@"%"]];
	
	NSString* iron = [serving objectForKey:@"iron"];
	if(!iron) {
		iron = @"0";
	}
	[ironLabel setStringValue:[iron stringByAppendingString:@"%"]];
	 
}

- (void)foodSelected:(FoodData *)data {
	if (!updating) {
		
		updating = YES;
		
		[searching startAnimation:self];
		
		selectedData = data;
		if(!data.detailedDescription) {
			[restManager obtainNutritionInformationWithID:data.foodID forTarget:self forSelector:@selector(performedMethodLoadForURL2:withResponseBody:)];
		} else {
			NSDictionary* serving = [selectedData.detailedDescription objectAtIndex:0];
			[self displayDetailForServing:serving forFoodNamed:data.foodName];
			[searching stopAnimation:self];
			updating = NO;
		}
		
		updating = YES;
		[searching startAnimation:self];
		
		if(!infoDrawer) {
			
			NSSize contentSize = NSMakeSize(300, 100);
			infoDrawer = [[NSDrawer alloc] initWithContentSize:contentSize preferredEdge:NSMaxXEdge];
			[infoDrawer setParentWindow:myParentWindow];
			[infoDrawer setMinContentSize:contentSize];
			[infoDrawer setContentView:infoView];
		}
		NSDrawerState state = [infoDrawer state];
		if (NSDrawerOpeningState == state || NSDrawerOpenState == state) {
			//[infoDrawer close];
		} else {
			[infoDrawer openOnEdge:NSMaxXEdge];
		}
		
		updating = NO;
    }
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
	
	return [selectedData.detailedDescription count];
}
- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)itemIndex {
	NSDictionary * data = [selectedData.detailedDescription objectAtIndex:itemIndex];
	return [data objectForKey:@"serving_description"];
}

- (void)comboBoxWillPopUp:(NSNotification *)notification {
	
}
- (void)comboBoxWillDismiss:(NSNotification *)notification {
	
}
- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
	NSComboBox* box = (NSComboBox*)[notification object];
	int selectionIndex = [box indexOfSelectedItem];

	NSDictionary* serving = [selectedData.detailedDescription objectAtIndex:selectionIndex];
	[self displayDetailForServing:serving forFoodNamed:selectedData.foodName];
	
}
- (void)comboBoxSelectionIsChanging:(NSNotification *)notification {
	
}	 
- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
	
	[self searchForFood:self];
	return YES;
}
@end
