import csv

# Constants
thickness = {
    'Wood': 0.04,        # meters
    'Frigolit': 0.05,    # meters
    'Glass 1-layer': 0.005, # meters
    'Glass 2-layer': 0.005  # meters (per pane)
}
h1 = 8.1  # W/m2K

# For composite calculation
glass2_pane = thickness['Glass 2-layer']
air_gap = 0.007  # meters

delta_t_cols = {
    'Wood': ('Wood inside temp Ave. (C)', 'Wood outside temp Ave. (C)'),
    'Frigolit': ('Frigolit inside temp Ave. (C)', 'Frigolit outside temp Ave. (C)'),
    'Glass 1-layer': ('Glass 1-layer inside temp Ave. (C)', 'Glass 1-layer outside temp Ave. (C)'),
    'Glass 2-layer': ('Glass 2-layer inside temp Ave. (C)', 'Glass 2-layer outside temp Ave. (C)')
}

csv_path = r'c:\Users\Husse\Documents\Repos\DIV\Labb 2 data copy.csv'
with open(csv_path, newline='', encoding='utf-8') as csvfile:
    reader = csv.DictReader(csvfile)
    data = [row for row in reader]

def column_mean(data, col):
    vals = []
    for row in data:
        try:
            vals.append(float(row[col]))
        except (ValueError, KeyError):
            continue
    return sum(vals) / len(vals) if vals else 0

results = {}

for material, (t_in_col, t_out_col) in delta_t_cols.items():
    t_in = column_mean(data, t_in_col)
    t_out = column_mean(data, t_out_col)
    room_temp = column_mean(data, 'Room temp Ave. (C)')        # T_inf2

    # Use correct hot box column for each material
    if material == "Glass 2-layer":
        hot_box_temp = column_mean(data, 'Hot-Box 2 layer box Ave. (C)')  # T_inf1 for 2-layer
    else:
        hot_box_temp = column_mean(data, 'Hot-Box temp Ave. (C)')         # T_inf1 for others

    # U = h1 * (T_inf1 - T1) / (T_inf1 - T_inf2)
    delta_t_surface = hot_box_temp - t_in
    delta_t_inf = hot_box_temp - room_temp
    u = (h1 * delta_t_surface / delta_t_inf) if delta_t_inf != 0 else 0

    # For k, use the temperature drop across the material
    delta_t_material = t_in - t_out

    if material == "Glass 2-layer" and u != 0:
        # Overall thermal conductivity for the composite (2 panes + air gap)
        d_total = 2 * glass2_pane + air_gap
        R_total = 1 / u
        k_eff = d_total / R_total if R_total > 0 else 0
        k = k_eff
    else:
        # k = (h1 * (T_inf1 - T1) * thickness) / (delta_t_material * (T_inf1 - T_inf2))
        # Or, equivalently, k = thickness / (1/u - 1/h1), but using delta_t_material for physical meaning
        if u != 0 and delta_t_material != 0:
            # Calculate heat flow per area: q = h1 * (T_inf1 - T1)
            q_per_area = h1 * delta_t_surface
            k = (q_per_area * thickness[material]) / (delta_t_material * delta_t_inf)
        else:
            k = 0

    results[material] = {
        'Thermal Conductivity (W/mK)': k,
        'U-value (W/m2K)': u
    }

for material, vals in results.items():
    print(f"{material}:")
    print(f"  Thermal Conductivity: {vals['Thermal Conductivity (W/mK)']:.4f} W/mK")
    print(f"  U-value: {vals['U-value (W/m2K)']:.4f} W/m2K\n")