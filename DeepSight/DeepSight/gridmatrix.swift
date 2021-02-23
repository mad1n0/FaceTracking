//
//  gridmatrix.swift
//  DeepSight
//
//  Created by Marc Valdivieso Merino on 04/02/2021.
//

import Foundation

class gridmatrix {
    
    var N : Int
    var M : Int
    var gc_size : Int
    //let dot : UIView
    var grid : [[[CGFloat]]]
    //var row : [Int]
    var ncoords : [CGFloat]
    var mcoords : [CGFloat]
    
    
    init(a : Int, b : Int, c : Int){
        self.N = a
        self.M = b
        self.gc_size = c
        self.grid = [[[]]]
        self.ncoords = []
        self.mcoords = []

        //self.row = []
    }
    

    
    func generateMatrix() -> [[[CGFloat]]]{
        var grid = [[[CGFloat]]]()
        for i in 0...N {
            var row = [[CGFloat]]()
            for j in 0...M {
                row.append([self.ncoords[i], self.mcoords[j]])
                
            }
            grid.append(row)
            
        }
        return grid
    
    }
    
    
    func calcCoords(){
        let screenSize: CGRect = UIScreen.main.bounds
        for i in 0...N{
            ncoords.append(CGFloat(i)*screenSize.width/35)
        }
        
        for i in 0...M{
            mcoords.append(CGFloat(i)*screenSize.height/35)
        }
        
        print(self.ncoords)
        print(self.mcoords)
        
        //positions / resolution array
    }
    
    
    
    
}
