import os
import sys

# Append the hardware sub-channel root path to import native hexadecimal logic adapters
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '../../Digital-Signals-in-Hexadecimal-Code/src')))

try:
    from chips.native.hex_rt_infrastructure import RTPhaseChangeThermalInterface, RTGuardRing
    from hex_voltage_controller import HexVoltageInjectionBridge
except ImportError:
    raise RuntimeError("Critical System Failure: Hexadecimal Native Silicon Core Drivers Not Found.")

class HexadecimalGimbalController:
    def __init__(self):
        # Enforce high-durability RT Fabrication Rules to prevent Joule heating
        self.thermal_armor = RTPhaseChangeThermalInterface(target_component="Lockheed_Gimbal_Bus")
        self.azimuth_guard = RTGuardRing(signal_line="Azimuth_Analog_0.0625V_Steps")
        self.elevation_guard = RTGuardRing(signal_line="Elevation_Analog_0.0625V_Steps")
        self.voltage_bridge = HexVoltageInjectionBridge()

    def update_pointing_vectors(self, final_target_vector):
        """
        Processes the unified radio and laser target calculation matrix 
        and maps the raw angular coordinates straight onto the analog bus.
        """
        # Extract angular offsets
        azimuth_error, elevation_error = self.calculate_angular_offsets(final_target_vector)
        
        # Hexadecimal Conversion: Map calculated errors directly to the 0.0V - 1.0V voltage levels
        v_azimuth = max(0.0, min(1.0, 0.5 + (azimuth_error * 0.0625)))
        v_elevation = max(0.0, min(1.0, 0.5 + (elevation_error * 0.0625)))
        
        # Zero-latency analog execution loop driving the high-torque servos
        self.voltage_bridge.inject_hex_signal(channel="CH_AZIMUTH", voltage=v_azimuth)
        self.voltage_bridge.inject_hex_signal(channel="CH_ELEVATION", voltage=v_elevation)

    def calculate_angular_offsets(self, target_vector):
        # Standard trigonometric coordinate matching routine to calculate step counts
        # Returns an integer offset range between -8 and +7 steps from center
        return int(target_vector[0] * 8), int(target_vector[1] * 8)
