from bs4 import BeautifulSoup
import requests
import pandas as pd

url = 'https://en.wikipedia.org/wiki/List_of_largest_companies_in_the_United_States_by_revenue'
page = requests.get(url)
soup = BeautifulSoup(page.text, 'html')
soup.find_all('table')[0]
table = soup.find_all('table')[0]
print (table)
world_title = table.find_all('th')
world_table_title = [title.text.strip() for title in world_title]
print(world_table_title)
df = pd.DataFrame(columns = world_table_title)
column_data = table.find_all('tr')
for row in column_data[1:]:
    row_data = row.find_all('td')
    individual_row_data = [data.text.strip() for data in row_data]
    #print (individual_row_data)
    
    length=len(df)
    df.loc[length] = individual_row_data
  
df.to_csv(r'C:\Users\Yuval\Documents\יובל\code\python\test.csv',index = False )
