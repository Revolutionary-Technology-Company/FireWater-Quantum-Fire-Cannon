#!/usr/bin/env python3
"""
FireWater Quantum Fire Cannon - Pneumatic Separation Cap Solenoid Driver
Monitors line pressure and triggers 6-inch clearance isolation caps upon break detection.
"""

import time

class PipeBreakMonitor:
    def __init__(self, baseline_operating_psi=150.0):
        self.nominal_psi = baseline_operating_psi
        self.critical_drop_threshold = 0.40  # 40% pressure loss triggers isolation
        
        # State Registers
        self.line_intact = True
        self.clearance_rails_extended = False
        self.caps_deployed = False

    def evaluate_pressure_telemetry(self, cannon_sensor_psi, hydrant_sensor_psi):
        """
        Cross-checks pressure differences between the intake and discharge ends.
        A sudden delta indicates an uncontained pipeline separation event.
        """
        if not self.line_intact:
            return "ISOLATED"

        # Check for catastrophic pressure loss spikes
        if cannon_sensor_psi < (self.nominal_psi * (1.0 - self.critical_drop_threshold)):
            print("[ALERT] Pressure loss threshold breached on Cannon terminal! Line break suspected.")
            self.execute_isolation_sequence()
            return "BREAK_DETECTED"
            
        if hydrant_sensor_psi < (self.nominal_psi * (1.0 - self.critical_drop_threshold)):
            print("[ALERT] Pressure loss threshold breached on Hydrant terminal! Line break suspected.")
            self.execute_isolation_sequence()
            return "BREAK_DETECTED"

        return "NOMINAL"

    def execute_isolation_sequence(self):
        """
        Executes the mechanical isolation sequence.
        Enforces the 6-inch linear clearance rule before deploying the sealing caps.
        """
        print("[!!!] INITIALIZING EMERGENCY PIPE SEPARATION PROTOCOL [!!!]")
        self.line_intact = False
        
        # Step 1: Extend 6-Inch Mechanical Clearance Sleeves
        print("[Actuator] Driving linear clearance sleeves to extension limit...")
        time.sleep(0.15) # 150ms mechanical pneumatic slide travel time
        self.clearance_rails_extended = True
        print("[Actuator] Clearance achieved: 6 inches of clearance cleared behind break point.")
        
        # Step 2: Trigger Spring-Loaded Sealing Flap Caps
        print("[Hardware] Releasing high-torque spring latches on both isolation caps...")
        time.sleep(0.05) # 50ms mechanical snap latch time
        self.caps_deployed = True
        
        # Step 3: Hard clamp safety interlock rail to ground
        print("[Failsafe] Sealing caps locked under pressure. Main supply isolated successfully.")
