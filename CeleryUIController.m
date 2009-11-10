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
	[searching startAnimation:self];
	if(!restManager) {
		restManager = [[FatSecretManager alloc] init];
		[restManager authenticateWithServer];
	}
	
	currentPage = 0;
	maxPages = 0;
	
	[restManager searchForFoodWithString:[inputText stringValue] forTarget:self forSelector:@selector(performedMethodLoadForURL:withResponseBody:) pageNumber:currentPage];
}

- (IBAction) nextPage:(id)sender {
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
	
	[restManager searchForFoodWithString:[inputText stringValue] forTarget:self forSelector:@selector(performedMethodLoadForURL:withResponseBody:) pageNumber:currentPage];
	
}

- (IBAction) prevPage:(id)sender {
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
	
	[restManager searchForFoodWithString:[inputText stringValue] forTarget:self forSelector:@selector(performedMethodLoadForURL:withResponseBody:) pageNumber:currentPage];
}
	 
- (void)performedMethodLoadForURL:(NSURL *)inMethod withResponseBody:(NSString *)inResponseBody {
	id dict = [inResponseBody JSONValue];
	id foodDict = [dict objectForKey:@"foods"];
	int page = [[foodDict objectForKey:@"max_results"] intValue];
	int total = [[foodDict objectForKey:@"total_results"] intValue];
	
	maxPages = total/page;
	
	[countLabel setStringValue:[NSString stringWithFormat:@"%i/%i", currentPage, maxPages]];
	
	NSArray* foods = (NSArray*)[foodDict objectForKey:@"food"];
	
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
	NSString* servDescrip = [serving objectForKey:@"serving_description"];
	NSString* description = [NSString stringWithFormat:@"Name: %@\nServing:%@\nCalories:%@\nFat:%@\nSugar:%@", name, 
							 servDescrip, [serving objectForKey:@"calories"], [serving objectForKey:@"fat"], [serving objectForKey:@"sugar"]];
	
	selectedData.detailedDescription = description;
	[detailView setStringValue:selectedData.detailedDescription];
	[searching stopAnimation:self];
}

- (void)foodSelected:(FoodData *)data {
	[searching startAnimation:self];
	selectedData = data;
	if(!data.detailedDescription) {
		[restManager obtainNutritionInformationWithID:data.foodID forTarget:self forSelector:@selector(performedMethodLoadForURL2:withResponseBody:)];
	} else {
		[detailView setStringValue:selectedData.detailedDescription];
		[searching stopAnimation:self];
	}	
}
	 
@end
