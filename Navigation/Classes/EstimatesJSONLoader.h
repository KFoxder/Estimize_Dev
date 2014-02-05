//
//  EstimatesJSONLoader.h
//  Estimize_dev
//
//  Created by Richard Fox on 1/31/14.
//  Copyright (c) 2014 Kevin Fox. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EstimatesJSONLoader : NSObject

- (NSArray *)estimatesFromJSONFile:(NSURL *)url;

@end
