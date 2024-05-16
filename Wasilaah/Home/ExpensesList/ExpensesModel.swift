//
//  ExpensesModel.swift
//  Namaa
//
//  Created by sumaiya on 06/05/2567 BE.
//



import Foundation


struct SingleExpense {
    let title: String
    let date: String
    let amount: Double
    let currency: String
    let colorIndex: Int
    let viewIcon: String
}

var expenses: [SingleExpense] = []
