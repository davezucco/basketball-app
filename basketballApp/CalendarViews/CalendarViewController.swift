//
//  CalendarViewController.swift
//  basketballApp
//
//  Created by Hesham Hussain on 10/20/19.
//

import UIKit
import JTAppleCalendar
import FirebaseFirestore

class CalendarViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate {

    @IBOutlet var calendarView: JTAppleCalendarView!
    
    var calendarDataSource: [String:String] = [:]
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        return formatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.scrollDirection = .horizontal
        calendarView.scrollingMode   = .stopAtEachCalendarFrame
        calendarView.showsHorizontalScrollIndicator = false
        calendarView.scrollToDate(Date(), animateScroll: false)
        
        
        getDocs()
        }
    
    func getDocs(){
        let s = self
        var game : [String:String] =
        ["gameDate": "",
         "oppName": ""]
        // Do any additional setup after loading the view.
        //TODO: Read from DB
        calendarDataSource = ["22-Oct-2019": "Cavaliers",
                 "15-Jan-2019":"GS Warriors"]
        FireRoot.games.getDocuments(){ (snapshot, err) in
            print("----------------")
            print(snapshot?.count)
            print(snapshot?.description)
        }
        }
        s.calendarDataSource = game
        
        print("anjir + \(game)")
        //return game
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        //let formatter = DateFormatter()
        //formatter.dateFormat = "yyyy MM dd"
        //let startDate = formatter.date(from: "2019 01 01")!
        let startDate = Calendar.current.date(byAdding: .year,value: -1, to: Date())
        let endDate = Date()
        return ConfigurationParameters(startDate: startDate!, endDate: endDate, numberOfRows: 6, hasStrictBoundaries: true)
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCellView
        cell.dateLabel.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        return cell
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! DateCellView
        cell.dateLabel.text = cellState.text
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor(red: 0, green: 0, blue: 0.5, alpha: 0.1).cgColor
        configureCell(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, headerViewForDateRange range: (start: Date, end: Date), at indexPath: IndexPath) -> JTAppleCollectionReusableView {
        let formatter = DateFormatter()  // Declare this outside, to avoid instancing this heavy class multiple times.
        formatter.dateFormat = "MMMM yyyy"
        
        let header = calendar.dequeueReusableJTAppleSupplementaryView(withReuseIdentifier: "DateHeader", for: indexPath) as! DateHeader
        header.monthTitle.text = formatter.string(from: range.start)
        return header
    }
    
    func calendarSizeForMonths(_ calendar: JTAppleCalendarView?) -> MonthSize? {
        return MonthSize(defaultSize: 50)
    }

    
    
    func configureCell(view: JTAppleCell?, cellState: CellState) {
        guard let cell = view as? DateCellView  else { return }
        cell.dateLabel.text = cellState.text
        let dateString = formatter.string(from: cellState.date)
        if(calendarDataSource[dateString] != nil){
            cell.matchButton.setTitle( calendarDataSource[dateString], for: UIControlState.normal)
            setDefaultButtonStyle(button: cell.matchButton)
            cell.matchButton.isHidden = false
            print(dateString)
        }else{
            cell.matchButton.isHidden = true
        }
        
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func handleCellTextColor(cell: DateCellView, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.dateLabel.textColor = UIColor.black
        } else {
            cell.dateLabel.textColor = UIColor.gray
        }
    }
    
    private func setDefaultButtonStyle(button: UIButton){
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func goBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MiddleViewController{
            let gameSummary = segue.destination as? MiddleViewController
            guard let buttonClicked = sender as? UIButton else{return}
            if let title = buttonClicked.currentTitle{
                gameSummary?.opponentTeam = title
            }
        }
    }
}

