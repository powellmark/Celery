//
//  FoodData.h
//  Celery
//
//  Created by Mark Powell on 11/5/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FoodData : NSObject {
	int foodID;
	NSString* foodName;
	NSString* brandName;
	NSString* shortDescription;
	NSString* detailedDescription;
}

@property (nonatomic, assign) int foodID;
@property (nonatomic, retain) NSString* foodName;
@property (nonatomic, retain) NSString* brandName;
@property (nonatomic, retain) NSString* shortDescription;
@property (nonatomic, retain) NSString* detailedDescription;

@end
