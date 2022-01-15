//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit

final class ChecklistViewController: UITableViewController {
    @IBOutlet weak var eye: UIButton!

    var checklist: Checklist!

    struct Constants {
        static let cellID = "ChecklistCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
    }

    @IBAction func eyePressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected

        tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            guard let controller = segue.destination as? ItemDetailViewController else { return }
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            guard let controller = segue.destination as? ItemDetailViewController else { return }
            controller.delegate = self

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if eye.isSelected {
            let item = checklist.items[indexPath.row]
            return item.checked ? 0 : 60
        } else {
            return 60
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        let item = checklist.items[indexPath.row]

        if let checklistCell = cell as? ChecklistCell {
            checklistCell.delegate = self
            checklistCell.itemData = item
        }

        return cell
    }

    // MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}

// MARK: - Add Item ViewController Delegates
extension ChecklistViewController: ItemDetailViewControllerDelegate {
    func didCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func didFinishAdding(_ controller: ItemDetailViewController, item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)

        navigationController?.popViewController(animated: true)
    }

    func didFinishEditing(_ controller: ItemDetailViewController, item: ChecklistItem) {
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension ChecklistViewController: ChecklistCellDelegate {
    func editPressed(_ cell: ChecklistCell, itemData: ChecklistItem?) {
        guard let data = itemData else { return }

        guard
            let storyboard = storyboard,
            let controller = storyboard
                .instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController
        else { return }

        controller.delegate = self
        controller.itemToEdit = data

        navigationController?.pushViewController(controller, animated: true)
    }

    func checkPressed(_ cell: ChecklistCell, itemData: ChecklistItem?) {
        if let item = checklist.items.first(where: { $0.itemID == itemData?.itemID }) {
            item.checked.toggle()
        }

        tableView.reloadData()
    }
}
