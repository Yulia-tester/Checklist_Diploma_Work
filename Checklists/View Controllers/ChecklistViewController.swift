//
//  ChecklistViewController.swift
//  Checklists
//
//  Created by Yulia on 11/4/21.
//  Copyright © 2021 Distillery. All rights reserved.

import UIKit

final class ChecklistViewController: UITableViewController {
    var checklist: Checklist!

    struct Constants {
        static let cellID = "ChecklistCell"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.largeTitleDisplayMode = .never
        title = checklist.name
    }
  
  
  @IBOutlet weak var eyeIcon: UIBarButtonItem!
  @IBAction func eyeIcon(_ sender: Any) {
  }
  

    // MARK: - Navigation

    //ф-ция назначения делегата и передачи данных при переходе на экран ItemDetailViewController
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

    // ф-ция берет с модели данных к-чество ячеек в таблице
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

    // ф-ция возвращения ячеек с информацией с даты моделс
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID, for: indexPath)
        let item = checklist.items[indexPath.row]

        if let checklistCell = cell as? ChecklistCell {
            // подключение делегата
            checklistCell.delegate = self
            checklistCell.itemData = item
        }

        return cell
    }

    // MARK: - Table View Delegate

    //ф-ция обрабатывает нажатие на ячейку
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked.toggle()
            //configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    //ф-ция удаления ячейки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }

    // MARK: - Add Item ViewController Delegates

    //ф-ция возвращения на предыдущий экран после нажатия на cancel
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }

    //ф-ция возвращения на предыдущий экран после добавления новой ячейки
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowIndex = checklist.items.count
        checklist.items.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)

        navigationController?.popViewController(animated: true)
    }
    //ф-ция возвращения на предыдущий экран после редктирования
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                //configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
}


extension ChecklistViewController: ItemDetailViewControllerDelegate {

}

extension ChecklistViewController: ChecklistCellDelegate {
  
    func cheklistEditPressed(_ cell: ChecklistCell, itemData: ChecklistItem?) {
//        guard let data = itemData else { return }
//
//        let controller = storyboard!.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
//        controller.delegate = self
//        controller.checklistToEdit = data
//
//        navigationController?.pushViewController(controller, animated: true)
  }
}
extension UIButton {
    //MARK:- Animate check mark
    func checkboxAnimation(closure: @escaping () -> Void){
        guard let image = self.imageView else {return}
        
        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
        }) { (success) in
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
                self.isSelected = !self.isSelected
                //to-do
                closure()
                image.transform = .identity
            }, completion: nil)
        }
        
    }
}
