//
//  gridmatrix.swift
//  DeepSight
//
//  Created by Marc Valdivieso Merino on 04/02/2021.
//

import Foundation

class gridmatrix : UIView{
    
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
        super.init(frame: CGRect(x: 0, y: 0, width: 414, height: 896))
        //self.row = []
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

    
    func generateMatrix() -> [[[CGFloat]]]{
        var grid = [[[CGFloat]]]()
        for i in 1...N-2 {
            var row = [[CGFloat]]()
            for j in 0...M-1 {
                row.append([self.ncoords[i], self.mcoords[j]])
                
            }
            grid.append(row)
            
        }
        return grid
    
    }
    
    
    func calcCoords(){
        let screenSize: CGRect = UIScreen.main.bounds
        for i in 0...N{
            ncoords.append(CGFloat(i)*screenSize.height/CGFloat(N))
        }
        
        for i in 0...M{
            mcoords.append(CGFloat(i)*screenSize.width/CGFloat(M))
        }
        
        print(self.ncoords)
        print(self.mcoords)
        
        //positions / resolution array
    }
    
    override func draw(_ rect: CGRect){
        let path = UIBezierPath()
        
        for item in self.mcoords{
        
            path.move(to: CGPoint(x: item, y: 37.3333333333333))
            path.addLine(to: CGPoint(x: item, y: 858.66666666666))
        }
        
        for item in self.ncoords{
        
            path.move(to: CGPoint(x: 0, y: item))
            path.addLine(to: CGPoint(x: 414, y: item))
        }
        
        
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.lineWidth = 1.0
        path.fill()
        path.stroke()
    }
    
    
    func createBezierPath() -> UIBezierPath {
        
        // create a new path
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 44.8, y: 0))
        path.addLine(to: CGPoint(x: 44.8, y: 896))
        path.addLine(to: CGPoint(x: 10, y: 150))
        
        path.close()
        
        UIColor.green.setFill()
        UIColor.red.setStroke()
        path.lineWidth = 3.0
        path.fill()
        path.stroke()
        
        return path
        
    }
    
    
    
    
}
