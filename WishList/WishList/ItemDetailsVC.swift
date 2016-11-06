//
//  ItemDetailsVC.swift
//  WishList
//
//  Created by c.uraga on 2016/09/03.
//  Copyright © 2016年 c.uraga. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var itemTypeField: UILabel!
    
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var itemTypeLabel: UILabel!
    
    
    var stores = [Store]()
    var itemType = [ItemType]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    var itemTypePicker: UIPickerView!
    let pickerFrame = CGRect(x: 10, y:120, width: 250, height: 120);
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        storePicker.delegate = self
        storePicker.dataSource = self
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        /*let store = ItemType(context: context)
        store.type = "Electronics"
        let store2 = ItemType(context: context)
        store2.type = "Book"
        let store3 = ItemType(context: context)
        store3.type = "Home Good"
        let store4 = ItemType(context: context)
        store4.type = "Clothing"
        let store5 = ItemType(context: context)
        store.type = "Other"
        ad.saveContext()*/
        
        itemTypePicker = UIPickerView(frame: pickerFrame);
        itemTypePicker.delegate = self
        itemTypePicker.dataSource = self
        itemTypePicker.tag = 2

        getItemType()
        getStores()
        if itemToEdit != nil {
            loadItemData()
        }
        // Do any additional setup after loading t<#T##NSManagedObjectContext?#>he view.
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2 {
            let itemTypes = itemType[row]
            return itemTypes.type
        }
        else {
            let store = stores[row]
            return store.name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 2 {
            return itemType.count
        }
        else{
            return stores.count
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //update when selected
        if pickerView.tag == 2 {
            
        }
    }
    
    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
            
            
        } catch {
            
        }
    }
    func getItemType() {
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        do {
            self.itemType = try context.fetch(fetchRequest)
            self.itemTypePicker.reloadAllComponents()
            
        } catch {
            
        }
    }
    @IBAction func saveItem(_ sender: UIButton) {
        var item: Item!
        
        let picture = Image(context: context)
        picture.image = thumbImage.image
        
        if itemToEdit == nil {
            
            item = Item(context: context)
        }
        else {
            item = itemToEdit
        }
        if let title = titleField.text {
            item.title = title
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        item.toImage = picture
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        item.toItemType = itemType[itemTypePicker.selectedRow(inComponent: 0)]
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = "\(item.price)"
            detailsField.text = item.details
            
            thumbImage.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
            
            if let itemSingleType = item.toItemType {
                var index = 0
                repeat {
                    let s = itemType[index]
                    if s.type == itemSingleType.type {
                        itemTypePicker.selectRow(index, inComponent: 0, animated: false)
                        itemTypeLabel.text = self.itemType[self.itemTypePicker.selectedRow(inComponent: 0)].type
                        break
                    }
                    index += 1
                } while (index < itemType.count)
            }
        }
    }
    
    func showPickerView(){
        let title = "Pick an Item Type"
        let message = "This will link the type to the item"
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.isModalInPopover = true
        //alert.addAction(addItem())
        
        
    
        
    
        // now cralertour custom view - we are using a container view which can contain other views
        let containerView: UIView = UIView(frame: pickerFrame);
        //containerView.addSubview(picker)
        alert.view.addSubview(containerView)
        
        // now add some constraints to make sure that the alert resizes itself
        let cons:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.height, multiplier: 1.00, constant: 130)
        
        alert.view.addConstraint(cons)
        
        let cons2:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.greaterThanOrEqual, toItem: containerView, attribute: NSLayoutAttribute.width, multiplier: 1.00, constant: 0)
        alert.view.addConstraint(cons2)
        alert.view.addSubview(itemTypePicker);
        alert.addAction(addItem())
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func addItem() -> UIAlertAction{
        return UIAlertAction(title: "Add Item", style: .default, handler: {
            (action) -> Void in
            self.itemTypeLabel.text = self.itemType[self.itemTypePicker.selectedRow(inComponent: 0)].type
        })
    }
    
    @IBAction func deletePressed(_ sender: AnyObject) {
        
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    
    
    @IBAction func showPickerAlert(_ sender: UIButton) {
        
        showPickerView()
    }
    
    
    @IBAction func addImage(_ sender: UIButton) {
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImage.image = img
        
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
