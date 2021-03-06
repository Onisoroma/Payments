//
//  PaymentMethodsViewController.h
//  Payments
//
//  Created by Nicolas Alejandro Fernandez Amorosino on 6/8/20.
//  Copyright © 2020 Nicolas Alejandro Fernandez Amorosino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "PaymentMethodsViewModel.h"
#import "UIViewController+Alert.h"

NS_ASSUME_NONNULL_BEGIN

@interface PaymentMethodsViewController : BaseViewController <UITableViewDelegate, UITableViewDataSource, PaymentMethodsDelegate>

@property (nonatomic, strong) PaymentMethodsViewModel *paymentMethodsViewModel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

NS_ASSUME_NONNULL_END
