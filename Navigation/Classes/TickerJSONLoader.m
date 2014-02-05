//
//  TickerJSONLoader.m
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import "TickerJSONLoader.h"
#import "TickerItem.h"

@implementation TickerJSONLoader

- (NSArray *)tickersFromJSONFile:(NSURL *)url {
    
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
    NSMutableArray *tickers = [[NSMutableArray alloc] init];
    
    // Get an array of dictionaries with the key "locations"
    NSArray *array = [jsonDictionary objectForKey:@"tickers"];
    if(array.count<5){
        NSLog(@"LEss than 5");
    }
    if(!array){
        NSLog(@"NO ARRAY");
    }
    // Iterate through the array of dictionaries
    for(NSDictionary *dict in array) {
        // Create a new Location object for each one and initialise it with information in the dictionary
        TickerItem *ticker = [[TickerItem alloc] initWithJSONDictionary:dict];
        // Add the Location object to the array
        [tickers addObject:ticker];
    }
    
    // Return the array of Location objects
    return tickers;
}

@end
