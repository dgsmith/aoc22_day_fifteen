import Darwin
import Foundation

var beacons = [Beacon]()
var sensors = [Sensor]()

let filePath = "/Users/grayson/code/advent_of_code/2022/day_fifteen/input.txt"
guard let filePointer = fopen(filePath, "r") else {
    preconditionFailure("Could not open file at \(filePath)")
}
var lineByteArrayPointer: UnsafeMutablePointer<CChar>?
defer {
    fclose(filePointer)
    lineByteArrayPointer?.deallocate()
}
var lineCap: Int = 0
while getline(&lineByteArrayPointer, &lineCap, filePointer) > 0 {
    let line = String(cString:lineByteArrayPointer!)
    
    let xs = line.matches(of: #/x=(-?\d*)/#)
    let ys = line.matches(of: #/y=(-?\d*)/#)
   
    let beaconPos = Position(x: Int(xs[1].output.1)!, y: Int(ys[1].output.1)!)
    let beacon = Beacon(position: beaconPos)
    beacons.append(beacon)

    let sensorPos = Position(x: Int(xs[0].output.1)!, y: Int(ys[0].output.1)!)
    let sensorMaxDist = sensorPos.distance(to: beaconPos)
    let sensor = Sensor(position: sensorPos, maxDetectableDistance: sensorMaxDist)
    sensors.append(sensor)
}

struct Position : Equatable {
    var x: Int
    var y: Int

    init(x: Int = 0, y: Int = 0) {
        self.x = x
        self.y = y
    }

    // Manhattan distance
    // (0, 0) --> 
    func distance(to other: Position) -> Int {
        let x = max(self.x, other.x) - min(self.x, other.x)
        let y = max(self.y, other.y) - min(self.y, other.y)

        return x + y
    }

    static func ==(lhs: Position, rhs: Position) -> Bool {
        return lhs.x == rhs.x && lhs.y == rhs.y
    }
}

struct Sensor {
    let position: Position
    let maxDetectableDistance: Int
}

struct Beacon {
    let position: Position
}

//for beacon in beacons {
//    print(beacon)
//}

if false {
    var farLeft: Int = .max
    var farRight: Int = .min
    for sensor in sensors {
        farLeft = min(farLeft, sensor.position.x - sensor.maxDetectableDistance)
        farRight = max(farRight, sensor.position.x + sensor.maxDetectableDistance)
    //    print(sensor)
    }

    print(farLeft)
    print(farRight)

    var noBeacon = 0
    let rowToCheck = 2000000
    var currentPosition = Position(y: rowToCheck)
    for i in farLeft...farRight {
        currentPosition.x = i
        
        //    print("Checking pos=\(currentPosition)")
        let beacon = beacons.first { $0.position == currentPosition }
        if beacon != nil {
            //        print("  Found beacon")
            continue
        }
        
        let found = sensors.first { $0.position.distance(to: currentPosition) <= $0.maxDetectableDistance }
        if found != nil {
            //        print("  Found overlap")
            noBeacon += 1
        }
    }
    
    print(noBeacon)
}

var output: (x: Int, y: Int)?

for x in 0...4000000 {
    for y in 0...4000000 {
        let currentPosition = Position(x: x, y: y)
        
        let beacon = beacons.first { $0.position == currentPosition }
        if beacon != nil {
            continue
        }
        
        let found = sensors.first { $0.position.distance(to: currentPosition) <= $0.maxDetectableDistance }
        if found == nil {
            output = (x: x, y: y)
            break
        }
    }
}

print(output!)
print((output!.x * 4000000) + output!.y)

