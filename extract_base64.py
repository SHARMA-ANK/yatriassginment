import re
import base64
import os

files_to_fix = [
    'assets/LocalTrip_icon.svg',
    'assets/AirportTransfer_icon.svg',
    'assets/belowImage.svg',
    'assets/pickup_icon.svg'
]

for filepath in files_to_fix:
    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Search for base64 encoded png/jpeg inside image tags
        match = re.search(r'data:image/(png|jpeg);base64,([^"]+)', content)
        if match:
            ext = match.group(1)
            b64_data = match.group(2)
            
            out_file = filepath.replace('.svg', f'.{ext}')
            
            with open(out_file, 'wb') as f_out:
                f_out.write(base64.b64decode(b64_data))
            
            print(f"Extracted {out_file}")
        else:
            print(f"No base64 image found in {filepath}")
    except Exception as e:
        print(f"Error processing {filepath}: {e}")
