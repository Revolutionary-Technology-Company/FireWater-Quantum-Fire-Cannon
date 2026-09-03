// ============================================================================
// FireWater Quantum Cannon - IP67 Waterproof Enclosure & Structural Chassis
// Incorporates passive vapor-chamber heat sinks and 6-inch break-apart rail sleeves
// ============================================================================

$fn = 60; // Global cylindrical render resolution 

// Global System Spatial Metrics (mm)
BOX_W = 380.0;             // Internal Micro-ATX width capacity
BOX_L = 420.0;             // Internal depth capacity to clear RTX 50 TUF
BOX_H = 180.0;             // Vertical clearance height
WALL_THICKNESS = 15.0;     // 15mm heavy aluminum structural shield
GASKET_WIDTH   = 6.0;      // Viton compression seal groove width
GASKET_DEPTH   = 4.5;      // Compression channel depth
PIPE_OUTER_D   = 142.00;   // 4.8" inner bore solid copper pipeline diameter
CLEARANCE_6IN  = 152.40;   // Exactly 6 inches of linear break travel

module Waterproof_Enclosure_Base() {
    difference() {
        // 1. Core Heavy-Mass Anodized Aluminum Outer Block
        translate([0, 0, -WALL_THICKNESS/2])
            cube([BOX_W + (WALL_THICKNESS * 2), BOX_L + (WALL_THICKNESS * 2), BOX_H + WALL_THICKNESS], center=true);
            
        // 2. Hollow Internal Chamber (The Dry Plenum Cavity)
        translate([0, 0, 0])
            cube([BOX_W, BOX_L, BOX_H + 2], center=true);
            
        // 3. Precision-Milled Viton Gasket Sealing Track (Top Lip Perimeter)
        translate([0, 0, BOX_H/2]) difference() {
            cube([BOX_W + GASKET_WIDTH, BOX_L + GASKET_WIDTH, GASKET_DEPTH * 2], center=true);
            cube([BOX_W - GASKET_WIDTH, BOX_L - GASKET_WIDTH, GASKET_DEPTH * 3], center=true);
        }
        
        // 4. Lateral Pass-Through Ports for Liquid-Tight NPT Cable Glands
        for (x_offset = [-120, 0, 120]) {
            translate([x_offset, BOX_L/2 + WALL_THICKNESS/2, -20])
                rotate([90, 0, 0]) cylinder(h=WALL_THICKNESS + 2, d=32, center=true); // 32mm NPT threads
        }
        
        // 5. Milled Side Windows for External Phase-Change Copper Vapor Plates
        for (side = [-1, 1]) {
            scale([side, 1, 1]) translate([BOX_W/2 + WALL_THICKNESS/2, 40, 0])
                cube([WALL_THICKNESS + 2, 220, 100], center=true);
        }
    }
}

module External_Cooling_Heatsinks() {
    // Large external fins to passively dissipate heat from the internal RTX 50 TUF
    for (side = [-1, 1]) {
        scale([side, 1, 1]) translate([BOX_W/2 + WALL_THICKNESS + 25, 40, 0]) color("DarkSlateGray") {
            cube([50, 240, 120], center=true); // Solid base flange
            // Extruded vertical cooling fins
            for (f = [-100 : 20 : 100]) {
                translate([25, f, 0]) cube([4, 4, 140], center=true);
            }
        }
    }
}

module Integrated_Pipeline_Break_Rails() {
    // Models the external slide assembly implementing the 6-inch clearance parameter
    translate([0, -BOX_L/2 - 100, -BOX_H/2]) union() {
        // Main Copper Delivery Pipe (Input Feed Section)
        color("Copper") rotate([90, 0, 0]) difference() {
            cylinder(h=300, d=PIPE_OUTER_D, center=true);
            cylinder(h=302, d=PIPE_OUTER_D - 20, center=true);
        }
        
        // 6-Inch Sliding Carriage Extension Tracks (Stainless Steel Guides)
        for (i = [-1, 1]) {
            translate([i * (PIPE_OUTER_D/2 + 20), 0, 0]) rotate([90, 0, 0]) color("DimGray") {
                cylinder(h=320, d=25, center=true); // Fixed structural anchor rail
                // Sliding sleeve indicator demonstrating full travel capability
                translate([0, 0, -CLEARANCE_6IN/2])
                    color("Silver") cylinder(h=60, d=38, center=true);
            }
        }
        
        // Stamped Sealing Cap Pivot Hub (Sits 6 inches back to clear jagged cuts)
        translate([0, CLEARANCE_6IN, PIPE_OUTER_D/2 + 10]) color("SteelBlue")
            cube([PIPE_OUTER_D + 15, 20, 25], center=true);
    }
}

module Full_Waterproof_System_Assembly() {
    // Base Enclosure Chassis Block
    color("LightGray") Waterproof_Enclosure_Base();
    
    // External Passive Thermal Management Layer
    External_Cooling_Heatsinks();
    
    // Low-Profile Viton Compression Gasket Ring (Rendered inside track)
    translate([0, 0, BOX_H/2 - GASKET_DEPTH/2]) color("Black") difference() {
        cube([BOX_W + GASKET_WIDTH - 1, BOX_L + GASKET_WIDTH - 1, GASKET_DEPTH], center=true);
        cube([BOX_W - GASKET_WIDTH + 1, BOX_L - GASKET_WIDTH + 1, GASKET_DEPTH + 2], center=true);
    }
    
    // Rigid Hydraulic Conduit with Emergency 6-Inch Decoupling Tracks
    Integrated_Pipeline_Break_Rails();
}

// Global Execution Render Compilation Trigger
Full_Waterproof_System_Assembly();
