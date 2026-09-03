// ============================================================================
// FireProve System - Solid Copper Hydrant-to-Cannon Pipeline Module
// Incorporates a ceramic insulation layer over an aluminum structural base
// ============================================================================

$fn = 80; // High resolution configuration for cylindrical pipe walls

// Global Structural Dimensions (mm)
PIPE_INNER_D       = 121.92; // 4.8 inches inner bore core
PIPE_OUTER_D       = 142.00; // Solid heavy-wall copper piping
BASE_PLATE_LEN     = 1200.0; // Complete pipeline structural length
INSULATION_THICK   = 10.0;   // High-temperature ceramic barrier shield
ALUMINUM_THICK     = 25.0;   // Rigid aluminum foundational chassis layer

module Copper_Hydrant_Pipeline_Assembly() {
    
    // 1. Foundational Layer: Heavy-Duty Structural Aluminum Base Chassis
    color("LightGray") translate([0, 0, -ALUMINUM_THICK - INSULATION_THICK])
        cube([BASE_PLATE_LEN, 300, ALUMINUM_THICK], center=true);
        
    // 2. Thermal Defense Layer: High-Temperature Ceramic Insulator Sheet
    // Separates the copper pipe mountings directly from the aluminum structure
    color("DarkCharcoal") translate([0, 0, -INSULATION_THICK/2])
        cube([BASE_PLATE_LEN, 280, INSULATION_THICK], center=true);

    // 3. Intake Side: Commercial Mechanical Fire Hydrant Input Flange
    translate([-BASE_PLATE_LEN/2 + 80, 0, 40]) rotate([0, 90, 0]) union() {
        color("FireBrick") cylinder(h=60, d=240, center=true); // Hydrant connection node
        color("Gold") translate([0, 0, 40]) cylinder(h=20, d=260, center=true); // Coupling collar
    }

    // 4. Conduit Core: Solid Heavy-Wall Copper Transfer Pipeline
    // Connects the water supply directly into the turret swivel joints
    color("Copper") translate([40, 0, 40]) rotate([0, 90, 0]) difference() {
        cylinder(h=BASE_PLATE_LEN - 240, d=PIPE_OUTER_D, center=true);
        cylinder(h=BASE_PLATE_LEN - 238, d=PIPE_INNER_D, center=true); // Clear fluid path
    }
    
    // Support Mounting Collars (Secure pipe to the ceramic insulator deck)
    for (offset = [-200, 200]) {
        translate([offset, 0, 0]) color("Bronze") difference() {
            cube([60, PIPE_OUTER_D + 30, PIPE_OUTER_D], center=true);
            rotate([0, 90, 0]) cylinder(h=62, d=PIPE_OUTER_D, center=true);
        }
    }

    // 5. Discharge Side: Lockheed-Style Dual-Axis Fire Suppression Cannon
    // Houses your internal contra-helical tracks and audio driver arrays
    translate([BASE_PLATE_LEN/2 - 120, 0, 80]) union() {
        // Lower pan-tilt housing drive enclosure
        color("DarkSlateGray") cylinder(h=120, d=220, center=true);
        
        // Lockheed-Style Main Pivot Yoke Arm Assembly
        translate([0, 0, 100]) color("DimGray") difference() {
            cube([160, 240, 160], center=true);
            translate([0, 0, 40]) cube([162, 160, 125], center=true); // Gimbal fork center opening
        }
        
        // Main Contra-Helical Barrel Exit Nozzle Body
        translate([40, 0, 140]) rotate([0, 75, 0]) difference() {
            color("Silver") cylinder(h=280, d=PIPE_INNER_D + 30, center=true);
            cylinder(h=282, d=PIPE_INNER_D, center=true); // Finished barrel exit path
        }
    }
}

// Render execution call point
Copper_Hydrant_Pipeline_Assembly();
