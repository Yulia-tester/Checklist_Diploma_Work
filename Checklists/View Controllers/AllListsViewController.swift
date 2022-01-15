//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit

final class AllListsViewController: UITableViewController {
    var dataModel: DataModel!
    
    struct Constants {
        static let cellID = "ListCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        
        let checklist = dataModel.lists[indexPath.row]
        
        if let listCell = cell as? ListCell {
            listCell.delegate = self
            listCell.listData = checklist
        }
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}

// MARK: - Navigation
extension AllListsViewController: UINavigationControllerDelegate {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            guard let controller = segue.destination as? ChecklistViewController else { return }
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            guard let controller = segue.destination as? ListDetailViewController else { return }
            controller.delegate = self
        }
    }
    
    // MARK: - Navigation Controller Delegates
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}

// MARK: - List Detail View Controller Delegates
extension AllListsViewController: ListDetailViewControllerDelegate {
    func didCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    func didFinishAdding(_ controller: ListDetailViewController, checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }

    func didFinishEditing(_ controller: ListDetailViewController, checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension AllListsViewController: ListCellDelegate {
    func editPressed(_ cell: ListCell, listData: Checklist?) {
        guard let data = listData else { return }
        
        guard
            let storyboard = storyboard,
            let controller = storyboard.instantiateViewController(withIdentifier: "ListDetailViewController") as? ListDetailViewController
        else { return }
    
        controller.delegate = self
        controller.checklistToEdit = data
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
