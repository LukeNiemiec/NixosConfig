from subprocess import run, Popen
from os import system, scandir

import easygui



"""
Tools for Tablet file system management
    . Notes -> strap-pdfs
    . Notes -> exportPDF -> to COURSES
    . Booke -> upload       


    UPLOAD:
    DOWNLOAD:
        . Notes -> stap-pdfs 
        . export pdf

"""




class TabTools:
    def __init__(self):
        self.tablet_path = "/home/box/Sync-Tablet/Internal shared storage/" 
        self.tmp_path = "/tmp/TabTools/"
        
    def upload_file(self, src_path, dst_path):
        print(f"uploading {src_path} to {dst_path}")

    def download_file(self, src_path, dst_path):
        print(f"uploading {src_path} to {dst_path}")

    def concat_pdfs(self, file_1, file_2, out_file):
        print(f"uploading {file_1} and {file_2} to {dst_path}/out.pdf")

    
    
    def view_notes(self):
        files = scandir(self.tablet_path)
        for file in files:
            if not file.is_dir():
                print(file.name)


    def launch(self):
        # try:
        while True:
            print(f"\n---------------------------------------\nCOMMANDS:\n\tnotes -> view notes\n\tupload -> upload a file or directory\n\tdownload -> download a file or directory\n\tconcat -> concatinates pdfs\n")

            choice = input(": ")

            match choice:
                case "notes":
                    self.view_notes()
                    
                case "upload":
                    src = easygui.fileopenbox() # file / directory
                    dst = easygui.fileopenbox() # file / directory
                    
                    self.upload_file(src, dst)
                    
                case "download":
                    src = easygui.fileopenbox() # file
                    dst = easygui.fileopenbox() # directory / file
                    
                    self.upload_file(src, dst)
                    
                    
                case "concat":
                    pdf1 = easygui.fileopenbox()            # pdf file
                    pdf2 = easygui.fileopenbox()            # pdf file
                    out_location = easygui.fileopenbox()    # directory
                    
                    self.upload_file(pdf1, pdf2, out_location)
                    
                    # except:

                case "q":
                    return
                
            

if __name__ == "__main__":
    tt = TabTools()
    tt.launch()
    
