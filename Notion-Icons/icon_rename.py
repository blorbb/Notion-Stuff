import os

dir = os.path.dirname(os.path.realpath(__file__))
icons_list = os.listdir(os.path.join(dir, "icons"))  # source from "icons" folder

# get all the folder names excluding "icons"
folder_list = next(os.walk(dir))[1]
folder_list.remove("icons")

icon_names = []
for folder in folder_list:
    for i, filename in enumerate(icons_list):
        # icon in the icons folder
        file_source = os.path.join(dir, "icons", filename)
        # copy to folder of each of the colour variants
        icon_destination = os.path.join(dir, folder, filename)

        # rewrite code of each file
        with open(file_source, mode="r", encoding="utf-8") as file:
            source_code = file.read()

        # get index of substring 'fill="something"'
        start_index = source_code.index('fill="')
        end_index = source_code.index(">", start_index)
        # everything before and after the fill
        beginning = source_code[:start_index]
        ending = source_code[end_index:]
        recoloured_code = beginning + f'fill="{folder}"' + ending

        # create the svg in the destination folder
        with open(icon_destination, mode="w") as newfile:
            newfile.write(recoloured_code)

# create an array for icons.json
# get names of each icon
for filename in icons_list:
    icon_names.append(filename[:-4])  # remove .svg

names = ["Misc", "Database", "Main", "Project", "Stuff"]  # in same order as folder names

full_icon_groups = ""

for i, colour in enumerate(folder_list):
    icon_groups = f"""
    {{
        "name": "{names[i]}",
        "sourceUrl": "https://raw.githubusercontent.com/blorbb/Notion-Stuff/master/Notion-Icons/{colour}",
        "source": {icon_names},
        "extension": "svg"
    }},""".replace("#", "%23")

    full_icon_groups += icon_groups

full_icon_groups = full_icon_groups[:-1]  # remove comma from last one

json_text = f"""
{{
  "icons": [{full_icon_groups}
  ]
}}
""".replace("'", '"')

json_path = os.path.join(dir, "icons.json")
with open(json_path, mode="w") as json_file:
    json_file.write(json_text)
