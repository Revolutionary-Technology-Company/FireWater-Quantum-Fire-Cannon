// ============================================================================
// FireProve System - Emergency Pipe Separation & Sealing Cap Array
// Implements 6 inches of clearance shafts for both Cannon and Hydrant terminals
// ============================================================================

$fn = 60; // Render configuration

// Standard Dimensional Metrics (mm)
PIPE_OUTER_D      = 142.00; // Solid heavy-wall copper piping
CLEARANCE_GAP     = 152.40; // Exactly 6 inches of travel clearance
CAP_THICKNESS     = 12.00;  // Stamped structural sealing gate plate

module Emergency_Isolation_Coupling() {
    
    // 1. Center Shear Axis (The designated structural failure fracture line)
    color("Red") translate([0, 0, 0]) 
        cube([200, 200, 2], center=true);

    // =====================================================================
    // SIDE A: CANNON ISOLATION ASSEMBLY (Upper Terminal Deck)
    // =====================================================================
    translate([0, 0, 10]) union() {
        // Main structural copper pipeline sleeve routing back to cannon yoke
        color("Copper") cylinder(h=200, d=PIPE_OUTER_D, center=false);
        
        // 6-Inch Mechanical Clearance Sliding Rail Guides
        color("DimGray") translate([0, 0, 0]) difference() {
            cylinder(h=CLEARANCE_GAP, d=PIPE_OUTER_D + 20, center=false);
            cylinder(h=CLEARANCE_GAP + 2, d=PIPE_OUTER_D, center=false);
        }
        
        // Automated High-Pressure Spring Flap Cap (Open state during normal flow)
        // Positioned 6 inches back from the shear zone to clear broken edges
        translate([0, PIPE_OUTER_D/2 + 10, CLEARANCE_GAP]) 
            color("DarkSlateGray") rotate([90, 0, 0])
                cylinder(h=CAP_THICKNESS, d=PIPE_OUTER_D + 10, center=true);
    }

    // =====================================================================
    // SIDE B: HYDRANT ISOLATION ASSEMBLY (Lower Terminal Deck)
    // =====================================================================
    translate([0, 0, -10]) scale([1, 1, -1]) union() {
        // Main structural copper line leading back to the fire hydrant input
        color("Copper") cylinder(h=200, d=PIPE_OUTER_D, center=false);
        
        // 6-Inch Mechanical Clearance Sliding Rail Guides
        color("DimGray") translate([0, 0, 0]) difference() {
            cylinder(h=CLEARANCE_GAP, d=PIPE_OUTER_D + 20, center=false);
            cylinder(h=CLEARANCE_GAP + 2, d=PIPE_OUTER_D, center=false);
        }
        
        // Automated High-Pressure Spring Flap Cap (Open state during normal flow)
        // Positioned 6 inches back from the shear zone to clear broken edges
        translate([0, PIPE_OUTER_D/2 + 10, CLEARANCE_GAP]) 
            color("DarkSlateGray") rotate([90, 0, 0])
                cylinder(h=CAP_THICKNESS, d=PIPE_OUTER_D + 10, center=true);
    }
}

// Render execution call point
Emergency_Isolation_Coupling();
