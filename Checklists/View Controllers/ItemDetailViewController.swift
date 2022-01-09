//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit
import UserNotifications

protocol ItemDetailViewControllerDelegate: class {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishAdding item: ChecklistItem
  )
  func itemDetailViewController(
    _ controller: ItemDetailViewController,
    didFinishEditing item: ChecklistItem
  )
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!
  @IBOutlet weak var shouldRemindSwitch: UISwitch!
  @IBOutlet weak var datePicker: UIDatePicker!

  weak var delegate: ItemDetailViewControllerDelegate?
  var itemToEdit: ChecklistItem?

  //ф-ция сообщает, что view controller-а загрузилось в память
	override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    if let item = itemToEdit {
      title = "Edit Item"
      textField.text = item.text
      doneBarButton.isEnabled = true
      shouldRemindSwitch.isOn = item.shouldRemind
      datePicker.date = item.dueDate
    }
  }
  // ф-ция сообщает, что вью готово к представлению на экран
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }

  // MARK: - Actions
  //ф-ция отмены
  @IBAction func cancel() {
    delegate?.itemDetailViewControllerDidCancel(self)
  }
  //ф-ция сохранения
  @IBAction func done() {
    if let item = itemToEdit {
      item.text = textField.text!
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = datePicker.date
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishEditing: item)
    } else {
      let item = ChecklistItem()
      item.text = textField.text!
      item.shouldRemind = shouldRemindSwitch.isOn
      item.dueDate = datePicker.date
      item.scheduleNotification()
      delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
  }
 //ф-ция переключения свитчера
  @IBAction func shouldRemindToggled(_ switchControl: UISwitch) {
    textField.resignFirstResponder()

    if switchControl.isOn {
      let center = UNUserNotificationCenter.current()
      center.requestAuthorization(options: [.alert, .sound]) {_, _ in
        // do nothing
      }
    }
  }

  // MARK: - Table View Delegates
  //ф-ция сообщает делегату, что скоро будет выбрана ячейка
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return nil
  }

  // MARK: - Text Field Delegates
  //ф-ция смены текста в поле
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    doneBarButton.isEnabled = !newText.isEmpty
    return true
  }
  //ф-ция 
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }
}
