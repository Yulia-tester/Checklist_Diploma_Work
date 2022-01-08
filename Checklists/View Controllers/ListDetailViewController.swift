//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit

protocol ListDetailViewControllerDelegate: class {
  func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist)
  func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
  @IBOutlet weak var textField: UITextField!
	@IBOutlet weak var iconImage: UIImageView!
	@IBOutlet weak var doneBarButton: UIBarButtonItem!

  weak var delegate: ListDetailViewControllerDelegate?
  var checklistToEdit: Checklist?
  var iconName = "Folder"
  //ф-ция сообщает, что view controller-а загрузилось в память
  override func viewDidLoad() {
    super.viewDidLoad()

    if let checklist = checklistToEdit {
      title = "Отредактировать пункт"
      textField.text = checklist.name
      doneBarButton.isEnabled = true
      iconName = checklist.iconName
    }
    iconImage.image = UIImage(named: iconName)
  }
  //ф-ция сообщает, что вью готово к представлению на экран
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    textField.becomeFirstResponder()
  }

  // MARK: - Navigation
  //ф-ция перехода на экран выбора иконки
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "PickIcon" {
      let controller = segue.destination as! IconPickerViewController
      controller.delegate = self
    }
  }

  // MARK: - Actions
  //ф-ция отмены
  @IBAction func cancel() {
    delegate?.listDetailViewControllerDidCancel(self)
  }
  //ф-ция сохранения
  @IBAction func done() {
    if let checklist = checklistToEdit {
      checklist.name = textField.text!
      checklist.iconName = iconName
      delegate?.listDetailViewController(self, didFinishEditing: checklist)
    } else {
      let checklist = Checklist(name: textField.text!, iconName: iconName)
      delegate?.listDetailViewController(self, didFinishAdding: checklist)
    }
  }

  // MARK: - Table View Delegates
  //ф-ция сообщает делегату, что скоро будет выбрана ячейка
  override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    return indexPath.section == 1 ? indexPath : nil
  }

  // MARK: - Text Field Delegates
  //ф-ция смены текста в поле
  func textField(
    _ textField: UITextField,
    shouldChangeCharactersIn range: NSRange,
    replacementString string: String
  ) -> Bool {
    let oldText = textField.text!
    let stringRange = Range(range, in: oldText)!
    let newText = oldText.replacingCharacters(in: stringRange, with: string)
    doneBarButton.isEnabled = !newText.isEmpty
    return true
  }
  //
  func textFieldShouldClear(_ textField: UITextField) -> Bool {
    doneBarButton.isEnabled = false
    return true
  }

  // MARK: - Icon Picker View Controller Delegate
  //ф-ция устанавливает иконку
  func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
    self.iconName = iconName
    iconImage.image = UIImage(named: iconName)
    navigationController?.popViewController(animated: true)
  }
}
