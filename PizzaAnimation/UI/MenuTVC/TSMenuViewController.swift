//
//  MenuTableViewController.swift
//  PizzaAnimation
//
//  Created by Tubik Studio on 8/4/16.
//  Copyright © 2016 Tubik Studio. All rights reserved.
//

import UIKit

let kFoodItemCellIdentifier = "FoodItemCell"
let kAnimationDuration = 0.5
let kPizzaRowIndex = 2

struct SubTableViewSettings {
    
    var maxRowHeight: CGFloat = 88
    var minRowHeight: CGFloat = 44
    var horizontalOffset: CGFloat = 20
    var makeSmaller = false
    
}

class TSMenuViewController: UIViewController {
    
    //MARK: vars
    
    var subTableSettings = SubTableViewSettings()
    
    @IBOutlet private weak var mainTableView: UITableView!
    
    private var subTableView: UITableView?
    
    private var categories = [TSFoodCategory]()
    private var dataProvider = DataProvider()
    private var selectedIndexPath: NSIndexPath?

    //MARK: view life
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categories = dataProvider.mockedCategories()
        
        mainTableView.registerNib(UINib(nibName: String(TSFoodCategoryTableViewCell), bundle: NSBundle.mainBundle()),
                              forCellReuseIdentifier: String(TSFoodCategoryTableViewCell))
        mainTableView.registerNib(UINib(nibName: String(TSPizzaTableViewCell), bundle: NSBundle.mainBundle()),
                              forCellReuseIdentifier: String(TSPizzaTableViewCell))
        
        let navigationBar = navigationController?.navigationBar
        navigationBar?.setBackgroundImage(UIImage(named: "nav_bar"), forBarMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        categories.removeAll()
    }
    
    // MARK: - SubTable funcs
    
    private func hideSubTable() {
        guard let subTableView = subTableView else { return }
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        if selectedIndexPath != nil {
            let cell = mainTableView.cellForRowAtIndexPath(selectedIndexPath!) as? TSFoodCategoryTableViewCell
            cell?.closeButton.hidden = true
            
            mainTableView.beginUpdates()
            selectedIndexPath = nil
            mainTableView.endUpdates()
            
            self.view.sendSubviewToBack(subTableView)
            UIView.animateWithDuration(kAnimationDuration, animations: {
                self.subTableView?.center.y = -subTableView.frame.height
            }) { ended in
                if ended {
                    self.subTableView?.removeFromSuperview()
                }
            }
        }
    }
    
    private func showSubTable(forIndexPath indexPath: NSIndexPath) {
        subTableSettings.makeSmaller = false
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        mainTableView.beginUpdates()
        selectedIndexPath = indexPath
        mainTableView.endUpdates()
        
        let category = categories[selectedIndexPath!.row]
        addSubTable(hidden: true, andFoodItems: category.foodItems)
        guard let subTableView = subTableView else { return }
        
        
        UIView.animateWithDuration(kAnimationDuration, animations: {
            subTableView.center.y = subTableView.frame.height/2.0 + kActionButtonHeight
            self.mainTableView.contentOffset = CGPointZero
        }) { ended in
            if ended {
                subTableView.beginUpdates()
                self.subTableSettings.makeSmaller = true
                subTableView.endUpdates()
                self.view.bringSubviewToFront(subTableView)
            }
        }
    }
    
    private func addSubTable(hidden hidden: Bool, andFoodItems foodItems: [FoodItem]) {
        if subTableView?.superview != nil {
            subTableView?.removeFromSuperview()
        }
        
        let maxSubTableHeight = view.frame.size.height - mainTableView.rowHeight
        let subTableHeight = min(CGFloat(foodItems.count) * subTableSettings.minRowHeight, maxSubTableHeight)
        
        let frame = CGRect(x: subTableSettings.horizontalOffset ,
                           y: hidden ? -subTableHeight : kActionButtonHeight ,
                           width: view.frame.width - 2*subTableSettings.horizontalOffset ,
                           height: subTableHeight)
        subTableView = UITableView(frame: frame)
        subTableView?.delegate = self
        subTableView?.dataSource = self
        subTableView?.separatorStyle = .None
        subTableView?.scrollEnabled = subTableView?.frame.height == maxSubTableHeight
        view.insertSubview(subTableView!, belowSubview: mainTableView)
    }

}

extension TSMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == subTableView {
            guard let selectedIndexPath = selectedIndexPath else { return 0 }
            let category = categories[selectedIndexPath.row]
            return category.foodItems.count
        }
        return categories.count + 1 //we should change content size for table view
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == subTableView {
            guard let selectedIndexPath = selectedIndexPath else { return UITableViewCell() }
            let category = categories[selectedIndexPath.row]
            let foodItem = category.foodItems[indexPath.row]
            var cell = tableView.dequeueReusableCellWithIdentifier(kFoodItemCellIdentifier)
            if cell == nil {
                cell = UITableViewCell(style: .Default, reuseIdentifier: kFoodItemCellIdentifier)
                cell?.accessoryType = .DisclosureIndicator
                cell?.textLabel?.textColor = UIColor.lightGrayColor()
            }
            cell?.textLabel?.text = foodItem.title

            return cell!
        } else {
            if indexPath.row >= categories.count {
                //empty cell (for changing table view content size)
                let cell = UITableViewCell(style: .Default, reuseIdentifier: "emptyCell")
                cell.backgroundColor = UIColor.clearColor()
                cell.selectionStyle = .None
                return cell
            }
            
            var cell: TSFoodCategoryTableViewCell
            if indexPath.row == kPizzaRowIndex {
                cell = tableView.dequeueReusableCellWithIdentifier(String(TSPizzaTableViewCell),
                                                                   forIndexPath: indexPath) as! TSPizzaTableViewCell
            } else {
                cell = tableView.dequeueReusableCellWithIdentifier(String(TSFoodCategoryTableViewCell),
                                                                   forIndexPath: indexPath) as! TSFoodCategoryTableViewCell
            }
            
            //refactor
            let rectOfCellInSuperview = mainTableView.convertRect(cell.frame, toView: view)
            let minY = mainTableView.rowHeight
            let maxY = view.frame.height/2.0
            let currentY = CGRectGetMaxY(rectOfCellInSuperview)
            let offset = abs(min(currentY - minY, maxY))/maxY
            cell.animate(offset: 1 - offset)
            
            
            cell.delegate = self
            cell.closeButton.hidden = indexPath.row != selectedIndexPath?.row || selectedIndexPath == nil
            let category = categories[indexPath.row]
            cell.customizeCell(withCategory: category)
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == subTableView {
            if subTableSettings.makeSmaller {
                return subTableSettings.minRowHeight
            }
            return subTableSettings.maxRowHeight
        }
        
        guard selectedIndexPath != nil else {
            if indexPath.row == categories.count { //fake cell
                return 0
            }
            return tableView.rowHeight
        }
        if indexPath.row < selectedIndexPath?.row ||
            (indexPath.row == categories.count && selectedIndexPath?.row != categories.count - 1) {
            return 0.0
        } else if indexPath.row == selectedIndexPath?.row {
            return kActionButtonHeight
        } else {
            return view.frame.height
        }
    }
    
}

extension TSMenuViewController: TSFoodCategoryTableViewCellDelegate {
    
    func foodCategoryTableViewCellDidPressCloseButton(cell: TSFoodCategoryTableViewCell) {
        hideSubTable()
        cell.closeButton.hidden = true
    }
    
    func foodCategoryTableViewCellDidPressActionButton(cell: TSFoodCategoryTableViewCell) {
        cell.closeButton.hidden = false
        guard let indexPath = mainTableView.indexPathForCell(cell) else { return }
        showSubTable(forIndexPath: indexPath)
    }
    
}

extension TSMenuViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        if scrollView == subTableView || selectedIndexPath == nil {
            return
        }
        hideSubTable()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView == subTableView {
            return
        }
        
        if selectedIndexPath != nil {
            mainTableView.contentOffset = CGPointZero
            return
        }
        
        guard let indexPathsForVisibleRows =  mainTableView.indexPathsForVisibleRows else { return }
        for indexPath in indexPathsForVisibleRows {
            
            let cell = mainTableView.cellForRowAtIndexPath(indexPath) as? TSFoodCategoryTableViewCell
            if let cell = cell {
                let rectOfCellInSuperview = mainTableView.convertRect(cell.frame, toView: view)
                let minY = mainTableView.rowHeight
                let maxY = view.frame.height/2.0
                var currentY = CGRectGetMaxY(rectOfCellInSuperview)
                if let navBar = navigationController?.navigationBar {
                    currentY -= navBar.frame.height
                }
                let offset = abs(min(currentY - minY, maxY))/maxY
                cell.animate(offset: 1 - offset)
            }
        }
    }

}
