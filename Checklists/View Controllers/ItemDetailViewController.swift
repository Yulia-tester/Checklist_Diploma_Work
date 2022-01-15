//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: AnyObject {
    func didCancel(_ controller: ItemDetailViewController)
    func didFinishAdding(_ controller: ItemDetailViewController, item: ChecklistItem)
    func didFinishEditing(_ controller: ItemDetailViewController, item: ChecklistItem)
}

final class ItemDetailViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: ItemDetailViewControllerDelegate?
    var itemToEdit: ChecklistItem?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never

        if let item = itemToEdit {
            title = "Отредактировать"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            datePicker.date = item.dueDate
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.didCancel(self)
    }

    @IBAction func done() {
        guard let text = textField.text else { return }

        if let item = itemToEdit {
            item.text = text
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.didFinishEditing(self, item: item)
        } else {
            let item = ChecklistItem()
            item.text = text
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = datePicker.date
            item.scheduleNotification()
            delegate?.didFinishAdding(self, item: item)
        }
    }

    @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
        textField.resignFirstResponder()

        if switchControl.isOn {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {_, _ in
            }
        }
    }

    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}

// MARK: - Text Field Delegates
extension ItemDetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String)
    -> Bool {
        guard
            let oldText = textField.text,
            let stringRange = Range(range, in: oldText)
        else { return false }

        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty

        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
