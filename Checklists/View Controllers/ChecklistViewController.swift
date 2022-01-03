//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit
  
final class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
  var checklist: Checklist!
  
  
  struct Constants {
    static let cellID = "ChecklistItem"
    static let emptyText = "(No Items)"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    // Disable large titles for this view controller
    navigationItem.largeTitleDisplayMode = .never
    title = checklist.name
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


  // MARK: - Navigation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItem" {
      let controller = segue.destination as! ItemDetailViewController
      controller.delegate = self
    } else if segue.identifier == "EditItem" {
      let controller = segue.destination as! ItemDetailViewController
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

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
  UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: "ChecklistItem",
      for: indexPath)

    let item = checklist.items[indexPath.row]
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    return cell
  }

  // MARK: - Table View Delegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = checklist.items[indexPath.row]
      item.checked.toggle()
      configureCheckmark(for: cell, with: item)
    }
    tableView.deselectRow(at: indexPath, animated: true)
  }

  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    checklist.items.remove(at: indexPath.row)

    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
  }

  // MARK: - Add Item ViewController Delegates
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }

  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    let newRowIndex = checklist.items.count
    checklist.items.append(item)

    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)

    navigationController?.popViewController(animated: true)
  }

  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    if let index = checklist.items.firstIndex(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
  }
}
