//
//  FatSecretManager.h
//  Celery
//
//  Created by Mark Powell on 11/3/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MPOAuth/MPOAuth.h>
#import <MPOAuth/MPURLRequestParameter.h>

@interface FatSecretManager : NSObject {
	MPOAuthAPI* oauthAPI;
}

- (void) authenticateWithServer;
- (void) searchForFoodWithString:(NSString*)searchString forTarget:(id)target forSelector:(SEL)selector pageNumber:(int)page;
- (void) obtainNutritionInformationWithID:(int)foodID forTarget:(id)target forSelector:(SEL)selector;

@end
