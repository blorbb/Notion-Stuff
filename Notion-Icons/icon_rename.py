import os

icon_types_dict = {
    "Notes": "lightcyan",
    "Databases": "darksalmon",
    "Misc": "#EBEBEB",
    "Stuff": "mediumaquamarine",
    "Master": "gold",
}

dir = os.path.dirname(os.path.realpath(__file__))
files = os.listdir(os.path.join(dir, "icons"))

source_array = []

for folder, colour in icon_types_dict.items():
    for filename in files:
        # file in the icons folder
        file_source = os.path.join(dir, "icons", filename)
        # copy to folder of each of the colour variants
        file_destination = os.path.join(dir, folder, filename)

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

        # create the svg in the destination folder
        with open(file_destination, mode="w") as newfile:
            newfile.write(recoloured_code)

# create an array for icons.json
for filename in files:
    source_array.append(filename[:-4])


page_type_list = [key for key in icon_types_dict.keys()]

full_icon_groups = ""

for page_type in page_type_list:
    icon_groups = f"""
    {{
        "name": "{page_type}",
        "sourceUrl": "https://raw.githubusercontent.com/blorbb/Notion-Stuff/master/Notion-Icons/{page_type}",
        "source": {source_array},
        "extension": "svg"
    }},"""

    full_icon_groups += icon_groups

full_icon_groups = full_icon_groups[:-1]

json_text = f"""
{{
  "icons": [{full_icon_groups}
  ]
}}
""".replace("'", '"')

json_path = os.path.join(dir, "icons.json")
with open(json_path, mode="w") as json_file:
    json_file.write(json_text)
