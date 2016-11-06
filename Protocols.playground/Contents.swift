//: Playground - noun: a place where people can play

import UIKit

protocol Vechile: CustomStringConvertible {
    var isRunning: Bool { get set} //specifiy it's a read and write
    
    var make: String {get set}
    var model: String {get set}
    
    mutating func start() //gonna mutate an interal property that will confirm to this
    mutating func turnOff()
    

}
extension Vechile {
    
    var makeModel: String {
        return "\(make) \(model)"
    }
    
    mutating func start(){
        if isRunning {
            print( "Is currently running")
        }
        else {
            isRunning  = true
            print( "\(self.description) is fired uo!")
        }
    
    }
    
    mutating func turnOff(){
        if isRunning {
            isRunning  = false
            print( "\(self.description)  shut down")
        }
        else {
            print("already dead!")
        }
    }
    
}
struct SportsCar: Vechile {

    var isRunning: Bool = false
    var model: String
    var make: String
    

    var description: String {
        return self.makeModel
    }
    
}

class SemiTruck: Vechile {
    var isRunning: Bool = false
    var model: String
    var make: String
    init(isRunning: Bool, make:String, mode:String) {
        self.make = make
        self.model = mode
        self.isRunning = isRunning
    }
    var description: String {
         return self.makeModel
    }
    
    //being a refernece type, doesn't need a mutated keyword
    
    
    func blowAirHorn(){
        print("TOOOT")
    }
    
}

var car1 = SportsCar(isRunning: false, model: "Porsche", make: "911")
var truck1 = SemiTruck(isRunning: false, make: "peterbuilt", mode: "Verago")
car1.start()
truck1.start()
truck1.blowAirHorn()
//
//
truck1.turnOff()
//
var vechileArray: Array<Vechile> = [car1, truck1]
for vechile in vechileArray {
    print("\(vechile.makeModel)")
}

extension Double{
    var dollarString: String {
        return String(format: "$%.02f", self)
    }
}


var pct = 32.15 * 0.15
pct.dollarString
