import os
import json
import re
import csv
import pandas as pd
from openpyxl import Workbook
from openpyxl.utils.dataframe import dataframe_to_rows
from openpyxl.worksheet.table import Table, TableStyleInfo
from tkinter import Tk, filedialog

# Busca o root onde o script está
root_dir = os.path.dirname(os.path.abspath(__file__))

# Obtém a lista de .json no diretório do script
json_files = [f for f in os.listdir(root_dir) if f.endswith('.json')]

if len(json_files) == 0:
    print('Nenhum arquivo .json encontrado.')
else:
    if len(json_files) == 1:
        # Construir o path para o arquivo .json
        json_path = os.path.join(root_dir, json_files[0])
    else:
        # Exibir uma interface para selecionar qual arquivo .json converter
        root = Tk()
        root.withdraw()
        json_path = filedialog.askopenfilename(initialdir=root_dir, title="Selecione o arquivo .json a ser convertido", filetypes=[("JSON Files", "*.json")])

        if not json_path:
            print('Nenhum arquivo .json selecionado.')
            exit()

    # Obter o nome do arquivo selecionado e usar esse nome para nomear o .csv e .xlsx que será gerado
    filename = os.path.splitext(os.path.basename(json_path))[0]
    csv_filename = f'{filename}_{pd.Timestamp.now().strftime("%Y%m%d%H%M")}.csv'
    csv_path = os.path.join(root_dir, csv_filename)

    # Lê o conteúdo do JSON
    with open(json_path, "r") as f:
        json_data = json.load(f)

    # Extrai os campos necessários
    headers = list(json_data[0].keys())
    result = []

    for item in json_data:
        row = []
        for header in headers:
            row.append(str(item[header]))
        result.append(row)

    # Remove linhas duplicadas
    unique_results = []
    for row in result:
        if row not in unique_results:
            unique_results.append(row)

    # Escreve o arquivo CSV
    with open(csv_path, "w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(headers)  # Escreve o cabeçalho na primeira linha
        for row in unique_results:
            writer.writerow(row)

    # Cria um workbook
    wb = Workbook()
    ws = wb.active

    # Escreve o dataframe no arquivo .xlsx
    for r in dataframe_to_rows(pd.DataFrame(unique_results, columns=headers), index=False, header=True):
        ws.append(r)

    # Cria uma tabela formatada
    table_range = ws.dimensions
    table = Table(displayName='Table1', ref=table_range)
    style = TableStyleInfo(name="TableStyleMedium1", showFirstColumn=False,
                           showLastColumn=False, showRowStripes=True, showColumnStripes=False)
    table.tableStyleInfo = style
    ws.add_table(table)

    # Ajusta automaticamente a largura das colunas
    for col in ws.columns:
        max_length = 0
        column = col[0].column_letter  # Get column name
        for cell in col:
            try:
                if len(str(cell.value)) > max_length:
                    max_length = len(cell.value)
            except:
                pass
        adjusted_width = (max_length + 2)
        ws.column_dimensions[column].width = adjusted_width

    # Salva o arquivo no Excel
    excel_filename = f'{filename}_{pd.Timestamp.now().strftime("%Y%m%d%H%M")}.xlsx'
    excel_path = os.path.join(root_dir, excel_filename)
    wb.save(excel_path)

    print('Conversão concluída com sucesso.')
