//
//  FatSecretManager.m
//  Celery
//
//  Created by Mark Powell on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "FatSecretManager.h"


@implementation FatSecretManager

- (void) authenticateWithServer {
	if (!oauthAPI) {
		NSDictionary *credentials = [NSDictionary dictionaryWithObjectsAndKeys:	@"c8d3538d8175406888b8d6a78ab0f3eb", kMPOAuthCredentialConsumerKey,
									 @"3c05b077c9e1435d96cb74deafa75a01", kMPOAuthCredentialConsumerSecret,
									 nil];
		oauthAPI = [[MPOAuthAPI alloc] initWithCredentials:credentials
										  authenticationURL:[NSURL URLWithString:@""]
												 andBaseURL:[NSURL URLWithString:@"http://platform.fatsecret.com/rest/server.api"]];		
	} else {
		[oauthAPI authenticate];
	}
}

- (void) searchForFoodWithString:(NSString*)searchString forTarget:(id)target forSelector:(SEL)selector pageNumber:(int)page {
	MPURLRequestParameter *parameter1 = [[MPURLRequestParameter alloc] init];
	parameter1.name = @"method";
	parameter1.value = @"foods.search";
	
	MPURLRequestParameter *parameter2 = [[MPURLRequestParameter alloc] init];
	parameter2.name = @"search_expression";
	parameter2.value = searchString;
	
	MPURLRequestParameter *parameter3 = [[MPURLRequestParameter alloc] init];
	parameter3.name = @"page_number";
	parameter3.value = [NSString stringWithFormat:@"%d", page];
	
	
	MPURLRequestParameter *parameter4 = [[MPURLRequestParameter alloc] init];
	parameter4.name = @"format";
	parameter4.value = @"json";
	
	
	NSMutableArray *params = [NSMutableArray arrayWithObjects:parameter1, parameter2, parameter3, parameter4, nil];
	[oauthAPI performMethod:@"server.api" atURL:oauthAPI.baseURL withParameters:params 
				  withTarget:target andAction:selector];
	
	[parameter1 release];
	[parameter2 release];
	[parameter3 release];
	[parameter4 release];
}

- (void) obtainNutritionInformationWithID:(int)foodID forTarget:(id)target forSelector:(SEL)selector {
	
	MPURLRequestParameter *parameter1 = [[MPURLRequestParameter alloc] init];
	parameter1.name = @"method";
	parameter1.value = @"food.get";
	
	MPURLRequestParameter *parameter2 = [[MPURLRequestParameter alloc] init];
	parameter2.name = @"food_id";
	parameter2.value = [NSString stringWithFormat:@"%d",foodID];
	
	MPURLRequestParameter *parameter3 = [[MPURLRequestParameter alloc] init];
	parameter3.name = @"format";
	parameter3.value = @"json";
	
	
	NSMutableArray *params = [NSMutableArray arrayWithObjects:parameter1, parameter2, parameter3, nil];
	[oauthAPI performMethod:@"server.api" atURL:oauthAPI.baseURL withParameters:params 
				 withTarget:target andAction:selector];
	
	[parameter1 release];
	[parameter2 release];
	[parameter3 release];
	
}

@end
