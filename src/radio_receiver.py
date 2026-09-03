#!/usr/bin/env python3
"""
FireWater Quantum Fire Cannon - Radio Mesh Network Receiver Bridge
Captures real-time targeting coordinates broadcast by nearby FireProve acoustic units
to coordinate localized water suppression over extinguished fire sectors.
"""

import math

class FireProveRadioReceiver:
    def __init__(self, node_id="Water_Cannon_Alpha"):
        self.node_id = node_id
        self.active_mesh_assignments = {}
        
        # Local physical location registers (for distance-to-target evaluation)
        self.local_lat = 47.313
        self.local_lon = -122.179

    def parse_incoming_mesh_broadcast(self, raw_rf_packet):
        """
        Decodes incoming radio signals from adjacent FireProve acoustic systems.
        """
        if not raw_rf_packet or "target" not in raw_rf_packet:
            return None
            
        sender_id = raw_rf_packet.get("id")
        target_coords = raw_rf_packet.get("target") # Format: (lat, lon)
        
        if target_coords is None:
            if sender_id in self.active_mesh_assignments:
                del self.active_mesh_assignments[sender_id]
            return None
            
        # Register the coordinates into the local target tracking map
        self.active_mesh_assignments[sender_id] = target_coords
        return sender_id, target_coords

    def calculate_relative_target_vector(self, target_lat, target_lon):
        """
        Translates geographical coordinates into relative azimuth angles
        for the dual-axis Lockheed gimbal gearboxes.
        """
        d_lat = target_lat - self.local_lat
        d_lon = target_lon - self.local_lon
        
        # Basic trigonometry to compute the relative bearing vector
        bearing_rad = math.atan2(d_lon, d_lat)
        bearing_degrees = math.degrees(bearing_rad)
        
        # Calculate structural distance to target coordinates
        distance_meters = math.sqrt(d_lat**2 + d_lon**2) * 111000.0
        
        return bearing_degrees, distance_meters
