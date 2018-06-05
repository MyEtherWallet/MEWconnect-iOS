//
//  ApplicationConfiguratorImplementation.m
//  MyEtherWallet-iOS
//
//  Created by Mikhail Nikanorov on 15/04/2018.
//  Copyright © 2018 MyEtherWallet, Inc. All rights reserved.
//

@import UIKit;
@import MagicalRecord;

#import "MyEtherWallet_iOS-Swift.h"

#import "ApplicationConstants.h"

#import "UIImage+Color.h"
#import "UIColor+Hex.h"
#import "UIColor+Application.h"

#import "PasswordTextField.h"
#import "BordlessNavigationBar.h"
#import "BackupConfirmationSegmenteControl.h"

#import "ApplicationConfiguratorImplementation.h"

@implementation ApplicationConfiguratorImplementation

- (void)configureInitialSettings {
}

- (void)configurateAppearance {
  /* Password text field */
  UIImage *background = [[UIImage imageWithColor:[UIColor mainApplicationColor]
                                            size:CGSizeMake(48.0f, 48.0f)
                                    cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(24.0f, 24.0f, 24.0f, 24.0f)];
  [[PasswordTextField appearance] setBackground:background];
  [[PasswordTextField appearance] setTextColor:[UIColor whiteColor]];
  [[PasswordTextField appearance] setTintColor:[UIColor whiteColor]];
  
  /* Bordless navigation bar */
  [[BordlessNavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
  [BordlessNavigationBar appearance].tintColor = [UIColor mainApplicationColor];
  
  /* Bar buttons */
  NSDictionary *normalTextAttributes = @{NSForegroundColorAttributeName: [UIColor barButtonColorForState:UIControlStateNormal]};
  NSDictionary *disabledTextAttributes = @{NSForegroundColorAttributeName: [UIColor barButtonColorForState:UIControlStateDisabled]};
  [[UIBarButtonItem appearance] setTitleTextAttributes:normalTextAttributes forState:UIControlStateNormal];
  [[UIBarButtonItem appearance] setTitleTextAttributes:disabledTextAttributes forState:UIControlStateDisabled];
  /* Search bar */
  UIImage *searchBarBackground = [[UIImage imageWithColor:[[UIColor mainApplicationColor] colorWithAlphaComponent:0.08]
                                                     size:CGSizeMake(28.0, 28.0) cornerRadius:8.0] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
  [[UISearchBar appearance] setSearchFieldBackgroundImage:searchBarBackground forState:UIControlStateNormal];
  [[UISearchBar appearance] setPositionAdjustment:UIOffsetMake(3.0, 1.0) forSearchBarIcon:UISearchBarIconSearch];
  [[UISearchBar appearance] setSearchTextPositionAdjustment:UIOffsetMake(11.0, 1.0)];
  [UISearchBar appearance].barTintColor = [UIColor purpleColor];
  NSDictionary *searchBarAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0 weight:UIFontWeightRegular]};
  [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:searchBarAttributes];
  /* Checkbox button */
  UIImage *normalBackgroundImage = [[UIImage imageWithColor:[UIColor backgroundLightBlue] size:CGSizeMake(20.0, 20.0) cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
  UIImage *selectedBackgroundImage = [[UIImage imageWithColor:[UIColor clearColor] size:CGSizeMake(20.0, 20.0) cornerRadius:10.0 borderColor:[UIColor backgroundLightBlue] borderSize:1.5] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
  [[CheckboxButton appearance] setBackgroundImage:normalBackgroundImage forState:UIControlStateNormal];
  [[CheckboxButton appearance] setBackgroundImage:normalBackgroundImage forState:UIControlStateHighlighted];
  [[CheckboxButton appearance] setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected];
  [[CheckboxButton appearance] setBackgroundImage:selectedBackgroundImage forState:UIControlStateSelected|UIControlStateHighlighted];
  { /* BackupConfirmationSegmentedControl */
    UIImage *backgroundNormal = [[UIImage imageWithColor:[UIColor backgroundLightBlue] size:CGSizeMake(56.0, 56.0) cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    UIImage *backgroundSelected = [[UIImage imageWithColor:[UIColor mainApplicationColor] size:CGSizeMake(56.0, 56.0) cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    UIImage *backgroundHighlighted = [[UIImage imageWithColor:[[UIColor mainApplicationColor] colorWithAlphaComponent:0.5] size:CGSizeMake(56.0, 56.0) cornerRadius:10.0] resizableImageWithCapInsets:UIEdgeInsetsMake(20.0, 20.0, 20.0, 20.0)];
    UIImage *separatorNormal = [[UIImage imageWithColor:[UIColor colorWithRGB:0xD2D7E3] size:CGSizeMake(1.0, 3.0) cornerRadius:0.0] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)];
    UIImage *separatorSelected = [[UIImage imageWithColor:[UIColor colorWithRGB:0x1A54C5] size:CGSizeMake(1.0, 3.0) cornerRadius:0.0] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)];
    UIImage *separatorHighlighted = [[UIImage imageWithColor:[[UIColor colorWithRGB:0x1A54C5] colorWithAlphaComponent:0.5] size:CGSizeMake(1.0, 3.0) cornerRadius:0.0] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)];
    
    [[BackupConfirmationSegmenteControl appearance] setBackgroundImage:backgroundNormal forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setBackgroundImage:backgroundSelected forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setBackgroundImage:backgroundHighlighted forState:UIControlStateNormal|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setBackgroundImage:backgroundHighlighted forState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorNormal forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorSelected forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorSelected forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorHighlighted forLeftSegmentState:UIControlStateNormal|UIControlStateHighlighted rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorHighlighted forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorHighlighted forLeftSegmentState:UIControlStateSelected|UIControlStateHighlighted rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setDividerImage:separatorHighlighted forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal|UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    NSDictionary *normalAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor],
                                       NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]};
    NSDictionary *selectedAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                         NSFontAttributeName: [UIFont systemFontOfSize:17.0 weight:UIFontWeightMedium]};
    [[BackupConfirmationSegmenteControl appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal];
    [[BackupConfirmationSegmenteControl appearance] setTitleTextAttributes:normalAttributes forState:UIControlStateNormal|UIControlStateHighlighted];
    [[BackupConfirmationSegmenteControl appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected];
    [[BackupConfirmationSegmenteControl appearance] setTitleTextAttributes:selectedAttributes forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [[BackupConfirmationSegmenteControl appearance] setContentPositionAdjustment:UIOffsetMake(-6.0, 0.0) forSegmentType:UISegmentedControlSegmentLeft barMetrics:UIBarMetricsDefault];
    [[BackupConfirmationSegmenteControl appearance] setContentPositionAdjustment:UIOffsetMake(6.0, 0.0) forSegmentType:UISegmentedControlSegmentRight barMetrics:UIBarMetricsDefault];
  }
}

#pragma mark - Core Data

- (void)setupCoreDataStack {
  if ([self shouldMigrateCoreData]) {
    [self migrateStore];
  } else {
    NSURL *directory = [self.fileManager containerURLForSecurityApplicationGroupIdentifier:AppGroupIdentifier];
    NSURL *storeURL = [directory URLByAppendingPathComponent:kCoreDataName];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:storeURL];
  }
}

- (BOOL)shouldMigrateCoreData {
  NSString *oldStoreName = [MagicalRecord defaultStoreName];
  return [[NSFileManager defaultManager] fileExistsAtPath:oldStoreName];
}

- (void)migrateStore {
  NSString *oldStoreName = [MagicalRecord defaultStoreName];
  NSPersistentStoreCoordinator *coordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:oldStoreName];
  // grab the current store
  NSPersistentStore *currentStore = coordinator.persistentStores.lastObject;
  // create a new URL
  NSURL *directory = [self.fileManager containerURLForSecurityApplicationGroupIdentifier:AppGroupIdentifier];
  NSURL *newStoreURL = [directory URLByAppendingPathComponent:kCoreDataName];
  
  NSDictionary *storeOptions = @{NSPersistentStoreFileProtectionKey: NSFileProtectionComplete};
  // migrate current store to new URL
  [coordinator migratePersistentStore:currentStore
                                toURL:newStoreURL
                              options:storeOptions
                             withType:NSSQLiteStoreType
                                error:nil];
  [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreAtURL:newStoreURL];
}

@end
