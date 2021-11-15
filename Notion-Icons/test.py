import os


dir = os.path.dirname(os.path.realpath(__file__))
folder_list = next(os.walk(dir))[1]
folder_list.remove("icons")
folder_list.remove("iconbackup")
print(folder_list)
