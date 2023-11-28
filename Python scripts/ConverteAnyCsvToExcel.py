import os
import pandas as pd
from openpyxl import Workbook
from openpyxl.utils.dataframe import dataframe_to_rows
from openpyxl.worksheet.table import Table, TableStyleInfo
from tkinter import Tk, filedialog

# busca o root onde esta o script
root_dir = os.path.dirname(os.path.abspath(__file__))

# obter a lista de .csv no diretorio de script
csv_files = [f for f in os.listdir(root_dir) if f.endswith('.csv')]

if len(csv_files) == 0:
    print('Nenhum arquivo .csv encontrado.')
elif len(csv_files) == 1:
    # construido o path para o arquivo .csv
    csv_path = os.path.join(root_dir, csv_files[0])
else:
    # exibir uma interface para selecionar qual arquivo .csv converter
    root = Tk()
    root.withdraw()
    csv_path = filedialog.askopenfilename(initialdir=root_dir, title="Selecione o arquivo .csv a ser convertido", filetypes=[("CSV Files", "*.csv")])
    
    if not csv_path:
        print('Nenhum arquivo .csv selecionado.')
        exit()
        
#obter o nome do arquivo selecionado e usar esse nome para nomear o .xlsx que será gerado
filename = os.path.splitext(os.path.basename(csv_path))[0]
excel_filename = f'{filename}_{pd.Timestamp.now().strftime("%Y%m%d%H%M")}.xlsx'

# pega a localizacao da pasta do script
root_dir = os.path.dirname(os.path.abspath(__file__))

# seleciona a entrada e saida dos arquivos e seus caminhos
csv_path = os.path.join(root_dir, csv_path)
excel_path = os.path.join(root_dir, excel_filename)

# checa se existe arquivo com mesmo nome e deleta o antigo
if os.path.exists(excel_path):
    os.remove(excel_path)
    
# le o arquivo CSV no pandas Dataframe
df = pd.read_csv(csv_path, dtype=str)

# cria um workbook
wb = Workbook()
ws = wb.active

# escreve o dataframe
for r in dataframe_to_rows(df, index=False, header=True):
    ws.append(r)
    
# cria uma tabela formatada
table_range = ws.dimensions
table = Table(displayName='Table1', ref=table_range)
style = TableStyleInfo(name="TableStyleMedium1", showFirstColumn=False,
                       showLastColumn=False, showRowStripes=True, showColumnStripes=False)
table.tableStyleInfo = style
ws.add_table(table)

# ajusta automaticamente a largura das colunas
for col in ws.columns:
    max_length = 0
    column = col[0].column_letter  #Get column name
    for cell in col:
        try:
            if len(str(cell.value)) > max_length:
                max_length = len(cell.value)
        except:
            pass
    adjusted_width = (max_length + 2)
    ws.column_dimensions[column].width = adjusted_width
    
# salva arquivo no excel
wb.save(excel_path)