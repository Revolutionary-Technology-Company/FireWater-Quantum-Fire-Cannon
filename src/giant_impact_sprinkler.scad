// ==========================================
// PARAMETRIC GIANT IMPACT SPRINKLER HEAD
// Optimized for Fire Hydrant Pressure & Flow
// ==========================================

$fn = 100; // High resolution rendering

// --- Dimensions & Conversions ---
inch = 25.4; // 1 inch = 25.4 mm

// --- Main Design Constraints ---
nozzle_diameter = 1.35 * inch;  // Balanced for standard hydrant flow (34.3mm)
inlet_diameter  = 2.50 * inch;  // Matches standard hydrant 2.5" NST/NH side port
body_height     = 32.00 * inch; // Overall physical height scale (~812mm)
wall_thickness  = 0.50 * inch;  // Heavy duty structural thickness for high pressure

// --- Internal Structural Variables ---
outer_inlet = inlet_diameter + (wall_thickness * 2);
outer_nozzle = nozzle_diameter + (wall_thickness * 2);

module main_sprinkler_assembly() {
    // 1. HIGH-FLOW INLET BASE & SWIVEL FLANGE
    difference() {
        cylinder(h=6*inch, r=outer_inlet/2, center=false);
        // Hollow high-flow core
        translate([0, 0, -1])
            cylinder(h=6*inch + 2, r=inlet_diameter/2, center=false);
    }
    
    // 2. MAIN PRESSURE RETAINING TRUNK (VERTICAL PIPE)
    translate([0, 0, 6*inch])
    difference() {
        cylinder(h=body_height - 12*inch, r=(outer_inlet*0.85)/2);
        translate([0, 0, -1])
            cylinder(h=body_height - 12*inch + 2, r=(inlet_diameter)/2);
    }

    // 3. TAPERED VELOCITY NOZZLE (TURNS AND ACCELERATES WATER)
    translate([0, 0, body_height - 6*inch])
    rotate([0, 75, 0]) // 15-degree trajectory angle up from horizontal
    translate([0, 0, -1*inch])
    difference() {
        // Tapered outer shell
        cylinder(h=10*inch, r1=outer_inlet/2, r2=outer_nozzle/2);
        // Internal acceleration profile converting pressure to jet velocity
        translate([0, 0, -1])
            cylinder(h=10*inch + 2, r1=inlet_diameter/2, r2=nozzle_diameter/2);
    }

    // 4. INTEGRATED MOUNTING HUB FOR THE SWINGING IMPACT SPOON ARM
    translate([0, (outer_inlet/2), body_height - 9*inch])
    difference() {
        // Structural solid boss block
        cube([2*inch, 2.5*inch, 4*inch], center=true);
        // Precision pivot shaft hole for 1/2" steel axis bolt
        rotate([0, 90, 0])
            cylinder(h=3*inch, r=(0.25*inch), center=true);
    }
}

module lightweight_spoon_arm() {
    // 5. THE IMPACT REBOUND SPOON (HOLLOW DEFLECTOR HOUSING)
    // Sized to cleanly intercept and fan out a 1.35-inch high-velocity jet
    translate([10*inch, 0, body_height - 3*inch])
    difference() {
        // Outer spoon profile
        sphere(r=2.5*inch);
        // Deep internal concave scoop to catch the water stream momentum
        translate([-0.5*inch, 0, 0])
            sphere(r=2.1*inch);
        // Slice away the back to form an exit fan path for the water
        translate([2*inch, -2.5*inch, -2.5*inch])
            cube([5*inch, 5*inch, 5*inch]);
    }

    // 6. BALANCE WEIGHT EXTENSION TAIL & RETURN TORSION ANCHOR
    // Counteracts the weight of the massive spoon to eliminate wobble
    translate([-6*inch, 0, body_height - 4*inch])
    difference() {
        cube([8*inch, 1.5*inch, 2.0*inch], center=true);
        // Torsion spring pin hook channel
        translate([-3*inch, 0, 0])
            cylinder(h=3*inch, r=0.125*inch, center=true);
    }
    
    // Connecting beam between balance tail, pivot hub, and spoon head
    translate([2*inch, 0, body_height - 4*inch])
        cube([14*inch, 1.2*inch, 1.5*inch], center=true);
}

// Render components in working layout alignment
color("Silver") main_sprinkler_assembly();
color("Red") lightweight_spoon_arm();
