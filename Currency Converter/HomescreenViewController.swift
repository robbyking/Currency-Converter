//
//  HomescreenViewController.swift
//  Currency Converter
//
//  Created by Robert King on 2/17/17.
//  Copyright © 2017 robbyking. All rights reserved.
//

import UIKit

class HomescreenViewController: UIViewController {

    @IBOutlet weak var currencyAmountTextField: UITextField!
    @IBOutlet weak var currencyListTableView: UITableView!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!

    let orangeColor = UIColor.init(red: 150/255, green: 25/255, blue: 12/255, alpha: 1)
    let networkServices = NetworkServices()
    var amountToConvert = 1.0
    var currencyList = [String]()

    // When the user taps on a currency in the currencyListTableView,
    // update the selected currency label and request updated rates
    // from the API.
    var selectedCurrency = "USD" {
        didSet {
            selectedCurrencyLabel.text = "\(selectedCurrency):"
            networkServices.makeRequest(forCurrency: selectedCurrency)
        }
    }

    // A dictionary with currency types and their corresponding values.
    // When updated, we sort by currency name, reload the table view,
    // and scroll to the top.
    var currencyValues = [String:Any]() {
        didSet {
            currencyList = Array(currencyValues.keys).sorted()
            currencyListTableView.reloadData()
            currencyListTableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureTextView()
        configureNotifications()
        networkServices.makeRequest(forCurrency: selectedCurrency)
        navigationItem.title = "Currency Converter"
        navigationController?.navigationBar.backgroundColor = orangeColor
    }

    override func viewDidAppear(_ animated: Bool) {
        navigationItem.title = "Currency Converter"
    }

    fileprivate func configureTableView() {
        currencyListTableView.dataSource = self
        currencyListTableView.delegate = self
        currencyListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }

    fileprivate func configureTextView() {
        currencyAmountTextField.accessibilityIdentifier = "Currency amount"
        currencyAmountTextField.addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        currencyAmountTextField.becomeFirstResponder()
        currencyAmountTextField.delegate = self
        currencyAmountTextField.keyboardType = .decimalPad
    }

    fileprivate func configureNotifications() {

        // This notification listens for the network service to return a new list of currency values.
        // Because they're loaded asynchronously, we have to use the notification center to listen
        // for their value to be updated inthe completion block.
        NotificationCenter.default.addObserver(self, selector: #selector(updateCurrencyValues(_:)),
                                                         name: NSNotification.Name(rawValue: "currencyRefreshed"),
                                                       object: nil)

        // In order to prevent the bottom of the table view from being hidden by the onscreen keyboard,
        // we listen for its notification, then adjust its inset when the keyboard toggles.
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                                                         name: NSNotification.Name.UIKeyboardWillShow,
                                                       object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                                                         name: NSNotification.Name.UIKeyboardWillHide,
                                                       object: nil)
    }

    // This function is called when then currencyRefreshed notification is fired.
    // It gets the updated exchangeRates from the network service, then assigns them
    // to the currecnyValues dictionary.
    @objc fileprivate func updateCurrencyValues(_ notification: NSNotification) {
        if let exchangeRates = networkServices.exchangeRates {
            currencyValues = exchangeRates
        }
    }

    @objc fileprivate func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrameHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height ?? 0.0
        currencyListTableView.contentInset.bottom += keyboardFrameHeight
        currencyListTableView.scrollIndicatorInsets.bottom += keyboardFrameHeight
    }

    @objc fileprivate func keyboardWillHide(_ notification: NSNotification) {
        let keyboardFrameHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height ?? 0.0
        currencyListTableView.contentInset.bottom -= keyboardFrameHeight
        currencyListTableView.scrollIndicatorInsets.bottom -= keyboardFrameHeight
    }

    // This function handles the text inputed by the user.
    // 1. If the field is blank, we set the value to 0.
    // 2. If the field contains an int or a double, we update the amountToConvert variable.
    // 3. If the field contains other text, we just revert back to the previous value and try
    //    to not to give them too hard of a time about it.
    @objc fileprivate func textDidChange(_ textField: UITextField) {
        if textField.text?.characters.count == 0  {
            amountToConvert = 0
        } else if let userText = Int(textField.text!) {
            amountToConvert = Double(userText)
        } else if let userText = Double(textField.text!) {
            amountToConvert = userText
        } else {
            textField.text = "\(amountToConvert)"
        }
        currencyListTableView.reloadData()
    }

    @IBAction func infoButtonPressed(_ sender: UIButton) {
        let infoViewController = CurrencyInfoViewController()
        navigationItem.title = ""
        navigationController?.pushViewController(infoViewController, animated: true)
    }
}

// UITableView protocol complience
extension HomescreenViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let currency = currencyList[indexPath.row]
        var currencyValue = currencyValues[currency]

        // If we're able to retrieve an updated value from the API, multiply
        // it by the amount of currency to convert as entered by the user.
        if let updatedValue = currencyValue as? Double {
            currencyValue = updatedValue*amountToConvert
        }

        // Update the cell label with the new currency value.
        if let currencyValue = currencyValue as? Double {
            cell.textLabel?.text = "\(currency): \(String(format: "%.2f", currencyValue))"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerViewFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        let headerView = UIView(frame: headerViewFrame)
        headerView.backgroundColor = UIColor.white

        let headerLabelFrame = CGRect(x: 10, y: 10, width: UIScreen.main.bounds.width, height: 20)
        let headerTextLabel = UILabel(frame: headerLabelFrame)

        headerTextLabel.accessibilityIdentifier = "Selected currency"
        headerTextLabel.adjustsFontSizeToFitWidth = true
        headerTextLabel.text = "Select a currency to view its exchange rates."
        headerTextLabel.textColor = orangeColor
        headerTextLabel.font = headerTextLabel.font.withSize(15)
        headerView.addSubview(headerTextLabel)

        return headerView
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // When the user taps a table row, set the selected currency based on its
        // index in the currency list array
        selectedCurrency = currencyList[indexPath.row]

        // Hide the keyboard.
        currencyAmountTextField.endEditing(true)
    }
}

// UITextField protocol complience
extension HomescreenViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }
}
