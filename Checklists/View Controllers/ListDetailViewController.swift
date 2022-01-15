//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func didCancel(_ controller: ListDetailViewController)
    func didFinishAdding(_ controller: ListDetailViewController, checklist: Checklist)
    func didFinishEditing(_ controller: ListDetailViewController, checklist: Checklist)
}

final class ListDetailViewController: UITableViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!

    weak var delegate: ListDetailViewControllerDelegate?
    var checklistToEdit: Checklist?

    var iconName = "Folder"

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickIcon" {
            guard let controller = segue.destination as? IconPickerViewController else { return }
            controller.delegate = self
        }
    }

    // MARK: - Actions
    @IBAction func cancel() {
        delegate?.didCancel(self)
    }

    @IBAction func done() {
        guard let text = textField.text else { return }
        if let checklist = checklistToEdit {
            checklist.name = text
            checklist.iconName = iconName
            delegate?.didFinishEditing(self, checklist: checklist)
        } else {
            let checklist = Checklist(name: text, iconName: iconName)
            delegate?.didFinishAdding(self, checklist: checklist)
        }
    }

    // MARK: - Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return indexPath.section == 1 ? indexPath : nil
    }
}

// MARK: - Text Field Delegates
extension ListDetailViewController: UITextFieldDelegate {
    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
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

// MARK: - Icon Picker View Controller Delegate
extension ListDetailViewController: IconPickerViewControllerDelegate {
    func iconPicker(_ picker: IconPickerViewController, didPick iconName: String) {
        self.iconName = iconName
        iconImage.image = UIImage(named: iconName)
        navigationController?.popViewController(animated: true)
    }
}
