import os
from wand.image import Image
from wand.color import Color
import json

from paths import ROOT_PATH, SOURCE_PATH

icon_types_dict = {
    "Notes": "lightcyan",
    "Databases": "darksalmon",
    "Misc": "#EBEBEB",
    "Stuff": "mediumaquamarine",
    "Master": "gold",
}

source_path = SOURCE_PATH
root_path = ROOT_PATH
files = os.listdir(source_path)

source_array = []

for folder, colour in icon_types_dict.items():
    for filename in files:
        file_source = os.path.join(source_path, filename)
        file_destination = os.path.join(root_path, folder, filename)

        # rewrite code of each file
        with open(file_source, mode="r", encoding="utf-8") as file:
            source_code = file.read()

        # get index of substring 'fill="something"'
        start_index = source_code.index('fill="')
        end_index = source_code.index(">", start_index)
        # everything before and after the fill
        beginning = source_code[:start_index]
        ending = source_code[end_index:]
        recoloured_code = beginning + f'fill="{colour}"' + ending

        with open(file_destination, mode="w") as newfile:
            newfile.write(recoloured_code)

# create an array for icons.json
# TODO create full json
for filename in files:
    source_array.append(filename)


page_type_list = [key for key in icon_types_dict.keys()]

full_icon_groups = ""

for page_type in page_type_list:
    icon_groups = f"""
    {{
        "name": "{page_type}",
        "sourceUrl": "https://raw.githubusercontent.com/waaaaaaaaaaaaaaaaaaaaa/Notion-Icons/master/{page_type}",
        "source": {source_array}
    }},"""

    full_icon_groups += icon_groups

full_icon_groups = full_icon_groups[:-1]

print(f"""
{{
  "icons": [{full_icon_groups}
  ]
}}
""".replace("'", '"'))
