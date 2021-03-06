//
//  PaymentMethodsViewController.m
//  Payments
//
//  Created by Nicolas Alejandro Fernandez Amorosino on 6/8/20.
//  Copyright © 2020 Nicolas Alejandro Fernandez Amorosino. All rights reserved.
//

#import "PaymentMethodsViewController.h"
#import "CardIssuersViewController.h"
#import "PaymentMethodsTableViewCell.h"
#import "PaymentMethod.h"

@interface PaymentMethodsViewController ()


@end

@implementation PaymentMethodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Metodos de Pago";
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _paymentMethodsViewModel.delegate = self;
    
    self.tableView.hidden = YES;
    [self startLoadingSpinner];

    [_paymentMethodsViewModel getPaymentMethods];
}

-(void) navigateToCardIssuersViewController:(NSString *) paymentMethodId :(NSString *) paymentMethod {
    CardIssuersViewController *cardIssuersViewController = [[CardIssuersViewController alloc] init];
    
    CardIssuersViewModel * cardIssuersViewModel = [[CardIssuersViewModel alloc] initWithPaymentMethodId:paymentMethodId];
    
    cardIssuersViewModel.selectedAmount = _paymentMethodsViewModel.selectedAmount;
    
    cardIssuersViewModel.paymentMethod = paymentMethod;
    
    cardIssuersViewController.cardIssuersViewModel = cardIssuersViewModel;
    
    [self.navigationController pushViewController:cardIssuersViewController animated:YES];
}

- (void)paymentMethodsFetched:(PaymentMethodsViewModel *)sender {
    self.tableView.hidden = NO;
    [self stopLoadingSpinner];
    
    if (_paymentMethodsViewModel.paymentMethods.count == 0) {
        [self showAlertWithTitle:@"Error" andMessage:@"Por el momento no hay informacion para mostrar." buttonTitle:@"Volver atras" andHandler:^(UIAlertAction *action) {
            [self.navigationController popViewControllerAnimated:true];
        }];
        
        return;
    }
    
    [self.tableView reloadData];
}

- (void)paymentMethodsFailed:(PaymentMethodsViewModel *)sender error:(NSString *)error {
    self.tableView.hidden = NO;
    [self stopLoadingSpinner];
    
    [self showAlertWithTitle:@"Error" andMessage:error buttonTitle:@"Volver atras" andHandler:^(UIAlertAction *action) {
        [self.navigationController popViewControllerAnimated:true];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PaymentMethodsTableViewCell";
    
    PaymentMethodsTableViewCell *cell = (PaymentMethodsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentMethodsTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    PaymentMethod *paymentMethod = (PaymentMethod *)[_paymentMethodsViewModel.paymentMethods objectAtIndex:indexPath.row];
    
    cell.name.text = paymentMethod.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PaymentMethod *paymentMethod = (PaymentMethod *)[_paymentMethodsViewModel.paymentMethods objectAtIndex:indexPath.row];
    
    [self navigateToCardIssuersViewController:paymentMethod.paymentMethodId:paymentMethod.name];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _paymentMethodsViewModel.paymentMethods.count;
}

@end
