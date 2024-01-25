# Code in Pycharm:

import time

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By

s = Service('C:/Users/Nitish/Desktop/chromedriver.exe')

driver = webdriver.Chrome(service = s)

driver.get('https://www.smartprix.com/mobiles')
time.sleep(1)

driver.find_element(by=By.XPATH, value='//*[@id="app"]/main/aside/div/div[5]/div[2]/label[1]/input').click()
time.sleep(1)
driver.find_element(by=By.XPATH, value='//*[@id="app"]/main/aside/div/div[5]/div[2]/label[2]/input').click()

time.sleep(2)

old_height = driver.execute_script('return document.body.scrollHeight')
while True:

    driver.find_element(by=By.XPATH, value='//*[@id="app"]/main/div[1]/div[2]/div[3]').click()
    time.sleep(1)

    new_height = driver.execute_script('return document.body.scrollHeight')

    print(old_height)
    print(new_height)

    if new_height == old_height:
        break

    old_height = new_height

html = driver.page_source

with open('smartprix.html','w',encoding='utf-8') as f:
    f.write(html)

# Code in Jupiter Notebook:

with open('smartprix.html','r',encoding='utf-8') as f:
    html = f.read()

from bs4 import BeautifulSoup 
import numpy as np 
import pandas as pd

soup = BeautifulSoup(html, 'lxml')

containers = soup.find_all('div', {'class': 'sm-product has-tag has-features has-actions'})

names = []
prices = []
ratings = []
sim = []
processor = []
ram = []
battery = []
display = []
camera = []
card = []
os = []

for i in soup.find_all('div',{'class':'sm-product has-tag has-features has-actions'}):
    try:
        names.append(i.find('h2').text)
    except:
        names.append(np.nan)
    try:
        prices.append(i.find('span',{'class':'price'}).text)
    except:
        price.append(np.nan)
    try:
        ratings.append(i.find('div',{'class':'score rank-2-bg'}).find('b').text)
    except:
        ratings.append(np.nan)
        
    x = i.find('ul',{'class':'sm-feat specs'}).find_all('li')
    try:
        sim.append(x[0].text)
    except:
        sim.append(np.nan)
    try:
        processor.append(x[1].text)
    except:
        processor.append(np.nan)
    try:    
        ram.append(x[2].text)
    except:
        ram.append(np.nan)
    try:
        battery.append(x[3].text)
    except:
        battery.append(np.nan)
    try:
        display.append(x[4].text)
    except:
        display.append(np.nan)
    try:
        camera.append(x[5].text)
    except:
        camera.append(np.nan)
    try:
        card.append(x[6].text)
    except:
        card.append(np.nan)
    try:
        os.append(x[7].text)
    except:
        os.append(np.nan)

df = pd.DataFrame({
    'model': names,
    'price': prices,
    'rating': ratings,
    'sim': sim,
    'processor': processor,
    'ram': ram,
    'battery': battery,
    'display': display,
    'camera': camera,
    'card': card,
    'os': os
})

df.isnull().sum()

df = pd.DataFrame({
    'model': names,
    'price': prices,
    'rating': ratings,
})

df = pd.DataFrame({
    'model': names,
    'price': prices,
    'rating': ratings,
    'sim': sim,
    'processor': processor,
    'ram': ram,
    'battery': battery,
    'display': display,
    'camera': camera,
    'card': card,
    'os': os
})
