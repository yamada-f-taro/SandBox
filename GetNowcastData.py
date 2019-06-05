'''
Created on 2019/05/26

@author: yamada
'''
# from datetime import datetime, timedelta
from datetime import datetime as dt
import os
import urllib.error
import urllib.request

from numpy.distutils.fcompiler import none

import datetime as dtt

INTERVAL = 10


def download_image(url, dst_path):
    try:
        data = urllib.request.urlopen(url).read()
        with open(dst_path, mode="wb") as f:
            f.write(data)
    except urllib.error.URLError as e:
        print(e)


def getFileName(num):

    dtnau = dt.now() - dtt.timedelta(minutes=num * INTERVAL)
#    dt = datetime.now - datetime.timedelta(minutes=5)
#    print (dt)
    minn = format(int(dtnau.strftime('%M')) - int(dtnau.strftime('%M')) % INTERVAL, "02d")
    nau = dtnau.strftime("%Y%m%d%H")
    return nau + minn


base = 'https://www.jma.go.jp/jp/radnowc/imgs/radar/210'

for i in range(5):
    fn = getFileName(i) + "-00.png"
    strr = base + "/" + fn

    download_image(strr, os.path.join ("c:\\tmp\\sss", fn))

    print(strr)

# url = 'https://upload.wikimedia.org/wikipedia/en/2/24/Lenna.png'
# https://www.jma.go.jp/jp/radnowc/imgs/radar/210/201905261225-00.png
# name = ""

# https://www.jma.go.jp/jp/radnowc/imgs/radar/210/201905261225-00.png

# os.path.exists(os.path.join(base, name))

# url = base + ""
# dst_path = 'data/src/lena_square.png'
# dst_dir = 'data/src'
# dst_path = os.path.join(dst_dir, os.path.basename(url))
# download_image(url, dst_path)
