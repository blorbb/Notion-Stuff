import os
from wand.image import Image
from wand.color import Color

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

for folder, colour in icon_types_dict.items():
    for icon_index, filename in enumerate(files):
        file_source = os.path.join(source_path, filename)
        icon_name = f"{folder}_{str(icon_index)}.svg"
        file_destination = os.path.join(root_path, folder, icon_name)

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
