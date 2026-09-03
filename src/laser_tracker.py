#!/usr/bin/env python3
"""
FireWater Quantum Fire Cannon - Infrared Heat Laser Tracker
Profiles temperature gradients to locate the absolute thermal epicenter
of residual hotspots, outputting spatial target offsets.
"""

import numpy as np

class InfraredLaserTracker:
    def __init__(self, resolution_matrix=(16, 16), dynamic_gain=1.2):
        self.rows, self.cols = resolution_matrix
        self.gain = dynamic_gain
        
        # Operational baseline calibration values
        self.min_valid_surface_temp_c = 70.0 # Ignores elements below flashpoints

    def capture_laser_temperature_matrix(self):
        """
        Simulates an SPI registry scan from the onboard infrared laser array.
        In active use, this pulls raw focal plane temperatures.
        """
        # Injecting simulation environment data representing hot smoldering fuel beds
        mock_grid = np.random.uniform(20.0, 60.0, size=(self.rows, self.cols))
        
        # Simulating a concentrated boundary hotspot breach point
        mock_grid[6:9, 7:10] = np.random.uniform(140.0, 220.0, size=(3, 3))
        return mock_grid

    def isolate_thermal_epicenter(self, raw_temperature_matrix):
        """
        Processes the temperature grid to find the exact centroid
        of the highest localized temperature cluster.
        """
        # Threshold pass: strip out normal ambient background readings
        filtered_matrix = np.where(raw_temperature_matrix >= self.min_valid_surface_temp_c, raw_temperature_matrix, 0.0)
        
        total_mass = np.sum(filtered_matrix)
        if total_mass == 0.0:
            return None, 0.0 # No critical hotspots detected inside field of view
            
        # Calculate the center of mass (centroid) of the thermal footprint
        y_indices, x_indices = np.indices(filtered_matrix.shape)
        
        centroid_x = np.sum(x_indices * filtered_matrix) / total_mass
        centroid_y = np.sum(y_indices * filtered_matrix) / total_mass
        peak_temperature = float(np.max(filtered_matrix))
        
        # Convert pixel centroid coordinates to normalized angular error offsets (-1.0 to 1.0)
        normalized_error_x = (centroid_x / (self.cols - 1)) * 2.0 - 1.0
        normalized_error_y = (centroid_y / (self.rows - 1)) * 2.0 - 1.0
        
        return (normalized_error_x, normalized_error_y), peak_temperature
