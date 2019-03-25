//
//  WhatsNewServiceImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 3/21/19.
//  Copyright © 2019 MyEtherWallet, Inc. All rights reserved.
//

#import "WhatsNewServiceImplementation.h"

#import "KeychainService.h"

#import "NSBundle+Version.h"

static NSString *const kWhatsNewServiceChangeLogFilename = @"CHANGELOG";
static NSString *const kWhatsNewServiceChangeLogExtension = @"md";
static NSString *const kWhatsNewServiceReleaseHeader = @"### Release ";

@interface WhatsNewServiceImplementation ()
@property (nonatomic, strong) NSString *whatsNew;
@end

@implementation WhatsNewServiceImplementation

- (instancetype) initWithFileManager:(NSFileManager *)fileManager {
  self = [super init];
  if (self) {
    NSString *applicationVersion = [[NSBundle mainBundle] applicationVersion];
    self.fileManager = fileManager;
    NSString *path = [[NSBundle mainBundle] pathForResource:kWhatsNewServiceChangeLogFilename ofType:kWhatsNewServiceChangeLogExtension];
    NSString *changelog = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray <NSString *> *versionDescriptions = [changelog componentsSeparatedByString:kWhatsNewServiceReleaseHeader];
    for (NSString *versionDescription in versionDescriptions) {
      NSArray *components = [versionDescription componentsSeparatedByString:@"\n"];
      if ([components count] == 0) {
        continue;
      }
      NSString *version = [components firstObject];
      if ([version isEqualToString:applicationVersion]) {
        NSMutableArray <NSString *> *filteredComponents = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSInteger idx = 1; idx < [components count]; ++idx) {
          NSString *component = components[idx];
          if ([component length] > 0) {
            NSString *filteredComponent = [component stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            filteredComponent = [filteredComponent stringByReplacingOccurrencesOfString:@"#####" withString:@" "];
            [filteredComponents addObject:filteredComponent];
          }
        }
        self.whatsNew = [filteredComponents componentsJoinedByString:@"\n"];
        break;
      }
    }
  }
  return self;
}

- (BOOL) shouldShowWhatsNew {
  NSString *version = [self.keychainService obtainWhatsNewViewedVersion];
  if (!version) {
    NSDate *firstLaunchDate = [self.keychainService obtainFirstLaunchDate];
    NSDate *now = [NSDate date];
    NSTimeInterval interval = [now timeIntervalSinceDate:firstLaunchDate];
    if (interval < 300.0) {
      [self registerShow];
      return NO;
    }
  }
  NSString *applicationVersion = [[NSBundle mainBundle] applicationVersion];
  return ![applicationVersion isEqualToString:version];
}

- (void) registerShow {
  NSString *applicationVersion = [[NSBundle mainBundle] applicationVersion];
  [self.keychainService saveWhatsNewViewedVersion:applicationVersion];
}

- (NSString *) currentWhatsNew {
  return self.whatsNew;
}

@end
