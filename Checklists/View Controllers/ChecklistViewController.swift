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
  
  
  @IBOutlet weak var eye: UIButton!

  @IBAction func eyePressed(_ sender: UIButton) {
      sender.isSelected = !sender.isSelected

      tableView.reloadData()
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
//        if eye.isSelected {
//            let count = checklist.countUncheckedItems()
//            return count
//        } else {
//            return checklist.items.count
//        }
        return checklist.items.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if eye.isSelected {
            let item = checklist.items[indexPath.row]
            if item.checked {
                return 0
            } else {
                return 60
            }
        } else {
            return 60
        }
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

//        if item.checked {
//            cell.
//        }

        return cell
    }

    // MARK: - Table View Delegate

//    //ф-ция обрабатывает нажатие на ячейку
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let cell = tableView.cellForRow(at: indexPath) {
//            let item = checklist.items[indexPath.row]
//            item.checked.toggle()
//            //configureCheckmark(for: cell, with: item)
//        }
//        tableView.deselectRow(at: indexPath, animated: true)
//    }

    //ф-ция удаления ячейки
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }



}

// MARK: - Add Item ViewController Delegates
extension ChecklistViewController: ItemDetailViewControllerDelegate {
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
        tableView.reloadData()
        navigationController?.popViewController(animated: true)
    }
}

extension ChecklistViewController: ChecklistCellDelegate {
  
    func cheklistEditPressed(_ cell: ChecklistCell, itemData: ChecklistItem?) {
        guard let data = itemData else { return }

        let controller = storyboard!.instantiateViewController(withIdentifier: "ItemDetailViewController") as! ItemDetailViewController
        controller.delegate = self
        controller.itemToEdit = data

        navigationController?.pushViewController(controller, animated: true)
  }

    func cheklistCheckPressed(_ cell: ChecklistCell, itemData: ChecklistItem?) {

        if let item = checklist.items.first(where: { $0.itemID == itemData?.itemID }) {
            item.checked.toggle()
        }


        tableView.reloadData()
    }
}


//extension UIButton {
//    //MARK:- Animate check mark
//    func checkboxAnimation(closure: @escaping () -> Void){
//        guard let image = self.imageView else {return}
//
//        UIView.animate(withDuration: 0.1, delay: 0.1, options: .curveLinear, animations: {
//            image.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//
//        }) { (success) in
//            UIView.animate(withDuration: 0.1, delay: 0, options: .curveLinear, animations: {
//                self.isSelected = !self.isSelected
//                //to-do
//                closure()
//                image.transform = .identity
//            }, completion: nil)
//        }
//
//    }
//}
