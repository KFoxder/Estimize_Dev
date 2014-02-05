//
//  EstimatesJSONLoader.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "EstimatesJSONLoader.h"
#import "EstimateItem.h"

@implementation EstimatesJSONLoader

- (NSArray *) estimatesFromJSONFile:(NSURL *)url
{
    if(!url){
        NSLog(@"NO URL!");
    }
    // Create a NSURLRequest with the given URL
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                         timeoutInterval:30.0];
	
    // Get the data
    NSURLResponse *response;
	NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    if(!data){
        NSLog(@"No data!");
    }
    // Now create a NSDictionary from the JSON data
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    // Create a new array to hold the locations
    NSMutableArray *estimates = [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [jsonDictionary objectForKey:@"estimates"];
    if(!array){
        NSLog(@"NO ARRAY");
    }
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        EstimateItem *estimate = [[EstimateItem alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [estimates addObject:estimate];
    }
    
    // Return the array of Location objects
    return estimates;
}
@end
