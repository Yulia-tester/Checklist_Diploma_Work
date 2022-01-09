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
    //ф-ция сообщает, что view controller-а загрузилось в память
    override func viewDidLoad() {
        super.viewDidLoad()
        // Enable large titles
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    //ф-ция сообщает, что вью готово к представлению на экран
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    //ф-ция сообщает, что вью загрузилось
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
    //ф-ция берет с модели данных к-чество ячеек в таблице и отображает на экране
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    //ф-ция возвращения ячеек с информацией с даты моделс
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        
        let checklist = dataModel.lists[indexPath.row]
        
        if let listCell = cell as? ListCell {
            // подключение делегата
            listCell.delegate = self
            listCell.listData = checklist
        }
        
        return cell
    }
    //ф-ция обрабатывает нажатие на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender: checklist)
    }
    //ф-ция удаления ячейки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
}

extension AllListsViewController: UINavigationControllerDelegate {
    // MARK: - Navigation
    //ф-ция смены экранов
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            let controller = segue.destination as! ChecklistViewController
            controller.checklist = sender as? Checklist
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
    }
    
    // MARK: - Navigation Controller Delegates
    //ф-ция управления панелью навигации Назад на предыдуший вью
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // Was the back button tapped?
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}

extension AllListsViewController: ListDetailViewControllerDelegate {
    // MARK: - List Detail View Controller Delegates
    //ф-ция управления возвращением назад, когда нажимаем Cancel
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    //ф-ция управления переходом на экран добавления нового пункта
    func listDetailViewController(_ controller: ListDetailViewController, didFinishAdding checklist: Checklist) {
        dataModel.lists.append(checklist)
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
    //ф-ция управления переходом на экран редактирования пункта
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension AllListsViewController: ListCellDelegate {
    func listCellEditPressed(_ cell: ListCell, listData: Checklist?) {
        guard let data = listData else { return }
        
        let controller = storyboard!.instantiateViewController(withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        controller.checklistToEdit = data
        
        navigationController?.pushViewController(controller, animated: true)
    }
}
